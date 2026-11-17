<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';
require_login();

if (current_role() !== 'head_sa') {
    http_response_code(403);
    exit('Forbidden');
}

if (!class_exists('ZipArchive')) {
    http_response_code(500);
    exit('The PHP zip extension is not enabled on this server. Enable "extension=zip" in php.ini to use CSV backup.');
}

$pdo = get_db();
$tables = [];
$stmt = $pdo->query('SHOW TABLES');
while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
    $tables[] = $row[0];
}

// Build the zip in a temp file (ZipArchive needs a real file path, not
// a memory stream), then read it back out for download and delete it.
$tmpZipPath = tempnam(sys_get_temp_dir(), 'sahms_backup_');

$zip = new ZipArchive();
if ($zip->open($tmpZipPath, ZipArchive::OVERWRITE) !== true) {
    http_response_code(500);
    exit('Could not create backup archive.');
}

foreach ($tables as $table) {
    // Table/column names come from SHOW TABLES / the DB schema itself,
    // not user input, so it's safe to use them directly in the query
    // here (there's nothing external to sanitize against).
    $stmt = $pdo->query('SELECT * FROM `' . $table . '`');
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Write this table's rows to an in-memory CSV buffer.
    $csvHandle = fopen('php://temp', 'r+');

    if ($rows) {
        fputcsv($csvHandle, array_keys($rows[0])); // header row = column names
        foreach ($rows as $row) {
            // Convert null to empty string; everything else to string as-is.
            $csvRow = array_map(fn($v) => $v === null ? '' : (string)$v, $row);
            fputcsv($csvHandle, $csvRow);
        }
    } else {
        // Table has no rows -- still get the column names via DESCRIBE
        // so the CSV isn't completely empty/unlabeled.
        $colStmt = $pdo->query('SHOW COLUMNS FROM `' . $table . '`');
        $columns = array_column($colStmt->fetchAll(PDO::FETCH_ASSOC), 'Field');
        fputcsv($csvHandle, $columns);
    }

    rewind($csvHandle);
    $csvContent = stream_get_contents($csvHandle);
    fclose($csvHandle);

    $zip->addFromString($table . '.csv', $csvContent);
}

// Small readme inside the zip explaining what this is (and isn't).
$readme = "SAHMS Database Export (CSV)\n"
    . "Generated: " . date('Y-m-d H:i:s') . "\n\n"
    . "This is a per-table CSV export for viewing/editing in Excel or Google Sheets.\n"
    . "It is NOT a restorable database backup -- it does not include table\n"
    . "structure, relationships, or foreign keys. If you need a true restorable\n"
    . "backup for disaster recovery, use phpMyAdmin's Export feature (SQL format)\n"
    . "on the sahms database directly.\n";
$zip->addFromString('README.txt', $readme);

$zip->close();

header('Content-Type: application/zip');
header('Content-Disposition: attachment; filename=sahms_csv_export_' . date('Y-m-d_H-i-s') . '.zip');
header('Content-Length: ' . filesize($tmpZipPath));
readfile($tmpZipPath);

unlink($tmpZipPath);
exit;