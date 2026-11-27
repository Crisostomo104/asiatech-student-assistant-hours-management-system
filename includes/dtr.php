<?php
/**
 * DTR (Daily Time Record) logic -- Head SA manual entry model.
 *
 * Student Assistants do NOT clock themselves in/out. The Head SA
 * encodes each entry directly (based on the existing paper DTR),
 * so every entry is authored by someone other than the SA it
 * belongs to -- separation of duties is structural, not a
 * separate "approve" step. All totals are computed server-side
 * (via the DB's generated column) -- client-submitted totals are
 * never trusted.
 */

declare(strict_types=1);

/**
 * Computes NET hours for a single time_in/time_out pair, applying the
 * Head-SA-configurable break deduction rule: if the raw duration
 * exceeds BREAK_DEDUCTION_THRESHOLD_HOURS, 1 hour is deducted;
 * otherwise the raw duration is returned as-is. This is computed live
 * in PHP (not as a MySQL generated column) specifically so it responds
 * immediately to changes made on the Settings page -- MySQL generated
 * columns can't reference values from another table.
 */
function compute_net_hours(?string $timeIn, ?string $timeOut): ?float
{
    if ($timeIn === null || $timeOut === null) {
        return null;
    }
    $start = strtotime($timeIn);
    $end = strtotime($timeOut);
    if ($end === false || $start === false) {
        return 0.0;
    }
    if ($end <= $start) {
        if ($end === $start) {
            return 0.0;
        }
        $end = strtotime('+1 day', $end);
    }

    $raw = ($end - $start) / 3600;
    if ($raw <= 0) {
        return 0.0;
    }
    return $raw > BREAK_DEDUCTION_THRESHOLD_HOURS ? round($raw - 1, 2) : round($raw, 2);
}

/** List ALL Student Assistants regardless of active status, for the management page. */
function list_all_student_assistants(): array
{
    $pdo = get_db();
    $stmt = $pdo->query(
        "SELECT user_id, id_number, full_name, email, required_hours, is_active FROM users
         WHERE role = 'student_assistant'
         ORDER BY is_active DESC, full_name ASC"
    );
    return $stmt->fetchAll();
}

function format_sa_full_name(string $lastName, string $firstName, string $middleName = '', string $suffix = ''): string
{
    $lastName = normalize_sa_name_part($lastName);
    $firstName = normalize_sa_name_part($firstName);
    $middleName = normalize_sa_name_part($middleName);
    $suffix = normalize_sa_name_part($suffix);

    if ($lastName === '' || $firstName === '') {
        return '';
    }

    if ($middleName !== '' && preg_match('/^\p{L}\.?$/u', $middleName) === 1) {
        $middleName = rtrim($middleName, '.') . '.';
    }

    $fullName = $lastName . ', ' . $firstName;
    if ($middleName !== '') {
        $fullName .= ' ' . $middleName;
    }
    if ($suffix !== '') {
        $fullName .= ' ' . $suffix;
    }

    return $fullName;
}

function normalize_sa_name_part(string $part): string
{
    $part = trim(preg_replace('/\s+/', ' ', $part) ?? '');
    return function_exists('mb_strtoupper')
        ? mb_strtoupper($part, 'UTF-8')
        : strtoupper($part);
}

/** Head SA creates a new SA account directly (alternative to public self-registration). */
function head_sa_create_sa(int $headSaId, string $idNumber, string $fullName, string $email): array
{
    $idNumber = function_exists('mb_strtoupper')
        ? mb_strtoupper(trim($idNumber), 'UTF-8')
        : strtoupper(trim($idNumber));
    $fullName = normalize_sa_name_part($fullName);

    if (trim($fullName) === '') {
        return ['ok' => false, 'error' => 'Enter the Student Assistant name.'];
    }

    $result = register_user($idNumber, $fullName, $email, null, 'student_assistant');
    if (!$result['ok']) {
        return $result;
    }
    audit_log($headSaId, 'SA_CREATED_BY_HEAD', 'users', $result['user_id']);
    return $result;
}

/** Toggle an SA's active/inactive status (deactivated SAs can't log in and drop off entry-form dropdowns). */
function set_sa_active_status(int $headSaId, int $saUserId, bool $active): array
{
    $pdo = get_db();
    $check = $pdo->prepare("SELECT user_id FROM users WHERE user_id = :id AND role = 'student_assistant'");
    $check->execute([':id' => $saUserId]);
    if (!$check->fetch()) {
        return ['ok' => false, 'error' => 'Student Assistant not found.'];
    }

    // Reactivating clears deactivated_at (resets the review clock);
    // deactivating stamps "now" as the start of the review clock.
    $stmt = $pdo->prepare(
        'UPDATE users SET is_active = :active, deactivated_at = :deactivatedAt WHERE user_id = :id'
    );
    $stmt->execute([
        ':active'        => $active ? 1 : 0,
        ':deactivatedAt' => $active ? null : date('Y-m-d H:i:s'),
        ':id'            => $saUserId,
    ]);

    audit_log($headSaId, $active ? 'SA_REACTIVATED' : 'SA_DEACTIVATED', 'users', $saUserId);
    return ['ok' => true];
}

