<?php
declare(strict_types=1);
require_once __DIR__ . '/../php_source/dashboard_src.php';
?>
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SAHMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link rel="icon" type="images/png" href="/sahms/images/asiatech_logo.jpeg">
    
    <link href="/sahms/public/assets/css/dashboard.css?v=20261128e" rel="stylesheet">
        <?php if (current_role() !== 'student_assistant'): ?><link href="/sahms/public/assets/css/head-sa-dashboard.css?v=20261128e" rel="stylesheet"><?php endif; ?>
</head>
<body class="bg-light">
<nav class="navbar dashboard-navbar navbar-dark bg-dark mb-4">
	<div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 w-100">
    
    <!-- Logo + Text -->
    <div class="d-flex align-items-center">
      <!-- Logo -->
        <img src="/sahms/images/asiatech_logo.jpeg" alt="asiatech logo" class="brand-logo me-2">

      <!-- Text block -->
      <div class="d-flex flex-column text-white">
        <span class="brand-name">ASIATECH <small class="fw-normal">(SAHMS)</small></span>
            <span class="role-label">
              <?= htmlspecialchars($_SESSION['name'], ENT_QUOTES) ?> · <?= htmlspecialchars(current_role() === 'head_sa' ? 'Head SA' : 'Student Assistant', ENT_QUOTES) ?>
        </span>
      </div>
    </div>

    <!-- Right-side buttons -->
	<div class="d-none d-md-flex gap-2 justify-content-end">
      <!-- Change Password -->
      <button type="button" class="btn btn-outline-light btn-sm d-inline-flex align-items-center gap-1" 
              data-bs-toggle="modal" data-bs-target="#changePasswordModal">
        <!-- 🔑 Password Icon -->
		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user-round-pen-icon lucide-user-round-pen"><path d="M2 21a8 8 0 0 1 10.821-7.487"/><path d="M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z"/><circle cx="10" cy="8" r="5"/></svg>
        
      </button>

      <!-- Log Out -->
      <a href="logout" class="btn btn-outline-light btn-sm d-inline-flex align-items-center gap-1">
        <!-- 🚪 Logout Icon -->
		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-log-out-icon lucide-log-out"><path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/></svg>
        
      </a>
    </div>
  </div>
</nav>


<div class="container">

    <?php if ($message): ?><div class="alert alert-success auto-dismiss"><?= htmlspecialchars($message, ENT_QUOTES) ?></div><?php endif; ?>
    <?php if ($error): ?><div class="alert alert-danger auto-dismiss"><?= htmlspecialchars($error, ENT_QUOTES) ?></div><?php endif; ?>
    
    <?php if ($message || $error): ?>
    <script>
        setTimeout(function() {
            document.querySelectorAll('.auto-dismiss').forEach(function(el) {
                el.style.transition = 'opacity 0.5s ease';
                el.style.opacity = '0';
                setTimeout(() => el.remove(), 500);
            });
        }, 4000);
    </script>
    <?php endif; ?>

    <?php if (current_role() === 'student_assistant'): ?>
    <?php require_once __DIR__ . '/views/sa_dashboard.php'; ?>
<?php else: ?>
    <?php require_once __DIR__ . '/views/head_sa_dashboard.php'; ?>
<?php endif; ?>

</div>
<form id="dtr-edit-form" method="post" action="dashboard#tab-all" class="d-none">
    <?= csrf_field() ?>
    <input type="hidden" name="action" value="edit_entry">
    <input type="hidden" name="dtr_id" id="dtr-edit-id" value="">
    <input type="hidden" name="work_date" id="dtr-edit-date" value="">
    <input type="hidden" name="time_in" id="dtr-edit-time-in" value="">
    <input type="hidden" name="time_out" id="dtr-edit-time-out" value="">
</form>

<!-- Delete DTR Confirmation Modal -->
<div class="modal fade" id="deleteDtrModal" tabindex="-1" aria-labelledby="deleteDtrModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm modal-dialog-centered">
    <div class="modal-content">
      <form method="post" action="dashboard#tab-all">
          <?= csrf_field() ?>
          <input type="hidden" name="action" value="delete_entry">
          <input type="hidden" name="dtr_id" id="delete-dtr-id" value="">
          <div class="modal-header">
            <h5 class="modal-title text-danger" id="deleteDtrModalLabel">Confirm Deletion</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body text-center">
            Are you sure you want to permanently delete this DTR entry?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-danger">Yes, Delete</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Delete All Confirmation Modal -->
