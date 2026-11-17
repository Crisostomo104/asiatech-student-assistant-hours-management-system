<?php
/**
 * Append-only, hash-chained audit logging.
 *
 * Each row's row_hash = SHA-256(action|target_table|target_id|details|prev_hash).
 * Because each new row's prev_hash must match the previous row's row_hash,
 * altering or deleting any historical row breaks the chain -- which
 * verify_audit_chain() below can detect even if the DB user somehow
 * had write access outside the app (e.g. someone editing directly in
 * phpMyAdmin with an admin account).
 *
 * The application's own DB user (sahms_app) is granted INSERT + SELECT
 * only on audit_log -- see schema.sql setup notes -- so the app itself
 * cannot UPDATE or DELETE rows even if there were a bug.
 */

declare(strict_types=1);

function audit_log(?int $actorUserId, string $action, ?string $targetTable = null, ?int $targetId = null, array $details = []): void
{
    $pdo = get_db();

    $stmt = $pdo->prepare('SELECT row_hash FROM audit_log ORDER BY log_id DESC LIMIT 1');
    $stmt->execute();
    $prevHash = $stmt->fetchColumn();
    if ($prevHash === false) {
        $prevHash = str_repeat('0', 64); // should not happen; genesis row exists in schema.sql
    }

    $detailsJson = json_encode($details, JSON_UNESCAPED_SLASHES);
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'cli';

    $rowHash = hash('sha256', implode('|', [
        $action,
        $targetTable ?? '',
        (string)($targetId ?? ''),
        $detailsJson ?? '',
        $prevHash,
    ]));

    $insert = $pdo->prepare(
        'INSERT INTO audit_log (actor_user_id, action, target_table, target_id, details, ip_address, prev_hash, row_hash)
         VALUES (:actor, :action, :ttable, :tid, :details, :ip, :prev, :rowh)'
    );
    $insert->execute([
        ':actor'   => $actorUserId,
        ':action'  => $action,
        ':ttable'  => $targetTable,
        ':tid'     => $targetId,
        ':details' => $detailsJson,
        ':ip'      => $ip,
        ':prev'    => $prevHash,
        ':rowh'    => $rowHash,
    ]);
}

/**
 * Walks the entire chain and confirms every row_hash matches what it
 * should be given the row's own content and the previous row's hash.
 *
 * Returns ['ok' => true] if the chain is intact, or
 * ['ok' => false, 'broken_at_log_id' => int] at the first break found.
 *
 * (Returns a plain array on every path on purpose -- a standalone
 * `true` type in a return signature only works on PHP 8.2+, and most
 * XAMPP installs still run 8.0/8.1, where `true|array` throws a fatal
 * error at parse time. This avoids that entirely.)
 *
 * Run this periodically (e.g. a scheduled admin-only check page, or a cron job).
 */
function verify_audit_chain(): array
{
    try {
        $pdo = get_db();
        $stmt = $pdo->query('SELECT log_id, action, target_table, target_id, details, prev_hash, row_hash FROM audit_log ORDER BY log_id ASC');

        $expectedPrev = str_repeat('0', 64);

        while ($row = $stmt->fetch()) {
            if ($row['action'] === 'CHAIN_GENESIS') {
                $expectedPrev = $row['row_hash'];
                continue;
            }

            $computed = hash('sha256', implode('|', [
                $row['action'],
                $row['target_table'] ?? '',
                (string)($row['target_id'] ?? ''),
                $row['details'] ?? '',
                $expectedPrev,
            ]));

            if ($row['prev_hash'] !== $expectedPrev || $row['row_hash'] !== $computed) {
                return ['ok' => false, 'broken_at_log_id' => $row['log_id']];
            }

            $expectedPrev = $row['row_hash'];
        }

        return ['ok' => true];
    } catch (\Throwable $e) {
        return ['ok' => false, 'error' => $e->getMessage()];
    }
}

/**
 * Fetch the 100 most recent audit log entries for Head SA viewing.
 */
function get_recent_audit_logs(int $limit = 100): array
{
    try {
        $pdo = get_db();
        $stmt = $pdo->prepare('
            SELECT a.log_id, a.actor_user_id, a.action, a.target_table, a.target_id, 
                   a.details, a.ip_address, a.created_at, u.full_name as actor_name, u.role as actor_role
            FROM audit_log a
            LEFT JOIN users u ON a.actor_user_id = u.user_id
            ORDER BY a.log_id DESC
            LIMIT :limit
        ');
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll() ?: [];
    } catch (\Throwable $e) {
        return [];
    }
}


