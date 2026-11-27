<?php 
if (basename($_SERVER['PHP_SELF']) === basename(__FILE__)) {
    header('Location: ../dashboard.php');
    exit;
}
$allCashouts = get_all_ot_cashouts();

        // ===== OVERVIEW STATS =====
        $activeSaCount = 0;
        foreach ($allSaListForManage ?? [] as $sa) {
            if ($sa['is_active']) $activeSaCount++;
        }

        $monthKeysOverview = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'];
        $currentMonthKey = $monthKeysOverview[(int)date('n') - 1];
        $isCurrentYearLoaded = isset($selectedYear) && (int)$selectedYear === (int)date('Y') && !empty($annualSummaryReport);

        $thisMonthTotal = 0.0;
        $topSaThisMonth = [];
        $orgMonthlyTotals = array_fill_keys($monthKeysOverview, 0.0);
        if (!empty($annualSummaryReport)) {
            foreach ($annualSummaryReport as $row) {
                foreach ($monthKeysOverview as $mk) {
                    $orgMonthlyTotals[$mk] += (float)($row[$mk] ?? 0);
                }
                if ($isCurrentYearLoaded) {
                    $val = (float)($row[$currentMonthKey] ?? 0);
                    $thisMonthTotal += $val;
                    if ($val > 0) {
                        $topSaThisMonth[] = ['full_name' => $row['full_name'], 'hrs' => $val];
                    }
                }
            }
            usort($topSaThisMonth, function ($a, $b) {
                return $b['hrs'] <=> $a['hrs'];
            });
            $topSaThisMonth = array_slice($topSaThisMonth, 0, 5);
        }

        ?>

        
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <ul class="nav nav-pills mb-4 gap-2" id="headSaTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold" id="overview-tab" data-bs-toggle="pill" data-bs-target="#tab-overview" type="button" role="tab">
                    Overview
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold" id="managesas-tab" data-bs-toggle="pill" data-bs-target="#tab-managesas" type="button" role="tab">
                    Manage SAs
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold" id="settings-tab" data-bs-toggle="pill" data-bs-target="#tab-settings" type="button" role="tab">
                    Settings
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold text-info" id="reports-tab" data-bs-toggle="pill" data-bs-target="#tab-reports" type="button" role="tab">
                    Reports
                </button>
            </li>
        </ul>

        <div class="tab-content" id="headSaTabsContent">

            <!-- OVERVIEW TAB -->
            

            <div class="tab-pane fade show active" id="tab-overview" role="tabpanel">

                <!-- STAT CARDS -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-md-6">
                        <div class="stat-card">
                            <div class="stat-value"><?= $activeSaCount ?></div>
                            <div class="stat-label">Active SAs</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-6">
                        <div class="stat-card <?= count($dueForReview ?? []) > 0 ? 'warn' : '' ?>">
                            <div class="stat-value"><?= count($dueForReview ?? []) ?></div>
                            <div class="stat-label">Due for Review</div>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="text-muted small fw-bold text-uppercase mb-1">This Month</div>
                                <div class="fs-3 fw-bold text-primary"><?= number_format($thisMonthTotal, 1) ?> hrs</div>
                                <div class="text-muted small"><?= date('F Y') ?> across all SAs</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="card h-100">
                            <div class="card-header fw-semibold">Top SAs This Month</div>
                            <div class="card-body">
                                <?php if (!$isCurrentYearLoaded): ?>
                                    <p class="text-muted small mb-0">No data loaded for the current year yet.</p>
                                <?php elseif (!$topSaThisMonth): ?>
                                    <p class="text-muted small mb-0">No hours entered this month.</p>
                                <?php else:
                                    $maxTop = $topSaThisMonth[0]['hrs'] ?: 1;
                                    foreach ($topSaThisMonth as $t): ?>
                                    <div class="mini-bar-row">
                                        <div class="name"><?= htmlspecialchars($t['full_name'], ENT_QUOTES) ?></div>
                                        <div class="mini-bar-track">
                                            <div class="mini-bar-fill" style="width:<?= max(6, round(($t['hrs'] / $maxTop) * 100)) ?>%"></div>
                                        </div>
                                        <div class="val"><?= number_format($t['hrs'], 1) ?></div>
                                    </div>
                                <?php endforeach; endif; ?>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CHARTS ROW -->
                <div class="row g-3 mt-1">
                    <div class="col-12">
                        <div class="card h-100">
                            <div class="card-header fw-semibold">
                                Monthly Hours Trend <?= !empty($annualSummaryReport) ? '— ' . $selectedYear : '' ?>
                            </div>
                            <div class="card-body">
                                <?php if (empty($annualSummaryReport)): ?>
                                    <p class="text-muted small mb-0 py-3 text-center">
                                        Load a year in
                                        <button type="button" class="btn btn-sm btn-link p-0 align-baseline nav-tab-jump" data-jump="tab-reports">Reports</button>
                                        to see the trend.
                                    </p>
                                <?php else: ?>
                                    <canvas id="orgMonthlyChart" height="220"></canvas>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END OVERVIEW TAB -->

            <?php if (false): ?>
            <!-- PENDING TAB -->
            <div class="tab-pane fade" id="tab-pending" role="tabpanel">
                <div class="card mb-4">
                    <div class="card-body">
                <h2 class="h5">Pending Submissions (<?= count($groupedPending) ?> groups)</h2>
                <p class="text-muted small mb-3">
                    Submitted directly by SAs with a photo of their DTR.
                    Click <strong>Review</strong> to open the photo and check if the entries match before approving or rejecting.
                </p>

                <?php if (!$groupedPending): ?>
                    <p class="text-muted text-center mb-0">Nothing pending review.</p>
                <?php else: ?>
                <div class="list-group list-group-flush">
                <?php foreach ($groupedPending as $group):
                    $modalId       = 'dtrModal_' . $group['group_id'];
                    $approveFormId = 'approve_' . $group['group_id'];
                    $rejectFormId  = 'reject_'  . $group['group_id'];
                    
                    // Summarize dates
                    $dates = array_column($group['entries'], 'work_date');
                    $dateRange = count($dates) > 1 ? min($dates) . ' to ' . max($dates) : $dates[0];
                    $totalHrs = 0;
                    foreach ($group['entries'] as $sub) {
                        $hrs = compute_net_hours($sub['time_in'], $sub['time_out']);
                        if ($hrs !== null) $totalHrs += $hrs;
                    }
                ?>
                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                        <div>
                            <div class="fw-semibold"><?= htmlspecialchars($group['full_name'], ENT_QUOTES) ?></div>
                            <div class="text-muted small">
                                <?= htmlspecialchars($group['id_number'], ENT_QUOTES) ?> &mdash;
                                <?= htmlspecialchars($dateRange, ENT_QUOTES) ?> &nbsp;
                                (<?= count($group['entries']) ?> entries, <?= number_format($totalHrs, 2) ?> hrs total)
                            </div>
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-primary"
                                data-bs-toggle="modal" data-bs-target="#<?= $modalId ?>">
                            🔍 Review
                        </button>
                    </div>

                    <!-- ===== DTR Review Modal ===== -->
                    <div class="modal fade" id="<?= $modalId ?>" tabindex="-1" aria-labelledby="<?= $modalId ?>_label" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-centered">
                            <div class="modal-content">

                                <div class="modal-header">
                                    <h5 class="modal-title" id="<?= $modalId ?>_label">
                                        DTR Review — <?= htmlspecialchars($group['full_name'], ENT_QUOTES) ?>
                                        <span class="text-muted fw-normal small ms-2"><?= htmlspecialchars($group['id_number'], ENT_QUOTES) ?></span>
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <div class="modal-body p-0">
                                    <div class="row g-0 review-photo-row">

                                        <!-- LEFT: DTR Photo -->
                                        <div class="col-md-7 bg-dark d-flex flex-column align-items-center justify-content-center p-3 review-photo-column">
                                            <div class="w-100 d-flex justify-content-between align-items-center mb-2 text-white">
                                                <div class="small">Photo review</div>
                                                <div class="btn-group btn-group-sm pending-photo-controls" role="group" aria-label="Photo controls">
                                                    <button type="button" class="btn btn-outline-light" data-action="zoom-out" title="Zoom out">−</button>
                                                    <button type="button" class="btn btn-outline-light" data-action="zoom-in" title="Zoom in">+</button>
                                                    <button type="button" class="btn btn-outline-light" data-action="rotate-left" title="Rotate left">⟲</button>
                                                    <button type="button" class="btn btn-outline-light" data-action="rotate-right" title="Rotate right">⟳</button>
                                                    <button type="button" class="btn btn-outline-light" data-action="reset" title="Reset image">↺</button>
                                                </div>
                                            </div>
                                            <div class="w-100 mb-3 text-end text-white small pending-photo-zoom-label">100%</div>
                                            <div class="pending-photo-card w-100 d-flex align-items-center justify-content-center">
                                                <img src="view_photo.php?dtr_id=<?= (int)$group['first_dtr_id'] ?>"
                                                     alt="DTR Photo"
                                                     class="img-fluid rounded shadow pending-photo-preview"
                                                     data-zoom="1"
                                                     data-rotate="0"
                                                     data-translate-x="0"
                                                     data-translate-y="0">
                                            </div>
                                        </div>

                                        <!-- RIGHT: Entry Details + Actions -->
                                        <div class="col-md-5 p-4 d-flex flex-column h-100">
                                            <h6 class="encoded-entries-heading text-muted text-uppercase fw-semibold mb-3">
                                                Encoded Entries (<?= count($group['entries']) ?>)
                                            </h6>

                                            <div class="table-responsive encoded-entries-list flex-grow-1 mb-4">
                                                <table class="table table-sm mb-0">
                                                    <thead class="sticky-top bg-white">
                                                        <tr>
                                                            <th>Date</th>
                                                            <th>In</th>
                                                            <th>Out</th>
                                                            <th>Hrs</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <?php 
                                                        $firstDateStr = $group['entries'][0]['work_date'];
                                                        $y = (int)date('Y', strtotime($firstDateStr));
                                                        $m = (int)date('n', strtotime($firstDateStr));
                                                        $d = (int)date('j', strtotime($firstDateStr));
                                                        $startDay = $d <= 15 ? 1 : 16;
                                                        $endDay = $d <= 15 ? 15 : (int)date('t', mktime(0, 0, 0, $m, 1, $y));
                                                        
                                                        $entriesByDate = [];
                                                        foreach ($group['entries'] as $sub) {
                                                            $entriesByDate[$sub['work_date']] = $sub;
                                                        }
                                                        
                                                        for ($day = $startDay; $day <= $endDay; $day++):
                                                            $dateStr = sprintf('%04d-%02d-%02d', $y, $m, $day);
                                                            if (isset($entriesByDate[$dateStr])):
                                                                $sub = $entriesByDate[$dateStr];
                                                                $subHrs = compute_net_hours($sub['time_in'], $sub['time_out']);
                                                        ?>
                                                        <tr>
                                                            <td><?= htmlspecialchars($dateStr, ENT_QUOTES) ?></td>
                                                            <td class="fw-semibold"><?= htmlspecialchars(substr($sub['time_in'], 11, 5), ENT_QUOTES) ?></td>
                                                            <td class="fw-semibold"><?= htmlspecialchars(isset($sub['time_out']) ? substr($sub['time_out'], 11, 5) : '—', ENT_QUOTES) ?></td>
                                                            <td class="text-success fw-semibold"><?= $subHrs !== null ? number_format($subHrs, 2) : '—' ?></td>
                                                        </tr>
                                                        <?php else: ?>
                                                        <tr class="table-light text-muted">
                                                            <td><?= htmlspecialchars($dateStr, ENT_QUOTES) ?></td>
                                                            <td colspan="3" class="no-duty-text text-center fst-italic">Absent / No Duty</td>
                                                        </tr>
                                                        <?php endif; endfor; ?>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <p class="text-muted small mb-3">
                                                Compare the photo on the left with the entries above.
                                                If they match, approve all. If not, reject all with a reason.
                                            </p>

                                            <div class="mt-auto">
                                                <!-- Approve All -->
                                                <form method="post" action="dashboard.php#tab-pending" class="mb-2"
                                                      onsubmit="return confirm('Approve all <?= count($group['entries']) ?> entries?');">
                                                    <?= csrf_field() ?>
                                                    <input type="hidden" name="action" value="approve_pending_bulk">
                                                    <?php foreach ($group['entries'] as $sub): ?>
                                                        <input type="hidden" name="dtr_ids[]" value="<?= (int)$sub['dtr_id'] ?>">
                                                    <?php endforeach; ?>
                                                    <button type="submit" class="btn btn-success w-100">✓ Approve All (<?= count($group['entries']) ?>)</button>
                                                </form>

                                                <!-- Reject All -->
                                                <form method="post" action="dashboard.php#tab-pending"
                                                      onsubmit="var r = this.querySelector('[name=reason]'); if(!r.value.trim()){alert('Please provide a reason.');return false;} return confirm('Reject all <?= count($group['entries']) ?> entries?');">
                                                    <?= csrf_field() ?>
                                                    <input type="hidden" name="action" value="reject_pending_bulk">
                                                    <?php foreach ($group['entries'] as $sub): ?>
                                                        <input type="hidden" name="dtr_ids[]" value="<?= (int)$sub['dtr_id'] ?>">
                                                    <?php endforeach; ?>
                                                    <div class="input-group">
                                                        <input type="text" name="reason" class="form-control form-control-sm" placeholder="Rejection reason (required)">
                                                        <button type="submit" class="btn btn-danger">✗ Reject All</button>
                                                    </div>
                                                </form>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
                </div>
                <?php endif; ?>
            </div>
                </div>
            </div>
            <!-- END PENDING TAB -->

            <!-- ADD TAB -->
            <div class="tab-pane fade" id="tab-add" role="tabpanel">
                <div class="card mb-4">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="h5 mb-1">Add DTR Entry</h2>
                            <p class="text-muted small mb-0">One SA at a time. For encoding many SAs for the same day, use Bulk Entry instead.</p>
                        </div>
                        <button type="button" class="btn btn-outline-primary nav-tab-jump" data-jump="tab-bulk">Bulk Entry (multiple SAs)</button>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                <form method="post" action="dashboard.php#tab-add" class="row g-3">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="add_entry">
                    <div class="col-md-4">
                        <label class="form-label">Student Assistant</label>
                        <select name="sa_user_id" class="form-select" required>
                            <option value="">-- Select --</option>
                            <?php foreach ($saList as $sa): ?>
                                <option value="<?= (int)$sa['user_id'] ?>">
                                    <?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?> (<?= htmlspecialchars($sa['id_number'], ENT_QUOTES) ?>)
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Date</label>
                        <input type="date" name="work_date" class="form-control" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Time In</label>
                        <input type="text" name="time_in" class="form-control time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Time Out</label>
                        <input type="text" name="time_out" class="form-control time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric" required>
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button class="btn btn-primary w-100">Add</button>
                    </div>
                </form>
            </div>
        </div>
            </div>
            <!-- END ADD TAB -->

            <!-- ALL ENTRIES TAB -->
        <div class="tab-pane fade" id="tab-all" role="tabpanel">
                <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h5 mb-0">All DTR Entries</h2>
                    <?php if (!empty($allEntries)): ?>
                        <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAllModal">
                            Delete All
                        </button>
                    <?php endif; ?>
                </div>
                <div class="table-responsive all-records-table-wrap">
                <table class="table table-sm align-middle mb-0" id="all-records-table">
                    <thead class="sticky-top bg-white all-records-table-header">
                        <tr><th>SA</th><th>Date</th><th>Time In</th><th>Time Out</th><th>Hours</th><th>Status</th><th></th></tr>
                    </thead>
                    <tbody>
                    <?php foreach ($allEntries as $row): ?>
                        <tr>
                            <td><?= htmlspecialchars($row['full_name'], ENT_QUOTES) ?> (<?= htmlspecialchars($row['id_number'], ENT_QUOTES) ?>)</td>
                            <td class="min-width-140">
                                <input type="date" class="form-control form-control-sm row-date"
                                       value="<?= htmlspecialchars($row['work_date'], ENT_QUOTES) ?>">
                            </td>
                            <td class="min-width-110">
                                <input type="text" class="form-control form-control-sm time24 row-time-in"
                                       value="<?= htmlspecialchars(substr($row['time_in'], 11, 5), ENT_QUOTES) ?>"
                                       placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                            </td>
                            <td class="min-width-110">
                                <input type="text" class="form-control form-control-sm time24 row-time-out"
                                       value="<?= htmlspecialchars(substr($row['time_out'] ?? '', 11, 5), ENT_QUOTES) ?>"
                                       placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                            </td>
                            <td><?php $hrs = compute_net_hours($row['time_in'], $row['time_out']); ?><?= $hrs !== null ? number_format($hrs, 2) : '—' ?></td>
                            <td>
                                <span class="badge <?= $row['status'] === 'approved' ? 'bg-success' : ($row['status'] === 'rejected' ? 'bg-danger' : 'bg-secondary') ?>">
                                    <?= htmlspecialchars($row['status'], ENT_QUOTES) ?>
                                </span>
                            </td>
                            <td class="text-nowrap">
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="saveDtr(<?= (int)$row['dtr_id'] ?>, this)">Save</button>
                                <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteDtrModal" onclick="document.getElementById('delete-dtr-id').value = <?= (int)$row['dtr_id'] ?>;">Delete</button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
                </div>
                
                <?php if (isset($totalPages) && $totalPages > 1): ?>
                <nav class="mt-3">
                    <ul class="pagination pagination-sm justify-content-center">
                        <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                            <li class="page-item <?= ($i === $page) ? 'active' : '' ?>">
                                <a class="page-link" href="dashboard.php?page=<?= $i ?>#tab-all"><?= $i ?></a>
                            </li>
                        <?php endfor; ?>
                    </ul>
                </nav>
                <?php endif; ?>
                
            </div>
        </div>
        </div>
            <!-- END ALL ENTRIES TAB -->

            <!-- BULK ENTRY TAB -->
            <div class="tab-pane fade" id="tab-bulk" role="tabpanel">
                <div class="card mb-3">
                    <div class="card-body">
                        <form method="get" action="dashboard.php#tab-bulk" class="row g-2 align-items-end">
                            <div class="col-auto">
                                <label class="form-label mb-0">Date</label>
                                <input type="date" name="work_date" value="<?= htmlspecialchars($bulkSelectedDate, ENT_QUOTES) ?>" class="form-control">
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-secondary">Load Date</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <h2 class="h5">Bulk DTR Entry — <?= htmlspecialchars($bulkSelectedDate, ENT_QUOTES) ?></h2>
                        <p class="text-muted small">
                            Leave both Time In and Time Out blank for any SA not on duty that day — those rows are skipped automatically.
                        </p>

                        <form method="post" action="dashboard.php#tab-bulk">
                            <?= csrf_field() ?>
                            <input type="hidden" name="action" value="bulk_add_entries">
                            <input type="hidden" name="work_date" value="<?= htmlspecialchars($bulkSelectedDate, ENT_QUOTES) ?>">

                            <table class="table table-sm align-middle">
                                <thead>
                                    <tr><th>Student Assistant</th><th>Already Encoded Today</th><th>Time In</th><th>Time Out</th></tr>
                                </thead>
                                <tbody>
                                <?php foreach ($saList as $sa): $uid = (int)$sa['user_id']; ?>
                                    <tr>
                                        <td><?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?> (<?= htmlspecialchars($sa['id_number'], ENT_QUOTES) ?>)</td>
                                        <td class="small text-muted">
                                            <?php if (!empty($existingByUser[$uid])): ?>
                                                <?php foreach ($existingByUser[$uid] as $ex): ?>
                                                    <span class="badge bg-light text-dark border">
                                                        <?= htmlspecialchars(substr($ex['time_in'], 11, 5), ENT_QUOTES) ?>–<?= htmlspecialchars(substr($ex['time_out'] ?? '—', 11, 5), ENT_QUOTES) ?>
                                                    </span>
                                                <?php endforeach; ?>
                                            <?php else: ?>
                                                —
                                            <?php endif; ?>
                                        </td>
                                        <td class="min-width-130">
                                            <input type="text" name="entries[<?= $uid ?>][time_in]" class="form-control form-control-sm time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                                        </td>
                                        <td class="min-width-130">
                                            <input type="text" name="entries[<?= $uid ?>][time_out]" class="form-control form-control-sm time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php if (!$saList): ?>
                                    <tr><td colspan="4" class="text-muted text-center">No active Student Assistants found.</td></tr>
                                <?php endif; ?>
                                </tbody>
                            </table>

                            <button type="submit" class="btn btn-primary">Save All</button>
                        </form>
                    </div>
                </div>
            </div>
            <!-- END BULK ENTRY TAB -->
            <?php endif; ?>

            <!-- MANAGE SAs TAB -->
            <div class="tab-pane fade" id="tab-managesas" role="tabpanel">
                <div class="card mb-4">
                    <div class="card-body">
                        <h2 class="h5">Add Student Assistant</h2>
                        <form method="post" action="dashboard.php#tab-managesas" class="row g-3" data-sa-name-form>
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
                                <button type="submit" class="btn btn-primary">Add Account</button>
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
                                                <form method="post" action="dashboard.php#tab-managesas" onsubmit="return confirm('Permanently delete this account? Hindi na ito mababawi.');">
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
                            <thead><tr><th>Name</th><th>Student Number</th><th>Email</th><th>Status</th><th></th></tr></thead>
                            <tbody>
                            <?php foreach ($allSaListForManage as $sa): $uid = (int)$sa['user_id']; ?>
                                <tr class="<?= $sa['is_active'] ? '' : 'table-secondary text-muted' ?>">
                                    <td><?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?></td>
                                    <td><?= htmlspecialchars($sa['id_number'], ENT_QUOTES) ?></td>
                                    <td><?= htmlspecialchars($sa['email'], ENT_QUOTES) ?></td>
                                    <td><?= $sa['is_active'] ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-secondary">Inactive</span>' ?></td>
                                    <td>
                                        <form method="post" action="dashboard.php#tab-managesas" onsubmit="return confirm('<?= $sa['is_active'] ? 'Deactivate' : 'Reactivate' ?> this SA?');">
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
                            <?php if (!$allSaListForManage): ?>
                                <tr><td colspan="5" class="text-muted text-center">No Student Assistants yet.</td></tr>
                            <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- END MANAGE SAs TAB -->

            <!-- SETTINGS TAB -->
            <div class="tab-pane fade" id="tab-settings" role="tabpanel">
                <form method="post" action="dashboard.php#tab-settings">
                    <?= csrf_field() ?>
                    <input type="hidden" name="action" value="update_settings">

                    <div class="card mb-3">
                        <div class="card-body">
                            <h2 class="h5">DTR Rules</h2>
                            <div class="mb-3">
                                <label class="form-label">Lunch break window</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <input type="text" name="break_start_time" class="form-control time24"
                                               placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric"
                                               value="<?= htmlspecialchars($settings['break_start_time'] ?? '12:00', ENT_QUOTES) ?>">
                                    </div>
                                    <div class="col-6">
                                        <input type="text" name="break_end_time" class="form-control time24"
                                               placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric"
                                               value="<?= htmlspecialchars($settings['break_end_time'] ?? '13:00', ENT_QUOTES) ?>">
                                    </div>
                                </div>
                                <div class="form-text">
                                    If an SA's Time In–Time Out range overlaps this window, only the actual overlapping
                                    portion is deducted (e.g. clocking out at 12:30 mid-break only deducts 30 minutes,
                                    not the full hour). Leave both blank to disable window-based deduction.
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Fallback: break deduction threshold (hours)</label>
                                <input type="number" step="0.5" min="1" name="break_deduction_threshold_hours"
                                       value="<?= htmlspecialchars($settings['break_deduction_threshold_hours'] ?? '8', ENT_QUOTES) ?>" class="form-control">
                                <div class="form-text">
                                    Only used if the break window above is blank/disabled. A single DTR entry longer
                                    than this gets a flat 1 hour auto-deducted for lunch break.
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Default required hours (applies to all SAs)</label>
                                <input type="number" step="1" min="1" name="default_required_hours"
                                       value="<?= htmlspecialchars($settings['default_required_hours'] ?? '200', ENT_QUOTES) ?>" class="form-control">
                                <div class="form-text">This value is applied to every Student Assistant immediately and also becomes the default for new SAs.</div>
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
                            </div>
                        </div>
                    </div>

                    <div class="card mb-3">
                        <div class="card-body">
                            <h2 class="h5">System</h2>
                            <div class="mb-3">
                                <label class="form-label">Database Backup</label>
                                <p class="text-muted small mb-2">Download a full SQL dump of the database (DTRs, Users, Cashouts, Settings) for safekeeping.</p>
                                <a href="backup.php" class="btn btn-outline-secondary">Download Backup</a>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">Save Settings</button>
                </form>
            </div>
            <!-- END SETTINGS TAB -->

            <?php if (false): ?>
            <!-- HEAD OT CASHOUTS TAB -->
            <div class="tab-pane fade" id="tab-otcashouts-head" role="tabpanel">
                <div class="card">
                    <div class="card-header bg-success text-white fw-bold">Pending OT Cashout Requests</div>
                    <div class="card-body">
                        <table class="table table-hover align-middle">
                            <thead><tr><th>Date Requested</th><th>Student Assistant</th><th>Hours</th><th>Action</th></tr></thead>
                            <tbody>
                                <?php 
                                $pendingCashouts = get_pending_ot_cashouts();
                                if (empty($pendingCashouts)): ?>
                                    <tr><td colspan="4" class="text-center text-muted py-3">No pending cashout requests.</td></tr>
                                <?php else: foreach ($pendingCashouts as $c): ?>
                                    <tr>
                                        <td><?= htmlspecialchars(date('M d, Y h:i A', strtotime($c['requested_at'])), ENT_QUOTES) ?></td>
                                        <td><?= htmlspecialchars($c['full_name'], ENT_QUOTES) ?> <span class="text-muted small">(<?= htmlspecialchars($c['id_number'], ENT_QUOTES) ?>)</span></td>
                                        <td><strong class="text-success"><?= htmlspecialchars((string)$c['hours_requested'], ENT_QUOTES) ?></strong></td>
                                        <td>
                                            <form method="post" action="dashboard.php" class="d-inline" onsubmit="return confirm('Approve this cashout?');">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="action" value="resolve_ot_cashout">
                                                <input type="hidden" name="cashout_id" value="<?= $c['cashout_id'] ?>">
                                                <input type="hidden" name="status" value="approved">
                                                <button type="submit" class="btn btn-success btn-sm btn-loading">Approve</button>
                                            </form>
                                            <form method="post" action="dashboard.php" class="d-inline" onsubmit="var r = prompt('Reason for rejection:'); if(r===null) return false; this.rejection_reason.value = r; return true;">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="action" value="resolve_ot_cashout">
                                                <input type="hidden" name="cashout_id" value="<?= $c['cashout_id'] ?>">
                                                <input type="hidden" name="status" value="rejected">
                                                <input type="hidden" name="rejection_reason" value="">
                                                <button type="submit" class="btn btn-danger btn-sm btn-loading">Reject</button>
                                            </form>
                                            <form method="post" action="dashboard.php#tab-otcashouts-head" class="d-inline" onsubmit="return confirm('Are you sure you want to permanently delete this pending request? This will refund the requested hours to the SA.');">
                                                <?= csrf_field() ?>
                                                <input type="hidden" name="action" value="delete_ot_cashout">
                                                <input type="hidden" name="cashout_id" value="<?= $c['cashout_id'] ?>">
                                                <button type="submit" class="btn btn-dark btn-sm">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                <?php endforeach; endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- END HEAD OT CASHOUTS TAB -->
            <?php endif; ?>

            <!-- ============================================================ -->
            <!-- REPORTS TAB — redesigned: inner sub-tabs + shared filter bar  -->
            <!-- ============================================================ -->

            

            <div class="tab-pane fade" id="tab-reports" role="tabpanel">

                <!-- INNER SUB-NAV -->
                <ul class="nav rpt-subnav hide-on-print" id="rptSubnav" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#rpt-annual" type="button">
                            <i class="bi bi-calendar3"></i> Annual Summary
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#rpt-cashouts" type="button">
                            <i class="bi bi-receipt"></i> OT Register &amp; Vouchers
                            <span class="badge bg-secondary badge-count"><?= count($allCashouts) ?></span>
                        </button>
                    </li>
                </ul>

                <div class="tab-content">

                    <!-- ================= ANNUAL SUMMARY ================= -->
                    <div class="tab-pane fade show active" id="rpt-annual" role="tabpanel">

                        <form method="get" action="/sahms/public/dashboard.php#tab-reports" class="rpt-filterbar row g-2 align-items-end hide-on-print">
                            <div class="col-auto">
                                <label class="form-label mb-0">Year</label>
                                <input type="number" name="year" class="form-control form-control-sm year-width-100" value="<?= $selectedYear ?>" required>
                            </div>
                            <div class="col-auto ms-auto">
                                <button type="submit" class="btn btn-dark btn-sm">Load Year</button>
                            </div>
                        </form>

                        <div class="card rpt-card print-annual">
                            <form method="post" action="/sahms/public/dashboard.php#tab-reports">
                                <?= csrf_field() ?>
                                <input type="hidden" name="action" value="save_annual_hours_summary">
                                <input type="hidden" name="year" value="<?= $selectedYear ?>">

                                <div class="card-header">
                                    <h2><i class="bi bi-calendar3"></i> Annual Hours Summary — <?= $selectedYear ?></h2>
                                    <div class="actions hide-on-print">
                                        <button type="submit" class="btn btn-primary btn-sm">
                                            <i class="bi bi-save"></i> Save Summary
                                        </button>
                                        <a href="/sahms/public/export_annual_summary.php?year=<?= $selectedYear ?>" class="btn btn-outline-secondary btn-sm">
                                            <i class="bi bi-filetype-csv"></i> Export CSV
                                        </a>
                                        <button type="button" class="btn btn-dark btn-sm" onclick="printSection('annual')">
                                            <i class="bi bi-printer"></i> Print
                                        </button>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <h5 class="mb-3 text-center print-only-heading">
                                        Annual Student Assistant Hours Summary Report — <?= $selectedYear ?>
                                    </h5>

                                    <?php if (empty($annualSummaryReport)): ?>
                                        <p class="empty text-muted text-center py-4 mb-0">No Student Assistant records found.</p>
                                    <?php else: ?>

                                        <div class="table-responsive annual-summary-scroll">
                                            <table class="table table-sm table-bordered annual-hours-table align-middle mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Student Assistant</th>
                                                        <?php foreach (['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'] as $index => $monthLabel): ?>
                                                            <?php $headerEndDay = (int)date('t', mktime(0, 0, 0, $index + 1, 1, $selectedYear)); ?>
                                                            <th>
                                                                <?= $monthLabel ?>
                                                                <small class="d-block fw-normal text-muted">1-15</small>
                                                                <small class="d-block second-half-label">16-<?= $headerEndDay ?></small>
                                                            </th>
                                                        <?php endforeach; ?>
                                                        <th>Total</th>
                                                        <th>OT</th>
                                                        <th>Remaining</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <?php
                                                $totAdvance=$totAll=$totOt=$totRemaining=0.0;
                                                $monthKeys = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'];
                                                foreach ($annualSummaryReport as $row):
                                                    $uid = (int)$row['user_id'];
                                                    $totAdvance += (float)$row['advance_hrs'];
                                                    $totAll += (float)$row['total_hrs'];
                                                    $totOt += (float)$row['ot_hrs'];
                                                    $remaining = max((float)$row['set_hours'] - (float)$row['total_hrs'], 0);
                                                    $totRemaining += $remaining;
                                                ?>
                                                    <tr>
                                                        <th scope="row">
                                                            <?= htmlspecialchars($row['full_name'], ENT_QUOTES) ?>
                                                            <small class="d-block text-muted"><?= htmlspecialchars($row['id_number'], ENT_QUOTES) ?></small>
                                                            <small class="d-block text-muted">Advance:
                                                                <input type="number" min="0" step="0.25"
                                                                       name="advance_hours[<?= $uid ?>]"
                                                                       value="<?= number_format((float)$row['advance_hrs'], 2, '.', '') ?>"
                                                                       class="form-control form-control-sm advance-input hide-on-print d-inline-block">
                                                                <span class="d-none d-print-inline"><?= number_format((float)$row['advance_hrs'], 1) ?></span>
                                                            </small>
                                                        </th>
                                                        <?php foreach ($monthKeys as $index => $mk):
                                                            $monthNumber = $index + 1;
                                                            $monthEndDay = (int)date('t', mktime(0, 0, 0, $monthNumber, 1, $selectedYear));
                                                            $monthFirst = (float)($row[$mk . '_first'] ?? $row[$mk]);
                                                            $monthSecond = (float)($row[$mk . '_second'] ?? 0);
                                                        ?>
                                                            <td>
                                                                <div class="month-entry hide-on-print">
                                                                    <input type="number" min="0" max="99999.99" step="0.25"
                                                                           class="form-control form-control-sm month-input first-half-input"
                                                                           name="first_half_hours[<?= $uid ?>][<?= $monthNumber ?>]"
                                                                           aria-label="<?= htmlspecialchars($row['full_name'] . ' ' . ucfirst($mk) . ' hours for days 1-15', ENT_QUOTES) ?>"
                                                                           value="<?= number_format($monthFirst, 2, '.', '') ?>" required>
                                                                    <input type="number" min="0" max="99999.99" step="0.25"
                                                                           class="form-control form-control-sm month-input second-half-input"
                                                                           name="second_half_hours[<?= $uid ?>][<?= $monthNumber ?>]"
                                                                           aria-label="<?= htmlspecialchars($row['full_name'] . ' ' . ucfirst($mk) . ' hours for days 16-' . $monthEndDay, ENT_QUOTES) ?>"
                                                                           value="<?= number_format($monthSecond, 2, '.', '') ?>" required>
                                                                </div>
                                                                <div class="d-none d-print-block">
                                                                    <?= number_format($monthFirst, 1) ?> / <?= number_format($monthSecond, 1) ?>
                                                                </div>
                                                            </td>
                                                        <?php endforeach; ?>
                                                        <td class="fw-bold"><?= number_format((float)$row['total_hrs'], 1) ?></td>
                                                        <td class="fw-semibold text-warning"><?= number_format((float)$row['ot_hrs'], 1) ?></td>
                                                        <td><?= $remaining <= 0.005 ? 'Completed' : number_format($remaining, 1) . ' hrs' ?></td>
                                                    </tr>
                                                <?php endforeach; ?>
                                                </tbody>
                                            </table>
                                        </div>
                                        <p class="form-text mb-0 mt-2">Each month is split into a 1-15 period and a 16-end period. The month total is the sum of both halves; OT and Remaining are shown at the right.</p>

                                        <div class="grand-total-strip mt-2">
                                            <span>Advance: <?= number_format($totAdvance, 1) ?></span>
                                            <span>Total: <?= number_format($totAll, 1) ?></span>
                                            <span>OT: <?= number_format($totOt, 1) ?></span>
                                            <span>Remaining: <?= number_format($totRemaining, 1) ?></span>
                                        </div>

                                    <?php endif; ?>

                                    <div class="mt-4 text-start print-only-heading prepared-by-block">
                                        <strong>PREPARED BY:</strong><br><br><br>
                                        <div class="signature-line"></div>
                                        <strong><?= htmlspecialchars($_SESSION['name'] ?? 'Head SA', ENT_QUOTES) ?></strong><br>
                                        <span class="text-muted">Head SA</span>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- END ANNUAL -->

                    <?php if (false): ?>
                    <!-- ================= CUT-OFF + DUTY (shared filter bar) ================= -->
                    <div class="tab-pane fade" id="rpt-cutoffduty" role="tabpanel">

                        <form method="get" action="/sahms/public/dashboard.php#tab-reports" class="rpt-filterbar row g-2 align-items-end hide-on-print">
                            <div class="col-auto">
                                <label class="form-label mb-0">Year</label>
                                <input type="number" name="year" class="form-control form-control-sm year-width-80" value="<?= $selectedYear ?>" required>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Month</label>
                                <select name="month" class="form-select form-select-sm filter-width-140">
                                    <?php for($m=1; $m<=12; $m++): ?>
                                        <option value="<?= $m ?>" <?= $m === $selectedMonth ? 'selected' : '' ?>><?= date('F', mktime(0,0,0,$m,1)) ?></option>
                                    <?php endfor; ?>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Cut-off</label>
                                <select name="period" class="form-select form-select-sm filter-width-140">
                                    <option value="first_half" <?= $selectedPeriod === 'first_half' ? 'selected' : '' ?>>1st - 15th</option>
                                    <option value="second_half" <?= $selectedPeriod === 'second_half' ? 'selected' : '' ?>>16th - End</option>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Student Assistant</label>
                                <select name="duty_user" class="form-select form-select-sm filter-width-180">
                                    <option value="">All SAs</option>
                                    <?php foreach ($saList as $sa): ?>
                                        <option value="<?= (int)$sa['user_id'] ?>" <?= ($dutyFilterUser ?? 0) === (int)$sa['user_id'] ? 'selected' : '' ?>>
                                            <?= htmlspecialchars($sa['full_name'], ENT_QUOTES) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Status</label>
                                <select name="duty_status" class="form-select form-select-sm filter-width-130">
                                    <option value="">All</option>
                                    <option value="approved" <?= ($dutyFilterStatus ?? '') === 'approved' ? 'selected' : '' ?>>Approved</option>
                                    <option value="pending" <?= ($dutyFilterStatus ?? '') === 'pending' ? 'selected' : '' ?>>Pending</option>
                                    <option value="rejected" <?= ($dutyFilterStatus ?? '') === 'rejected' ? 'selected' : '' ?>>Rejected</option>
                                </select>
                            </div>
                            <div class="col-auto ms-auto">
                                <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                            </div>
                        </form>

                        <!-- Cut-off card -->
                        <div class="card rpt-card print-cutoff mb-3">
                            <div class="card-header">
                                <h2>Cut-off Hours Report</h2>
                                <div class="actions hide-on-print">
                                    <button type="button" class="btn btn-dark btn-sm" onclick="printSection('cutoff')">
                                        <i class="bi bi-printer"></i> Print
                                    </button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <h5 class="mb-0 text-center print-only-heading p-3">
                                    Student Assistant Cut-off Hours Report<br>
                                    <small class="text-muted"><?= $selectedPeriod === 'first_half' ? '1st to 15th' : '16th to End' ?> of <?= date('F Y', mktime(0,0,0,$selectedMonth, 1, $selectedYear)) ?></small>
                                </h5>
                                <table class="table table-sm m-0">
                                    <thead class="table-light">
                                        <tr><th>ID Number</th><th>Student Name</th><th class="text-end">Total Approved Hours</th></tr>
                                    </thead>
                                    <tbody>
                                        <?php if (empty($cutoffReport)): ?>
                                            <tr><td colspan="3" class="text-center text-muted py-3">No approved hours for this period.</td></tr>
                                        <?php else: foreach ($cutoffReport as $cr): ?>
                                            <tr>
                                                <td><?= htmlspecialchars($cr['id_number'], ENT_QUOTES) ?></td>
                                                <td><?= htmlspecialchars($cr['full_name'], ENT_QUOTES) ?></td>
                                                <td class="text-end"><strong class="text-primary"><?= number_format($cr['total_hours'], 2) ?></strong></td>
                                            </tr>
                                        <?php endforeach; endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Detailed Duty card -->
                        <div class="card rpt-card print-duty">
                            <div class="card-header">
                                <h2>Detailed Duty Report</h2>
                                <div class="actions hide-on-print">
                                    <button type="button" class="btn btn-dark btn-sm" onclick="printSection('duty')">
                                        <i class="bi bi-printer"></i> Print
                                    </button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <h5 class="mb-0 text-center print-only-heading p-3">
                                    Detailed Duty Report<br>
                                    <small class="text-muted">
                                        <?= $selectedPeriod === 'first_half' ? '1st to 15th' : '16th to End' ?> of <?= date('F Y', mktime(0,0,0,$selectedMonth, 1, $selectedYear)) ?>
                                        <?php if ($dutyFilterUser): ?>
                                            — <?= htmlspecialchars($saList[array_search($dutyFilterUser, array_column($saList, 'user_id'))]['full_name'] ?? 'Selected SA', ENT_QUOTES) ?>
                                        <?php endif; ?>
                                        <?php if ($dutyFilterStatus): ?>
                                            (<?= ucfirst($dutyFilterStatus) ?> only)
                                        <?php endif; ?>
                                    </small>
                                </h5>
                                <div class="table-responsive">
                                    <table class="table table-sm table-striped m-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Date</th><th>ID Number</th><th>Student Name</th>
                                                <th>Time In</th><th>Time Out</th><th class="text-end">Hours</th><th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php if (empty($detailedDutyReport)): ?>
                                                <tr><td colspan="7" class="text-center text-muted py-3">No duty entries found for this period.</td></tr>
                                            <?php else:
                                                $dutyGrandTotal = 0.0;
                                                foreach ($detailedDutyReport as $dr):
                                                    $drHrs = compute_net_hours($dr['time_in'], $dr['time_out']);
                                                    $dutyGrandTotal += $drHrs ?? 0;
                                            ?>
                                                <tr>
                                                    <td class="text-nowrap"><?= htmlspecialchars($dr['work_date'], ENT_QUOTES) ?></td>
                                                    <td><?= htmlspecialchars($dr['id_number'], ENT_QUOTES) ?></td>
                                                    <td><?= htmlspecialchars($dr['full_name'], ENT_QUOTES) ?></td>
                                                    <td class="text-nowrap"><?= htmlspecialchars(substr($dr['time_in'], 11, 5), ENT_QUOTES) ?></td>
                                                    <td class="text-nowrap"><?= htmlspecialchars(isset($dr['time_out']) ? substr($dr['time_out'], 11, 5) : '—', ENT_QUOTES) ?></td>
                                                    <td class="text-end"><strong><?= $drHrs !== null ? number_format($drHrs, 2) : '—' ?></strong></td>
                                                    <td>
                                                        <span class="badge <?= $dr['status'] === 'approved' ? 'bg-success' : ($dr['status'] === 'rejected' ? 'bg-danger' : 'bg-warning text-dark') ?>">
                                                            <?= htmlspecialchars(ucfirst($dr['status']), ENT_QUOTES) ?>
                                                        </span>
                                                    </td>
                                                </tr>
                                            <?php endforeach; ?>
                                                <tr class="table-success fw-bold">
                                                    <td colspan="5" class="text-end">Grand Total:</td>
                                                    <td class="text-end"><?= number_format($dutyGrandTotal, 2) ?></td>
                                                    <td><small><?= count($detailedDutyReport) ?> entries</small></td>
                                                </tr>
                                            <?php endif; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- END CUT-OFF + DUTY -->
                    <?php endif; ?>

                    <!-- ================= ADVANCE & VOUCHER (print-ready) ================= -->
                    <?php
                    $avActiveSas = [];
                    foreach (($allSaListForManage ?? []) as $avSa) {
                        if ((int)$avSa['is_active'] === 1) {
                            $avActiveSas[] = $avSa;
                        }
                    }
                    $avSaData = [];
                    foreach ($annualSummaryReport as $avRow) {
                        $avMonths = [];
                        foreach (['may','jun','jul','aug','sep','oct','nov','dec'] as $avKey) {
                            $avMonths[$avKey] = (float)($avRow[$avKey] ?? 0);
                        }
                        $avSaData[(int)$avRow['user_id']] = [
                            'name'    => (string)$avRow['full_name'],
                            'advance' => (float)($avRow['advance_hrs'] ?? 0),
                            'months'  => $avMonths,
                        ];
                    }
                    $avSemesters = ['1st Semester', '2nd Semester'];
                    $avDepartments = ['IT Dept.', 'Library', 'Custodian', 'Kinder', 'Other'];
                    ?>
                    <div class="tab-pane fade" id="rpt-cashouts" role="tabpanel">
                        <div class="card rpt-card print-otregister mb-3">
                            <div class="card-header">
                                <h2>Advance &amp; Voucher</h2>
                                <div class="actions hide-on-print">
                                    <button type="button" class="btn btn-dark btn-sm" onclick="printSection('otregister')">
                                        <i class="bi bi-printer"></i> Print Form
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="av-form" id="avForm">
                                    <div class="av-document-head hide-on-print">
                                        <div class="av-school">ASIATECH &middot; STUDENT ASSISTANT HOURS MANAGEMENT SYSTEM</div>
                                        <div class="av-document-title">ADVANCE &amp; VOUCHER</div>
                                        <div class="av-document-sub">STUDENT ASSISTANT MONITORING TIME RECORD</div>
                                    </div>
                                    <div class="av-header">
                                        <div class="av-date">Date: <?= date('M. d, Y') ?></div>
                                        <div class="av-header-row">
                                            <span>Student Assistant</span>
                                            <span class="av-dept">
                                                Department:
                                                <select id="avDepartment" class="av-select d-print-none">
                                                    <?php foreach ($avDepartments as $avDept): ?>
                                                        <option value="<?= htmlspecialchars($avDept, ENT_QUOTES) ?>"><?= htmlspecialchars($avDept, ENT_QUOTES) ?></option>
                                                    <?php endforeach; ?>
                                                </select>
                                                <input type="text" id="avDepartmentOther" class="av-other d-print-none" placeholder="Specify" hidden>
                                                <span id="avDepartmentPrint" class="d-none d-print-inline"></span>
                                            </span>
                                        </div>
                                        <div>A.Y: <span id="avSchoolYear"><?= (int)$selectedYear ?> - <?= (int)$selectedYear + 1 ?></span> (<span id="avSemesterPrint">1st Semester</span>)</div>
                                        <div>
                                            Name:
                                            <select id="avSaName" class="av-select d-print-none">
                                                <option value="">-- Select Student Assistant --</option>
                                                <?php foreach ($avActiveSas as $avSa): ?>
                                                    <option value="<?= (int)$avSa['user_id'] ?>"><?= htmlspecialchars($avSa['full_name'], ENT_QUOTES) ?></option>
                                                <?php endforeach; ?>
                                            </select>
                                            <span id="avSaNamePrint" class="d-none d-print-inline"></span>
                                        </div>
                                        <div class="av-semester hide-on-print">
                                            Semester:
                                            <select id="avSemester" class="av-select">
                                                <?php foreach ($avSemesters as $avSem): ?>
                                                    <option value="<?= htmlspecialchars($avSem, ENT_QUOTES) ?>"><?= htmlspecialchars($avSem, ENT_QUOTES) ?></option>
                                                <?php endforeach; ?>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="av-time-record">
                                        <strong>Time Record:</strong>
                                        <div>Advance: <span id="avAdvance">0</span> Hrs</div>
                                        <div>Total: <span id="avTotal">0</span> Hrs</div>
                                    </div>
                                    <hr class="av-rule av-rule-double">

                                    <div class="av-table-title" id="avTableTitle">SA- MONITORING TIME <?= (int)$selectedYear ?>-<?= (int)$selectedYear + 1 ?> (1st Semester)</div>
                                    <table class="av-table">
                                        <thead>
                                            <tr>
                                                <th rowspan="2">Name</th>
                                                <th colspan="1">MAY</th>
                                                <?php foreach (['JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'] as $avMonthLabel): ?>
                                                    <th colspan="2"><?= $avMonthLabel ?></th>
                                                <?php endforeach; ?>
                                                <th colspan="2">Earning Time</th>
                                                <th rowspan="2">Sig.</th>
                                            </tr>
                                            <tr>
                                                <th>Absences</th>
                                                <?php for ($avI = 0; $avI < 7; $avI++): ?>
                                                    <th>Hrs</th><th>Leave</th>
                                                <?php endfor; ?>
                                                <th>Total</th><th>Leave</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td id="avRowName" class="av-name-cell"></td>
                                                <td id="avMay"></td>
                                                <?php foreach (['jun','jul','aug','sep','oct','nov','dec'] as $avMonthKey): ?>
                                                    <td class="av-hrs" data-av-month="<?= $avMonthKey ?>"></td>
                                                    <td class="av-leave"></td>
                                                <?php endforeach; ?>
                                                <td id="avEarnTotal" class="fw-bold"></td>
                                                <td id="avEarnLeave"></td>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="av-bottom">
                                        <div class="av-signatures">
                                            <div class="av-signature">
                                                <div class="av-signature-line"></div>
                                                <strong><?= htmlspecialchars($_SESSION['name'] ?? 'Head SA', ENT_QUOTES) ?></strong><br>
                                                <span>SA Adviser</span>
                                                <span class="av-signature-date"><?= date('m/d/y') ?></span>
                                            </div>
                                            <div class="av-approval">
                                                <div class="av-signature-line"></div>
                                                <span>Checked by:</span>
                                            </div>
                                            <div class="av-approval">
                                                <div class="av-signature-line"></div>
                                                <span>Noted By:</span>
                                            </div>
                                        </div>
                                        <div class="av-computation">
                                            <strong>Computation</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                    (function () {
                        const saData = <?= json_encode($avSaData, JSON_UNESCAPED_SLASHES) ?>;
                        const semesters = <?= json_encode($avSemesters, JSON_UNESCAPED_SLASHES) ?>;
                        const $ = (id) => document.getElementById(id);
                        const dept = $('avDepartment'), deptOther = $('avDepartmentOther'), deptPrint = $('avDepartmentPrint');
                        const name = $('avSaName'), namePrint = $('avSaNamePrint');
                        const sem = $('avSemester'), semPrint = $('avSemesterPrint');
                        const sy = '<?= (int)$selectedYear ?> - <?= (int)$selectedYear + 1 ?>';
                        const fmt = (n) => (Math.round((Number(n) || 0) * 100) / 100).toFixed(2).replace(/\.00$/, '');

                        function syncDept() {
                            const value = dept.value;
                            deptOther.hidden = value !== 'Other';
                            deptPrint.textContent = value === 'Other' ? (deptOther.value.trim() || '') : value;
                        }
                        function syncName() {
                            const row = saData[name.value];
                            namePrint.textContent = row ? row.name : '';
                            $('avRowName').textContent = row ? row.name : '';
                            const advance = row ? row.advance : 0;
                            $('avAdvance').textContent = fmt(advance);
                            let sum = 0;
                            document.querySelectorAll('.av-hrs').forEach((cell) => {
                                const key = cell.getAttribute('data-av-month');
                                const value = row ? (row.months[key] || 0) : 0;
                                cell.textContent = value > 0 ? fmt(value) : '';
                                sum += value;
                            });
                            $('avMay').textContent = row && row.months.may > 0 ? fmt(row.months.may) : '';
                            sum += row ? (row.months.may || 0) : 0;
                            $('avEarnTotal').textContent = fmt(sum + advance);
                            $('avEarnLeave').textContent = fmt(advance);
                            $('avTotal').textContent = fmt(advance);
                        }
                        function syncSemester() {
                            semPrint.textContent = sem.value;
                            $('avTableTitle').textContent = 'SA- MONITORING TIME ' + sy + ' (' + sem.value + ')';
                        }
                        dept.addEventListener('change', syncDept);
                        deptOther.addEventListener('input', syncDept);
                        name.addEventListener('change', syncName);
                        sem.addEventListener('change', syncSemester);
                        if (name.options.length > 1) name.selectedIndex = 1;
                        syncDept(); syncName(); syncSemester();
                    })();
                    </script>
                    <!-- END ADVANCE & VOUCHER -->

                </div><!-- end inner tab-content -->
            </div>
            <!-- END REPORTS TAB -->



        </div> <!-- END TAB CONTENT -->

        <?php foreach ($allCashouts as $c): if ($c['status'] === 'approved'): ?>
            <div id="voucher-<?= $c['cashout_id'] ?>" class="print-only-voucher">
                <div class="p-4 bg-white">
                    <h3 class="text-center mb-4">Overtime Cashout Voucher</h3>
                    <div class="row mb-4">
                        <div class="col-6">
                            <strong>Student Assistant:</strong> <?= htmlspecialchars($c['full_name'], ENT_QUOTES) ?><br>
                            <strong>ID Number:</strong> <?= htmlspecialchars($c['id_number'], ENT_QUOTES) ?>
                        </div>
                        <div class="col-6 text-end">
                            <strong>Cashout ID:</strong> #<?= $c['cashout_id'] ?><br>
                            <strong>Date Requested:</strong> <?= htmlspecialchars(date('M d, Y h:i A', strtotime($c['requested_at'])), ENT_QUOTES) ?><br>
                            <strong>Hours Cashed Out:</strong> <span class="text-success fw-bold"><?= $c['hours_requested'] ?> hrs</span>
                        </div>
                    </div>
                    <table class="table table-bordered table-sm text-center">
                        <?php 
                        $breakdown = get_sa_hours_breakdown($c['user_id']);
                        $monthsData = [];
                        $totalAcc = 0;
                        foreach($breakdown as $b) {
                            $monthName = strtoupper(date('F', mktime(0,0,0,$b['mo'],1))) . ' ' . $b['yr'];
                            if (!isset($monthsData[$monthName])) {
                                $monthsData[$monthName] = ['first_half' => 0, 'second_half' => 0];
                            }
                            $monthsData[$monthName][$b['period']] = $b['total_hours'];
                            $totalAcc += $b['total_hours'];
                        }
                        ?>
                        <?php if(!empty($monthsData)): ?>
                            <thead class="table-light">
                                <tr>
                                    <?php foreach($monthsData as $monthName => $data): ?>
                                        <th colspan="2"><?= $monthName ?></th>
                                    <?php endforeach; ?>
                                </tr>
                                <tr>
                                    <?php foreach($monthsData as $monthName => $data): ?>
                                        <th>1 - 15</th>
                                        <th>16 - End</th>
                                    <?php endforeach; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <?php foreach($monthsData as $monthName => $data): ?>
                                        <td><?= $data['first_half'] > 0 ? number_format($data['first_half'], 2) : '' ?></td>
                                        <td><?= $data['second_half'] > 0 ? number_format($data['second_half'], 2) : '' ?></td>
                                    <?php endforeach; ?>
                                </tr>
                            </tbody>
                        <?php else: ?>
                            <tbody><tr><td class="text-center text-muted">No approved hours found.</td></tr></tbody>
                        <?php endif; ?>
                    </table>
                    <div class="text-end mb-4">
                        <?php 
                        $summaryForVoucher = get_dtr_summary((int)$c['user_id']);
                        $advanceHours = $summaryForVoucher['advance'] ?? 0;
                        ?>
                        <?php if ($advanceHours > 0): ?>
                            <strong>Total Rendered Hours:</strong> <?= number_format($totalAcc, 2) ?><br>
                            <strong>Advance Hours:</strong> <?= number_format($advanceHours, 2) ?><br>
                            <strong>Total Accumulated (Rendered + Advance):</strong> <?= number_format($totalAcc + $advanceHours, 2) ?>
                        <?php else: ?>
                            <strong>Total Approved Hours Accumulated:</strong> <?= number_format($totalAcc, 2) ?>
                        <?php endif; ?>
                    </div>
                    <div class="mt-5 text-start">
                        <strong>APPROVED BY:</strong><br><br><br>
                        <div class="signature-line"></div>
                        <strong><?= htmlspecialchars($c['resolved_by_name'] ?? 'Head SA', ENT_QUOTES) ?></strong><br>
                    </div>
                </div>
            </div>
        <?php endif; endforeach; ?>