<div class="modal fade" id="deleteAllModal" tabindex="-1" aria-labelledby="deleteAllModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm modal-dialog-centered">
    <div class="modal-content">
      <form method="post" action="dashboard#tab-all">
          <?= csrf_field() ?>
          <input type="hidden" name="action" value="delete_all_entries">
          <div class="modal-header">
            <h5 class="modal-title text-danger" id="deleteAllModalLabel">Delete All Entries</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body text-center">
            <strong>WARNING:</strong> Are you sure you want to delete ALL DTR entries in the system? This action cannot be undone.
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-danger">Yes, Delete All</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Change Password Modal (shared by both roles) -->
<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form method="post" action="dashboard">
        <?= csrf_field() ?>
        <input type="hidden" name="action" value="change_own_password">
        <div class="modal-header">
          <h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
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
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update Password</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Mobile Settings Modal (Change Password + Logout, shown only via mobile bottom nav) -->
<div class="modal fade" id="settingsMobileModal" tabindex="-1" aria-labelledby="settingsMobileModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="settingsMobileModalLabel">Settings</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body d-grid gap-2">
        <button type="button" class="btn btn-outline-primary d-flex align-items-center justify-content-center gap-2"
                data-bs-dismiss="modal"
                onclick="setTimeout(function(){ new bootstrap.Modal(document.getElementById('changePasswordModal')).show(); }, 300);">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 21a8 8 0 0 1 10.821-7.487"/><path d="M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z"/><circle cx="10" cy="8" r="5"/></svg>
          Change Password
        </button>
        <a href="logout" class="btn btn-outline-danger d-flex align-items-center justify-content-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/></svg>
          Log Out
        </a>
      </div>
    </div>
  </div>
</div>
    
<script>
var BREAK_DEDUCTION_THRESHOLD_HOURS = <?= json_encode((float)get_setting('break_deduction_threshold_hours', 8)) ?>;

function computeNetHoursJs(timeInStr, timeOutStr) {
    // Mirrors includes/dtr.php's compute_net_hours() logic so the live
    // preview here matches exactly what gets saved on submit.
    if (!/^([01][0-9]|2[0-3]):[0-5][0-9]$/.test(timeInStr) || !/^([01][0-9]|2[0-3]):[0-5][0-9]$/.test(timeOutStr)) {
        return null;
    }
    var toMinutes = function (t) {
        var parts = t.split(':');
        return parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
    };
    var inMin = toMinutes(timeInStr);
    var outMin = toMinutes(timeOutStr);
    if (outMin === inMin) return null; // still invalid - no duration
    if (outMin < inMin) {
        outMin += 24 * 60; // allow crossing midnight
    }
    var rawHours = (outMin - inMin) / 60;
    if (rawHours > BREAK_DEDUCTION_THRESHOLD_HOURS) {
        rawHours -= 1;
    }
    return Math.round(rawHours * 100) / 100;
}

function saveDtr(id, btn) {
    var tr = btn.closest('tr');
    document.getElementById('dtr-edit-id').value = id;
    document.getElementById('dtr-edit-date').value = tr.querySelector('.row-date').value;
    document.getElementById('dtr-edit-time-in').value = tr.querySelector('.row-time-in').value;
    document.getElementById('dtr-edit-time-out').value = tr.querySelector('.row-time-out').value;
    document.getElementById('dtr-edit-form').submit();
}

// Auto-format 24-hour time fields as the user types: "1430" -> "14:30".
// Also recomputes the live Total Hours preview on the Bulk 15-Day tab
// whenever a time24 field in that table changes.
document.addEventListener('input', function (e) {
    if (!e.target.classList.contains('time24')) return;

    var digits = e.target.value.replace(/\D/g, '').slice(0, 4);
    e.target.value = digits.length >= 3 ? digits.slice(0, 2) + ':' + digits.slice(2) : digits;

    updateSubmit1Hours();

    var row = e.target.closest('tr');
    if (!row) return;
    var hoursCell = row.querySelector('.bulk-row-hours');
    if (!hoursCell) return; // not a Bulk-15-day row, nothing to update

    updateBulkRow(row);
    updateBulkProgressAndTotal();
});

/** Recomputes and re-styles a single Bulk-15-day row's hours badge. */
function updateBulkRow(row) {
    var hoursCell = row.querySelector('.bulk-row-hours');
    if (!hoursCell) return;

    var timeInEl = row.querySelector('.bulk-time-in');
    var timeOutEl = row.querySelector('.bulk-time-out');
    var netHours = computeNetHoursJs(timeInEl.value, timeOutEl.value);

    hoursCell.classList.remove('bg-light', 'text-muted', 'bg-success', 'text-white', 'bg-warning', 'text-dark');

    if (netHours !== null) {
        hoursCell.textContent = netHours.toFixed(2);
        hoursCell.classList.add('bg-success', 'text-white');
    } else if (timeInEl.value === '' && timeOutEl.value === '') {
        hoursCell.textContent = '—'; // both blank = absent/no duty, not an error
        hoursCell.classList.add('bg-light', 'text-muted');
    } else {
        hoursCell.textContent = '…'; // still typing / incomplete, not resolvable yet
        hoursCell.classList.add('bg-warning', 'text-dark');
    }
}

