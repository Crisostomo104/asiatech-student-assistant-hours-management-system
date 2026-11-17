<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';

require_login();

$message = null;
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $result = change_password(
        current_user_id(),
        $_POST['current_password'] ?? '',
        $_POST['new_password'] ?? '',
        $_POST['confirm_password'] ?? ''
    );
    $result['ok'] ? $message = 'Password changed successfully.' : $error = $result['error'];
}
?>
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - SAHMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">SAHMS</span>
        <span class="text-white me-3"><?= htmlspecialchars($_SESSION['name'], ENT_QUOTES) ?></span>
        <div>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Log Out</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">

            <?php if ($message): ?><div class="alert alert-success"><?= htmlspecialchars($message, ENT_QUOTES) ?></div><?php endif; ?>
            <?php if ($error): ?><div class="alert alert-danger"><?= htmlspecialchars($error, ENT_QUOTES) ?></div><?php endif; ?>

            <div class="card">
                <div class="card-body">
                    <h2 class="h5 mb-3">Change Password</h2>
                    <form method="post">
                        <?= csrf_field() ?>
                        <div class="mb-3">
                            <label class="form-label">Current Password</label>
                            <input type="password" name="current_password" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Password</label>
                            <input type="password" name="new_password" class="form-control" minlength="10" required>
                            <div class="form-text">At least 10 characters, including one uppercase letter and one number.</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirm New Password</label>
                            <input type="password" name="confirm_password" class="form-control" minlength="10" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Update Password</button>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>