/**
 * SAs deactivated long enough ago (per the 'deactivation_review_months'
 * setting) show up here for a Head SA to manually decide what to do --
 * this never auto-deletes anything. Includes a count of their DTR
 * entries so the Head SA can see at a glance whether permanent
 * deletion is even possible (see delete_sa_permanently() below).
 */
function get_accounts_due_for_review(): array
{
    $months = (int)get_setting('deactivation_review_months', 12);

    $pdo = get_db();
    $stmt = $pdo->prepare(
        "SELECT u.user_id, u.id_number, u.full_name, u.email, u.deactivated_at,
                (SELECT COUNT(*) FROM dtr_entries d WHERE d.user_id = u.user_id) AS dtr_count
         FROM users u
         WHERE u.role = 'student_assistant' AND u.is_active = 0
           AND u.deactivated_at IS NOT NULL
           AND u.deactivated_at <= (NOW() - INTERVAL :months MONTH)
         ORDER BY u.deactivated_at ASC"
    );
    $stmt->bindValue(':months', $months, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll();
}

/**
 * Permanently deletes an SA account, but ONLY if it has zero DTR
 * entries -- this is a deliberate, manual, Head-SA-initiated action
 * (never automatic), and the dtr_entries foreign key is still
 * ON DELETE RESTRICT as a hard backstop even if this check were ever
 * bypassed. Accounts with any attendance history simply cannot be
 * deleted through this system -- that's by design, not a bug.
 */
function delete_sa_permanently(int $headSaId, int $saUserId): array
{
    $pdo = get_db();

    $stmt = $pdo->prepare("SELECT * FROM users WHERE user_id = :id AND role = 'student_assistant' AND is_active = 0");
    $stmt->execute([':id' => $saUserId]);
    $sa = $stmt->fetch();
    if (!$sa) {
        return ['ok' => false, 'error' => 'Account not found or is still active (deactivate it first).'];
    }

    $countStmt = $pdo->prepare('SELECT COUNT(*) FROM dtr_entries WHERE user_id = :id');
    $countStmt->execute([':id' => $saUserId]);
    if ((int)$countStmt->fetchColumn() > 0) {
        return ['ok' => false, 'error' => 'This account has DTR history and cannot be permanently deleted. Leave it deactivated instead.'];
    }

    try {
        $pdo->prepare('DELETE FROM users WHERE user_id = :id')->execute([':id' => $saUserId]);
    } catch (PDOException $e) {
        // Backstop in case something referenced this user unexpectedly --
        // never let a raw DB error reach the browser.
        error_log('delete_sa_permanently failed: ' . $e->getMessage());
        return ['ok' => false, 'error' => 'Could not delete this account -- it may still be referenced elsewhere in the system.'];
    }

    audit_log($headSaId, 'SA_PERMANENTLY_DELETED', 'users', $saUserId, [
        'id_number' => $sa['id_number'], 'full_name' => $sa['full_name'], 'email' => $sa['email'],
    ]);

    return ['ok' => true];
}

/** Head SA updates an individual SA's required_hours quota. */
function set_sa_required_hours(int $headSaId, int $saUserId, float $requiredHours): array
{
    if ($requiredHours <= 0) {
        return ['ok' => false, 'error' => 'Required hours must be greater than zero.'];
    }
    $pdo = get_db();
    $check = $pdo->prepare("SELECT user_id FROM users WHERE user_id = :id AND role = 'student_assistant'");
    $check->execute([':id' => $saUserId]);
    if (!$check->fetch()) {
        return ['ok' => false, 'error' => 'Student Assistant not found.'];
    }

    $pdo->prepare('UPDATE users SET required_hours = :h WHERE user_id = :id')
        ->execute([':h' => $requiredHours, ':id' => $saUserId]);

    audit_log($headSaId, 'SA_REQUIRED_HOURS_UPDATED', 'users', $saUserId, ['required_hours' => $requiredHours]);
    return ['ok' => true];
}

/** List all active Student Assistants, for the Head SA's entry-form dropdown. */
function list_student_assistants(): array
{
    $pdo = get_db();
    $stmt = $pdo->query(
        "SELECT user_id, id_number, full_name, required_hours FROM users
         WHERE role = 'student_assistant' AND is_active = 1
         ORDER BY full_name ASC"
    );
    return $stmt->fetchAll();
}

/**
 * Checks whether a [timeIn, timeOut] window overlaps any existing
 * entry for that SA on that date. Optionally excludes one dtr_id
 * (used when editing an existing entry against itself).
 */
function has_overlap(int $userId, string $workDate, string $timeIn, string $timeOut, ?int $excludeDtrId = null): bool
{
    $pdo = get_db();
    $sql = 'SELECT COUNT(*) FROM dtr_entries
            WHERE user_id = :uid AND work_date = :date
              AND status IN (\'approved\', \'pending\')
              AND time_out IS NOT NULL
              AND time_in < :new_out AND time_out > :new_in';
    $params = [
        ':uid'     => $userId,
        ':date'    => $workDate,
        ':new_in'  => $timeIn,
        ':new_out' => $timeOut,
    ];
    if ($excludeDtrId !== null) {
        $sql .= ' AND dtr_id != :exclude';
        $params[':exclude'] = $excludeDtrId;
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return (int)$stmt->fetchColumn() > 0;
}

function has_existing_entry_on_date(int $userId, string $workDate): bool
{
    $pdo = get_db();
    $stmt = $pdo->prepare(
        'SELECT COUNT(*) FROM dtr_entries
         WHERE user_id = :uid AND work_date = :date
           AND status IN (\'approved\', \'pending\')'
    );
    $stmt->execute([':uid' => $userId, ':date' => $workDate]);
    return (int)$stmt->fetchColumn() > 0;
}

/**
 * Head SA adds a DTR entry for a given Student Assistant. Written
 * directly as 'approved' since the Head SA is the source of the
 * record (no separate approval step needed in this model).
 */
function add_dtr_entry(int $headSaId, int $saUserId, string $workDate, string $timeIn, string $timeOut): array
{
    $pdo = get_db();

    // Server-side format check -- these are now plain text fields (not
    // browser-constrained <input type="time">), so never trust the format.
    if (!preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeIn) || !preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeOut)) {
        return ['ok' => false, 'error' => 'Time must be in 24-hour HH:MM format (e.g. 08:00, 17:30).'];
    }

    // Confirm target is actually an active Student Assistant.
    $check = $pdo->prepare("SELECT user_id FROM users WHERE user_id = :id AND role = 'student_assistant' AND is_active = 1");
    $check->execute([':id' => $saUserId]);
    if (!$check->fetch()) {
        return ['ok' => false, 'error' => 'Invalid Student Assistant selected.'];
    }

    $timeInFull  = $workDate . ' ' . $timeIn . ':00';
    $timeOutFull = $workDate . ' ' . $timeOut . ':00';

    if ($timeOutFull <= $timeInFull) {
        $timeOutFull = date('Y-m-d H:i:s', strtotime($timeOutFull . ' +1 day'));
    }
    if ($timeOutFull <= $timeInFull) {
        return ['ok' => false, 'error' => 'Time out must be after time in.'];
    }

    if (has_overlap($saUserId, $workDate, $timeInFull, $timeOutFull)) {
        return ['ok' => false, 'error' => 'This time range overlaps an existing entry for that date.'];
    }

    $insert = $pdo->prepare(
        'INSERT INTO dtr_entries (user_id, work_date, time_in, time_out, status, approved_by, approved_at)
         VALUES (:uid, :date, :tin, :tout, :status, :approver, NOW())'
    );
    $insert->execute([
        ':uid'      => $saUserId,
        ':date'     => $workDate,
        ':tin'      => $timeInFull,
        ':tout'     => $timeOutFull,
        ':status'   => 'approved',
        ':approver' => $headSaId,
    ]);

    $dtrId = (int)$pdo->lastInsertId();
    audit_log($headSaId, 'DTR_ENTRY_ADDED', 'dtr_entries', $dtrId, [
        'for_user_id' => $saUserId, 'work_date' => $workDate, 'time_in' => $timeInFull, 'time_out' => $timeOutFull,
    ]);

    return ['ok' => true, 'dtr_id' => $dtrId];
}

/** Head SA edits an existing entry (e.g. fixing a typo from paper DTR). */
function edit_dtr_entry(int $headSaId, int $dtrId, string $workDate, string $timeIn, string $timeOut): array
{
    $pdo = get_db();

    if (!preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeIn) || !preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeOut)) {
        return ['ok' => false, 'error' => 'Time must be in 24-hour HH:MM format (e.g. 08:00, 17:30).'];
    }

    $stmt = $pdo->prepare('SELECT * FROM dtr_entries WHERE dtr_id = :id');
    $stmt->execute([':id' => $dtrId]);
    $entry = $stmt->fetch();
    if (!$entry) {
        return ['ok' => false, 'error' => 'Entry not found.'];
    }

    $timeInFull  = $workDate . ' ' . $timeIn . ':00';
    $timeOutFull = $workDate . ' ' . $timeOut . ':00';

    if ($timeOutFull <= $timeInFull) {
        $timeOutFull = date('Y-m-d H:i:s', strtotime($timeOutFull . ' +1 day'));
    }
    if ($timeOutFull <= $timeInFull) {
        return ['ok' => false, 'error' => 'Time out must be after time in.'];
    }
    if (has_overlap((int)$entry['user_id'], $workDate, $timeInFull, $timeOutFull, $dtrId)) {
        return ['ok' => false, 'error' => 'This time range overlaps another existing entry for that date.'];
    }

    $update = $pdo->prepare(
        'UPDATE dtr_entries SET work_date = :date, time_in = :tin, time_out = :tout, approved_by = :approver, approved_at = NOW()
         WHERE dtr_id = :id'
    );
    $update->execute([
        ':date' => $workDate, ':tin' => $timeInFull, ':tout' => $timeOutFull,
        ':approver' => $headSaId, ':id' => $dtrId,
    ]);

    audit_log($headSaId, 'DTR_ENTRY_EDITED', 'dtr_entries', $dtrId, [
        'work_date' => $workDate, 'time_in' => $timeInFull, 'time_out' => $timeOutFull,
    ]);

    return ['ok' => true];
}

