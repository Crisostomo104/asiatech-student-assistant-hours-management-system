<?php
/**
 * App-wide configurable settings, stored as key-value pairs in
 * app_settings and editable by any Head SA via public/settings.php.
 * Cached per-request in a static array to avoid repeat queries.
 */

declare(strict_types=1);

$settings_cache = null;

function get_all_settings(): array
{
    global $settings_cache;
    if ($settings_cache !== null) {
        return $settings_cache;
    }

    $pdo = get_db();
    $stmt = $pdo->query('SELECT setting_key, setting_value FROM app_settings');
    $settings_cache = [];
    foreach ($stmt->fetchAll() as $row) {
        $settings_cache[$row['setting_key']] = $row['setting_value'];
    }
    return $settings_cache;
}

function get_setting(string $key, $default = null)
{
    $settings = get_all_settings();
    return $settings[$key] ?? $default;
}

function clear_settings_cache(): void
{
    global $settings_cache;
    $settings_cache = null;
}

/** Head SA updates one or more settings at once. Each change is audit-logged individually. */
function update_settings(int $headSaId, array $keyValuePairs): array
{
    $numericKeys = [
        'break_deduction_threshold_hours',
        'default_required_hours',
        'session_timeout_minutes',
        'login_max_attempts',
        'login_lockout_window_minutes',
        'max_photo_upload_mb',
        'deactivation_review_months',
    ];

    // HH:MM (24-hour) time-of-day settings, e.g. "12:00" -- these define
    // the actual lunch break WINDOW. If an SA's time_in-time_out range
    // overlaps this window, only the overlapping portion is deducted
    // (see compute_net_hours() in includes/dtr.php), which is more
    // accurate than a flat "if longer than X hours, minus 1hr" rule.
    $timeKeys = [
        'break_start_time',
        'break_end_time',
    ];

    $allowedKeys = array_merge($numericKeys, $timeKeys);

    $pdo = get_db();
    $update = $pdo->prepare(
        'INSERT INTO app_settings (setting_key, setting_value, updated_by)
         VALUES (:key, :value, :updater)
         ON DUPLICATE KEY UPDATE setting_value = :value2, updated_by = :updater2'
    );

    foreach ($keyValuePairs as $key => $value) {
        if (!in_array($key, $allowedKeys, true)) {
            continue; // ignore anything not in the known settings list
        }

        if (in_array($key, $timeKeys, true)) {
            if (!preg_match('/^([01][0-9]|2[0-3]):[0-5][0-9]$/', (string)$value)) {
                return ['ok' => false, 'error' => "Invalid value for {$key}: must be a 24-hour time like 12:00."];
            }
        } elseif (!is_numeric($value) || (float)$value <= 0) {
            return ['ok' => false, 'error' => "Invalid value for {$key}: must be a positive number."];
        }

        $update->execute([
            ':key' => $key, ':value' => $value, ':updater' => $headSaId,
            ':value2' => $value, ':updater2' => $headSaId,
        ]);

        if ($key === 'default_required_hours') {
            $applyAll = $pdo->prepare(
                'UPDATE users SET required_hours = :value WHERE role = :role'
            );
            $applyAll->execute([':value' => $value, ':role' => 'student_assistant']);
            audit_log($headSaId, 'DEFAULT_REQUIRED_HOURS_APPLIED', 'users', null, ['required_hours' => $value]);
        }

        audit_log($headSaId, 'SETTING_UPDATED', 'app_settings', null, ['key' => $key, 'new_value' => $value]);
    }

    clear_settings_cache();
    return ['ok' => true];
}