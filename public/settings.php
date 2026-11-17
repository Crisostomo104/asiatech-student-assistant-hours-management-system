<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';

require_role('head_sa');

$message = null;
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $result = update_settings(current_user_id(), [
        'break_deduction_threshold_hours' => $_POST['break_deduction_threshold_hours'] ?? '',
        'default_required_hours'          => $_POST['default_required_hours'] ?? '',
        'login_max_attempts'              => $_POST['login_max_attempts'] ?? '',
        'login_lockout_window_minutes'    => $_POST['login_lockout_window_minutes'] ?? '',
        'max_photo_upload_mb'             => $_POST['max_photo_upload_mb'] ?? '',
        'deactivation_review_months'      => $_POST['deactivation_review_months'] ?? '',
    ]);
    if ($result['ok']) {
        $message = 'Settings updated. Default required hours now applies immediately to all SAs; reload the page to see updated values.';
    } else {
        $error = $result['error'];
    }
}

$settings = get_all_settings();
?>
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - SAHMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">SAHMS</span>
        <span class="text-white me-3"><?= htmlspecialchars($_SESSION['name'], ENT_QUOTES) ?> (Head SA)</span>
        <div>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
            <a href="manage_sas.php" class="btn btn-outline-light btn-sm me-2">Manage SAs</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Log Out</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <?php if ($message): ?><div class="alert alert-success"><?= htmlspecialchars($message, ENT_QUOTES) ?></div><?php endif; ?>
            <?php if ($error): ?><div class="alert alert-danger"><?= htmlspecialchars($error, ENT_QUOTES) ?></div><?php endif; ?>

            <form method="post">
                <?= csrf_field() ?>

                <div class="card mb-3">
                    <div class="card-body">
                        <h2 class="h5">DTR Rules</h2>
                        <div class="mb-3">
                            <label class="form-label">Break deduction threshold (hours)</label>
                            <input type="number" step="0.5" min="1" name="break_deduction_threshold_hours"
                                   value="<?= htmlspecialchars($settings['break_deduction_threshold_hours'] ?? '8', ENT_QUOTES) ?>" class="form-control">
                            <div class="form-text">A single DTR entry longer than this gets 1 hour auto-deducted for lunch break. Entries at or under this stay as-is.</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Default required hours (for all SAs)</label>
                            <input type="number" step="1" min="1" name="default_required_hours"
                                   value="<?= htmlspecialchars($settings['default_required_hours'] ?? '200', ENT_QUOTES) ?>" class="form-control">
                            <div class="form-text">Applies immediately to all existing Student Assistants and becomes the default for new SAs. Can still be adjusted per-SA in Manage SAs.</div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h2 class="h5">Security</h2>
                        <div class="mb-3">
                            <label class="form-label">Max failed login attempts before lockout</label>
                            <input type="number" step="1" min="1" name="login_max_attempts"
                                   value="<?= htmlspecialchars($settings['login_max_attempts'] ?? '5', ENT_QUOTES) ?>" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Lockout window (minutes)</label>
                            <input type="number" step="1" min="1" name="login_lockout_window_minutes"
                                   value="<?= htmlspecialchars($settings['login_lockout_window_minutes'] ?? '15', ENT_QUOTES) ?>" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h2 class="h5">Uploads</h2>
                        <div class="mb-3">
                            <label class="form-label">Max DTR photo size (MB)</label>
                            <input type="number" step="1" min="1" name="max_photo_upload_mb"
                                   value="<?= htmlspecialchars($settings['max_photo_upload_mb'] ?? '5', ENT_QUOTES) ?>" class="form-control">
                            <div class="form-text">Also check your php.ini's upload_max_filesize / post_max_size are at least this high.</div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h2 class="h5">Account Cleanup</h2>
                        <div class="mb-3">
                            <label class="form-label">Months deactivated before "Due for Review"</label>
                            <input type="number" step="1" min="1" name="deactivation_review_months"
                                   value="<?= htmlspecialchars($settings['deactivation_review_months'] ?? '12', ENT_QUOTES) ?>" class="form-control">
                            <div class="form-text">Accounts inactive this long appear in Manage SAs for manual review. Never auto-deleted.</div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Save Settings</button>
            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>