/** Head SA deletes an entry (e.g. duplicate encoding mistake). Logged, not silent. */
function delete_dtr_entry(int $headSaId, int $dtrId): array
{
    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT * FROM dtr_entries WHERE dtr_id = :id');
    $stmt->execute([':id' => $dtrId]);
    $entry = $stmt->fetch();
    if (!$entry) {
        return ['ok' => false, 'error' => 'Entry not found.'];
    }

    $pdo->prepare('DELETE FROM dtr_entries WHERE dtr_id = :id')->execute([':id' => $dtrId]);

    audit_log($headSaId, 'DTR_ENTRY_DELETED', 'dtr_entries', $dtrId, [
        'was_for_user_id' => $entry['user_id'], 'work_date' => $entry['work_date'],
        'time_in' => $entry['time_in'], 'time_out' => $entry['time_out'],
    ]);

    return ['ok' => true];
}

function delete_all_dtr_entries(int $headSaId): array
{
    $pdo = get_db();
    
    // First, count how many we are deleting so we can log it
    $stmt = $pdo->query('SELECT COUNT(*) FROM dtr_entries');
    $count = (int)$stmt->fetchColumn();
    
    if ($count === 0) {
        return ['ok' => false, 'error' => 'There are no DTR entries to delete.'];
    }

    $pdo->exec('DELETE FROM dtr_entries');
    
    audit_log($headSaId, 'ALL_DTR_ENTRIES_DELETED', 'dtr_entries', 0, [
        'total_deleted' => $count
    ]);

    return ['ok' => true];
}

