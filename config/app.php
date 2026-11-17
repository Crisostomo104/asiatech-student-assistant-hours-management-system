<?php
/**
 * App bootstrap: secure session settings, error handling, timezone,
 * and dynamic Head-SA-configurable settings (loaded from the DB).
 * Require this at the top of every entry-point page.
 */

declare(strict_types=1);

ini_set('display_errors', '0');
ini_set('log_errors', '1');

require_once __DIR__ . '/env.php';
load_env_file(dirname(__DIR__) . DIRECTORY_SEPARATOR . '.env');

$appEnvironment = env_value('APP_ENV', 'production');
if ($appEnvironment !== 'production' && $appEnvironment !== 'development') {
    throw new RuntimeException('APP_ENV must be production or development.');
}
define('APP_ENV', $appEnvironment);

$appTimezone = env_value('APP_TIMEZONE', 'Asia/Manila');
if ($appTimezone === null || !in_array($appTimezone, timezone_identifiers_list(), true)) {
    throw new RuntimeException('APP_TIMEZONE must be a valid timezone identifier.');
}
date_default_timezone_set($appTimezone);

// Never display raw PHP errors to users -- log them instead.
if (APP_ENV === 'development') {
    ini_set('display_errors', '1'); // fine for local XAMPP testing only
}

require_once __DIR__ . '/database.php';
require_once __DIR__ . '/../includes/settings.php';
require_once __DIR__ . '/../includes/audit.php';
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/dtr.php';
require_once __DIR__ . '/../includes/monthly_hours.php';
require_once __DIR__ . '/../includes/ot_cashout.php';
require_once __DIR__ . '/../includes/turnstile.php';

// --- Dynamic, Head-SA-editable settings (see public/settings.php) ---
define('MAX_LOGIN_ATTEMPTS',              (int)get_setting('login_max_attempts', 5));
define('LOCKOUT_WINDOW_MINUTES',          (int)get_setting('login_lockout_window_minutes', 15));
define('MAX_PHOTO_UPLOAD_MB',           (float)get_setting('max_photo_upload_mb', 5));
define('BREAK_DEDUCTION_THRESHOLD_HOURS',(float)get_setting('break_deduction_threshold_hours', 8));
define('DEFAULT_REQUIRED_HOURS',        (float)get_setting('default_required_hours', 200));

function is_https_request(): bool
{
    if (!empty($_SERVER['HTTPS']) && strtolower((string)$_SERVER['HTTPS']) !== 'off') {
        return true;
    }

    $forwardedProtos = $_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '';
    if (is_string($forwardedProtos)) {
        foreach (explode(',', $forwardedProtos) as $proto) {
            if (strtolower(trim($proto)) === 'https') {
                return true;
            }
        }
    }

    return false;
}

// --- Secure session cookie settings + session_start ---
if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 0,          // cookie lasts until browser is closed
        'path'     => '/',
        'domain'   => '',
        'secure'   => is_https_request(),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}