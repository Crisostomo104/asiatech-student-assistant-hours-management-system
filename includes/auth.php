<?php
/**
 * Authentication, session, CSRF, and role-based access control.
 * Every function here assumes config/app.php has already run
 * (session started, DB connection available, audit.php loaded).
 */

declare(strict_types=1);

/** Self-service password change for any logged-in user. Requires the current password. */
function change_password(int $userId, string $currentPassword, string $newPassword, string $confirmPassword): array
{
    if (strlen($newPassword) < 10) {
        return ['ok' => false, 'error' => 'New password must be at least 10 characters long.'];
    }
    if (!preg_match('/[A-Z]/', $newPassword) || !preg_match('/[0-9]/', $newPassword)) {
        return ['ok' => false, 'error' => 'New password must include at least one uppercase letter and one number.'];
    }
    if ($newPassword !== $confirmPassword) {
        return ['ok' => false, 'error' => 'New password and confirmation do not match.'];
    }

    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT password_hash FROM users WHERE user_id = :id');
    $stmt->execute([':id' => $userId]);
    $hash = $stmt->fetchColumn();

    if (!$hash || !password_verify($currentPassword, $hash)) {
        audit_log($userId, 'PASSWORD_CHANGE_FAILED_WRONG_CURRENT', 'users', $userId);
        return ['ok' => false, 'error' => 'Current password is incorrect.'];
    }

    $newHash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);
    $pdo->prepare('UPDATE users SET password_hash = :h WHERE user_id = :id')->execute([':h' => $newHash, ':id' => $userId]);

    audit_log($userId, 'PASSWORD_CHANGED', 'users', $userId);
    return ['ok' => true];
}

