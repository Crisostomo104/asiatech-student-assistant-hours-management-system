<?php
declare(strict_types=1);

/**
 * Builds the annual summary for active SAs from monthly input rows. Approved
 * DTR totals remain a read-only fallback where monthly hours are not entered.
 */
function get_annual_hours_summary(int $year, ?int $userId = null): array
{
    $pdo = get_db();
    $monthKeys = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
    $legacyMonthSql = [];

    foreach ($monthKeys as $index => $key) {
        $month = $index + 1;
        $legacyMonthSql[] = "COALESCE(SUM(CASE WHEN MONTH(d.work_date) = {$month} THEN d.computed_hours ELSE 0 END), 0) AS legacy_{$key}";
    }

    $sql = "
        SELECT u.user_id, u.id_number, u.full_name, u.required_hours AS set_hours,
               COALESCE((
                   SELECT SUM(a.hours_requested)
                   FROM ot_advances a
                   WHERE a.user_id = u.user_id
                     AND a.status = 'approved'
                     AND YEAR(COALESCE(a.resolved_at, a.requested_at)) = :advance_year
               ), 0) AS advance_hrs,
               " . implode(",\n", $legacyMonthSql) . "
        FROM users u
        LEFT JOIN dtr_entries d
               ON d.user_id = u.user_id
              AND d.status = 'approved'
              AND YEAR(d.work_date) = :dtr_year
        WHERE u.role = 'student_assistant'
          AND u.is_active = 1
          AND (:user_filter IS NULL OR u.user_id = :user_id)
        GROUP BY u.user_id, u.id_number, u.full_name, u.required_hours
        ORDER BY u.full_name ASC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->bindValue(':advance_year', $year, PDO::PARAM_INT);
    $stmt->bindValue(':dtr_year', $year, PDO::PARAM_INT);
    if ($userId === null) {
        $stmt->bindValue(':user_filter', null, PDO::PARAM_NULL);
        $stmt->bindValue(':user_id', 0, PDO::PARAM_INT);
    } else {
        $stmt->bindValue(':user_filter', $userId, PDO::PARAM_INT);
        $stmt->bindValue(':user_id', $userId, PDO::PARAM_INT);
    }
    $stmt->execute();
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $manualSql = 'SELECT user_id, summary_month, total_hours, ot_hours
                  FROM sa_monthly_hours WHERE summary_year = :summary_year';
    if ($userId !== null) {
        $manualSql .= ' AND user_id = :user_id';
    }
    $manualStmt = $pdo->prepare($manualSql);
    $manualStmt->bindValue(':summary_year', $year, PDO::PARAM_INT);
    if ($userId !== null) {
        $manualStmt->bindValue(':user_id', $userId, PDO::PARAM_INT);
    }
    $manualStmt->execute();

    $manualByUser = [];
    foreach ($manualStmt->fetchAll(PDO::FETCH_ASSOC) as $entry) {
        $manualByUser[(int)$entry['user_id']][(int)$entry['summary_month']] = [
            'total_hours' => (float)$entry['total_hours'],
            'ot_hours' => (float)$entry['ot_hours'],
        ];
    }

    foreach ($rows as &$row) {
        $uid = (int)$row['user_id'];
        $hasManualHours = isset($manualByUser[$uid]);
        $totalHours = 0.0;
        $legacyHours = 0.0;
        $manualOtHours = 0.0;

        foreach ($monthKeys as $index => $key) {
            $month = $index + 1;
            $legacyValue = (float)$row['legacy_' . $key];
            $legacyHours += $legacyValue;

            if (isset($manualByUser[$uid][$month])) {
                $row[$key] = $manualByUser[$uid][$month]['total_hours'];
                $row[$key . '_ot'] = $manualByUser[$uid][$month]['ot_hours'];
                $manualOtHours += $row[$key . '_ot'];
            } else {
                $row[$key] = $legacyValue;
                $row[$key . '_ot'] = 0.0;
            }
            $totalHours += (float)$row[$key];
        }

        $advanceHours = (float)$row['advance_hrs'];
        $requiredHours = (float)$row['set_hours'];
        $row['has_manual_hours'] = $hasManualHours;
        $row['total_hrs'] = round($totalHours + $advanceHours, 2);
        $row['ot_hrs'] = round(
            $hasManualHours
                ? $manualOtHours
                : max(0, $legacyHours + $advanceHours - $requiredHours),
            2
        );
        $row['remaining_hrs'] = round(max(0, $requiredHours - $row['total_hrs']), 2);
    }
    unset($row);

    return $rows;
}

