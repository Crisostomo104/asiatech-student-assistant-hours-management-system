<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/../includes/dtr.php';

require_role('head_sa');

$message = null;
$error = null;
$activeTabOverride = null; // set to force which tab reopens after a redirect-free POST

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $action = $_POST['action'] ?? '';

    if ($action === 'change_own_password') {
        $result = change_password(
            current_user_id(),
            $_POST['current_password'] ?? '',
            $_POST['new_password'] ?? '',
            $_POST['confirm_password'] ?? ''
        );
        $result['ok'] ? $message = 'Password changed successfully.' : $error = $result['error'];
    } elseif (current_role() === 'head_sa') {
        if ($action === 'save_annual_hours_summary') {
            $year = (int)($_POST['year'] ?? $_GET['year'] ?? date('Y'));
            $result = save_monthly_hours_summary(
                current_user_id(),
                $year,
                $_POST['hours'] ?? [],
                $_POST['ot_hours'] ?? []
            );
            if ($result['ok']) {
                $message = 'Annual Hours Summary saved.';
            } else {
                $error = $result['error'];
            }

            $advanceHours = $_POST['advance_hours'] ?? [];
            if ($result['ok']) {
                foreach ($advanceHours as $userId => $rawHours) {
                $userId = (int)$userId;
                $value = trim((string)$rawHours);
                if ($value === '') {
                    $hours = 0.0;
                } else {
                    $value = str_replace(',', '.', $value);
                    if (!is_numeric($value) || (float)$value < 0) {
                        $error = "Invalid advance hours for SA #{$userId}.";
                        continue;
                    }
                    $hours = (float)$value;
                }

                if (!set_ot_advance_hours($userId, $hours, current_user_id(), $year)) {
                    $error = "Could not save advance hours for SA #{$userId}.";
                }
                }
            }
            $activeTabOverride = 'tab-reports';

        // ---------------- Head SA: Manage Student Assistants ----------------
        } elseif ($action === 'add_sa') {
            $fullName = array_key_exists('last_name', $_POST) || array_key_exists('first_name', $_POST)
                ? format_sa_full_name(
                    (string)($_POST['last_name'] ?? ''),
                    (string)($_POST['first_name'] ?? ''),
                    (string)($_POST['middle_name'] ?? ''),
                    (string)($_POST['suffix'] ?? '')
                )
                : (string)($_POST['full_name'] ?? '');
            $result = head_sa_create_sa(
                current_user_id(),
                $_POST['id_number'] ?? '',
                $fullName,
                $_POST['email'] ?? '',
                $_POST['password'] ?? ''
            );
            $result['ok'] ? $message = 'Student Assistant account created.' : $error = $result['error'];
            $activeTabOverride = 'tab-managesas';
        } elseif ($action === 'toggle_active') {
            $result = set_sa_active_status(current_user_id(), (int)($_POST['sa_user_id'] ?? 0), $_POST['active'] === '1');
            $result['ok'] ? $message = 'Status updated.' : $error = $result['error'];
            $activeTabOverride = 'tab-managesas';
        } elseif ($action === 'delete_permanently') {
            $result = delete_sa_permanently(current_user_id(), (int)($_POST['sa_user_id'] ?? 0));
            $result['ok'] ? $message = 'Account permanently deleted.' : $error = $result['error'];
            $activeTabOverride = 'tab-managesas';

        // ---------------- Head SA: Settings ----------------
        } elseif ($action === 'update_settings') {
            $result = update_settings(current_user_id(), [
                'break_start_time'                => $_POST['break_start_time'] ?? '',
                'break_end_time'                   => $_POST['break_end_time'] ?? '',
                'break_deduction_threshold_hours' => $_POST['break_deduction_threshold_hours'] ?? '',
                'default_required_hours'          => $_POST['default_required_hours'] ?? '',
                'login_max_attempts'              => $_POST['login_max_attempts'] ?? '',
                'login_lockout_window_minutes'    => $_POST['login_lockout_window_minutes'] ?? '',
                'max_photo_upload_mb'             => $_POST['max_photo_upload_mb'] ?? '',
                'deactivation_review_months'      => $_POST['deactivation_review_months'] ?? '',
            ]);
            $result['ok'] ? $message = 'Settings updated.' : $error = $result['error'];
            $activeTabOverride = 'tab-settings';
        }
    }
}

// Flash messages from redirect (kept for compatibility with any external links still using ?msg=)
if (isset($_GET['msg']) && !empty($_GET['msg'])) $message = $_GET['msg'];
if (isset($_GET['err'])) $error = $_GET['err'];

$currentYear = (int)date('Y');
$selectedYear = (int)($_POST['year'] ?? $_GET['year'] ?? $currentYear);
$dueForReview = get_accounts_due_for_review();
$settings = get_all_settings();
$annualSummaryReport = get_annual_hours_summary($selectedYear);
$allSaListForManage = current_role() === 'head_sa' ? list_all_student_assistants() : [];
?>