<script>
function printSection(section) {
    const sections = ['annual', 'otregister', 'narrative', 'tabular', 'cutoff', 'duty'];
    const elements = {};

    sections.forEach(s => { elements[s] = document.querySelector('.print-' + s); });

    // Hide all sections except the one being printed
    sections.forEach(s => {
        if (s !== section && elements[s]) {
            elements[s].style.setProperty('display', 'none', 'important');
        }
    });

    let style = null;
    if (section === 'annual' || section === 'otregister') {
        style = document.createElement('style');
        style.innerHTML = section === 'annual'
            ? '@page { size: landscape; }'
            : '@page { size: portrait; margin: 12mm; }';
        document.head.appendChild(style);
    }

    window.print();

    if (style) {
        document.head.removeChild(style);
    }

    // Restore all sections
    sections.forEach(s => {
        if (s !== section && elements[s]) {
            elements[s].style.removeProperty('display');
        }
    });
}


function printVoucher(id) {
    const tabContent = document.querySelector('.tab-content');
    const voucher = document.getElementById('voucher-' + id);
    
    if (tabContent && voucher) {
        tabContent.style.setProperty('display', 'none', 'important');
        voucher.style.setProperty('display', 'block', 'important');
        window.print();
        voucher.style.setProperty('display', 'none', 'important');
        tabContent.style.removeProperty('display');
    }
}