/**
 * Saves the editable Jan-Dec totals and their OT portions in one transaction.
 * The monthly total includes the OT portion.
 */
function save_monthly_hours_summary(
    int $actorUserId,
    int $year,
    array $hoursByUser,
    array $otByUser
): array {
    if ($year < 2000 || $year > 2100) {
        return ['ok' => false, 'error' => 'Select a valid summary year.'];
    }

    if (!$hoursByUser) {
        return ['ok' => false, 'error' => 'No monthly hours were submitted.'];
    }

    $pdo = get_db();
    $userCheck = $pdo->prepare(
        "SELECT user_id FROM users WHERE user_id = :user_id AND role = 'student_assistant'"
    );
    $upsert = $pdo->prepare(
        'INSERT INTO sa_monthly_hours
            (user_id, summary_year, summary_month, total_hours, ot_hours, updated_by)
         VALUES
            (:user_id, :summary_year, :summary_month, :total_hours, :ot_hours, :updated_by)
         ON DUPLICATE KEY UPDATE
            total_hours = VALUES(total_hours),
            ot_hours = VALUES(ot_hours),
            updated_by = VALUES(updated_by),
            updated_at = CURRENT_TIMESTAMP'
    );

    $validatedRows = [];
    foreach ($hoursByUser as $rawUserId => $monthlyValues) {
        $userId = filter_var($rawUserId, FILTER_VALIDATE_INT);
        if ($userId === false || $userId < 1 || !is_array($monthlyValues)) {
            return ['ok' => false, 'error' => 'Invalid Student Assistant entry in the summary.'];
        }

        $userCheck->execute([':user_id' => $userId]);
        if (!$userCheck->fetchColumn()) {
            return ['ok' => false, 'error' => 'A selected Student Assistant no longer exists. Reload the summary and try again.'];
        }

        for ($month = 1; $month <= 12; $month++) {
            $rawHours = trim((string)($monthlyValues[$month] ?? ''));
            $rawOt = trim((string)($otByUser[$userId][$month] ?? '0'));
            $rawHours = str_replace(',', '.', $rawHours);
            $rawOt = str_replace(',', '.', $rawOt);

            if ($rawHours === '' || !is_numeric($rawHours) || !is_numeric($rawOt)) {
                return ['ok' => false, 'error' => "Enter valid total and OT hours for SA #{$userId}, month {$month}."];
            }

            $totalHours = (float)$rawHours;
            $otHours = (float)$rawOt;
            if (!is_finite($totalHours) || !is_finite($otHours)
                || $totalHours < 0 || $otHours < 0 || $otHours > $totalHours
                || $totalHours > 99999.99 || $otHours > 99999.99) {
                return ['ok' => false, 'error' => "Hours are outside the allowed range for SA #{$userId}, month {$month}."];
            }

            $validatedRows[] = [
                'user_id' => $userId,
                'summary_year' => $year,
                'summary_month' => $month,
                'total_hours' => number_format($totalHours, 2, '.', ''),
                'ot_hours' => number_format($otHours, 2, '.', ''),
                'updated_by' => $actorUserId,
            ];
        }
    }

    try {
        $pdo->beginTransaction();
        foreach ($validatedRows as $row) {
            $upsert->execute($row);
        }
        $pdo->commit();
    } catch (PDOException $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        error_log('Monthly hours save failed: ' . $e->getMessage());
        return ['ok' => false, 'error' => 'Could not save the Annual Hours Summary. Please try again.'];
    }

    audit_log($actorUserId, 'ANNUAL_HOURS_SUMMARY_SAVED', 'sa_monthly_hours', null, [
        'year' => $year,
        'rows' => count($validatedRows),
    ]);

    return ['ok' => true];
}
