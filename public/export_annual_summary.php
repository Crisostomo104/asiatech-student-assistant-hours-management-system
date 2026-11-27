<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/../includes/dtr.php';
require_login();

if (current_role() !== 'head_sa') {
    http_response_code(403);
    exit('Forbidden');
}

$year = (int)($_GET['year'] ?? date('Y'));
$report = get_annual_hours_summary($year);

$monthKeys = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
$monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
$columns = ['Name', 'Advance Hours'];
foreach ($monthLabels as $index => $monthLabel) {
    $monthEndDay = (int)date('t', mktime(0, 0, 0, $index + 1, 1, $year));
    $columns[] = $monthLabel . ' 1-15';
    $columns[] = $monthLabel . ' 16-' . $monthEndDay;
}
$columns = array_merge($columns, ['Remaining Hours', 'Total hrs', 'OT hrs']);

$csvHandle = fopen('php://temp', 'r+');
fputcsv($csvHandle, $columns);

$totAdvance = 0.0;
$monthFirstTotals = array_fill_keys($monthKeys, 0.0);
$monthSecondTotals = array_fill_keys($monthKeys, 0.0);
$totAll = $totOt = $totRemaining = 0.0;

foreach ($report as $row) {
    // DB values (DECIMAL columns) come back from PDO as strings, e.g.
    // "0.00" -- explicit (float) casts are required here because this
    // file has strict_types=1, which makes number_format() reject a
    // raw string argument (unlike the dashboard view, which doesn't
    // declare strict_types and so PHP auto-converts there).
    $advanceHrs = (float)$row['advance_hrs'];
    $totalHrs = (float)$row['total_hrs'];
    $otHrs = (float)$row['ot_hrs'];
    $setHours = (float)$row['set_hours'];

    $remaining = max($setHours - $totalHrs, 0);
    $remainingDisplay = ($remaining <= 0.005) ? 'Completed' : number_format($remaining, 1, '.', '');

    $csvRow = [$row['full_name'], number_format($advanceHrs, 2, '.', '')];
    foreach ($monthKeys as $monthKey) {
        $monthFirst = (float)($row[$monthKey . '_first'] ?? $row[$monthKey]);
        $monthSecond = (float)($row[$monthKey . '_second'] ?? 0);
        $csvRow[] = $monthFirst > 0 ? number_format($monthFirst, 1, '.', '') : '';
        $csvRow[] = $monthSecond > 0 ? number_format($monthSecond, 1, '.', '') : '';
        $monthFirstTotals[$monthKey] += $monthFirst;
        $monthSecondTotals[$monthKey] += $monthSecond;
    }
    $csvRow[] = $remainingDisplay;
    $csvRow[] = number_format($totalHrs, 1, '.', '');
    $csvRow[] = number_format($otHrs, 1, '.', '');
    fputcsv($csvHandle, $csvRow);

    $totAdvance += $advanceHrs;
    $totAll += $totalHrs; $totOt += $otHrs; $totRemaining += $remaining;
}

if ($report) {
    $totalRow = ['Total', number_format($totAdvance, 1, '.', '')];
    foreach ($monthKeys as $monthKey) {
        $totalRow[] = number_format($monthFirstTotals[$monthKey], 1, '.', '');
        $totalRow[] = number_format($monthSecondTotals[$monthKey], 1, '.', '');
    }
    $totalRow[] = number_format($totRemaining, 1, '.', '');
    $totalRow[] = number_format($totAll, 1, '.', '');
    $totalRow[] = number_format($totOt, 1, '.', '');
    fputcsv($csvHandle, $totalRow);
}

rewind($csvHandle);
$csvContent = stream_get_contents($csvHandle);
fclose($csvHandle);

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename=annual_hours_summary_' . $year . '.csv');
header('Content-Length: ' . strlen($csvContent));
echo $csvContent;
exit;