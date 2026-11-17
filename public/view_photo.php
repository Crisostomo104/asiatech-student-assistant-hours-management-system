<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';
require_once __DIR__ . '/../includes/dtr.php';

require_login();

$dtrId = (int)($_GET['dtr_id'] ?? 0);
$entry = get_dtr_entry($dtrId);

if (!$entry || empty($entry['photo_path'])) {
    http_response_code(404);
    die('Photo not found.');
}

if (!can_view_dtr_photo($dtrId, current_user_id(), current_role())) {
    audit_log(current_user_id(), 'DTR_PHOTO_ACCESS_DENIED', 'dtr_entries', $dtrId);
    http_response_code(403);
    die('You do not have permission to view this photo.');
}

// photo_path is always a random server-generated filename (see store_dtr_photo()
// in includes/dtr.php) -- never derived from user input -- so this basename()
// call is just defense in depth against path traversal, not the primary control.
$safeFilename = basename($entry['photo_path']);
$fullPath = DTR_PHOTO_STORAGE_DIR . '/' . $safeFilename;

if (!is_file($fullPath)) {
    http_response_code(404);
    die('Photo file missing on server.');
}

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $fullPath);
finfo_close($finfo);

header('Content-Type: ' . $mime);
header('Content-Length: ' . filesize($fullPath));
header('Cache-Control: private, max-age=0, no-store');
header('X-Content-Type-Options: nosniff');
readfile($fullPath);
exit;
