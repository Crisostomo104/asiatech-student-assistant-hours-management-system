<?php
declare(strict_types=1);

function env_value(string $name, ?string $default = null): ?string
{
    if (function_exists('getenv')) {
        $value = getenv($name);
        if ($value !== false) {
            return $value;
        }
    }

    if (isset($_ENV[$name]) && is_string($_ENV[$name])) {
        return $_ENV[$name];
    }

    if (isset($_SERVER[$name]) && is_string($_SERVER[$name])) {
        return $_SERVER[$name];
    }

    return $default;
}

function env_required(string $name): string
{
    $value = env_value($name);
    if ($value === null || $value === '') {
        throw new RuntimeException('Required environment variable is missing or empty: ' . $name);
    }

    return $value;
}

function load_env_file(string $path): void
{
    static $loadedPaths = [];
    $resolvedPath = realpath($path);

    if ($resolvedPath === false) {
        if (file_exists($path)) {
            throw new RuntimeException('The environment file is not accessible.');
        }
        return;
    }

    if (isset($loadedPaths[$resolvedPath])) {
        return;
    }

    if (!is_file($resolvedPath) || !is_readable($resolvedPath)) {
        throw new RuntimeException('The environment file is not readable.');
    }

    $lines = file($resolvedPath, FILE_IGNORE_NEW_LINES);
    if ($lines === false) {
        throw new RuntimeException('The environment file could not be read.');
    }

    foreach ($lines as $index => $line) {
        $line = trim($line);
        if ($line === '' || $line[0] === '#') {
            continue;
        }

        if (strpos($line, 'export ') === 0) {
            $line = ltrim(substr($line, 7));
        }

        $separator = strpos($line, '=');
        if ($separator === false) {
            throw new RuntimeException('Invalid environment file syntax on line ' . ($index + 1) . '.');
        }

        $name = trim(substr($line, 0, $separator));
        $value = trim(substr($line, $separator + 1));
        if (!preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/D', $name)) {
            throw new RuntimeException('Invalid environment variable name on line ' . ($index + 1) . '.');
        }

        if ($value !== '' && ($value[0] === '"' || $value[0] === "'")) {
            $quote = $value[0];
            if (strlen($value) < 2 || substr($value, -1) !== $quote) {
                throw new RuntimeException('Unclosed quoted value on line ' . ($index + 1) . '.');
            }
            $value = substr($value, 1, -1);
            if ($quote === '"') {
                $value = stripcslashes($value);
            }
        } else {
            $comment = strpos($value, ' #');
            if ($comment !== false) {
                $value = rtrim(substr($value, 0, $comment));
            }
        }

        if (env_value($name) !== null) {
            continue;
        }

        if (function_exists('putenv') && !putenv($name . '=' . $value)) {
            throw new RuntimeException('Unable to load environment variable: ' . $name);
        }
        $_ENV[$name] = $value;
        $_SERVER[$name] = $value;
    }

    $loadedPaths[$resolvedPath] = true;
}