/**
 * Bulk-add entries for one date across many SAs at once (e.g. the
 * whole roster of 20+ SAs for "today"). Rows with a blank time_in
 * OR time_out are silently skipped (that SA simply wasn't on duty
 * that day). Every non-blank row still goes through the same
 * overlap + validation checks as a single add_dtr_entry() call.
 *
 * $rows: [ saUserId => ['time_in' => 'HH:MM', 'time_out' => 'HH:MM'], ... ]
 *
 * Returns ['added' => int, 'skipped' => int, 'errors' => [saUserId => message]]
 */
function bulk_add_dtr_entries(int $headSaId, string $workDate, array $rows): array
{
    $added = 0;
    $skipped = 0;
    $errors = [];

    foreach ($rows as $saUserId => $times) {
        $timeIn  = trim($times['time_in'] ?? '');
        $timeOut = trim($times['time_out'] ?? '');

        if ($timeIn === '' && $timeOut === '') {
            $skipped++;
            continue; // SA not on duty that day -- not an error
        }
        if ($timeIn === '' || $timeOut === '') {
            $errors[(int)$saUserId] = 'Only one of time in/time out was filled in.';
            continue;
        }

        $result = add_dtr_entry($headSaId, (int)$saUserId, $workDate, $timeIn, $timeOut);
        if ($result['ok']) {
            $added++;
        } else {
            $errors[(int)$saUserId] = $result['error'];
        }
    }

    return ['added' => $added, 'skipped' => $skipped, 'errors' => $errors];
}
function get_dtr_history(int $userId, ?int $year = null, ?int $month = null, int $limit = 100): array
{
    $pdo = get_db();
    if ($year !== null && $month !== null) {
        $stmt = $pdo->prepare(
            'SELECT * FROM dtr_entries
             WHERE user_id = :uid AND YEAR(work_date) = :yr AND MONTH(work_date) = :mo
             ORDER BY work_date DESC, time_in DESC LIMIT :lim'
        );
        $stmt->bindValue(':yr', $year, PDO::PARAM_INT);
        $stmt->bindValue(':mo', $month, PDO::PARAM_INT);
    } else {
        $stmt = $pdo->prepare(
            'SELECT * FROM dtr_entries WHERE user_id = :uid ORDER BY work_date DESC, time_in DESC LIMIT :lim'
        );
    }
    $stmt->bindValue(':uid', $userId, PDO::PARAM_INT);
    $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll();
}

