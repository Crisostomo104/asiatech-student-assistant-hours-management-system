<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';

if (!empty($_SESSION['user_id']) && current_role() === 'head_sa') {
    header('Location: /sahms/dashboard');
    exit;
}

$error = $_GET['err'] ?? ($_SESSION['flash_error'] ?? null);
unset($_SESSION['flash_error']);
$identifier = '';
$headIdentifier = null;
$studentSummary = null;
$summaryYear = (int)date('Y');
$turnstileSiteKey = turnstile_site_key();
$turnstileConfigured = turnstile_is_configured();

// A verified SA lookup survives a refresh through the session, but only
// until logout or the 30-minute idle timeout clears it.
if ($_SERVER['REQUEST_METHOD'] !== 'POST' && !empty($_SESSION['sa_lookup']['user_id'])) {
    $saLookupYear = (int)($_SESSION['sa_lookup']['year'] ?? $summaryYear);
    $saRows = get_annual_hours_summary($saLookupYear, (int)$_SESSION['sa_lookup']['user_id']);
    $studentSummary = $saRows ? $saRows[0] : null;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    verify_csrf();

    $action = $_POST['action'] ?? '';
    $identifier = trim((string)($_POST['id_number'] ?? $_POST['login_identifier'] ?? ''));
    $captcha = verify_turnstile_request();

    if (!$captcha['ok']) {
        $error = $captcha['error'];
    } elseif ($action === 'lookup' && $identifier !== '') {
        $pdo = get_db();
        $lookup = $pdo->prepare(
            'SELECT user_id, role, is_active FROM users
             WHERE id_number = :id_number OR email = :email
             LIMIT 1'
        );
        $lookup->execute([':id_number' => $identifier, ':email' => $identifier]);
        $account = $lookup->fetch();

        if ($account && (int)$account['is_active'] === 1 && $account['role'] === 'student_assistant') {
            $rows = get_annual_hours_summary($summaryYear, (int)$account['user_id']);
            $studentSummary = $rows ? $rows[0] : null;
            if ($studentSummary) {
                $_SESSION['sa_lookup'] = [
                    'user_id'   => (int)$account['user_id'],
                    'id_number' => (string)$studentSummary['id_number'],
                    'full_name' => (string)$studentSummary['full_name'],
                    'year'      => $summaryYear,
                ];
            }
        } elseif ($account && (int)$account['is_active'] === 1 && $account['role'] === 'head_sa') {
            $headIdentifier = $identifier;
        } else {
            $error = 'Incorrect credentials';
        }
    } elseif ($action === 'head_login' && $identifier !== '') {
        $pdo = get_db();
        $roleLookup = $pdo->prepare(
            "SELECT role, is_active FROM users
             WHERE id_number = :id_number OR email = :email
             LIMIT 1"
        );
        $roleLookup->execute([':id_number' => $identifier, ':email' => $identifier]);
        $account = $roleLookup->fetch();

        if (!$account || $account['role'] !== 'head_sa' || (int)$account['is_active'] !== 1) {
            $error = 'Invalid Head SA credentials.';
        } else {
            $password = (string)($_POST['password'] ?? '');
            if ($password === '') {
                $headIdentifier = $identifier;
                $error = 'Please enter your password.';
            } else {
                $result = attempt_login($identifier, $password);
                if ($result['ok'] && current_role() === 'head_sa') {
                    header('Location: /sahms/dashboard');
                    exit;
                }
                $error = $result['ok'] ? 'Invalid Head SA credentials.' : $result['error'];
                $headIdentifier = $identifier;
            }
        }
    } else {
        $error = 'Enter your student number or Head SA email to continue.';
    }
}

