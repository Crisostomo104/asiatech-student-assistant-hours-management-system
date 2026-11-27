CREATE TABLE IF NOT EXISTS `sa_monthly_hours` (
  `summary_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `summary_year` smallint(5) UNSIGNED NOT NULL,
  `summary_month` tinyint(3) UNSIGNED NOT NULL,
  `total_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
  `ot_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`summary_id`),
  UNIQUE KEY `uq_sa_monthly_hours_user_year_month` (`user_id`, `summary_year`, `summary_month`),
  KEY `idx_sa_monthly_hours_year_month` (`summary_year`, `summary_month`),
  KEY `idx_sa_monthly_hours_updated_by` (`updated_by`),
  CONSTRAINT `chk_sa_monthly_hours_month` CHECK (`summary_month` BETWEEN 1 AND 12),
  CONSTRAINT `chk_sa_monthly_hours_values` CHECK (`total_hours` >= 0 AND `ot_hours` >= 0 AND `ot_hours` <= `total_hours`),
  CONSTRAINT `fk_sa_monthly_hours_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_sa_monthly_hours_editor` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
