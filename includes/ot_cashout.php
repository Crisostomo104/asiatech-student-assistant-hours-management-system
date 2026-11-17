<?php
declare(strict_types=1);

if (!function_exists('compute_net_hours')) {
    require_once __DIR__ . '/dtr.php';
}

/**
 * Calculates how many Overtime hours a Student Assistant currently has
 * available to be cashed out.
 * Bankable OT = (Total Approved Rendered Hours) - (Required Hours) - (Already Pending/Approved Cashouts)
 */
function get_sa_bankable_ot(int $userId): float
{
    $pdo = get_db();
    
    // 1. Required Hours
    $stmt = $pdo->prepare("SELECT required_hours FROM users WHERE user_id = :uid");
    $stmt->execute([':uid' => $userId]);
    $required = (float)$stmt->fetchColumn();

    // 2. Rendered (Approved) Hours
    $stmt2 = $pdo->prepare("SELECT time_in, time_out FROM dtr_entries WHERE user_id = :uid AND status = 'approved'");
    $stmt2->execute([':uid' => $userId]);
    $rendered = 0.0;
    foreach ($stmt2->fetchAll() as $row) {
        $rendered += compute_net_hours($row['time_in'], $row['time_out']) ?? 0.0;
    }

    // 3. Previously requested/approved cashouts
    $stmt3 = $pdo->prepare("SELECT SUM(hours_requested) FROM ot_cashouts WHERE user_id = :uid AND status IN ('pending', 'approved')");
    $stmt3->execute([':uid' => $userId]);
    $cashedOut = (float)$stmt3->fetchColumn();

    // 4. Advance Hours
    $stmt4 = $pdo->prepare("SELECT SUM(hours_requested) FROM ot_advances WHERE user_id = :uid AND status = 'approved'");
    $stmt4->execute([':uid' => $userId]);
    $advance = (float)$stmt4->fetchColumn();

    $bankable = ($rendered + $advance) - $required - $cashedOut;
    return max(0.0, round($bankable, 2));
}