// Background slideshow photos. Add/remove filenames here -- everything
// else (preloading, crossfade timing) adapts automatically.
$bgPhotos = [
    '/sahms/images/bg/bg1.jpg',
    '/sahms/images/bg/bg2.jpg',
    '/sahms/images/bg/bg3.jpg',
    '/sahms/images/bg/bg4.jpg',
    '/sahms/images/bg/bg5.jpg',
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Student Assistant Hours Management System</title>
    <link rel="preload" as="image" href="/sahms/images/asiatech_logo.jpeg">
    <?php foreach ($bgPhotos as $i => $photo): ?>
    <link rel="preload" as="image" href="<?= htmlspecialchars($photo, ENT_QUOTES) ?>" <?= $i === 0 ? 'fetchpriority="high"' : '' ?>>
    <?php endforeach; ?>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="icon" type="images/png" href="/sahms/images/asiatech_logo.jpeg">
    
    <link href="/sahms/public/assets/css/login.css?v=20261129j" rel="stylesheet">
</head>
<body>

<!-- Background photo slideshow -->
<div class="bg-slideshow" aria-hidden="true">
    <?php foreach ($bgPhotos as $i => $photo): ?>
    <div class="bg-slide<?= $i === 0 ? ' active' : '' ?>" style="background-image:url('<?= htmlspecialchars($photo, ENT_QUOTES) ?>');"></div>
    <?php endforeach; ?>
</div>
<!-- Header -->
<header class="site-header">
    <div class="brand">
        <img src="/sahms/images/asiatech_logo.jpeg" alt="asiatech logo">
        <span class="brand-name">ASIATECH<small>Student Assistant Hours Management System</small></span>
    </div>
</header>

<div class="container-fluid login-container">
    <div class="login-wrapper">

        <!-- Left branding + About the System panel (desktop only) -->
        <div class="brand-panel">
            <h1>Student Assistant Hours, made simpler.</h1>

            <div class="about-panel">
                <h2>About The System</h2>
                <p>SAHMS helps Student Assistants check their rendered hours while Head SAs maintain a simple annual summary.</p>
                <ul>
                    <li>Quick time calculator with automatic OT rounding.</li>
                    <li>Annual hours tracking and printable OT summaries.</li>
                    <li>Head SA-only access for official hour entries.</li>
                </ul>
                <p class="about-credit mb-0">Developed by: <a href="https://loadssss.vercel.app/" target="_blank" rel="noopener noreferrer">Loadssss</a></p>
            </div>

        </div>

        <section class="auth-panel" aria-label="Login">
            <div class="card login-card shadow-sm">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <img src="/sahms/images/asiatech_logo.jpeg" alt="asiatech logo" class="login-logo img-fluid mx-auto mb-3">
                        <h1 class="login-title mb-1">Check your hours</h1>
                        <p class="login-subtitle mb-0">Enter your student number to view your summary, or use your Head SA email to sign in.</p>
                    </div>

                    <?php if ($headIdentifier === null): ?>
                        <button
                            type="button"
                            class="btn btn-calculator-trigger w-100 mb-3"
                            data-bs-toggle="modal"
                            data-bs-target="#calculatorModal"
                            aria-haspopup="dialog"
                            aria-controls="calculatorModal">
                            <i class="bi bi-calculator me-1" aria-hidden="true"></i> Open Hours Calculator
                        </button>
                    <?php endif; ?>

                    <?php if ($error): ?>
                        <div class="login-feedback login-feedback-error mb-3" role="alert">
                            <div class="login-feedback-copy">
                                <strong class="login-feedback-title">We couldn't continue</strong>
                                <span><?= htmlspecialchars($error, ENT_QUOTES) ?></span>
                            </div>
                        </div>
                    <?php endif; ?>

                    <?php if ($studentSummary): ?>
                        <div class="verified-sa-hours" role="group" aria-label="Verified student assistant">
                            <div class="verified-sa-identity">
                                <span class="verified-sa-name"><?= htmlspecialchars((string)$studentSummary['full_name'], ENT_QUOTES) ?></span>
                                <span class="verified-sa-id"><?= htmlspecialchars((string)$studentSummary['id_number'], ENT_QUOTES) ?></span>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#studentHoursModal">
                                    <i class="bi bi-clock-history me-1" aria-hidden="true"></i>Open My Hours
                                </button>
                            </div>
                        </div>
                        <div class="sa-logout-row">
                            <a href="/sahms/logout" class="sa-logout-link">
                                <i class="bi bi-box-arrow-right" aria-hidden="true"></i>Log out
                            </a>
                        </div>
                    <?php elseif ($headIdentifier !== null): ?>
                        <form method="post" novalidate>
                            <?= csrf_field() ?>
                            <input type="hidden" name="action" value="head_login">
                            <input type="hidden" name="login_identifier" value="<?= htmlspecialchars($headIdentifier, ENT_QUOTES) ?>">
                            <div class="head-account-summary mb-3" role="group" aria-label="Head SA account">
                                <span class="head-account-label">Signing in as</span>
                                <span class="head-account-value"><?= htmlspecialchars($headIdentifier, ENT_QUOTES) ?></span>
                            </div>
                            <div class="floating-field password-floating-field mb-4">
                                <input
                                    type="password"
                                    class="form-control"
                                    id="password"
                                    name="password"
                                    placeholder=" "
                                    autocomplete="current-password"
                                    required>
                                <label for="password">Head SA Password</label>
                                <button class="password-toggle" type="button" id="togglePassword" aria-label="Show password">
                                    <i class="bi bi-eye" aria-hidden="true"></i>
                                </button>
                            </div>
                            <?php if ($turnstileConfigured): ?>
                                <div class="turnstile-widget mb-2" data-sitekey="<?= htmlspecialchars($turnstileSiteKey, ENT_QUOTES) ?>"></div>
                                <div class="turnstile-status mb-3" data-turnstile-status role="status" aria-live="polite" hidden>
                                    <span data-turnstile-message></span>
                                </div>
                            <?php else: ?>
                                <div class="login-feedback login-feedback-warning mb-3" role="status">
                                    <div class="login-feedback-copy">
                                        <strong class="login-feedback-title">Security check unavailable</strong>
                                        <span>Head SA sign-in is temporarily disabled. Please contact the system administrator.</span>
                                    </div>
                                </div>
                            <?php endif; ?>
                            <button type="submit" class="btn btn-primary w-100" data-turnstile-submit <?= $turnstileConfigured ? 'disabled' : '' ?>>Log In</button>
                            <a class="btn btn-cancel-login w-100 mt-2" href="">
                                <i class="bi bi-x-circle me-1" aria-hidden="true"></i>Cancel Login
                            </a>
                        </form>
                    <?php elseif (!$studentSummary): ?>
                        <form method="post" novalidate>
                            <?= csrf_field() ?>
                            <input type="hidden" name="action" value="lookup">
                            <div class="floating-field mb-3">
                                <input type="text" class="form-control" id="id_number" name="id_number" placeholder=" " autocomplete="username" value="<?= htmlspecialchars($identifier, ENT_QUOTES) ?>" required>
                                <label for="id_number">Student Number or Email</label>
                                <span id="domainHint" class="domain-hint badge bg-primary-subtle text-primary border border-primary-subtle position-absolute end-0 top-50 translate-middle-y me-2" title="Click or press Tab/Right Arrow to append">@asiatech.edu.ph</span>
                            </div>
                            <?php if ($turnstileConfigured): ?>
                                <div class="turnstile-widget mb-2" data-sitekey="<?= htmlspecialchars($turnstileSiteKey, ENT_QUOTES) ?>"></div>
                                <div class="turnstile-status mb-3" data-turnstile-status role="status" aria-live="polite" hidden>
                                    <span data-turnstile-message></span>
                                </div>
                            <?php else: ?>
                                <div class="login-feedback login-feedback-warning mb-3" role="status">
                                    <div class="login-feedback-copy">
                                        <strong class="login-feedback-title">Security check unavailable</strong>
                                        <span>Student lookup and Head SA sign-in are temporarily disabled. Please contact the system administrator.</span>
                                    </div>
                                </div>
                            <?php endif; ?>
                            <button type="submit" class="btn btn-primary w-100" data-turnstile-submit <?= $turnstileConfigured ? 'disabled' : '' ?>>Continue</button>
                        </form>
                    <?php endif; ?>

                    <div class="text-center mt-4 about-link-wrap">
                        <a class="about-link small" data-bs-toggle="modal" data-bs-target="#aboutModal">About Us</a>
                    </div>

                    <div class="beta-version text-center small">
                        Beta Version 1.0.0
                    </div>
                </div>
            </div>
        </section>

    </div>
</div>

<!-- Footer -->
<footer class="site-footer">
    <span>&copy; <?= date('Y') ?> Asia Technological School of Science and Arts. All rights reserved.</span>
</footer>

<?php if ($studentSummary): ?>
    <?php
    $requiredHours = (float)$studentSummary['set_hours'];
    $renderedHours = (float)$studentSummary['total_hrs'];
    $remainingHours = max(0, $requiredHours - $renderedHours);
    $progressPercent = $requiredHours > 0 ? min(100, (int)round(($renderedHours / $requiredHours) * 100)) : 0;
    ?>
    <div class="modal fade" id="studentHoursModal" tabindex="-1" aria-labelledby="studentHoursTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header modal-brand-header text-white">
                    <div>
                        <h2 class="modal-title fs-5" id="studentHoursTitle">Your Hours Summary</h2>
                        <div class="small opacity-75"><?= htmlspecialchars((string)$summaryYear, ENT_QUOTES) ?></div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="fw-semibold mb-3"><?= htmlspecialchars((string)$studentSummary['full_name'], ENT_QUOTES) ?></p>
                    <div class="progress hours-progress mb-4" role="progressbar" aria-label="Required hours progress" aria-valuenow="<?= $progressPercent ?>" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar bg-success" style="width:<?= $progressPercent ?>%"></div>
                    </div>
                    <div class="row g-3 text-center">
                        <div class="col-6">
                            <div class="border rounded-3 p-3 h-100">
                                <small class="text-muted d-block">Rendered / Total</small>
                                <strong><?= number_format($renderedHours, 1) ?> hrs</strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded-3 p-3 h-100">
                                <small class="text-muted d-block">Required</small>
                                <strong><?= number_format($requiredHours, 1) ?> hrs</strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded-3 p-3 h-100">
                                <small class="text-muted d-block">Remaining</small>
                                <strong><?= number_format($remainingHours, 1) ?> hrs</strong>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded-3 p-3 h-100">
                                <small class="text-muted d-block">OT</small>
                                <strong><?= number_format((float)$studentSummary['ot_hrs'], 1) ?> hrs</strong>
                            </div>
                        </div>
                    </div>
                    <p class="small text-muted mt-3 mb-0">For privacy, close this browser window after checking your hours.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Done</button>
                </div>
            </div>
        </div>
    </div>
<?php endif; ?>

<!-- ABOUT US MODAL -->
<div class="modal fade" id="aboutModal" tabindex="-1" aria-labelledby="aboutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="aboutModalLabel">About The System</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body about-modal-body">
                <p>SAHMS helps Student Assistants check their rendered hours while Head SAs maintain the official annual hours summary.</p>
                <p>Key features include:</p>
                <ul>
                    <li>Student number lookup for hours, required totals, and remaining hours.</li>
                    <li>A time calculator with overtime rounded down to completed 30-minute blocks.</li>
                    <li>Head SA-only entry of monthly totals and OT summaries.</li>
                    <li>Management of student assistant accounts and settings.</li>
                </ul>
                <p>For more information, please contact the system administrator.</p>
            </div>
            <div class="modal-footer about-modal-footer">
                <p>Developed by: <a href="https://loadssss.vercel.app/" target="_blank" rel="noopener noreferrer">Loadssss</a></p>
            </div>
        </div>
    </div>
</div>

<div class="modal fade calculator-modal" id="calculatorModal" tabindex="-1" aria-labelledby="calculatorModalTitle" aria-describedby="calculatorModalDescription" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header modal-brand-header text-white">
                <div>
                    <h2 class="modal-title fs-5" id="calculatorModalTitle">Hours Calculator</h2>
                    <p class="small opacity-75 mb-0" id="calculatorModalDescription">Choose a month and cutoff, then enter each day's time. Entries are not saved.</p>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close calculator"></button>
            </div>
            <div class="modal-body">
                <div class="row g-2">
                    <div class="col-6">
                        <label class="form-label mb-1" for="calculatorMonth">Month</label>
                        <select class="form-select" id="calculatorMonth" data-year="<?= (int)date('Y') ?>">
                            <?php for ($month = 1; $month <= 12; $month++): ?>
                                <option value="<?= $month - 1 ?>" <?= (int)date('n') === $month ? 'selected' : '' ?>>
                                    <?= htmlspecialchars(date('F', mktime(0, 0, 0, $month, 1)), ENT_QUOTES) ?>
                                </option>
                            <?php endfor; ?>
                        </select>
                    </div>
                    <div class="col-6">
                        <label class="form-label mb-1" for="calculatorPeriod">Cutoff</label>
                        <select class="form-select" id="calculatorPeriod">
                            <option value="first">1-15</option>
                            <option value="second">16-end of month</option>
                        </select>
                    </div>
                </div>

                <div class="calculator-table-wrap">
                    <table class="table table-sm calculator-table">
                        <thead>
                            <tr>
                                <th scope="col">Date</th>
                                <th scope="col">Time In</th>
                                <th scope="col">Time Out</th>
                                <th scope="col" class="text-end">Total</th>
                            </tr>
                        </thead>
                        <tbody id="calculatorDays"></tbody>
                    </table>
                </div>

                <div class="calculator-period-total" aria-live="polite">
                    <span id="calculatorPeriodLabel">Selected cutoff total</span>
                    <strong id="calculatorPeriodTotal">0.0 hrs</strong>
                </div>
                <div id="calculatorError" class="small text-danger mt-2" role="status"></div>
                <p class="small text-muted mt-2 mb-0">Time In defaults to 08:00 and can be edited. Leave Time Out blank on days with no duty. A one-hour break is deducted for shifts longer than 8 hours; OT after 5:00 PM counts in completed 30-minute blocks.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Done</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<?php if ($turnstileConfigured): ?>
<script src="/sahms/public/assets/js/turnstile-status.js?v=20261129h"></script>
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit&amp;onload=sahmsTurnstileReady" async defer onerror="window.sahmsTurnstileError && window.sahmsTurnstileError()"></script>
<?php endif; ?>
<script src="/sahms/public/assets/js/time-calculator.js" defer></script>
<script src="/sahms/public/assets/js/idle-logout.js?v=20261128q" defer></script>
<script>
const togglePassword = document.getElementById('togglePassword');
const password = document.getElementById('password');
if (togglePassword && password) {
    const icon = togglePassword.querySelector('i');
    togglePassword.addEventListener('click', () => {
        const isHidden = password.type === 'password';
        password.type = isHidden ? 'text' : 'password';
        togglePassword.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');
        icon.classList.toggle('bi-eye', !isHidden);
        icon.classList.toggle('bi-eye-slash', isHidden);
    });
}

// Auto-complete / Suggest @asiatech.edu.ph on typing
const idInput = document.getElementById('id_number');
const domainHint = document.getElementById('domainHint');

if (idInput && domainHint) {
    idInput.addEventListener('input', () => {
        const val = idInput.value;
        if (val.includes('@')) {
            const parts = val.split('@');
            const domain = 'asiatech.edu.ph';
            const typedDomain = parts[1];
            if (domain.startsWith(typedDomain)) {
                domainHint.textContent = '@' + domain;
                domainHint.style.display = 'inline-block';
            } else {
                domainHint.style.display = 'none';
            }
        } else if (val.trim().length > 0 && isNaN(val) && !val.includes('-')) {
            domainHint.textContent = '@asiatech.edu.ph';
            domainHint.style.display = 'inline-block';
        } else {
            domainHint.style.display = 'none';
        }
    });

    domainHint.addEventListener('click', () => {
        const val = idInput.value;
        if (val.includes('@')) {
            idInput.value = val.split('@')[0] + '@asiatech.edu.ph';
        } else {
            idInput.value = val + '@asiatech.edu.ph';
        }
        domainHint.style.display = 'none';
        idInput.focus();
    });

    // Auto append on Tab or Right Arrow if hint is visible
    idInput.addEventListener('keydown', (e) => {
        if ((e.key === 'Tab' || e.key === 'ArrowRight') && domainHint.style.display !== 'none') {
            if (idInput.selectionEnd === idInput.value.length) {
                const val = idInput.value;
                if (val.includes('@')) {
                    idInput.value = val.split('@')[0] + '@asiatech.edu.ph';
                } else {
                    idInput.value = val + '@asiatech.edu.ph';
                }
                domainHint.style.display = 'none';
                if (e.key === 'Tab') e.preventDefault();
            }
        }
    });
}

// ---- Background photo slideshow ----
// All slides are already in the DOM (and preloaded via <link rel=preload>
// in <head>), so switching the "active" class is a pure opacity
// transition -- no network fetch, no re-decode, nothing that could
// cause lag/jank. Runs on a simple interval; pauses when the tab isn't
// visible so it doesn't burn cycles in the background.
(function () {
    const slides = document.querySelectorAll('.bg-slide');
    if (slides.length <= 1) return;

    let current = 0;
    const intervalMs = 6000;
    let timer = null;

    function goTo(index) {
        slides[current].classList.remove('active');
        current = index;
        slides[current].classList.add('active');
    }

    function next() {
        goTo((current + 1) % slides.length);
    }

    function start() {
        stop();
        timer = setInterval(next, intervalMs);
    }
    function stop() {
        if (timer) clearInterval(timer);
        timer = null;
    }

    document.addEventListener('visibilitychange', () => {
        if (document.hidden) stop();
        else start();
    });

    start();
})();
<?php if ($studentSummary): ?>
bootstrap.Modal.getOrCreateInstance(document.getElementById('studentHoursModal')).show();
<?php endif; ?>
</script>

</body>
</html>