<?php
// This file exists only so that visiting the bare folder
// (e.g. http://localhost/sahms/) sends people to the real login
// page instead of showing a directory listing or 404. The ACTUAL
// login page and its logic live in public/login.php -- that is the
// single source of truth. Do not duplicate login logic here.
declare(strict_types=1);
header('Location: dashboard.php');
exit;