function submit_ot_cashout(int $userId, float $hoursRequested): array
{
    if ($hoursRequested <= 0) {
        return ['ok' => false, 'error' => 'Invalid requested amount.'];
    }
    $bankable = get_sa_bankable_ot($userId);
    if (round($hoursRequested, 2) !== round($bankable, 2)) {
        return ['ok' => false, 'error' => 'Cashout must be for the full bankable OT amount.'];
    }

    $pdo = get_db();
    $stmt = $pdo->prepare(
        "INSERT INTO ot_cashouts (user_id, hours_requested, status) VALUES (:uid, :hours, 'pending')"
    );
    $stmt->execute([
        ':uid' => $userId,
        ':hours' => $hoursRequested
    ]);
    
    $cashoutId = (int)$pdo->lastInsertId();
    audit_log($userId, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', $cashoutId, ['hours' => $hoursRequested]);

    return ['ok' => true];
}

function get_sa_ot_cashouts(int $userId): array
{
    $pdo = get_db();
    $stmt = $pdo->prepare(
        "SELECT * FROM ot_cashouts WHERE user_id = :uid ORDER BY requested_at DESC"
    );
    $stmt->execute([':uid' => $userId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function get_pending_ot_cashouts(): array
{
    $pdo = get_db();
    $stmt = $pdo->query(
        "SELECT c.*, u.full_name, u.id_number 
         FROM ot_cashouts c 
         JOIN users u ON c.user_id = u.user_id 
         WHERE c.status = 'pending' 
         ORDER BY c.requested_at ASC"
    );
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function resolve_ot_cashout(int $cashoutId, int $headSaId, string $status, ?string $reason = null): array
{
    if (!in_array($status, ['approved', 'rejected'])) {
        return ['ok' => false, 'error' => 'Invalid status.'];
    }

    $pdo = get_db();
    $stmt = $pdo->prepare(
        "UPDATE ot_cashouts 
         SET status = :status, rejection_reason = :reason, resolved_by = :head_id, resolved_at = NOW() 
         WHERE cashout_id = :cid AND status = 'pending'"
    );
    $stmt->execute([
        ':status' => $status,
        ':reason' => $reason,
        ':head_id' => $headSaId,
        ':cid' => $cashoutId
    ]);

    if ($stmt->rowCount() === 0) {
        return ['ok' => false, 'error' => 'Cashout request not found or already resolved.'];
    }

    audit_log($headSaId, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', $cashoutId, ['status' => $status]);
    return ['ok' => true];
}

function set_ot_advance_hours(int $userId, float $hoursRequested, int $headSaId, int $year): bool
{
    $pdo = get_db();

    if ($hoursRequested <= 0) {
        $stmt = $pdo->prepare(
            "DELETE FROM ot_advances 
             WHERE user_id = :uid 
               AND status = 'approved' 
               AND YEAR(COALESCE(resolved_at, requested_at)) = :yr"
        );
        $success = $stmt->execute([':uid' => $userId, ':yr' => $year]);
        if ($success) {
            audit_log($headSaId, 'OT_ADVANCE_CLEARED', 'ot_advances', null, ['for_user_id' => $userId, 'year' => $year]);
        }
        return $success;
    }

    $pdo->prepare(
        "DELETE FROM ot_advances 
         WHERE user_id = :uid 
           AND status = 'approved' 
           AND YEAR(COALESCE(resolved_at, requested_at)) = :yr"
    )->execute([':uid' => $userId, ':yr' => $year]);

    $stmt = $pdo->prepare(
        "INSERT INTO ot_advances 
            (user_id, hours_requested, status, rejection_reason, requested_at, resolved_by, resolved_at) 
         VALUES 
            (:uid, :hours, 'approved', '', NOW(), :resolved_by, NOW())"
    );

    $success = $stmt->execute([
        ':uid' => $userId,
        ':hours' => $hoursRequested,
        ':resolved_by' => $headSaId,
    ]);
    if ($success) {
        audit_log($headSaId, 'OT_ADVANCE_APPROVED', 'ot_advances', null, ['for_user_id' => $userId, 'hours_requested' => $hoursRequested, 'year' => $year]);
    }

    return $success;
}

function get_all_ot_cashouts(): array
{
    $pdo = get_db();
    $stmt = $pdo->query(
        "SELECT c.*, u.full_name, u.id_number, r.full_name as resolved_by_name
         FROM ot_cashouts c 
         JOIN users u ON c.user_id = u.user_id 
         LEFT JOIN users r ON c.resolved_by = r.user_id
         ORDER BY c.requested_at DESC"
    );
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function generate_humanized_narrative_report(array $cashouts): string
{
    $totalRequests = count($cashouts);
    if ($totalRequests === 0) {
        return "There have been no Overtime Cashout requests recorded yet. All Student Assistants are currently operating within their standard required hours or have not requested to convert their excess hours.";
    }

    $approvedCount = 0;
    $rejectedCount = 0;
    $pendingCount = 0;
    $totalApprovedHours = 0.0;
    $totalRequestedHours = 0.0;

    foreach ($cashouts as $c) {
        $totalRequestedHours += (float)$c['hours_requested'];
        if ($c['status'] === 'approved') {
            $approvedCount++;
            $totalApprovedHours += (float)$c['hours_requested'];
        } elseif ($c['status'] === 'rejected') {
            $rejectedCount++;
        } else {
            $pendingCount++;
        }
    }

    $narrative = "As of " . date('F j, Y') . ", there have been a total of **{$totalRequests}** Overtime Cashout requests submitted by the Student Assistants, amounting to **" . number_format($totalRequestedHours, 2) . "** total requested hours. ";

    if ($approvedCount > 0) {
        $narrative .= "The administration has successfully approved **{$approvedCount}** of these requests, resulting in **" . number_format($totalApprovedHours, 2) . "** hours being authorized for cashout conversion. ";
    }

    if ($rejectedCount > 0) {
        $narrative .= "Meanwhile, **{$rejectedCount}** request(s) were declined upon review. ";
    }

    if ($pendingCount > 0) {
        $narrative .= "Currently, there are **{$pendingCount}** request(s) awaiting Head SA approval. ";
    } else {
        $narrative .= "There are currently no pending requests in the queue, indicating that all submissions have been addressed. ";
    }

    $narrative .= "This steady management of surplus hours ensures our Student Assistants are accurately compensated for their extended dedication beyond their required quota.";

    return $narrative;
}

function delete_ot_cashout(int $cashoutId, int $headSaId): array
{
    $pdo = get_db();
    
    $stmt = $pdo->prepare("SELECT * FROM ot_cashouts WHERE cashout_id = :cid");
    $stmt->execute([':cid' => $cashoutId]);
    $cashout = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$cashout) {
        return ['ok' => false, 'error' => 'Cashout request not found.'];
    }

    $delStmt = $pdo->prepare("DELETE FROM ot_cashouts WHERE cashout_id = :cid");
    $delStmt->execute([':cid' => $cashoutId]);

    audit_log($headSaId, 'OT_CASHOUT_DELETED', 'ot_cashouts', $cashoutId, [
        'was_for_user_id' => $cashout['user_id'],
        'hours_requested' => $cashout['hours_requested'],
        'status_before_delete' => $cashout['status']
    ]);

    return ['ok' => true];
}

function delete_all_ot_cashouts(int $headSaId): array
{
    $pdo = get_db();
    
    $stmt = $pdo->query("SELECT COUNT(*) FROM ot_cashouts");
    $count = (int)$stmt->fetchColumn();

    if ($count === 0) {
        return ['ok' => true];
    }

    $pdo->query("DELETE FROM ot_cashouts");

    audit_log($headSaId, 'ALL_OT_CASHOUTS_DELETED', 'ot_cashouts', 0, [
        'count_deleted' => $count
    ]);

    return ['ok' => true];
}