function updateSubmit1Hours() {
    var hoursEl = document.getElementById('submit1-hours');
    if (!hoursEl) return;

    var timeInEl = document.querySelector('#tab-submit1 input[name="time_in"]');
    var timeOutEl = document.querySelector('#tab-submit1 input[name="time_out"]');
    if (!timeInEl || !timeOutEl) return;

    var netHours = computeNetHoursJs(timeInEl.value, timeOutEl.value);
    hoursEl.classList.remove('bg-secondary', 'bg-success', 'text-white', 'bg-warning', 'text-dark');

    if (netHours !== null) {
        hoursEl.textContent = 'Hours: ' + netHours.toFixed(2);
        hoursEl.classList.add('bg-success', 'text-white');
    } else if (timeInEl.value === '' && timeOutEl.value === '') {
        hoursEl.textContent = 'Hours: —';
        hoursEl.classList.add('bg-secondary', 'text-white');
    } else {
        hoursEl.textContent = 'Hours: —';
        hoursEl.classList.add('bg-warning', 'text-dark');
    }
}

/** Recomputes the overall total and the "X / 15 days filled" progress badge. */
function updateBulkProgressAndTotal() {
    var overallTotal = 0;
    var filledCount = 0;
    var totalRows = 0;

    document.querySelectorAll('.bulk-dtr-table tbody tr').forEach(function (row) {
        totalRows++;
        var timeInEl = row.querySelector('.bulk-time-in');
        var timeOutEl = row.querySelector('.bulk-time-out');
        if (timeInEl && timeOutEl && timeInEl.value !== '' && timeOutEl.value !== '') {
            filledCount++;
        }
        var hoursCell = row.querySelector('.bulk-row-hours');
        if (hoursCell) {
            var val = parseFloat(hoursCell.textContent);
            if (!isNaN(val)) overallTotal += val;
        }
    });

    var overallEl = document.getElementById('bulk-overall-hours');
    if (overallEl) overallEl.textContent = overallTotal.toFixed(2);

    var progressEl = document.getElementById('bulk-progress-badge');
    if (progressEl) progressEl.textContent = filledCount + ' / ' + totalRows + ' days filled';
}

// "Copy First Day's Time to All Empty Days" -- finds the first row with
// both Time In and Time Out already filled, then applies that same time
// range to every OTHER row that's still completely blank. Rows that
// already have something typed in are left untouched (never overwritten).
document.addEventListener('DOMContentLoaded', function () {
    var copyAllBtn = document.getElementById('bulk-copy-all-btn');
    if (copyAllBtn) {
        copyAllBtn.addEventListener('click', function () {
            var rows = document.querySelectorAll('.bulk-dtr-table tbody tr');
            var sourceTimeIn = null;
            var sourceTimeOut = null;

            for (var i = 0; i < rows.length; i++) {
                var tin = rows[i].querySelector('.bulk-time-in');
                var tout = rows[i].querySelector('.bulk-time-out');
                if (tin && tout && tin.value !== '' && tout.value !== '') {
                    sourceTimeIn = tin.value;
                    sourceTimeOut = tout.value;
                    break;
                }
            }

            if (!sourceTimeIn) {
                alert('Fill in at least one day first, then click this button to copy that time to the rest.');
                return;
            }

            rows.forEach(function (row) {
                var tin = row.querySelector('.bulk-time-in');
                var tout = row.querySelector('.bulk-time-out');
                if (tin && tout && tin.value === '' && tout.value === '') {
                    tin.value = sourceTimeIn;
                    tout.value = sourceTimeOut;
                    updateBulkRow(row);
                }
            });

            updateBulkProgressAndTotal();
        });
    }

    var submit1Inputs = document.querySelectorAll('#tab-submit1 .time24');
    submit1Inputs.forEach(function (input) {
        input.addEventListener('input', updateSubmit1Hours);
        input.addEventListener('change', updateSubmit1Hours);
    });
    updateSubmit1Hours();
});

