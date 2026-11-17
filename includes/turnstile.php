<?php
declare(strict_types=1);

function turnstile_site_key(): string
{
    return trim(env_value('TURNSTILE_SITE_KEY', '') ?? '');
}

function turnstile_is_configured(): bool
{
    $secretKey = env_value('TURNSTILE_SECRET_KEY', '');
    return turnstile_site_key() !== '' && $secretKey !== null && trim($secretKey) !== '';
}

function verify_turnstile_request(): array
{
    $secretKey = env_value('TURNSTILE_SECRET_KEY', '');
    $token = $_POST['cf-turnstile-response'] ?? '';

    if ($secretKey === null || trim($secretKey) === '') {
        return ['ok' => false, 'error' => 'Security verification is unavailable right now. Please contact the system administrator.'];
    }

    if (!is_string($token) || trim($token) === '') {
        return ['ok' => false, 'error' => 'Please complete the security check above before continuing.'];
    }

    if (!function_exists('curl_init')) {
        error_log('Cloudflare Turnstile verification requires the PHP cURL extension.');
        return ['ok' => false, 'error' => 'Security verification is temporarily unavailable. Please contact the system administrator.'];
    }

    $payload = [
        'secret' => trim($secretKey),
        'response' => trim($token),
    ];
    if (!empty($_SERVER['REMOTE_ADDR'])) {
        $payload['remoteip'] = (string)$_SERVER['REMOTE_ADDR'];
    }

    $curl = curl_init('https://challenges.cloudflare.com/turnstile/v0/siteverify');
    curl_setopt_array($curl, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => http_build_query($payload),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CONNECTTIMEOUT => 3,
        CURLOPT_TIMEOUT => 6,
        CURLOPT_SSL_VERIFYPEER => true,
    ]);

    $response = curl_exec($curl);
    $status = (int)curl_getinfo($curl, CURLINFO_HTTP_CODE);
    $curlError = curl_error($curl);
    curl_close($curl);

    if (!is_string($response) || $status !== 200) {
        error_log('Cloudflare Turnstile request failed: HTTP ' . $status . ' ' . $curlError);
        return ['ok' => false, 'error' => 'Security verification is temporarily unavailable. Please try again.'];
    }

    $decoded = json_decode($response, true);
    if (!is_array($decoded) || !isset($decoded['success']) || $decoded['success'] !== true) {
        $errorCodes = [];
        if (is_array($decoded) && isset($decoded['error-codes']) && is_array($decoded['error-codes'])) {
            foreach ($decoded['error-codes'] as $errorCode) {
                if (is_string($errorCode) && preg_match('/^[a-z0-9_-]+$/i', $errorCode)) {
                    $errorCodes[] = $errorCode;
                }
            }
        }
        error_log('Cloudflare Turnstile verification rejected: ' . ($errorCodes ? implode(',', $errorCodes) : 'no error code returned'));
        return ['ok' => false, 'error' => 'The security check could not be verified. Please complete it again.'];
    }

    return ['ok' => true];
}
