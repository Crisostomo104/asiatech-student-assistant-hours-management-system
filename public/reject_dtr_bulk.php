<?php
declare(strict_types=1);
http_response_code(410);
header('Content-Type: text/plain; charset=utf-8');
echo 'DTR review has been retired. Use the Annual Hours Summary to maintain official hours.';