(function () {
    function updatePhotoTransform(img) {
        const zoom = parseFloat(img.dataset.zoom) || 1;
        const rotate = parseInt(img.dataset.rotate, 10) || 0;
        const translateX = parseFloat(img.dataset.translateX) || 0;
        const translateY = parseFloat(img.dataset.translateY) || 0;
        img.style.transform = `translate(${translateX}px, ${translateY}px) scale(${zoom}) rotate(${rotate}deg)`;

        const label = img.closest('.pending-photo-card')
            .parentElement.querySelector('.pending-photo-zoom-label');
        if (label) {
            label.textContent = Math.round(zoom * 100) + '%';
        }
    }

    function clampZoom(value) {
        return Math.min(3, Math.max(0.5, value));
    }

    function initPendingPhotoDrag(img) {
        let dragging = false;
        let startX = 0;
        let startY = 0;
        let startTranslateX = 0;
        let startTranslateY = 0;

        function onPointerMove(event) {
            if (!dragging) return;
            const dx = event.clientX - startX;
            const dy = event.clientY - startY;
            img.dataset.translateX = (startTranslateX + dx).toFixed(0);
            img.dataset.translateY = (startTranslateY + dy).toFixed(0);
            updatePhotoTransform(img);
        }

        function onPointerUp() {
            if (!dragging) return;
            dragging = false;
            img.style.cursor = 'grab';
            img.releasePointerCapture(pointerId);
        }

        let pointerId = null;

        img.addEventListener('pointerdown', event => {
            if (event.button !== 0) return;
            event.preventDefault();
            dragging = true;
            pointerId = event.pointerId;
            startX = event.clientX;
            startY = event.clientY;
            startTranslateX = parseFloat(img.dataset.translateX) || 0;
            startTranslateY = parseFloat(img.dataset.translateY) || 0;
            img.style.cursor = 'grabbing';
            img.setPointerCapture(pointerId);
        });

        img.addEventListener('pointermove', onPointerMove);
        img.addEventListener('pointerup', onPointerUp);
        img.addEventListener('pointercancel', onPointerUp);
        img.addEventListener('lostpointercapture', onPointerUp);
    }

    document.querySelectorAll('.pending-photo-preview').forEach(initPendingPhotoDrag);

    document.querySelectorAll('.pending-photo-controls button').forEach(button => {
        button.addEventListener('click', () => {
            const action = button.dataset.action;
            const modalSection = button.closest('.col-md-7');
            const img = modalSection ? modalSection.querySelector('.pending-photo-preview') : null;
            if (!img) return;

            let zoom = parseFloat(img.dataset.zoom) || 1;
            let rotate = parseInt(img.dataset.rotate, 10) || 0;
            let translateX = parseFloat(img.dataset.translateX) || 0;
            let translateY = parseFloat(img.dataset.translateY) || 0;

            if (action === 'zoom-in') {
                zoom = clampZoom(zoom + 0.1);
            } else if (action === 'zoom-out') {
                zoom = clampZoom(zoom - 0.1);
            } else if (action === 'rotate-left') {
                rotate = (rotate - 90) % 360;
            } else if (action === 'rotate-right') {
                rotate = (rotate + 90) % 360;
            } else if (action === 'reset') {
                zoom = 1;
                rotate = 0;
                translateX = 0;
                translateY = 0;
            }

            img.dataset.zoom = zoom.toFixed(2);
            img.dataset.rotate = rotate;
            img.dataset.translateX = translateX.toFixed(0);
            img.dataset.translateY = translateY.toFixed(0);
            updatePhotoTransform(img);
        });
    });
})();