/** All entries across all SAs, most recent first -- for the Head SA's management table. */
function get_all_dtr_entries(int $page = 1, int $perPage = 100): array
{
    $pdo = get_db();
    $offset = ($page - 1) * $perPage;
    $stmt = $pdo->prepare(
        "SELECT d.*, u.full_name, u.id_number FROM dtr_entries d
         JOIN users u ON u.user_id = d.user_id
         ORDER BY d.work_date DESC, d.time_in DESC LIMIT :lim OFFSET :off"
    );
    $stmt->bindValue(':lim', $perPage, PDO::PARAM_INT);
    $stmt->bindValue(':off', $offset, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll();
}

function get_all_dtr_entries_count(): int
{
    return (int)get_db()->query("SELECT COUNT(*) FROM dtr_entries")->fetchColumn();
}

/**
 * Computes an SA's rendered hours, required hours, remaining hours,
 * and OT (banked hours beyond the total required quota -- cumulative
 * across the whole period, not per day).
 */
function get_dtr_summary(int $userId): array
{
    // Use the per-SA required hours set on their account, not the global default.
    $requiredStmt = get_db()->prepare('SELECT required_hours FROM users WHERE user_id = :uid');
    $requiredStmt->execute([':uid' => $userId]);
    $required = (float)$requiredStmt->fetchColumn();

    $rowsStmt = get_db()->prepare(
        "SELECT time_in, time_out FROM dtr_entries
         WHERE user_id = :uid AND time_out IS NOT NULL AND status = 'approved'"
    );
    $rowsStmt->execute([':uid' => $userId]);

    $rendered = 0.0;
    foreach ($rowsStmt->fetchAll() as $row) {
        $rendered += compute_net_hours($row['time_in'], $row['time_out']) ?? 0.0;
    }

    $cashoutStmt = get_db()->prepare(
        "SELECT SUM(hours_requested) FROM ot_cashouts
         WHERE user_id = :uid AND status IN ('pending', 'approved')"
    );
    $cashoutStmt->execute([':uid' => $userId]);
    $cashedOut = (float)$cashoutStmt->fetchColumn();

    $advanceStmt = get_db()->prepare(
        "SELECT SUM(hours_requested) FROM ot_advances
         WHERE user_id = :uid AND status = 'approved'"
    );
    $advanceStmt->execute([':uid' => $userId]);
    $advance = (float)$advanceStmt->fetchColumn();

    $remaining = max(0, $required - ($rendered + $advance));
    $ot        = max(0, ($rendered + $advance) - $required - $cashedOut);

    return [
        'required'  => round($required, 2),
        'rendered'  => round($rendered, 2),
        'remaining' => round($remaining, 2),
        'ot'        => round($ot, 2),
        'advance'   => round($advance, 2),
    ];
}

// ------------------------------------------------------------
// SA self-submission with photo evidence (pending Head SA review)
// ------------------------------------------------------------

const DTR_PHOTO_STORAGE_DIR = __DIR__ . '/../storage/dtr_photos';
const DTR_PHOTO_ALLOWED_MIME = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];

/**
 * Validates and stores an uploaded DTR photo. Never trusts the
 * original filename or client-reported MIME type -- verifies the
 * actual file content and generates a random server-side filename
 * to prevent path traversal / overwrite / executable-upload attacks.
 *
 * Returns ['ok' => true, 'path' => relativeFilename] or ['ok' => false, 'error' => ...].
 */
