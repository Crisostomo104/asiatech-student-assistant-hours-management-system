<?php
/**
 * Database connection (PDO, prepared statements only).
 * Never build SQL by string concatenation anywhere in this app --
 * always use ->prepare() with bound parameters.
 */

declare(strict_types=1);

require_once __DIR__ . '/env.php';
load_env_file(dirname(__DIR__) . DIRECTORY_SEPARATOR . '.env');

define('DB_HOST', env_required('DB_HOST'));
define('DB_NAME', env_required('DB_NAME'));
define('DB_USER', env_required('DB_USER'));
define('DB_PASS', env_required('DB_PASS'));

$dbPort = filter_var(env_value('DB_PORT', '3306'), FILTER_VALIDATE_INT, [
    'options' => ['min_range' => 1, 'max_range' => 65535],
]);
if ($dbPort === false) {
    throw new RuntimeException('DB_PORT must be between 1 and 65535.');
}
define('DB_PORT', $dbPort);

$dbCharset = env_value('DB_CHARSET', 'utf8mb4');
if ($dbCharset === null || $dbCharset === '') {
    throw new RuntimeException('DB_CHARSET cannot be empty.');
}
define('DB_CHARSET', $dbCharset);
function get_db(): PDO
{
    static $pdo = null;

    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false, // real prepared statements, not PHP-emulated
        ];

        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
            $pdo->exec("SET time_zone = '+08:00'");
        } catch (PDOException $e) {
            error_log('DB connection failed: ' . $e->getMessage());
            http_response_code(500);
            die('Database connection error. Please contact the administrator.');
        }
    }

    return $pdo;
}