(function () {
    function showTabByTarget(target) {
        if (!target) return false;
        if (target.charAt(0) !== '#') target = '#' + target;
        var pane = document.querySelector(target);
        if (!pane) return false;
        var trigger = document.querySelector(
            '[data-bs-toggle="pill"][data-bs-target="' + target + '"], [data-bs-toggle="tab"][data-bs-target="' + target + '"]'
        );
        if (!trigger) return false;
        var tab = bootstrap.Tab.getOrCreateInstance(trigger);
        tab.show();
        return true;
    }

    // Wire up "jump to tab" buttons (e.g. the Review/View buttons in Overview's action list)
    document.querySelectorAll('.nav-tab-jump').forEach(function (btn) {
        btn.addEventListener('click', function () {
            showTabByTarget(btn.getAttribute('data-jump'));
        });
    });

    // Save + reflect the active tab in the URL hash whenever a tab is switched,
    // for both the main nav and the Reports inner sub-nav.
    function trackNav(navSelector, storageKey) {
        var nav = document.querySelector(navSelector);
        if (!nav) return;
        nav.querySelectorAll('[data-bs-toggle="pill"], [data-bs-toggle="tab"]').forEach(function (btn) {
            btn.addEventListener('shown.bs.tab', function (e) {
                var target = e.target.getAttribute('data-bs-target');
                try { localStorage.setItem(storageKey, target); } catch (err) {}
                if (history.replaceState) {
                    var url = new URL(window.location.href);
                    url.hash = target;
                    history.replaceState(null, '', url);
                }
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var hash = window.location.hash;
        var reportsSubIds = ['#rpt-annual', '#rpt-cashouts'];
        var restored = false;

        if (hash) {
            if (reportsSubIds.indexOf(hash) !== -1) {
                // Direct link to a Reports sub-section: open Reports first, then the sub-tab
                showTabByTarget('#tab-reports');
                showTabByTarget(hash);
                restored = true;
            } else {
                restored = showTabByTarget(hash);
            }
        }

        if (!restored) {
            // No usable hash (e.g. plain refresh on a bare URL) — fall back to last-used tab
            try {
                var lastMain = localStorage.getItem('lastActiveTab:headSaTabs');
                var lastReportsSub = localStorage.getItem('lastActiveTab:rptSubnav');
                if (lastMain) {
                    showTabByTarget(lastMain);
                    if (lastMain === '#tab-reports' && lastReportsSub) {
                        showTabByTarget(lastReportsSub);
                    }
                }
            } catch (err) {}
        }

        trackNav('#headSaTabs', 'lastActiveTab:headSaTabs');
        trackNav('#rptSubnav', 'lastActiveTab:rptSubnav');
    });
})();

document.addEventListener('DOMContentLoaded', function () {
    <?php if (!empty($annualSummaryReport)): ?>
    const orgMonthlyCtx = document.getElementById('orgMonthlyChart');
    if (orgMonthlyCtx) {
        new Chart(orgMonthlyCtx, {
            type: 'bar',
            data: {
                labels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
                datasets: [{
                    label: 'Total Hours',
                    data: <?= json_encode(array_values($orgMonthlyTotals)) ?>,
                    backgroundColor: '#3457d5',
                    borderRadius: 4,
                    maxBarThickness: 36
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { precision: 0 } }
                }
            }
        });
    }
    <?php endif; ?>

});
</script>