function store_dtr_photo(array $file): array
{
    if (!isset($file['error']) || $file['error'] !== UPLOAD_ERR_OK) {
        return ['ok' => false, 'error' => 'Photo upload failed. Please try again.'];
    }
    if ($file['size'] > MAX_PHOTO_UPLOAD_MB * 1024 * 1024) {
        return ['ok' => false, 'error' => 'Photo is too large (max ' . MAX_PHOTO_UPLOAD_MB . ' MB).'];
    }
    if (!is_uploaded_file($file['tmp_name'])) {
        return ['ok' => false, 'error' => 'Invalid upload.'];
    }

    // Verify actual file content, not the client-supplied MIME/extension.
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $actualMime = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!isset(DTR_PHOTO_ALLOWED_MIME[$actualMime])) {
        return ['ok' => false, 'error' => 'Only JPG, PNG, or WEBP photos are allowed.'];
    }

    if (!is_dir(DTR_PHOTO_STORAGE_DIR)) {
        mkdir(DTR_PHOTO_STORAGE_DIR, 0755, true);
    }

    $ext = DTR_PHOTO_ALLOWED_MIME[$actualMime];
    $randomName = bin2hex(random_bytes(16)) . '.' . $ext;
    $destination = DTR_PHOTO_STORAGE_DIR . '/' . $randomName;

    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        return ['ok' => false, 'error' => 'Could not save the uploaded photo.'];
    }

    return ['ok' => true, 'path' => $randomName];
}

/**
 * Generates the list of calendar dates for a payroll cutoff period.
 * $period is 'first_half' (1st-15th) or 'second_half' (16th to the
 * actual last day of that month). The last day is computed via
 * PHP's date('t'), which already accounts for 30 vs 31-day months
 * and February 28 vs 29 (leap years) correctly -- no manual leap
 * year logic needed.
 */
function generate_period_dates(int $year, int $month, string $period): array
{
    if ($month < 1 || $month > 12) {
        return [];
    }

    $lastDayOfMonth = (int)date('t', strtotime(sprintf('%04d-%02d-01', $year, $month)));

    if ($period === 'first_half') {
        $startDay = 1;
        $endDay = 15;
    } else { // 'second_half'
        $startDay = 16;
        $endDay = $lastDayOfMonth;
    }

    $dates = [];
    for ($day = $startDay; $day <= $endDay; $day++) {
        $dates[] = sprintf('%04d-%02d-%02d', $year, $month, $day);
    }
    return $dates;
}

/**
 * Validates and inserts one SA-submitted DTR row, given an already-
 * stored photo path (shared across a whole bulk submission -- see
 * submit_dtr_entries_by_sa_bulk() below). Split out from
 * submit_dtr_entry_by_sa() so both the single-day and bulk-period
 * flows share the exact same validation logic.
 */
function insert_sa_dtr_row(int $saUserId, string $workDate, string $timeIn, string $timeOut, string $photoPath): array
{
    if (!preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeIn) || !preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', $timeOut)) {
        return ['ok' => false, 'error' => 'Time must be in 24-hour HH:MM format (e.g. 08:00, 17:30).'];
    }

    $timeInFull  = $workDate . ' ' . $timeIn . ':00';
    $timeOutFull = $workDate . ' ' . $timeOut . ':00';

    if ($timeOutFull <= $timeInFull) {
        $timeOutFull = date('Y-m-d H:i:s', strtotime($timeOutFull . ' +1 day'));
    }
    if ($timeOutFull <= $timeInFull) {
        return ['ok' => false, 'error' => 'Time out must be after time in.'];
    }
    if (has_overlap($saUserId, $workDate, $timeInFull, $timeOutFull)) {
        return ['ok' => false, 'error' => 'This time range overlaps one of your already-approved entries for that date.'];
    }

    $pdo = get_db();
    $insert = $pdo->prepare(
        'INSERT INTO dtr_entries (user_id, work_date, time_in, time_out, status, photo_path)
         VALUES (:uid, :date, :tin, :tout, :status, :photo)'
    );
    $insert->execute([
        ':uid'    => $saUserId,
        ':date'   => $workDate,
        ':tin'    => $timeInFull,
        ':tout'   => $timeOutFull,
        ':status' => 'pending',
        ':photo'  => $photoPath,
    ]);

    $dtrId = (int)$pdo->lastInsertId();
    audit_log($saUserId, 'DTR_SELF_SUBMITTED', 'dtr_entries', $dtrId, ['work_date' => $workDate]);

    return ['ok' => true, 'dtr_id' => $dtrId];
}

/**
 * SA submits an entire cutoff period (1-15 or 16-end-of-month) at
 * once, attaching ONE photo of their DTR sheet that covers the whole
 * period, with per-day time in/out. Days left blank (both fields
 * empty) are skipped -- not on duty that day, not an error.
 *
 * $dayRows: [ 'YYYY-MM-DD' => ['time_in' => 'HH:MM', 'time_out' => 'HH:MM'], ... ]
 *
 * Returns ['ok' => true, 'added' => int, 'skipped' => int, 'errors' => [date => message]]
 * or ['ok' => false, 'error' => ...] if the photo itself fails to upload.
 */
