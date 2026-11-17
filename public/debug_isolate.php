<?php
// ============================================================
// TEMPORARY DEBUG FILE -- delete/replace once the real error is found.
// This deliberately wraps everything in try-catch and prints raw
// diagnostics, bypassing any custom error handling that might be
// suppressing the real message on the live server.
// ============================================================

ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);
header('Content-Type: text/plain'); // plain text so nothing gets swallowed by HTML rendering

echo "STEP 1: This line printed -- PHP itself is running fine.\n";

try {
    echo "STEP 2: About to require config/app.php...\n";
    require_once __DIR__ . '/../config/app.php';
    echo "STEP 3: config/app.php loaded OK.\n";

    require_once __DIR__ . '/../includes/dtr.php';
    echo "STEP 4: includes/dtr.php loaded OK.\n";

    require_login();
    echo "STEP 5: require_login() passed OK. Current role: " . current_role() . "\n";

    if (current_role() !== 'head_sa') {
        echo "STEP 6: Not head_sa -- this would normally exit with 403.\n";
        exit;
    }

    echo "STEP 6: function_exists('get_annual_hours_summary') = " . (function_exists('get_annual_hours_summary') ? 'YES' : 'NO -- THIS IS THE BUG') . "\n";

    if (function_exists('get_annual_hours_summary')) {
        $year = (int)($_GET['year'] ?? date('Y'));
        echo "STEP 7: Calling get_annual_hours_summary({$year})...\n";
        $report = get_annual_hours_summary($year);
        echo "STEP 8: Success! Got " . count($report) . " row(s) back.\n";
        if ($report) {
            echo "STEP 9: First row keys: " . implode(', ', array_keys($report[0])) . "\n";
        }
    }

    echo "\nALL STEPS PASSED. If you're seeing this, the export logic itself works --\n";
    echo "the 500 error may have been from something else (caching, a previous\n";
    echo "broken upload, etc). Try the real export file again.\n";

} catch (\Throwable $e) {
    echo "\n!!! CAUGHT ERROR !!!\n";
    echo "Type: " . get_class($e) . "\n";
    echo "Message: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . "\n";
    echo "Line: " . $e->getLine() . "\n";
    echo "\nStack trace:\n" . $e->getTraceAsString() . "\n";
}