// ---- Panel/tab navigation helpers ----
// Everything now lives in this one dashboard.php as Bootstrap pill tabs
// instead of separate pages. To make sure the right panel re-opens after
// a form POST (and so navbar buttons like "Manage SAs" jump straight to
// the right panel), we use the URL fragment (#tab-xxx) as the source of
// truth for which tab is active, both on load and whenever a tab is
// manually clicked.
(function () {
    function activateTabById(tabPaneId) {
        var pane = document.getElementById(tabPaneId);
        if (!pane) return;
        var trigger = document.querySelector('[data-bs-target="#' + tabPaneId + '"]');
        if (trigger && window.bootstrap) {
            var tabInstance = window.bootstrap.Tab.getOrCreateInstance(trigger);
            tabInstance.show();
        }
    }

    // Navbar buttons that should jump straight to a specific tab.
    document.querySelectorAll('.nav-tab-jump').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var target = btn.getAttribute('data-jump');
            activateTabById(target);
            history.replaceState(null, '', '#' + target);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    });

    function syncTabTriggers(target) {
        document.querySelectorAll('.sa-tab-trigger').forEach(function (other) {
            if (other.getAttribute('data-bs-target') === target) {
                other.classList.add('active');
            } else {
                other.classList.remove('active');
            }
        });
    }

    // On page load (including right after a form POST redirects back
    // with a #tab-xxx fragment in the action URL), open the matching tab.
    window.addEventListener('load', function () {
        var hash = window.location.hash ? window.location.hash.substring(1) : null;
        if (hash && window.bootstrap && window.bootstrap.Tab) {
            activateTabById(hash);
            syncTabTriggers('#' + hash);
        }
    });

    // Keep the URL fragment in sync whenever the user clicks a tab
    // manually, so refreshing the page (or the next form submit on
    // that same tab) keeps them on the same panel.
    document.querySelectorAll('[data-bs-toggle="pill"]').forEach(function (btn) {
        btn.addEventListener('shown.bs.tab', function (e) {
            var target = e.target.getAttribute('data-bs-target');
            if (target) {
                history.replaceState(null, '', target.replace('#', '#'));
            }
        });
    });

    // SA side has TWO separate nav containers (desktop top pills +
    // mobile bottom bar) both controlling the same tab-panes.
    // Bootstrap's Tab plugin only manages "active" state within its
    // own .nav container, so clicking one doesn't visually update
    // the other -- sync them manually here.
    document.querySelectorAll('.sa-tab-trigger').forEach(function (btn) {
        btn.addEventListener('shown.bs.tab', function (e) {
            var target = e.target.getAttribute('data-bs-target');
            syncTabTriggers(target);
        });
    });
    // Image Preview
    document.querySelectorAll('input[type="file"]').forEach(function(input) {
        input.addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = input.parentElement.querySelector('.img-preview');
                    if (!preview) {
                        preview = document.createElement('img');
                        preview.className = 'img-preview mt-2 rounded shadow-sm';
                        preview.style.maxWidth = '200px';
                        preview.style.maxHeight = '200px';
                        input.parentElement.appendChild(preview);
                    }
                    preview.src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });
    });

    // Local Storage Auto-Save for Bulk 15
    var bulkForm = document.querySelector('form[action="dashboard#tab-submitbulk"]');
    if (bulkForm) {
        var inputs = bulkForm.querySelectorAll('input[type="time"]');
        inputs.forEach(function(input) {
            var key = 'bulk_' + input.name + '_' + input.closest('tr').querySelector('.bulk-date-label').innerText;
            if (localStorage.getItem(key)) {
                input.value = localStorage.getItem(key);
                // trigger input to update hours
                input.dispatchEvent(new Event('input'));
            }
            input.addEventListener('input', function() {
                localStorage.setItem(key, input.value);
            });
        });
        bulkForm.addEventListener('submit', function() {
            // clear storage on submit
            inputs.forEach(function(input) {
                var key = 'bulk_' + input.name + '_' + input.closest('tr').querySelector('.bulk-date-label').innerText;
                localStorage.removeItem(key);
            });
        });
    }

    // Submit Button Loading State
    document.querySelectorAll('form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            if (e.defaultPrevented) return;
            if (form.dataset.submitting) {
                e.preventDefault();
                return;
            }
            var btn = form.querySelector('button[type="submit"].btn-loading, button[type="submit"]:not(.no-load)');
            if (btn) {
                form.dataset.submitting = 'true';
                btn.style.pointerEvents = 'none';
                btn.classList.add('disabled');
                btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...';
            }
        });
    });

})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/sahms/public/assets/js/sa-name-preview.js" defer></script>
<?php if (current_role() === 'head_sa'): ?>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
        if ($('#all-records-table').length) {
            $('#all-records-table').DataTable({
                "pageLength": 25,
                "order": [[ 0, "desc" ]]
            });
        }
        if ($('#ot-reports-table').length) {
            $('#ot-reports-table').DataTable({
                "pageLength": 25,
                "order": [[ 3, "desc" ]]
            });
        }
    });
</script>
<?php endif; ?>
</body>
</html>