function submit_dtr_entries_by_sa_bulk(int $saUserId, array $dayRows, array $photoFile): array
{
    $photoResult = store_dtr_photo($photoFile);
    if (!$photoResult['ok']) {
        return $photoResult;
    }
    $photoPath = $photoResult['path'];

    $added = 0;
    $skipped = 0;
    $errors = [];

    foreach ($dayRows as $workDate => $times) {
        $timeIn  = trim($times['time_in'] ?? '');
        $timeOut = trim($times['time_out'] ?? '');

        if ($timeIn === '' && $timeOut === '') {
            $skipped++;
            continue;
        }
        if ($timeIn === '' || $timeOut === '') {
            $errors[$workDate] = 'Only one of time in/time out was filled in.';
            continue;
        }

        if (has_existing_entry_on_date($saUserId, $workDate)) {
            $skipped++;
            continue;
        }

        $result = insert_sa_dtr_row($saUserId, $workDate, $timeIn, $timeOut, $photoPath);
        if ($result['ok']) {
            $added++;
        } else {
            $errors[$workDate] = $result['error'];
        }
    }

    return ['ok' => true, 'added' => $added, 'skipped' => $skipped, 'errors' => $errors, 'photo_path' => $photoPath];
}

/**
 * SA submits their own entry with photo evidence. Always written as
 * 'pending' -- never auto-approved, since the submitter is the same
 * person the hours belong to (that's exactly the case separation of
 * duties exists for). A Head SA must review and approve/reject it
 * before it counts toward rendered hours.
 */
function submit_dtr_entry_by_sa(int $saUserId, string $workDate, string $timeIn, string $timeOut, array $photoFile): array
{
    $photoResult = store_dtr_photo($photoFile);
    if (!$photoResult['ok']) {
        return $photoResult;
    }

    return insert_sa_dtr_row($saUserId, $workDate, $timeIn, $timeOut, $photoResult['path']);
}

/** Head SA approves a pending SA self-submission. Cannot approve one's own entry. */
function approve_dtr_entry(int $headSaId, int $dtrId): array
{
    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT * FROM dtr_entries WHERE dtr_id = :id');
    $stmt->execute([':id' => $dtrId]);
    $entry = $stmt->fetch();

    if (!$entry) {
        return ['ok' => false, 'error' => 'Entry not found.'];
    }
    if ((int)$entry['user_id'] === $headSaId) {
        audit_log($headSaId, 'DTR_SELF_APPROVE_BLOCKED', 'dtr_entries', $dtrId);
        return ['ok' => false, 'error' => 'You cannot approve your own entry.'];
    }
    if ($entry['status'] !== 'pending') {
        return ['ok' => false, 'error' => 'Only pending entries can be approved.'];
    }

    $update = $pdo->prepare(
        "UPDATE dtr_entries SET status = 'approved', approved_by = :approver, approved_at = NOW(), rejection_reason = NULL WHERE dtr_id = :id"
    );
    $update->execute([':approver' => $headSaId, ':id' => $dtrId]);

    audit_log($headSaId, 'DTR_APPROVED', 'dtr_entries', $dtrId, ['for_user_id' => $entry['user_id']]);

    return ['ok' => true];
}

/** Head SA rejects a pending SA self-submission, with a reason shown back to the SA. */
function reject_dtr_entry(int $headSaId, int $dtrId, string $reason): array
{
    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT * FROM dtr_entries WHERE dtr_id = :id');
    $stmt->execute([':id' => $dtrId]);
    $entry = $stmt->fetch();

    if (!$entry) {
        return ['ok' => false, 'error' => 'Entry not found.'];
    }
    if ($entry['status'] !== 'pending') {
        return ['ok' => false, 'error' => 'Only pending entries can be rejected.'];
    }
    if (trim($reason) === '') {
        return ['ok' => false, 'error' => 'Please provide a reason for rejecting this entry.'];
    }

    $update = $pdo->prepare(
        "UPDATE dtr_entries SET status = 'rejected', approved_by = :approver, approved_at = NOW(), rejection_reason = :reason WHERE dtr_id = :id"
    );
    $update->execute([':approver' => $headSaId, ':reason' => trim($reason), ':id' => $dtrId]);

    audit_log($headSaId, 'DTR_REJECTED', 'dtr_entries', $dtrId, ['for_user_id' => $entry['user_id'], 'reason' => trim($reason)]);

    return ['ok' => true];
}

