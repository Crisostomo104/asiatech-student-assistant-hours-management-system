<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/../includes/dtr.php';

require_role('head_sa');

$message = null;
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();
    $action = $_POST['action'] ?? '';

    if ($action === 'add_sa') {
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
        );
        $result['ok'] ? $message = 'Student Assistant account created.' : $error = $result['error'];
    } elseif ($action === 'toggle_active') {
        $result = set_sa_active_status(current_user_id(), (int)($_POST['sa_user_id'] ?? 0), $_POST['active'] === '1');
        $result['ok'] ? $message = 'Status updated.' : $error = $result['error'];
    } elseif ($action === 'delete_permanently') {
        $result = delete_sa_permanently(current_user_id(), (int)($_POST['sa_user_id'] ?? 0));
        $result['ok'] ? $message = 'Account permanently deleted.' : $error = $result['error'];
    }
}

$saList = list_all_student_assistants();
$dueForReview = get_accounts_due_for_review();
?>
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Student Assistants - SAHMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">SAHMS</span>
        <span class="text-white me-3"><?= htmlspecialchars($_SESSION['name'], ENT_QUOTES) ?> (Head SA)</span>
        <div>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
            <a href="settings.php" class="btn btn-outline-light btn-sm me-2">Settings</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Log Out</a>
        </div>
    </div>
</nav>

<div class="container">

    <?php if ($message): ?><div class="alert alert-success"><?= htmlspecialchars($message, ENT_QUOTES) ?></div><?php endif; ?>
    <?php if ($error): ?><div class="alert alert-danger"><?= htmlspecialchars($error, ENT_QUOTES) ?></div><?php endif; ?>

    <div class="card mb-4">
        <div class="card-body">
            <h2 class="h5">Add Student Assistant</h2>
            <form method="post" class="row g-3" data-sa-name-form>
                <?= csrf_field() ?>
                <input type="hidden" name="action" value="add_sa">
                <input type="hidden" name="full_name">
                <div class="col-md-3">
                    <label class="form-label" for="saIdNumber">Student Number <span class="text-danger" aria-hidden="true">*</span></label>
                    <input type="text" id="saIdNumber" name="id_number" class="form-control text-uppercase" data-uppercase autocomplete="off" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="saLastName">Last Name <span class="text-danger" aria-hidden="true">*</span></label>
                    <input type="text" id="saLastName" name="last_name" class="form-control text-uppercase" data-name-part="last" data-uppercase autocomplete="family-name" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="saFirstName">First Name <span class="text-danger" aria-hidden="true">*</span></label>
                    <input type="text" id="saFirstName" name="first_name" class="form-control text-uppercase" data-name-part="first" data-uppercase autocomplete="given-name" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="saMiddleName">Middle Name <span class="text-muted fw-normal">(optional)</span></label>
                    <input type="text" id="saMiddleName" name="middle_name" class="form-control text-uppercase" data-name-part="middle" data-uppercase autocomplete="additional-name">
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="saSuffix">Suffix <span class="text-muted fw-normal">(optional)</span></label>
                    <select id="saSuffix" name="suffix" class="form-select text-uppercase" data-name-part="suffix" data-uppercase>
                        <option value="">None</option>
                        <option value="JR.">Jr.</option>
                        <option value="SR.">Sr.</option>
                        <option value="II">II</option>
                        <option value="III">III</option>
                        <option value="IV">IV</option>
                        <option value="V">V</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="saEmail">Email <span class="text-danger" aria-hidden="true">*</span></label>
                    <input type="email" id="saEmail" name="email" class="form-control" autocomplete="email" required>
                </div>
                <div class="col-12">
                    <label class="form-label" for="saFullNamePreview">Full Name Preview <span class="text-muted fw-normal">(surname first)</span></label>
                    <output id="saFullNamePreview" class="form-control bg-light fw-semibold" data-full-name-preview aria-live="polite">Start typing a name to preview.</output>
                    <div class="form-text">A single-letter middle name will include a period, e.g. Dela Cruz, Juan M. Jr.</div>
                </div>
                <div class="col-12">
                    <button class="btn btn-primary w-100">Add SA</button>
                </div>
            </form>
        </div>
    </div>

    <?php if ($dueForReview): ?>
        <div class="card mb-4 border-warning">
            <div class="card-body">
                <h2 class="h5">Due for Review (<?= count($dueForReview) ?>)</h2>
                <p class="text-muted small">
                    Naka-deactivate na ng matagal ang mga account na ito. Hindi ito awtomatikong nade-delete —
                    ikaw mismo ang magdedesisyon. Pwede lang i-permanently delete kung <strong>zero</strong> ang DTR history nila.
                </p>
                <table class="table table-sm align-middle">
                    <thead><tr><th>Name</th><th>ID Number</th><th>Deactivated Since</th><th>DTR Records</th><th></th></tr></thead>
                    <tbody>
                    <?php foreach ($dueForReview as $sa): ?>
                        <tr>
                            <td><?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?></td>
                            <td><?= htmlspecialchars($sa['id_number'], ENT_QUOTES) ?></td>
                            <td><?= htmlspecialchars($sa['deactivated_at'], ENT_QUOTES) ?></td>
                            <td><?= (int)$sa['dtr_count'] ?></td>
                            <td>
                                <?php if ((int)$sa['dtr_count'] === 0): ?>
                                    <form method="post" onsubmit="return confirm('Permanently delete this account? Hindi na ito mababawi.');">
                                        <?= csrf_field() ?>
                                        <input type="hidden" name="action" value="delete_permanently">
                                        <input type="hidden" name="sa_user_id" value="<?= (int)$sa['user_id'] ?>">
                                        <button class="btn btn-sm btn-outline-danger">Delete Permanently</button>
                                    </form>
                                <?php else: ?>
                                    <span class="text-muted small">May DTR history &mdash; hindi puwedeng i-delete</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    <?php endif; ?>

    <div class="card">
        <div class="card-body">
            <h2 class="h5">All Student Assistants</h2>
            <table class="table table-sm align-middle">
                <thead><tr><th>Name</th><th>ID Number</th><th>Email</th><th>Status</th><th></th></tr></thead>
                <tbody>
                <?php foreach ($saList as $sa): $uid = (int)$sa['user_id']; ?>
                    <tr class="<?= $sa['is_active'] ? '' : 'table-secondary text-muted' ?>">
                        <td><?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?></td>
                        <td><?= htmlspecialchars($sa['id_number'], ENT_QUOTES) ?></td>
                        <td><?= htmlspecialchars($sa['email'], ENT_QUOTES) ?></td>
                        <td><?= $sa['is_active'] ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-secondary">Inactive</span>' ?></td>
                        <td>
                            <form method="post" onsubmit="return confirm('<?= $sa['is_active'] ? 'Deactivate' : 'Reactivate' ?> this SA?');">
                                <?= csrf_field() ?>
                                <input type="hidden" name="action" value="toggle_active">
                                <input type="hidden" name="sa_user_id" value="<?= $uid ?>">
                                <input type="hidden" name="active" value="<?= $sa['is_active'] ? '0' : '1' ?>">
                                <button class="btn btn-sm <?= $sa['is_active'] ? 'btn-outline-danger' : 'btn-outline-success' ?>">
                                    <?= $sa['is_active'] ? 'Deactivate' : 'Reactivate' ?>
                                </button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (!$saList): ?>
                    <tr><td colspan="5" class="text-muted text-center">No Student Assistants yet.</td></tr>
                <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/sahms/public/assets/js/sa-name-preview.js" defer></script>
</body>
</html>