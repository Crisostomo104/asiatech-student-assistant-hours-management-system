-- SAHMS: split each month's manual hours into two 15-day periods.
-- Run AFTER 20261117_create_sa_monthly_hours.sql on existing installations.
--
-- total_hours remains the month total (first half + second half) so every
-- existing report that reads the month total keeps the same numbers.
-- Existing OT values stay in ot_hours; they are also seeded into the second
-- half so first + second still equals the old month total.

ALTER TABLE `sa_monthly_hours`
  ADD COLUMN `first_half_hours` decimal(7,2) NOT NULL DEFAULT 0.00 AFTER `total_hours`,
  ADD COLUMN `second_half_hours` decimal(7,2) NOT NULL DEFAULT 0.00 AFTER `first_half_hours`;

UPDATE `sa_monthly_hours`
SET `first_half_hours` = GREATEST(`total_hours` - `ot_hours`, 0),
    `second_half_hours` = LEAST(`ot_hours`, `total_hours`);
