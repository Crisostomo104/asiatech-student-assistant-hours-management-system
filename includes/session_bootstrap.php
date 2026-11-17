<?php
/**
 * Just the secure session cookie setup + session_start(). Split out
 * from config/app.php so that read-only status checks (see
 * public/session_status.php) can open the SAME PHP session without
 * also running app.php's idle-timeout-touch logic -- a pure status
 * read should never itself count as "activity" that resets the idle
 * clock, or the idle timeout would never actually fire while a tab
 * sits open silently polling.
 */

declare(strict_types=1);

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

if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'domain'   => '',
        'secure'   => is_https_request(),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}