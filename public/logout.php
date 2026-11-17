<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/app.php';

logout_user();
header('Location: /sahms/login');
exit;