/** All pending SA self-submissions across the roster, oldest first (first submitted, first reviewed). */
function get_pending_submissions(): array
{
    $pdo = get_db();
    $stmt = $pdo->query(
        "SELECT d.*, u.full_name, u.id_number FROM dtr_entries d
         JOIN users u ON u.user_id = d.user_id
         WHERE d.status = 'pending' AND d.photo_path IS NOT NULL
         ORDER BY d.created_at ASC"
    );
    return $stmt->fetchAll();
}

/** Fetch a single entry by id (used by the photo viewer and review actions). */
function get_dtr_entry(int $dtrId): ?array
{
    $pdo = get_db();
    $stmt = $pdo->prepare('SELECT * FROM dtr_entries WHERE dtr_id = :id');
    $stmt->execute([':id' => $dtrId]);
    $row = $stmt->fetch();
    return $row ?: null;
}

/**
 * Is this entry's photo viewable by the given user? Any Head SA can
 * view any photo (that's the point of review); an SA can only view
 * the photo on their own entry.
 */
function can_view_dtr_photo(int $dtrId, int $viewerUserId, string $viewerRole): bool
{
    if ($viewerRole === 'head_sa') {
        return true;
    }
    $entry = get_dtr_entry($dtrId);
    return $entry !== null && (int)$entry['user_id'] === $viewerUserId;
}

/**
 * Calculates the total approved hours for all student assistants in a specific cut-off period.
 * Used by Head SA to print period-based summary reports.
 */
function get_cutoff_report(int $year, int $month, string $period): array
{
    $pdo = get_db();
    $dayStart = $period === 'first_half' ? 1 : 16;
    $dayEnd   = $period === 'first_half' ? 15 : 31;
    
    $sql = "
        SELECT 
            u.id_number,
            u.full_name,
            SUM(d.computed_hours) as total_hours
        FROM users u
        LEFT JOIN dtr_entries d ON u.user_id = d.user_id 
            AND d.status = 'approved'
            AND YEAR(d.work_date) = :yr
            AND MONTH(d.work_date) = :mo
            AND DAY(d.work_date) BETWEEN :ds AND :de
        WHERE u.role = 'student_assistant'
        GROUP BY u.user_id
        ORDER BY u.full_name ASC
    ";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':yr' => $year,
        ':mo' => $month,
        ':ds' => $dayStart,
        ':de' => $dayEnd,
    ]);
    return $stmt->fetchAll();
}

/**
 * Calculates the breakdown of approved hours for a specific student assistant across all cut-offs.
 * Used by Head SA to print individual cashout vouchers.
 */
function get_sa_hours_breakdown(int $userId): array
{
    $pdo = get_db();
    $sql = "
        SELECT 
            YEAR(work_date) as yr,
            MONTH(work_date) as mo,
            IF(DAY(work_date) <= 15, 'first_half', 'second_half') as period,
            SUM(computed_hours) as total_hours
        FROM dtr_entries
        WHERE user_id = :uid AND status = 'approved'
        GROUP BY yr, mo, period
        ORDER BY yr ASC, mo ASC, period ASC
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([':uid' => $userId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

/**
 * Detailed duty report: returns every individual DTR entry for a given
 * year/month/period, optionally filtered by a specific SA and/or status.
 * Used by Head SA in the Reports tab for a full day-by-day view.
 */
function get_detailed_duty_report(int $year, int $month, string $period, ?int $userId = null, ?string $status = null): array
{
    $pdo = get_db();
    $dayStart = $period === 'first_half' ? 1 : 16;
    $dayEnd   = $period === 'first_half' ? 15 : (int)date('t', mktime(0, 0, 0, $month, 1, $year));

    $sql = "
        SELECT 
            d.dtr_id, d.work_date, d.time_in, d.time_out, d.computed_hours,
            d.status, d.created_at,
            u.id_number, u.full_name, u.user_id
        FROM dtr_entries d
        JOIN users u ON u.user_id = d.user_id
        WHERE YEAR(d.work_date) = :yr
          AND MONTH(d.work_date) = :mo
          AND DAY(d.work_date) BETWEEN :ds AND :de
    ";
    $params = [
        ':yr' => $year,
        ':mo' => $month,
        ':ds' => $dayStart,
        ':de' => $dayEnd,
    ];

    if ($userId !== null && $userId > 0) {
        $sql .= " AND d.user_id = :uid";
        $params[':uid'] = $userId;
    }
    if ($status !== null && in_array($status, ['approved', 'pending', 'rejected'], true)) {
        $sql .= " AND d.status = :status";
        $params[':status'] = $status;
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}
