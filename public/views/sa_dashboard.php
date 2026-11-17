<?php 
if (basename($_SERVER['PHP_SELF']) === basename(__FILE__)) {
    header('Location: ../dashboard.php');
    exit;
}
?>
		<div class="row mb-4 g-3 justify-content-center">
          <!-- Advance Hours -->
          <div class="col">
            <div class="card text-center h-100 border-info">
              <div class="card-body">
                <div class="text-muted small">Advance Hours</div>
                <div class="h3 mb-0 text-info fw-bold">
                  <?= htmlspecialchars((string)$summary['advance'], ENT_QUOTES) ?>
                </div>
              </div>
            </div>
          </div>

          <!-- Rendered Hours -->
          <div class="col">
            <div class="card text-center h-100 border-primary">
              <div class="card-body">
                <div class="text-muted small">Rendered Hours</div>
                <div class="h3 mb-0 text-primary fw-bold">
                  <?= htmlspecialchars((string)$summary['rendered'], ENT_QUOTES) ?>
                </div>
              </div>
            </div>
          </div>

          <!-- Required Hours -->
          <div class="col">
            <div class="card text-center h-100 border-secondary">
              <div class="card-body">
                <div class="text-muted small">Required Hours</div>
                <div class="h3 mb-0 text-secondary fw-bold">
                  <?= htmlspecialchars((string)$summary['required'], ENT_QUOTES) ?>
                </div>
              </div>
            </div>
          </div>

          <!-- Remaining Hours -->
          <div class="col">
            <div class="card text-center h-100 border-warning">
              <div class="card-body">
                <div class="text-muted small">Remaining Hours</div>
                <div class="h3 mb-0 text-warning fw-bold">
                  <?= htmlspecialchars((string)$summary['remaining'], ENT_QUOTES) ?>
                </div>
              </div>
            </div>
          </div>

          <!-- OT (Bankable) -->
          <div class="col">
            <div class="card text-center h-100 border-success">
              <div class="card-body">
                <div class="text-muted small">OT (Bankable)</div>
                <div class="h3 mb-0 text-success fw-bold">
                  <?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?>
                </div>
              </div>
            </div>
          </div>
        </div>

        <?php 
        $req = (float)$summary['required'];
        $ren = (float)$summary['rendered'];
        $adv = (float)$summary['advance'];
        $totalRendered = $ren + $adv;
        $percent = $req > 0 ? min(100, round(($totalRendered / $req) * 100)) : 0;
        ?>
        <div class="progress sa-hours-progress mb-4 shadow-sm">
            <div class="progress-bar sa-hours-progress-bar <?= $percent >= 100 ? 'bg-success' : 'bg-primary' ?> progress-bar-striped progress-bar-animated" role="progressbar" style="width: <?= $percent ?>%;" aria-valuenow="<?= $percent ?>" aria-valuemin="0" aria-valuemax="100">
                <?= $percent ?>% Completed (<?= $totalRendered ?> / <?= $req ?> hrs)
            </div>
        </div>

        <!-- DESKTOP NAV (hidden on mobile, shown md and up) -->
        <ul class="nav nav-pills mb-4 gap-2 d-none d-md-flex" id="saTabsDesktop" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-semibold sa-tab-trigger" id="mydtr-tab-desktop" data-bs-toggle="pill" data-bs-target="#tab-mydtr" type="button" role="tab">My DTR</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold sa-tab-trigger" id="submit1-tab-desktop" data-bs-toggle="pill" data-bs-target="#tab-submit1" type="button" role="tab">Submit DTR (1 Day)</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold sa-tab-trigger" id="submitbulk-tab-desktop" data-bs-toggle="pill" data-bs-target="#tab-submitbulk" type="button" role="tab">Submit DTR (Bulk 15 Days)</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-semibold sa-tab-trigger text-success" id="otcashout-tab-desktop" data-bs-toggle="pill" data-bs-target="#tab-otcashout" type="button" role="tab">OT Cashout</button>
            </li>
        </ul>

        <!-- MOBILE BOTTOM NAV (shown only below md, fixed to bottom like an app nav bar) -->
        <nav class="d-md-none fixed-bottom bg-white border-top shadow-lg" id="saTabsMobile" role="tablist">
            <div class="d-flex">
                <!-- My DTR -->
                <button class="flex-fill btn rounded-0 py-2 active sa-tab-trigger" id="mydtr-tab-mobile" data-bs-toggle="pill" data-bs-target="#tab-mydtr" type="button" role="tab">
                    <div class="sa-mobile-icon">
                        <!-- Folder Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M10 4H2v16h20V6H12l-2-2z"/>
                        </svg>
                    </div>
                    <div class="small mt-1">My DTR</div>
                </button>

                <!-- 1 Day -->
                <button class="flex-fill btn rounded-0 py-2 sa-tab-trigger" id="submit1-tab-mobile" data-bs-toggle="pill" data-bs-target="#tab-submit1" type="button" role="tab">
                    <div class="sa-mobile-icon">
                        <!-- Note/Document Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M6 2h9l5 5v15H6V2zm8 7V3.5L18.5 9H14z"/>
                        </svg>
                    </div>
                    <div class="small mt-1">1 Day</div>
                </button>

                <!-- Bulk 15 -->
                <button class="flex-fill btn rounded-0 py-2 sa-tab-trigger" id="submitbulk-tab-mobile" data-bs-toggle="pill" data-bs-target="#tab-submitbulk" type="button" role="tab">
                    <div class="sa-mobile-icon">
                        <!-- Calendar Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 
                            2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 
                            2-2V6c0-1.1-.9-2-2-2zm0 
                            16H5V9h14v11z"/>
                        </svg>
                    </div>
                    <div class="small mt-1">Bulk 15</div>
                </button>

                <!-- OT Cashout -->
                <button class="flex-fill btn rounded-0 py-2 sa-tab-trigger text-success" id="otcashout-tab-mobile" data-bs-toggle="pill" data-bs-target="#tab-otcashout" type="button" role="tab">
                    <div class="sa-mobile-icon">
                        <!-- Money/Cash Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
                        </svg>
                    </div>
                    <div class="small mt-1">Cashout</div>
                </button>
                
                <!-- Settings (Change Password / Logout) -->
                <button class="flex-fill btn rounded-0 py-2" id="settings-tab-mobile" data-bs-toggle="modal" data-bs-target="#settingsMobileModal" type="button">
                    <div class="sa-mobile-icon">
                        <!-- Gear Icon -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M19.14 12.94c.04-.3.06-.61.06-.94s-.02-.64-.07-.94l2.03-1.58a.5.5 0 0 0 .12-.61l-1.92-3.32a.5.5 0 0 0-.59-.22l-2.39.96a7.03 7.03 0 0 0-1.62-.94l-.36-2.54a.5.5 0 0 0-.5-.42h-3.84a.5.5 0 0 0-.5.42l-.36 2.54c-.59.24-1.13.56-1.62.94l-2.39-.96a.5.5 0 0 0-.59.22L2.36 8.87a.5.5 0 0 0 .12.61l2.03 1.58c-.05.3-.08.63-.08.94s.02.64.07.94L2.47 14.52a.5.5 0 0 0-.12.61l1.92 3.32c.14.24.42.33.66.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.29.29.5.59.5h3.84c.3 0 .54-.21.59-.5l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.24.11.53.02.66-.22l1.92-3.32a.5.5 0 0 0-.12-.61l-2.03-1.58zM12 15.5A3.5 3.5 0 1 1 12 8.5a3.5 3.5 0 0 1 0 7z"/>
                        </svg>
                    </div>
                    <div class="small mt-1">Settings</div>
                </button>
                
            </div>
        </nav>

        <div class="tab-content" id="saTabsContent">

            <!-- MY DTR TAB -->
            <div class="tab-pane fade show active" id="tab-mydtr" role="tabpanel">
                <div class="card mb-4">
                    <div class="card-header fw-bold">My DTR History</div>
                    <div class="card-body pb-3">
                        <form method="get" action="dashboard#tab-mydtr" class="row gx-2 gy-3 align-items-end">
                            <div class="col-auto">
                                <label class="form-label small mb-1">Year</label>
                                <input type="number" name="history_year" class="form-control form-control-sm" min="2020" max="2100" value="<?= htmlspecialchars((string)$historyYear, ENT_QUOTES) ?>" onchange="this.form.submit()">
                            </div>
                            <div class="col-auto">
                                <label class="form-label small mb-1">Month</label>
                                <select name="history_month" class="form-select form-select-sm" onchange="this.form.submit()">
                                    <?php for ($m = 1; $m <= 12; $m++): ?>
                                        <option value="<?= $m ?>" <?= $m === $historyMonth ? 'selected' : '' ?>>
                                            <?= date('F', mktime(0, 0, 0, $m, 1)) ?>
                                        </option>
                                    <?php endfor; ?>
                                </select>
                            </div>
                            <div class="col-auto align-self-center">
                                <span class="badge bg-secondary fs-6">Total Hours: <?= number_format($historyTotalHours, 2) ?></span>
                            </div>
                        </form>
                    </div>
                    <div class="card-body pt-0">
                        <div class="table-responsive">
                            <table class="table table-sm table-striped align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-nowrap">Date</th>
                                        <th class="text-nowrap">Time In</th>
                                        <th class="text-nowrap">Time Out</th>
                                        <th class="text-nowrap">Hours</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (empty($history)): ?>
                                        <tr><td colspan="5" class="text-center text-muted py-3">No DTR entries yet.</td></tr>
                                    <?php else: foreach ($history as $entry): 
                                        $hours = compute_net_hours($entry['time_in'], $entry['time_out']);
                                    ?>
                                        <tr>
                                            <td class="text-nowrap"><?= htmlspecialchars(date('j M', strtotime($entry['work_date'])), ENT_QUOTES) ?></td>
                                            <td><?= htmlspecialchars(substr($entry['time_in'], 11, 5), ENT_QUOTES) ?></td>
                                            <td><?= htmlspecialchars($entry['time_out'] ? substr($entry['time_out'], 11, 5) : '—', ENT_QUOTES) ?></td>
                                            <td><?= $hours !== null ? number_format($hours, 2) : '—' ?></td>
                                            <td>
                                                <?php if ($entry['status'] === 'approved'): ?>
                                                    <span class="badge bg-success">Approved</span>
                                                <?php elseif ($entry['status'] === 'rejected'): ?>
                                                    <span class="badge bg-danger">Rejected</span>
                                                <?php else: ?>
                                                    <span class="badge bg-warning text-dark">Pending</span>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endforeach; endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END MY DTR TAB -->

            <!-- SUBMIT 1 DAY TAB -->
            <div class="tab-pane fade" id="tab-submit1" role="tabpanel">
                <div class="card">
                    <div class="card-body">
                        <h2 class="h5 mb-3">Submit DTR Entry</h2>
                        <p class="text-muted small">
                            Attach a clear photo of your signed DTR for this date. Your Head SA will review it and
                            the hours will only count toward your total once approved.
                        </p>
                        <form method="post" enctype="multipart/form-data" action="dashboard#tab-submit1" class="row g-3">
                            <?= csrf_field() ?>
                            <input type="hidden" name="action" value="submit_entry">
                            <div class="col-md-4">
                                <label class="form-label">Date</label>
                                <input type="date" name="work_date" class="form-control" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Time In</label>
                                <input type="text" name="time_in" class="form-control time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Time Out</label>
                                <input type="text" name="time_out" class="form-control time24" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric" required>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <div class="w-100">
                                    <div id="submit1-hours" class="badge bg-secondary text-white d-inline-block py-2 px-3">—</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Photo of DTR</label>
                                <div class="form-text">JPG, PNG, or WEBP.</div>
                                <input type="file" name="photo" class="form-control" accept="image/jpeg,image/png,image/webp" required>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">Submit for Review</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- END SUBMIT 1 DAY TAB -->

            <!-- SUBMIT BULK/CUTOFF TAB -->
            <div class="tab-pane fade" id="tab-submitbulk" role="tabpanel">
                <div class="card mb-3">
                    <div class="card-body">
                        <form method="get" action="dashboard#tab-submitbulk" class="row g-2 align-items-end">
                            <div class="col-auto">
                                <label class="form-label mb-0">Year</label>
                                <input type="number" name="year" value="<?= $selectedYear ?>" class="form-control" min="2020" max="2100">
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Months</label>
                                <select name="month" class="form-select">
                                    <?php for ($m = 1; $m <= 12; $m++): ?>
                                        <option value="<?= $m ?>" <?= $m === $selectedMonth ? 'selected' : '' ?>>
                                            <?= date('F', mktime(0, 0, 0, $m, 1)) ?>
                                        </option>
                                    <?php endfor; ?>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-0">Cutoff</label>
                                <select name="period" class="form-select">
                                    <option value="first_half" <?= $selectedPeriod === 'first_half' ? 'selected' : '' ?>>1–15</option>
                                    <option value="second_half" <?= $selectedPeriod === 'second_half' ? 'selected' : '' ?>>16–<?= $periodLastDay ?></option>
                                </select>
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-secondary">Load</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <h2 class="h5">Submit DTR — <?= htmlspecialchars($periodMonthName, ENT_QUOTES) ?> <?= $selectedYear ?>, <?= $selectedPeriod === 'first_half' ? '1–15' : '16–' . $periodLastDay ?></h2>
                        <p class="text-muted small">
                            Just one photo of your entire DTR sheet for this period.
                            <strong>Leave Blank the text inputs if you are absent or have no duty.</strong>
                        </p>

                        <form method="post" enctype="multipart/form-data" action="dashboard#tab-submitbulk">
                            <?= csrf_field() ?>
                            <input type="hidden" name="action" value="submit_bulk">
                            <input type="hidden" name="year" value="<?= $selectedYear ?>">
                            <input type="hidden" name="month" value="<?= $selectedMonth ?>">
                            <input type="hidden" name="period" value="<?= htmlspecialchars($selectedPeriod, ENT_QUOTES) ?>">

                            <div class="mb-3">
                                <label class="form-label">DTR Picture(whole period)</label>
                                <input type="file" name="photo" class="form-control" accept="image/jpeg,image/png,image/webp" required>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                                <span class="badge bg-primary-subtle text-primary-emphasis fs-6" id="bulk-progress-badge">0 / <?= count($periodDates) ?> days filled</span>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="bulk-copy-all-btn">
                                    Copy First Day's Time to All Empty Days
                                </button>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle bulk-dtr-table">
                                    <thead><tr><th>Date</th><th>Time In</th><th>Time Out</th><th class="text-center">Hours</th></tr></thead>
                                    <tbody>
                                <?php foreach ($periodDates as $date):
                                    $dayLabel = date('D, M j', strtotime($date));
                                    $dow = (int)date('w', strtotime($date)); // 0 = Sunday, 6 = Saturday
                                    $isWeekend = ($dow === 0 || $dow === 6);
                                ?>
                                    <tr class="<?= $isWeekend ? 'bulk-weekend-row' : '' ?>">
                                        <td class="text-nowrap"><?= htmlspecialchars($dayLabel, ENT_QUOTES) ?></td>
                                        <td class="min-width-100">
                                            <input type="text" name="days[<?= $date ?>][time_in]" class="form-control form-control-sm time24 bulk-time-in" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                                        </td>
                                        <td class="min-width-100">
                                            <input type="text" name="days[<?= $date ?>][time_out]" class="form-control form-control-sm time24 bulk-time-out" placeholder="HH:MM" pattern="([01][0-9]|2[0-3]):[0-5][0-9]" maxlength="5" inputmode="numeric">
                                        </td>
                                        <td class="text-center min-width-70">
                                            <span class="badge bg-light text-muted bulk-row-hours">—</span>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                </tbody>
                                <tfoot>
                                    <tr class="table-light">
                                        <td colspan="3" class="text-end fw-semibold align-middle">Overall Hours:</td>
                                        <td class="text-center"><span id="bulk-overall-hours" class="badge bg-primary fs-6">0.00</span></td>
                                    </tr>
                                </tfoot>
                                </table>
                            </div>

                            <button type="submit" class="btn btn-primary mt-2">Submit All</button>
                        </form>
                    </div>
                </div>
            </div>
            <!-- END SUBMIT BULK TAB -->

            <!-- OT CASHOUT TAB -->
            <div class="tab-pane fade" id="tab-otcashout" role="tabpanel">
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card border-success">
                            <div class="card-header bg-success text-white fw-bold">Request OT Cashout</div>
                            <div class="card-body">
                                <p>You currently have <strong class="text-success fs-5"><?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?></strong> bankable Overtime hours available.</p>
                                
                                <?php if ($summary['ot'] > 0): ?>
                                <form method="post" action="dashboard#tab-otcashout" onsubmit="return confirm('Submit this request for Head SA approval?');">
                                    <?= csrf_field() ?>
                                    <input type="hidden" name="action" value="submit_ot_cashout">
                                    <input type="hidden" name="hours_requested" value="<?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?>">
                                    <div class="mb-2">
                                        <label class="form-label">Hours to Cashout</label>
                                        <input type="number" step="0.01" min="0.01" max="<?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?>" name="hours_display" id="cashoutInput" class="form-control" value="<?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?>" readonly>
                                    </div>
                                    <div class="alert alert-info py-2 small mb-3">
                                        This request will cash out your full bankable OT balance of <strong><?= htmlspecialchars((string)$summary['ot'], ENT_QUOTES) ?></strong> hrs.
                                    </div>
                                    <button type="submit" class="btn btn-success btn-loading w-100">Submit Request</button>
                                </form>
                                <?php else: ?>
                                <div class="alert alert-secondary">You do not have any bankable OT hours to cash out right now.</div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header fw-bold">My Cashout Requests</div>
                            <div class="card-body p-0">
                                <table class="table table-sm m-0">
                                    <thead><tr><th>Date</th><th>Hours</th><th>Status</th></tr></thead>
                                    <tbody>
                                        <?php 
                                        $myCashouts = get_sa_ot_cashouts(current_user_id());
                                        if (empty($myCashouts)): ?>
                                            <tr><td colspan="3" class="text-center text-muted py-3">No cashout requests yet.</td></tr>
                                        <?php else: foreach ($myCashouts as $c): ?>
                                            <tr>
                                                <td><?= htmlspecialchars(date('M d, Y h:i A', strtotime($c['requested_at'])), ENT_QUOTES) ?></td>
                                                <td><?= htmlspecialchars((string)$c['hours_requested'], ENT_QUOTES) ?></td>
                                                <td>
                                                    <?php if ($c['status'] === 'approved'): ?>
                                                        <span class="badge bg-success">Approved</span>
                                                    <?php elseif ($c['status'] === 'rejected'): ?>
                                                        <span class="badge bg-danger" title="<?= htmlspecialchars($c['rejection_reason'] ?? '', ENT_QUOTES) ?>">Rejected</span>
                                                    <?php else: ?>
                                                        <span class="badge bg-warning text-dark">Pending</span>
                                                    <?php endif; ?>
                                                </td>
                                            </tr>
                                        <?php endforeach; endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END OT CASHOUT TAB -->

        </div>