// ------------------------------------------------------------
// CSRF protection
// ------------------------------------------------------------
function csrf_token(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function csrf_field(): string
{
    return '<input type="hidden" name="csrf_token" value="' . htmlspecialchars(csrf_token(), ENT_QUOTES) . '">';
}

function verify_csrf(): void
{
    $submitted = $_POST['csrf_token'] ?? '';
    if (empty($_SESSION['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $submitted)) {
        http_response_code(403);
        die('Invalid or expired form submission (CSRF check failed). Please go back and try again.');
    }
}

// ------------------------------------------------------------
// Registration
// ------------------------------------------------------------
function register_user(string $idNumber, string $fullName, string $email, string $password, string $role = 'student_assistant'): array
{
    $idNumber = trim($idNumber);
    $fullName = trim($fullName);
    $email    = trim(strtolower($email));

    if (strlen($password) < 10) {
        return ['ok' => false, 'error' => 'Password must be at least 10 characters long.'];
    }
    if (!preg_match('/[A-Z]/', $password) || !preg_match('/[0-9]/', $password)) {
        return ['ok' => false, 'error' => 'Password must include at least one uppercase letter and one number.'];
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        return ['ok' => false, 'error' => 'Invalid email address.'];
    }
    if (!in_array($role, ['head_sa', 'student_assistant'], true)) {
        return ['ok' => false, 'error' => 'Invalid role.'];
    }

    $pdo = get_db();

    $check = $pdo->prepare('SELECT user_id FROM users WHERE id_number = :id OR email = :email');
    $check->execute([':id' => $idNumber, ':email' => $email]);
    if ($check->fetch()) {
        return ['ok' => false, 'error' => 'An account with that ID number or email already exists.'];
    }

    $hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);

    $insert = $pdo->prepare(
        'INSERT INTO users (id_number, full_name, email, password_hash, role, required_hours) VALUES (:id, :name, :email, :hash, :role, :reqhrs)'
    );
    $insert->execute([
        ':id'     => $idNumber,
        ':name'   => $fullName,
        ':email'  => $email,
        ':hash'   => $hash,
        ':role'   => $role,
        ':reqhrs' => defined('DEFAULT_REQUIRED_HOURS') ? DEFAULT_REQUIRED_HOURS : 200,
    ]);

    $newUserId = (int)$pdo->lastInsertId();
    audit_log($newUserId, 'USER_REGISTERED', 'users', $newUserId, ['role' => $role]);

    return ['ok' => true, 'user_id' => $newUserId];
}

// ------------------------------------------------------------
// Login (with rate limiting / lockout)
// ------------------------------------------------------------
function is_locked_out(string $loginInput): bool
{
    $pdo = get_db();
    $stmt = $pdo->prepare(
        'SELECT COUNT(*) FROM login_attempts
         WHERE id_number = :input AND success = 0
           AND attempted_at > (NOW() - INTERVAL :mins MINUTE)'
    );
    $stmt->bindValue(':input', $loginInput);
    $stmt->bindValue(':mins', LOCKOUT_WINDOW_MINUTES, PDO::PARAM_INT);
    $stmt->execute();

    return (int)$stmt->fetchColumn() >= MAX_LOGIN_ATTEMPTS;
}

function record_login_attempt(string $loginInput, bool $success): void
{
    $pdo = get_db();
    $stmt = $pdo->prepare(
        'INSERT INTO login_attempts (id_number, ip_address, success) VALUES (:id, :ip, :success)'
    );
    $stmt->execute([
        ':id'      => $loginInput,
        ':ip'      => $_SERVER['REMOTE_ADDR'] ?? 'cli',
        ':success' => $success ? 1 : 0,
    ]);
}

/**
 * Returns ['ok' => true, 'user' => [...]] on success,
 * or ['ok' => false, 'error' => string] on failure.
 * Supports login via Student ID Number or Email address.
 */
function attempt_login(string $loginInput, string $password): array
{
    $loginInput = trim($loginInput);

    if (is_locked_out($loginInput)) {
        audit_log(null, 'LOGIN_BLOCKED_LOCKOUT', 'users', null, ['login_input' => $loginInput]);
        return ['ok' => false, 'error' => 'Too many failed attempts. Please try again in ' . LOCKOUT_WINDOW_MINUTES . ' minutes.'];
    }

    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT * FROM users WHERE (id_number = :input OR LOWER(email) = LOWER(:input_email)) AND is_active = 1');
    $stmt->execute([':input' => $loginInput, ':input_email' => $loginInput]);
    $user = $stmt->fetch();

    $genericError = 'Incorrect Credentials.';
    
    if ($user && $user['deactivated_at'] !== null) {
        return ['ok' => false, 'error' => 'This account has been deactivated. Please contact support.'];
    }
    
    if (!$user || !password_verify($password, $user['password_hash'])) {
        record_login_attempt($loginInput, false);
        audit_log($user['user_id'] ?? null, 'LOGIN_FAILED', 'users', $user['user_id'] ?? null, ['login_input' => $loginInput]);
        return ['ok' => false, 'error' => $genericError];
    }


    // Rehash transparently if PHP's default cost factor has changed since this hash was made.
    if (password_needs_rehash($user['password_hash'], PASSWORD_BCRYPT, ['cost' => 12])) {
        $newHash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
        $pdo->prepare('UPDATE users SET password_hash = :h WHERE user_id = :id')
            ->execute([':h' => $newHash, ':id' => $user['user_id']]);
    }

    record_login_attempt($loginInput, true);

    // Regenerate session ID on login to prevent session fixation.
    session_regenerate_id(true);

    // DB-backed session token: authoritative source of truth for
    // "is this user actually logged in", independent of PHP's own
    // session file lifetime. Logging in again elsewhere overwrites
    // this token, which automatically invalidates any older session
    // for the same account (see is_session_valid() below).
    $sessionToken = bin2hex(random_bytes(32));
    $pdo->prepare('UPDATE users SET session_id = :token WHERE user_id = :id')
        ->execute([':token' => $sessionToken, ':id' => $user['user_id']]);

    $_SESSION['user_id']      = (int)$user['user_id'];
    $_SESSION['role']         = $user['role'];
    $_SESSION['name']         = $user['full_name'];
    $_SESSION['session_token'] = $sessionToken;

    audit_log((int)$user['user_id'], 'LOGIN_SUCCESS', 'users', (int)$user['user_id']);

    return ['ok' => true, 'user' => $user];
}

function logout_user(): void
{
    if (isset($_SESSION['user_id'])) {
        audit_log((int)$_SESSION['user_id'], 'LOGOUT', 'users', (int)$_SESSION['user_id']);
        get_db()->prepare('UPDATE users SET session_id = NULL WHERE user_id = :id')
            ->execute([':id' => $_SESSION['user_id']]);
    }
    $_SESSION = [];
    session_unset();
    session_destroy();
}

/**
 * The real check: does this browser's PHP session token still match
 * what's stored in the DB for this user? If the DB column is NULL
 * (logged out / cleared by idle-timeout) or holds a DIFFERENT token
 * (they logged in again elsewhere, or a Head SA deactivated them),
 * this session is no longer valid -- regardless of what the PHP
 * session file itself still says.
 */
function is_session_valid(): bool
{
    if (empty($_SESSION['user_id']) || empty($_SESSION['session_token'])) {
        return false;
    }

    $stmt = get_db()->prepare('SELECT session_id, is_active FROM users WHERE user_id = :id');
    $stmt->execute([':id' => $_SESSION['user_id']]);
    $row = $stmt->fetch();

    if (!$row || !$row['is_active'] || $row['session_id'] === null || $row['deactivated_at'] !== null) {
        return false;
    }

    return hash_equals((string)$row['session_id'], (string)$_SESSION['session_token']);
}

// ------------------------------------------------------------
// RBAC guards -- call at the top of any protected page
// ------------------------------------------------------------
function require_login(): void
{
    if (empty($_SESSION['user_id']) || !is_session_valid()) {
        $_SESSION = [];
        session_unset();
        session_destroy();
        header('Location: /sahms/login');
        exit;
    }
}

function require_role(string ...$roles): void
{
    require_login();
    if (!in_array($_SESSION['role'], $roles, true)) {
        audit_log((int)$_SESSION['user_id'], 'ACCESS_DENIED', null, null, ['required_roles' => $roles, 'actual_role' => $_SESSION['role']]);
        http_response_code(403);
        die('You do not have permission to access this page.');
    }
}

function current_user_id(): int
{
    return (int)($_SESSION['user_id'] ?? 0);
}

function current_role(): string
{
    return (string)($_SESSION['role'] ?? '');
}