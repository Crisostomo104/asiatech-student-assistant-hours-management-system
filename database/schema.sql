-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql208.infinityfree.com
-- Generation Time: Jul 27, 2026 at 10:21 PM
-- Server version: 11.4.12-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_42459223_sahms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `app_settings`
--

CREATE TABLE `app_settings` (
  `setting_key` varchar(100) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `app_settings`
--

INSERT INTO `app_settings` (`setting_key`, `setting_value`, `updated_by`, `updated_at`) VALUES
('break_deduction_threshold_hours', '8', 2, '2026-07-19 05:53:53'),
('deactivation_review_months', '12', 2, '2026-07-19 05:53:53'),
('default_required_hours', '486', 2, '2026-07-21 18:05:16'),
('login_lockout_window_minutes', '15', 2, '2026-07-19 05:53:53'),
('login_max_attempts', '5', 2, '2026-07-19 05:53:53'),
('max_photo_upload_mb', '5', 2, '2026-07-19 05:53:53'),
('session_timeout_minutes', '15', 2, '2026-07-19 05:53:53');

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `actor_user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `target_table` varchar(64) DEFAULT NULL,
  `target_id` int(10) UNSIGNED DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `prev_hash` char(64) NOT NULL,
  `row_hash` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(1, NULL, 'CHAIN_GENESIS', NULL, NULL, 'Audit chain initialized', NULL, '0000000000000000000000000000000000000000000000000000000000000000', '6f024aa91ff27710d1416541c95bd29be63c36f5b9f3aad01d409989d3208447', '2026-07-16 10:25:28'),
(2, 1, 'USER_REGISTERED', 'users', 1, '{\"role\":\"student_assistant\"}', '::1', '6f024aa91ff27710d1416541c95bd29be63c36f5b9f3aad01d409989d3208447', '3759d5529e417900da2cfb6096a9b8044d65b8b6dcb47b6fa3933ad4c9267418', '2026-07-17 01:01:29'),
(3, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '3759d5529e417900da2cfb6096a9b8044d65b8b6dcb47b6fa3933ad4c9267418', 'dc8e5c6cd5ddfdca025bb8fbea84bc028e92dc107b52ddb86e8ac14c0fb4b221', '2026-07-17 01:03:56'),
(4, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'dc8e5c6cd5ddfdca025bb8fbea84bc028e92dc107b52ddb86e8ac14c0fb4b221', '819a45977c2dbbee1526a00f2643b79a0ae6e041e1d015e80cb8ba833e7dfd08', '2026-07-17 01:04:58'),
(5, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '819a45977c2dbbee1526a00f2643b79a0ae6e041e1d015e80cb8ba833e7dfd08', '35e9fff2ab00f6027959e6471550f7ab85aec5a0e8ea1563332af1af5fe7dd05', '2026-07-17 01:06:36'),
(6, 2, 'USER_REGISTERED', 'users', 2, '{\"role\":\"student_assistant\"}', '::1', '35e9fff2ab00f6027959e6471550f7ab85aec5a0e8ea1563332af1af5fe7dd05', '063dfb256dae7947e78ab1f3e360e610836ff8dc65f63f80a0573fad5ce8206a', '2026-07-17 01:08:51'),
(7, 1, 'LOGOUT', 'users', 1, '[]', '::1', '063dfb256dae7947e78ab1f3e360e610836ff8dc65f63f80a0573fad5ce8206a', '27c66c11051ea224bbb0ded98766f7ee4339a820ec9d1bd37587625ddaf975e8', '2026-07-17 01:09:37'),
(8, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '27c66c11051ea224bbb0ded98766f7ee4339a820ec9d1bd37587625ddaf975e8', 'd294ea34921ed02c239759fb975d095e47712de464a06f566ea1e27652c5855c', '2026-07-17 01:09:42'),
(9, 1, 'DTR_CLOCK_IN', 'dtr_entries', 1, '{\"time_in\":\"2026-07-17 09:09:43\"}', '::1', 'd294ea34921ed02c239759fb975d095e47712de464a06f566ea1e27652c5855c', '04686099860be0a21e9bb03fc14b5bc941815885958d25ceb708e59743f865da', '2026-07-17 01:09:43'),
(10, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '04686099860be0a21e9bb03fc14b5bc941815885958d25ceb708e59743f865da', 'ee6c1ad39d5421d0566e27caff8333debe73dd565b4554b8be49b1b6d46ca391', '2026-07-17 01:09:53'),
(11, 1, 'DTR_CLOCK_OUT', 'dtr_entries', 1, '{\"time_out\":\"2026-07-17 09:09:57\",\"hours\":0}', '::1', 'ee6c1ad39d5421d0566e27caff8333debe73dd565b4554b8be49b1b6d46ca391', '9a68772025bd1e5968b42753a1465ad08f3eb1ac0e9e19b1f1420ea5aeefa821', '2026-07-17 01:09:57'),
(12, 1, 'DTR_CLOCK_IN', 'dtr_entries', 2, '{\"time_in\":\"2026-07-17 09:12:02\"}', '::1', '9a68772025bd1e5968b42753a1465ad08f3eb1ac0e9e19b1f1420ea5aeefa821', '0a9071d8bb156d6d3b250937cf9c4c87fb2653ead19e27e9f24ebef1c01b714d', '2026-07-17 01:12:02'),
(13, 1, 'DTR_CLOCK_OUT', 'dtr_entries', 2, '{\"time_out\":\"2026-07-17 09:12:04\",\"hours\":0}', '::1', '0a9071d8bb156d6d3b250937cf9c4c87fb2653ead19e27e9f24ebef1c01b714d', 'e6a6f06a7017aaac950f12248d2cf0020415e1ae75cb4d4acf7ac8a800b001e8', '2026-07-17 01:12:04'),
(14, 2, 'DTR_APPROVE', 'dtr_entries', 1, '{\"new_status\":\"approved\"}', '::1', 'e6a6f06a7017aaac950f12248d2cf0020415e1ae75cb4d4acf7ac8a800b001e8', 'f6bd9dab2affa795a3e0624c15515d3b82645f7c89eea9819a2bf22db115dde7', '2026-07-17 01:12:15'),
(15, 2, 'DTR_APPROVE', 'dtr_entries', 1, '{\"new_status\":\"approved\"}', '::1', 'f6bd9dab2affa795a3e0624c15515d3b82645f7c89eea9819a2bf22db115dde7', '4ad0403de92b92c9d0c7c447a39a646f1985c3e0d8fa7c8bf7c6a72fcf5e6368', '2026-07-17 01:12:18'),
(16, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '4ad0403de92b92c9d0c7c447a39a646f1985c3e0d8fa7c8bf7c6a72fcf5e6368', '9095de7c503ed71401ddf1f3efbdfaf69ab10e22484697fd9cb62a7617ebc593', '2026-07-17 01:54:53'),
(17, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '9095de7c503ed71401ddf1f3efbdfaf69ab10e22484697fd9cb62a7617ebc593', '54147663a62872cc60073e58f9c57c82eeaa00061e178b73e39fae8475aa2699', '2026-07-17 01:57:09'),
(18, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 2, '{\"was_for_user_id\":1,\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 09:12:02\",\"time_out\":\"2026-07-17 09:12:04\"}', '::1', '54147663a62872cc60073e58f9c57c82eeaa00061e178b73e39fae8475aa2699', '1f4ee22afc0855558e8086aa68ce289aa754a36c31afef28ba86636d93c159a8', '2026-07-17 02:04:30'),
(19, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 08:23:00\",\"time_out\":\"2026-07-17 09:09:00\"}', '::1', '1f4ee22afc0855558e8086aa68ce289aa754a36c31afef28ba86636d93c159a8', 'f60c7e37ba414fd7d0faf2ec488085e2d090f77e85fcb314a29d58902b7e5301', '2026-07-17 02:04:51'),
(20, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 08:23:00\",\"time_out\":\"2026-07-17 21:01:00\"}', '::1', 'f60c7e37ba414fd7d0faf2ec488085e2d090f77e85fcb314a29d58902b7e5301', 'f0f5be382a2b01ff4103b9f42697533331a9611977d77f8420f483218c99a9a5', '2026-07-17 02:05:05'),
(21, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 08:23:00\",\"time_out\":\"2026-07-17 21:01:00\"}', '::1', 'f0f5be382a2b01ff4103b9f42697533331a9611977d77f8420f483218c99a9a5', '1be205d3f904179fd5188889e546659b193be0b1501a360955964c58b736f755', '2026-07-17 02:05:19'),
(22, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', '1be205d3f904179fd5188889e546659b193be0b1501a360955964c58b736f755', 'b9ee46a1c2e662a1750118c67e04b6e0040987059451af3ee4e08b94d3d56363', '2026-07-17 02:10:08'),
(23, 2, 'DTR_ENTRY_ADDED', 'dtr_entries', 3, '{\"for_user_id\":1,\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', 'b9ee46a1c2e662a1750118c67e04b6e0040987059451af3ee4e08b94d3d56363', '3107e16fcd9841a2256305c0344384418015ce4d4a5364fc4db8aa21c50bcbc8', '2026-07-17 02:11:06'),
(24, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', '3107e16fcd9841a2256305c0344384418015ce4d4a5364fc4db8aa21c50bcbc8', '0ab62e7cf4997704f24e716bf4d2ee9945a6f388e295ce55972caaea3fd9392b', '2026-07-17 02:11:09'),
(25, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', '0ab62e7cf4997704f24e716bf4d2ee9945a6f388e295ce55972caaea3fd9392b', 'a923072f105679cc7d0efb2a715d83ec53395e6dc570cc95d3276af4d8d50a11', '2026-07-17 02:11:45'),
(26, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'a923072f105679cc7d0efb2a715d83ec53395e6dc570cc95d3276af4d8d50a11', 'ce39a19ce7a1ffff9b00f0e7920927cfa150cbe9925e45d58d8014746f7d8a06', '2026-07-17 03:00:18'),
(27, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'ce39a19ce7a1ffff9b00f0e7920927cfa150cbe9925e45d58d8014746f7d8a06', 'a3b757554296ae603f9abbd420c11a4f7e08a9c540df53cd6cd366eb000fc7ff', '2026-07-17 03:04:05'),
(28, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', 'a3b757554296ae603f9abbd420c11a4f7e08a9c540df53cd6cd366eb000fc7ff', 'd3aa485dcde3e83e6a3dafa5b563b79b4a16b6d3c4343960da7f4e875cf1f293', '2026-07-17 03:06:45'),
(29, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 1, '{\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', 'd3aa485dcde3e83e6a3dafa5b563b79b4a16b6d3c4343960da7f4e875cf1f293', '66994b8dc6a30f261328bf4c58c6b68ac4f45c035df46320536e84a500fca27f', '2026-07-17 03:06:48'),
(30, 1, 'LOGOUT', 'users', 1, '[]', '::1', '66994b8dc6a30f261328bf4c58c6b68ac4f45c035df46320536e84a500fca27f', '39433fefd7bafe95aea7a003f4fabc3ff181d886feb8f9b5e2c0fb9d0bd1052b', '2026-07-17 03:10:08'),
(31, 3, 'USER_REGISTERED', 'users', 3, '{\"role\":\"student_assistant\"}', '::1', '39433fefd7bafe95aea7a003f4fabc3ff181d886feb8f9b5e2c0fb9d0bd1052b', '115684533ed23e5d735f4de612eeec25c99c9b258a1be1417ec5826bc1dcadd9', '2026-07-17 03:20:16'),
(32, 2, 'DTR_ENTRY_ADDED', 'dtr_entries', 4, '{\"for_user_id\":3,\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:52:00\",\"time_out\":\"2026-07-16 21:54:00\"}', '::1', '115684533ed23e5d735f4de612eeec25c99c9b258a1be1417ec5826bc1dcadd9', '61e832c64039ce1aeaf30c0068941d68f929b90021ad492cecfaa00fcd3f5784', '2026-07-17 03:23:01'),
(33, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '61e832c64039ce1aeaf30c0068941d68f929b90021ad492cecfaa00fcd3f5784', 'ff4bb093964dc818b42fd51feb50fc6366a3e7d14ffdb9deeaa3d00bcc414f47', '2026-07-17 07:48:35'),
(34, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210253\"}', '::1', 'ff4bb093964dc818b42fd51feb50fc6366a3e7d14ffdb9deeaa3d00bcc414f47', 'd1186a237a41613315e189e176e743bc83fd91b88753b09f749d7c34bd4d9abe', '2026-07-17 07:48:44'),
(35, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'd1186a237a41613315e189e176e743bc83fd91b88753b09f749d7c34bd4d9abe', '5fd588f3ca6b9b63755d11e61dfcf2fbe0e74ad9745220ef96d20a9fb1ad74db', '2026-07-17 07:48:54'),
(36, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '5fd588f3ca6b9b63755d11e61dfcf2fbe0e74ad9745220ef96d20a9fb1ad74db', 'eac97597d2babc3c2e0dc1c8cbbe3944a888e0aee626f6a19958ea8c19ec5efc', '2026-07-17 08:00:09'),
(37, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '::1', 'eac97597d2babc3c2e0dc1c8cbbe3944a888e0aee626f6a19958ea8c19ec5efc', 'be7ab73d708d92be73fa0834c94dcc945d7065d3546608e35887bfc584a5a5d4', '2026-07-18 03:03:59'),
(38, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'be7ab73d708d92be73fa0834c94dcc945d7065d3546608e35887bfc584a5a5d4', '8c3f0dbd58e32540fbc86ee01200d988624374100e836e3dfb9fade8e58fa294', '2026-07-18 03:04:10'),
(39, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', '8c3f0dbd58e32540fbc86ee01200d988624374100e836e3dfb9fade8e58fa294', 'ca07ffbd46a5c4f71466859206809a7966ebc957c78962730dce5579cfabc8b8', '2026-07-18 03:49:31'),
(40, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', 'ca07ffbd46a5c4f71466859206809a7966ebc957c78962730dce5579cfabc8b8', '2d77aca78ce9fb0ad05543cad9e1a70ee53acf7b7ad33ea1096025ebcb2f6887', '2026-07-18 03:49:49'),
(41, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', '2d77aca78ce9fb0ad05543cad9e1a70ee53acf7b7ad33ea1096025ebcb2f6887', 'd15f110a8d2b1d5c2269604f596dc34ea11f94003455317d1d0a65846d8d3fd7', '2026-07-18 03:50:10'),
(42, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', 'd15f110a8d2b1d5c2269604f596dc34ea11f94003455317d1d0a65846d8d3fd7', '040f780ad9ec902f6b187a18918c8e89abb239726d973fa81b6fbcc584dfc05b', '2026-07-18 03:50:20'),
(43, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', '040f780ad9ec902f6b187a18918c8e89abb239726d973fa81b6fbcc584dfc05b', 'ed73736665e1db9d20489dfd50d1a21fa7b0bddc5536cd315ef95a014d9b41a4', '2026-07-18 03:50:31'),
(44, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'ed73736665e1db9d20489dfd50d1a21fa7b0bddc5536cd315ef95a014d9b41a4', '894755fdd320b96bbe439853390cb7e103f5ed4d77afe6a3e85eb098de938cc3', '2026-07-18 03:50:57'),
(45, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '894755fdd320b96bbe439853390cb7e103f5ed4d77afe6a3e85eb098de938cc3', '334448d7bd6d928b177d15df313223dd4dbafba663c7f50d102bfef4411c23ef', '2026-07-18 05:00:44'),
(46, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', '334448d7bd6d928b177d15df313223dd4dbafba663c7f50d102bfef4411c23ef', '8457ccd04fcd4c5fd88ac19f8a541ba8a2417a443f5726e80a8cf503e5bf1b98', '2026-07-19 03:22:38'),
(47, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"raffylorico@example.com\"}', '::1', '8457ccd04fcd4c5fd88ac19f8a541ba8a2417a443f5726e80a8cf503e5bf1b98', 'a50a82bec31a3ae379da435d4044dc07fd4b38671cb9464cbe4a37b4042ab698', '2026-07-19 03:22:48'),
(48, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'a50a82bec31a3ae379da435d4044dc07fd4b38671cb9464cbe4a37b4042ab698', 'be639c271c28ec97d119b0a251fd33c80317a77bdfe9ef5fb949b6e5bdea1d08', '2026-07-19 03:22:55'),
(49, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'be639c271c28ec97d119b0a251fd33c80317a77bdfe9ef5fb949b6e5bdea1d08', 'ad08301d98d023721832bc24bc2e6ae0274d29ff26699004d2217acc682d0532', '2026-07-19 03:33:46'),
(50, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'ad08301d98d023721832bc24bc2e6ae0274d29ff26699004d2217acc682d0532', '79f681e88edc18f732ee2940bceede68de54cc350880281fd987158153a5230c', '2026-07-19 03:33:57'),
(51, 2, 'LOGOUT', 'users', 2, '[]', '::1', '79f681e88edc18f732ee2940bceede68de54cc350880281fd987158153a5230c', '47a35e0636c0097e705d9580c27fb9444cadac3ea2666ee3e5707349f9c328b5', '2026-07-19 03:34:09'),
(52, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '47a35e0636c0097e705d9580c27fb9444cadac3ea2666ee3e5707349f9c328b5', '5471ed241726e79c0bd445c158b9e1d86858b98633ca7974483774e17bbfd3cf', '2026-07-19 03:34:15'),
(53, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '5471ed241726e79c0bd445c158b9e1d86858b98633ca7974483774e17bbfd3cf', '512d28c57f3ea63d5a097142a24662738ccecf22167f3816cba4136242abf96d', '2026-07-19 04:00:53'),
(54, 2, 'LOGOUT', 'users', 2, '[]', '::1', '512d28c57f3ea63d5a097142a24662738ccecf22167f3816cba4136242abf96d', 'b236ccd0904656d894dcf172fc17715c89a33744bc8676bda2b3bd525c556237', '2026-07-19 04:01:48'),
(55, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'b236ccd0904656d894dcf172fc17715c89a33744bc8676bda2b3bd525c556237', 'b4ae393997f107b82cfa98124241914b53b0582b0888efff4167faf3b48390e9', '2026-07-19 04:04:40'),
(56, 2, 'LOGOUT', 'users', 2, '[]', '::1', 'b4ae393997f107b82cfa98124241914b53b0582b0888efff4167faf3b48390e9', 'fd0caec805e594fc337a0e8a9ced7a7b088be129cb651c2faa7679ecbb009829', '2026-07-19 04:09:18'),
(57, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210253f\"}', '::1', 'fd0caec805e594fc337a0e8a9ced7a7b088be129cb651c2faa7679ecbb009829', 'ee8acba8b2cdf4cbd8ef3c5b4604938780cdc17c77301b164edb765b9dec9f14', '2026-07-19 04:09:41'),
(58, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210253f\"}', '::1', 'ee8acba8b2cdf4cbd8ef3c5b4604938780cdc17c77301b164edb765b9dec9f14', 'db7d4efc22a48968f00529fce3049d2782694058362c2d4c2b69b927142f7225', '2026-07-19 04:09:48'),
(59, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210213A\"}', '::1', 'db7d4efc22a48968f00529fce3049d2782694058362c2d4c2b69b927142f7225', '120ee0afa5df61297af0ec6d73d89d8f7e471233618ef4f9de8842950fba6000', '2026-07-19 04:10:03'),
(60, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210213A\"}', '::1', '120ee0afa5df61297af0ec6d73d89d8f7e471233618ef4f9de8842950fba6000', '3c6602aecc28bf40c5fee4319b52f76f12eaef4d76880b6e8e8612c93a5b0da2', '2026-07-19 04:10:13'),
(61, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '3c6602aecc28bf40c5fee4319b52f76f12eaef4d76880b6e8e8612c93a5b0da2', '51cf94a77bd85ee527385ef43881bb3207b614de0647212f6ccac879613b5ed7', '2026-07-19 04:10:19'),
(62, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '51cf94a77bd85ee527385ef43881bb3207b614de0647212f6ccac879613b5ed7', '0dfee216c9c73f05e5e210da83860ceb924ebdb28b80d1093d1483f1967461bc', '2026-07-19 04:11:37'),
(63, 1, 'LOGOUT', 'users', 1, '[]', '::1', '0dfee216c9c73f05e5e210da83860ceb924ebdb28b80d1093d1483f1967461bc', '19ea4fb1f7ef9aa14a0167b57a2f4ddf96f094bc933464950f79d0b82d49841c', '2026-07-19 04:13:03'),
(64, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '19ea4fb1f7ef9aa14a0167b57a2f4ddf96f094bc933464950f79d0b82d49841c', 'db4a1b39e6d838ea9b9c9ea9b30821ac0fb2d85a4e4ec9340bc801fe9c274c25', '2026-07-19 04:17:28'),
(65, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'db4a1b39e6d838ea9b9c9ea9b30821ac0fb2d85a4e4ec9340bc801fe9c274c25', 'b53741afac6df54b1037fc748d5ba7cfcdfd071398849fb09c4571cb4c1a2e33', '2026-07-19 04:30:02'),
(66, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'b53741afac6df54b1037fc748d5ba7cfcdfd071398849fb09c4571cb4c1a2e33', '90f8e7339f306f51af8fa5f6a9cd5ade9178184e3d40e199f9101fba11af5cd4', '2026-07-19 04:31:16'),
(67, 1, 'LOGOUT', 'users', 1, '[]', '::1', '90f8e7339f306f51af8fa5f6a9cd5ade9178184e3d40e199f9101fba11af5cd4', 'bfc56ddfaf8da031f7bfe59e724f61770cd0ea1a7953986f38dd5f815717be19', '2026-07-19 04:34:20'),
(68, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'bfc56ddfaf8da031f7bfe59e724f61770cd0ea1a7953986f38dd5f815717be19', '6b33782285952209d23c8101a491507a79d0cbe21d03fb81b4d9788ae5bf9038', '2026-07-19 04:34:49'),
(69, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '6b33782285952209d23c8101a491507a79d0cbe21d03fb81b4d9788ae5bf9038', '20705a431ed72d283f5f54e521c372a8e49508ce80df325d133db6fdc7185a10', '2026-07-19 05:18:06'),
(70, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210213A\"}', '::1', '20705a431ed72d283f5f54e521c372a8e49508ce80df325d133db6fdc7185a10', '6ffb430982497081ee951f7dca1c21a22a33bc4ddcd75c7f0778e91d3fa6fa82', '2026-07-19 05:48:24'),
(71, NULL, 'LOGIN_FAILED', 'users', NULL, '{\"id_number\":\"1-210213A\"}', '::1', '6ffb430982497081ee951f7dca1c21a22a33bc4ddcd75c7f0778e91d3fa6fa82', '7572db864d00366e8fa70e1541e7fa2b3e34a1208b75d209810b175a7d99211a', '2026-07-19 05:48:30'),
(72, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '7572db864d00366e8fa70e1541e7fa2b3e34a1208b75d209810b175a7d99211a', '9000940a00697502dee2856ee0536ca8c42dacd3019f012ed17f04c96df1c234', '2026-07-19 05:48:49'),
(73, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '9000940a00697502dee2856ee0536ca8c42dacd3019f012ed17f04c96df1c234', 'd7e00fa1d38bce2076fe284afaa820e1144affec2ec3d99d280aa0430cffc891', '2026-07-19 05:53:53'),
(74, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', 'd7e00fa1d38bce2076fe284afaa820e1144affec2ec3d99d280aa0430cffc891', '5a139339ef94a0947551bf992553e727219a43a68d9c41a8188d62591037302e', '2026-07-19 05:53:53'),
(75, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"session_timeout_minutes\",\"new_value\":\"15\"}', '::1', '5a139339ef94a0947551bf992553e727219a43a68d9c41a8188d62591037302e', 'd6957a2628c31508f5b7d6ef65d88a2f5b8fc8744e5aaeac19de786f669acec6', '2026-07-19 05:53:53'),
(76, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'd6957a2628c31508f5b7d6ef65d88a2f5b8fc8744e5aaeac19de786f669acec6', '079831bdaf35d9cbf50a6a99383262353871f89dc8c34ddc8e06a1587a10e1df', '2026-07-19 05:53:53'),
(77, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '079831bdaf35d9cbf50a6a99383262353871f89dc8c34ddc8e06a1587a10e1df', '696f73d3c35445f125ecd3a5d546651716cbfbc3527e675b690837ad20eaad63', '2026-07-19 05:53:53'),
(78, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '696f73d3c35445f125ecd3a5d546651716cbfbc3527e675b690837ad20eaad63', '2a99e69bb1de22877cf30373b656f142396e97642791741f3ae21ee5231d33c8', '2026-07-19 05:53:53'),
(79, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '2a99e69bb1de22877cf30373b656f142396e97642791741f3ae21ee5231d33c8', 'c05d5854defe82c9098cc8902523c361e3a4f9f8ea52d2a73d9463ad04d76cfb', '2026-07-19 05:53:53'),
(80, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'c05d5854defe82c9098cc8902523c361e3a4f9f8ea52d2a73d9463ad04d76cfb', '38c68bbd7d2425093977ef8750fa922a290d0e348d3dc8b85b00b4bda599ac02', '2026-07-19 05:53:58'),
(81, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', '38c68bbd7d2425093977ef8750fa922a290d0e348d3dc8b85b00b4bda599ac02', '6c5b33a279ae71159e96a01f4bec17dec98ab687904f4965a891df7205c78969', '2026-07-19 05:53:58');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(82, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '6c5b33a279ae71159e96a01f4bec17dec98ab687904f4965a891df7205c78969', 'f2b8fc9b6d555935d1b471ecae130f7a95a0897280ce451c6b0d55e0e29a29a3', '2026-07-19 05:53:58'),
(83, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'f2b8fc9b6d555935d1b471ecae130f7a95a0897280ce451c6b0d55e0e29a29a3', '866f49e502deeb8d5efef929d00d8ac9b0f9e2bc5c6f49e7071851a8167f331d', '2026-07-19 05:53:58'),
(84, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '866f49e502deeb8d5efef929d00d8ac9b0f9e2bc5c6f49e7071851a8167f331d', 'd6e4513ce48b021ef9203d5503e0a363e527443a0ee4ff828383b8e0ee037802', '2026-07-19 05:53:58'),
(85, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'd6e4513ce48b021ef9203d5503e0a363e527443a0ee4ff828383b8e0ee037802', '5b443efab905498111a654f8924d88d88aadd773a25a99afbc67ca99ad0eba3e', '2026-07-19 05:53:58'),
(86, 1, 'LOGOUT', 'users', 1, '[]', '::1', '5b443efab905498111a654f8924d88d88aadd773a25a99afbc67ca99ad0eba3e', '0dea24e64190747945728d658e677ec0e7560f72e99e0de44d9ee35c71447e72', '2026-07-19 05:54:20'),
(87, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '0dea24e64190747945728d658e677ec0e7560f72e99e0de44d9ee35c71447e72', 'aaabd229f2c0a53d34ba52881245c529ee60163b5769091e8400961f2297dd9d', '2026-07-19 05:54:27'),
(88, 2, 'DTR_REJECTED', 'dtr_entries', 5, '{\"for_user_id\":1,\"reason\":\"invalid\"}', '::1', 'aaabd229f2c0a53d34ba52881245c529ee60163b5769091e8400961f2297dd9d', '8389063aabf0bfa79a4eeecaadaea4a6cadcedb41bfdd9a4d2b0386adf0d8030', '2026-07-19 05:59:16'),
(89, 4, 'USER_REGISTERED', 'users', 4, '{\"role\":\"student_assistant\"}', '::1', '8389063aabf0bfa79a4eeecaadaea4a6cadcedb41bfdd9a4d2b0386adf0d8030', 'ebb2614a106ae17c55dfd7b5a75bc0efd04595d2f1b29567097f4be168d2841b', '2026-07-19 06:03:24'),
(90, 2, 'SA_CREATED_BY_HEAD', 'users', 4, '[]', '::1', 'ebb2614a106ae17c55dfd7b5a75bc0efd04595d2f1b29567097f4be168d2841b', 'fccc0f6287c386add7bc01fa723cdf443e169dddc45f1585bdcbfb517bf99d0d', '2026-07-19 06:03:24'),
(91, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'fccc0f6287c386add7bc01fa723cdf443e169dddc45f1585bdcbfb517bf99d0d', '36e0ecf63b7732c0c47fe75056b4d69d1d2d7aa2f6dd89c39a3c11addbf271df', '2026-07-19 06:20:23'),
(92, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '36e0ecf63b7732c0c47fe75056b4d69d1d2d7aa2f6dd89c39a3c11addbf271df', '23fc8f47abf23613ca79d447924fc49a049384e92e3b6ee96c30847c346295d5', '2026-07-19 06:20:26'),
(93, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '23fc8f47abf23613ca79d447924fc49a049384e92e3b6ee96c30847c346295d5', '635ed5030e4bd695537c8c0fc25857deac4fae4556bf59dadc26276adf96e90b', '2026-07-19 06:20:30'),
(94, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '635ed5030e4bd695537c8c0fc25857deac4fae4556bf59dadc26276adf96e90b', '9b2e8efedd98467a388e7335f66b02924bdc60d2fb74f2eb613917d149396f7a', '2026-07-19 06:20:31'),
(95, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '9b2e8efedd98467a388e7335f66b02924bdc60d2fb74f2eb613917d149396f7a', '767cdd4e3279384388042526d75a9170b8a002008f8aaa1c3b05d9f5f187cce4', '2026-07-19 06:20:33'),
(96, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '767cdd4e3279384388042526d75a9170b8a002008f8aaa1c3b05d9f5f187cce4', 'e94ede5d5e2aa9f83c247e93345edce6fbea654d70fe8c48bba9aaef50503dcc', '2026-07-19 06:20:46'),
(97, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'e94ede5d5e2aa9f83c247e93345edce6fbea654d70fe8c48bba9aaef50503dcc', 'a73882ce183e300202a32f47ff296c25a00c14bea2ddf3f141f1ca43628989c3', '2026-07-19 06:22:09'),
(98, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'a73882ce183e300202a32f47ff296c25a00c14bea2ddf3f141f1ca43628989c3', 'c20296bbdd038b492faea3888344f60d4efb8ec87fc2f1c7212e69faadb7e7f1', '2026-07-19 06:22:11'),
(99, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'c20296bbdd038b492faea3888344f60d4efb8ec87fc2f1c7212e69faadb7e7f1', '6fb2710609c3b7e2559e0c631cb120eb6c1aab35d72fa44ed3e99261109c8b12', '2026-07-19 06:22:16'),
(100, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '6fb2710609c3b7e2559e0c631cb120eb6c1aab35d72fa44ed3e99261109c8b12', '47c8647cfaeb84e2f07ccefd9c5bfdb1f896a02be8b26372b282bb2d97e66ba4', '2026-07-19 06:22:17'),
(101, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '47c8647cfaeb84e2f07ccefd9c5bfdb1f896a02be8b26372b282bb2d97e66ba4', 'b026bd86d19dcea5f161e122549aaafe7a5baa85d77d596cc89f74daa4190e7f', '2026-07-19 06:26:40'),
(102, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'b026bd86d19dcea5f161e122549aaafe7a5baa85d77d596cc89f74daa4190e7f', '32e92706b8a5281e6620ee9261e5b8cae5e435b0a146b2428260a26416ab9a5f', '2026-07-19 06:26:42'),
(103, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '32e92706b8a5281e6620ee9261e5b8cae5e435b0a146b2428260a26416ab9a5f', '8614bfd2238752911e5a1b09103236c74b0e909b33957700410cf714a61c30e0', '2026-07-19 06:26:51'),
(104, 2, 'LOGOUT', 'users', 2, '[]', '::1', '8614bfd2238752911e5a1b09103236c74b0e909b33957700410cf714a61c30e0', '2656d41f8e8db4207700b3ae8e90e4c87b58ac24f65b5674c69af3b51c9789e3', '2026-07-19 06:26:51'),
(105, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '2656d41f8e8db4207700b3ae8e90e4c87b58ac24f65b5674c69af3b51c9789e3', 'fe24256ab42339870ab0faaca6ca62489a3f59d66220998733514bc9d2ba861c', '2026-07-19 06:26:57'),
(106, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'fe24256ab42339870ab0faaca6ca62489a3f59d66220998733514bc9d2ba861c', 'b26dfac60791ef1c6bd32dd5c5cfba318cd6250fa3c65dc2478373b131a1792f', '2026-07-19 06:27:43'),
(107, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'b26dfac60791ef1c6bd32dd5c5cfba318cd6250fa3c65dc2478373b131a1792f', '92855c6063d27b746d2304bbdd478183d9bc71b358800a45039e7dde5f56f9d0', '2026-07-19 06:27:45'),
(108, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '92855c6063d27b746d2304bbdd478183d9bc71b358800a45039e7dde5f56f9d0', '061cd7acb81cdba33f1a68867baf41a9aa30434e36f7c290fe60713e73cd0c1f', '2026-07-19 06:27:47'),
(109, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '061cd7acb81cdba33f1a68867baf41a9aa30434e36f7c290fe60713e73cd0c1f', 'de0e2c02dc52af389cdb2bdb37e08b2c692b545959f2f7261a2fc882dbdd70db', '2026-07-19 06:27:49'),
(110, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'de0e2c02dc52af389cdb2bdb37e08b2c692b545959f2f7261a2fc882dbdd70db', 'd3d2c30a9c0fb0dad9ffb85ba48879b90000602fe3b6631a1295b68a30e99422', '2026-07-19 06:29:10'),
(111, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', 'd3d2c30a9c0fb0dad9ffb85ba48879b90000602fe3b6631a1295b68a30e99422', '692c1ad0d1ed4bf272c5fc25a7a1b230d45c6e19a20682e84fbc31f455a3b70a', '2026-07-19 06:33:21'),
(112, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '692c1ad0d1ed4bf272c5fc25a7a1b230d45c6e19a20682e84fbc31f455a3b70a', '69d8359c4a19d6679787b9cfc0ca6eda8edae298d4ff42326d2541bba778246f', '2026-07-19 06:37:21'),
(113, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '69d8359c4a19d6679787b9cfc0ca6eda8edae298d4ff42326d2541bba778246f', '6a784e133dd47ab273716047e1643b5a0b8b6dd5ecb9a3a688fffa0b1cce4add', '2026-07-19 06:37:37'),
(114, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '6a784e133dd47ab273716047e1643b5a0b8b6dd5ecb9a3a688fffa0b1cce4add', '045ffdaa025499305b165bff6c9da2be37699f55a30e377408354b73275a20b9', '2026-07-19 06:37:40'),
(115, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 3, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', '045ffdaa025499305b165bff6c9da2be37699f55a30e377408354b73275a20b9', 'fce134464356e35f9aa838bda520bc256c51090c2a8a2b7c8a0a47abcec84558', '2026-07-19 06:37:41'),
(116, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 3, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', 'fce134464356e35f9aa838bda520bc256c51090c2a8a2b7c8a0a47abcec84558', '56890e25b890ddff2dee4db994c1fd7dec9232b0c89ea512e1e69797e153bf3b', '2026-07-19 06:37:43'),
(117, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 5, '{\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '56890e25b890ddff2dee4db994c1fd7dec9232b0c89ea512e1e69797e153bf3b', 'e188b1b06d3775e938d9dbebe48be00c7f8444be5717652479135ae40bf535d1', '2026-07-19 06:37:49'),
(118, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 3, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', 'e188b1b06d3775e938d9dbebe48be00c7f8444be5717652479135ae40bf535d1', 'a94936716af9f3dbd503aa04c1102e0857897cfe149ac68a2a2ba553854e879f', '2026-07-19 06:59:40'),
(119, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 3, '{\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', 'a94936716af9f3dbd503aa04c1102e0857897cfe149ac68a2a2ba553854e879f', '624ae296ce6762af85f977e7a8911b87fcee7e4b36f3e448540d30190584c492', '2026-07-19 06:59:42'),
(120, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 5, '{\"was_for_user_id\":1,\"work_date\":\"2026-08-01\",\"time_in\":\"2026-08-01 06:30:00\",\"time_out\":\"2026-08-01 20:00:00\"}', '::1', '624ae296ce6762af85f977e7a8911b87fcee7e4b36f3e448540d30190584c492', '6b6c4a08ff1d6fd3a32836bd865a6c2ad519a749dba4d702a528160c4d2dd6cc', '2026-07-19 07:08:59'),
(121, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 3, '{\"was_for_user_id\":1,\"work_date\":\"2026-07-17\",\"time_in\":\"2026-07-17 06:30:00\",\"time_out\":\"2026-07-17 17:00:00\"}', '::1', '6b6c4a08ff1d6fd3a32836bd865a6c2ad519a749dba4d702a528160c4d2dd6cc', 'ddc6eca97634671b88c81d59cec67afcf878a52d895a05d0bfb50d658d288a38', '2026-07-19 07:09:23'),
(122, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 4, '{\"was_for_user_id\":3,\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:52:00\",\"time_out\":\"2026-07-16 21:54:00\"}', '::1', 'ddc6eca97634671b88c81d59cec67afcf878a52d895a05d0bfb50d658d288a38', 'fdf224b3d703fa61a5b9316150ec76d21071a4b792cc1afd0d3b9df7e75aacd8', '2026-07-19 07:13:30'),
(123, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 1, '{\"was_for_user_id\":1,\"work_date\":\"2026-07-16\",\"time_in\":\"2026-07-16 08:23:00\",\"time_out\":\"2026-07-16 21:01:00\"}', '::1', 'fdf224b3d703fa61a5b9316150ec76d21071a4b792cc1afd0d3b9df7e75aacd8', '9cbea24bdea5711d80ef1d80395457587be821e50d64a9ef21c19912e453e398', '2026-07-19 07:15:55'),
(124, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\"}', '::1', '9cbea24bdea5711d80ef1d80395457587be821e50d64a9ef21c19912e453e398', 'e453f6fb473dcbbd1bb2a9c1935bf36f2e8ac44e569655c3a0adecd246eeb3ca', '2026-07-19 07:19:07'),
(125, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', 'e453f6fb473dcbbd1bb2a9c1935bf36f2e8ac44e569655c3a0adecd246eeb3ca', '60a1cbc93b7cd44598f747e60a18f680db13e0097015f71af6ed01969a593b31', '2026-07-19 07:19:21'),
(126, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '60a1cbc93b7cd44598f747e60a18f680db13e0097015f71af6ed01969a593b31', 'e3a0c6ef283f499af8b8234d6c15bb8caac10ac5e98d3689c20561df1a0c8a43', '2026-07-19 07:19:23'),
(127, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', 'e3a0c6ef283f499af8b8234d6c15bb8caac10ac5e98d3689c20561df1a0c8a43', '99156aa4daaa44e9e75dee405016bac84589bf7222c2e97221e9eac646c846d6', '2026-07-19 07:19:27'),
(128, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 7, '{\"work_date\":\"2026-07-01\"}', '::1', '99156aa4daaa44e9e75dee405016bac84589bf7222c2e97221e9eac646c846d6', '0612bd21691bb3c533d6a8da133eddddaff1d16e4a5c74908fe966bd71a9f9ce', '2026-07-19 07:23:44'),
(129, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 8, '{\"work_date\":\"2026-07-02\"}', '::1', '0612bd21691bb3c533d6a8da133eddddaff1d16e4a5c74908fe966bd71a9f9ce', '5d2c3a3c28c718b2a7fa0d271bf55e6f830ef477ad3fe9cde8a6c8bdaf945953', '2026-07-19 07:23:44'),
(130, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 9, '{\"work_date\":\"2026-07-03\"}', '::1', '5d2c3a3c28c718b2a7fa0d271bf55e6f830ef477ad3fe9cde8a6c8bdaf945953', '47362b6e479019a0924b7ac3e152a0118ab3ef13d6103a72e8e8f5605730aa70', '2026-07-19 07:23:44'),
(131, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 10, '{\"work_date\":\"2026-07-06\"}', '::1', '47362b6e479019a0924b7ac3e152a0118ab3ef13d6103a72e8e8f5605730aa70', 'f7d7e92ab8a0cba12b2291eef83b5a4d22681235f5f3372e0a06bcb6de723aff', '2026-07-19 07:23:44'),
(132, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 11, '{\"work_date\":\"2026-07-07\"}', '::1', 'f7d7e92ab8a0cba12b2291eef83b5a4d22681235f5f3372e0a06bcb6de723aff', '1d2d8e8bb530227a64f7cd74a75b023f5cb11c94429340d51142058ac1bef4cd', '2026-07-19 07:23:44'),
(133, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 12, '{\"work_date\":\"2026-07-08\"}', '::1', '1d2d8e8bb530227a64f7cd74a75b023f5cb11c94429340d51142058ac1bef4cd', '04d3300bbc5a7ff5493c85b306e8cabdc24d6b1193f5f56ae0fcf9b4745c1049', '2026-07-19 07:23:44'),
(134, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 13, '{\"work_date\":\"2026-07-09\"}', '::1', '04d3300bbc5a7ff5493c85b306e8cabdc24d6b1193f5f56ae0fcf9b4745c1049', 'b83f24d3ac843b8e40783f58d7d4da94572ee286ae0a8cdbb4c590913593b221', '2026-07-19 07:23:44'),
(135, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 14, '{\"work_date\":\"2026-07-10\"}', '::1', 'b83f24d3ac843b8e40783f58d7d4da94572ee286ae0a8cdbb4c590913593b221', 'd793b2359ef4bea7d1a90e8cff00efd99438d6c35f7f6ba446dd1aa92a345da5', '2026-07-19 07:23:44'),
(136, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 15, '{\"work_date\":\"2026-07-13\"}', '::1', 'd793b2359ef4bea7d1a90e8cff00efd99438d6c35f7f6ba446dd1aa92a345da5', '2faa0a2518994758348ec3b07359d1ede1e4dbc8314835bf16c6f44aaf1cd545', '2026-07-19 07:23:44'),
(137, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 16, '{\"work_date\":\"2026-07-14\"}', '::1', '2faa0a2518994758348ec3b07359d1ede1e4dbc8314835bf16c6f44aaf1cd545', '9380c14dcc643916bdb735ce26119f8d05b52af0c1ed9555e7ca0aea3dd4f353', '2026-07-19 07:23:44'),
(138, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '9380c14dcc643916bdb735ce26119f8d05b52af0c1ed9555e7ca0aea3dd4f353', 'bb59585ed780631102fdfc03bca2dcd559ba6944b84aeb72bf2bcc089aa1546f', '2026-07-19 07:24:16'),
(139, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', 'bb59585ed780631102fdfc03bca2dcd559ba6944b84aeb72bf2bcc089aa1546f', '0d3c88c342cd21d860efe731939ec902d59fdd872fc2ad3ac8908308486fffec', '2026-07-19 07:28:25'),
(140, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '0d3c88c342cd21d860efe731939ec902d59fdd872fc2ad3ac8908308486fffec', '6032b4110b4a7bc7413955dc5d79f9043622d00f86bb55d9e98d2f178397f059', '2026-07-19 07:29:45'),
(141, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '6032b4110b4a7bc7413955dc5d79f9043622d00f86bb55d9e98d2f178397f059', '8efe445d2c6231237a32948e1578e66c902dfcec79d9f0440c46cf414b631e51', '2026-07-19 07:29:47'),
(142, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '8efe445d2c6231237a32948e1578e66c902dfcec79d9f0440c46cf414b631e51', '58fb4d18643041a02ad5897726916c398df0aa7fe043a409202874b74eda7b11', '2026-07-19 07:31:56'),
(143, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 6, '{\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '58fb4d18643041a02ad5897726916c398df0aa7fe043a409202874b74eda7b11', 'cdc5570de004444d72d9e068ae6cb16423d1e1b692b5539ee5c155d3e75f55b3', '2026-07-19 07:32:02'),
(144, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'cdc5570de004444d72d9e068ae6cb16423d1e1b692b5539ee5c155d3e75f55b3', 'eb161e2320b6c854701deed0dc8ed52bea5cdaa1438a71a51e3249fd4b81db08', '2026-07-20 14:26:06'),
(145, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'eb161e2320b6c854701deed0dc8ed52bea5cdaa1438a71a51e3249fd4b81db08', 'c4a27c65ffd49b2cb4b644e5cc3f0be80ff7a014f050e11b5e727ca9a41ccfd2', '2026-07-20 14:26:12'),
(146, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'c4a27c65ffd49b2cb4b644e5cc3f0be80ff7a014f050e11b5e727ca9a41ccfd2', 'b5a8f312c86e2ccb6d0b6f9a1c88f6fb6f4edf5bbde7c63949e59327a61c4d29', '2026-07-20 14:26:37'),
(147, 2, 'DTR_APPROVED', 'dtr_entries', 6, '{\"for_user_id\":1}', '::1', 'b5a8f312c86e2ccb6d0b6f9a1c88f6fb6f4edf5bbde7c63949e59327a61c4d29', 'ed6c9f6932edd438016b03f35bda4dee7650103858d26ee13bd8360ed36c9157', '2026-07-20 14:26:47'),
(148, 2, 'DTR_APPROVED', 'dtr_entries', 7, '{\"for_user_id\":1}', '::1', 'ed6c9f6932edd438016b03f35bda4dee7650103858d26ee13bd8360ed36c9157', 'a71a8c3fcebc700a3cde85a3cb0a3a68151d8695962ca96a0d5e498b932636de', '2026-07-20 14:26:55'),
(149, 2, 'DTR_APPROVED', 'dtr_entries', 12, '{\"for_user_id\":1}', '::1', 'a71a8c3fcebc700a3cde85a3cb0a3a68151d8695962ca96a0d5e498b932636de', '3828ec24eac88148c5742cd83ae8f7e74df57b771f69a6f293507518005c96c6', '2026-07-20 14:26:55'),
(150, 2, 'DTR_APPROVED', 'dtr_entries', 11, '{\"for_user_id\":1}', '::1', '3828ec24eac88148c5742cd83ae8f7e74df57b771f69a6f293507518005c96c6', '7a6b393eba1a9815eb30083e48b7dbff205c8fcd30e10ea039a4664363959071', '2026-07-20 14:26:55');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(151, 2, 'DTR_APPROVED', 'dtr_entries', 16, '{\"for_user_id\":1}', '::1', '7a6b393eba1a9815eb30083e48b7dbff205c8fcd30e10ea039a4664363959071', 'f806102a02d0a617486ff7fb2c0d1a3dfa0e80df1e1db1fb62bf4409d1741e8d', '2026-07-20 14:26:55'),
(152, 2, 'DTR_APPROVED', 'dtr_entries', 10, '{\"for_user_id\":1}', '::1', 'f806102a02d0a617486ff7fb2c0d1a3dfa0e80df1e1db1fb62bf4409d1741e8d', 'd760e62674809dd5602228838a9aae975bc069a6dd700b47718b1e48f7c35eaf', '2026-07-20 14:26:55'),
(153, 2, 'DTR_APPROVED', 'dtr_entries', 15, '{\"for_user_id\":1}', '::1', 'd760e62674809dd5602228838a9aae975bc069a6dd700b47718b1e48f7c35eaf', 'b9aa74597d9ad7ad85f853464758d8efb9bf3e49c9f08fc6e82a9075d348ebe6', '2026-07-20 14:26:55'),
(154, 2, 'DTR_APPROVED', 'dtr_entries', 9, '{\"for_user_id\":1}', '::1', 'b9aa74597d9ad7ad85f853464758d8efb9bf3e49c9f08fc6e82a9075d348ebe6', 'e7b946b3cb1f7b8248a36d53dceb430c573534edc9b6132823aa359797714f3e', '2026-07-20 14:26:55'),
(155, 2, 'DTR_APPROVED', 'dtr_entries', 14, '{\"for_user_id\":1}', '::1', 'e7b946b3cb1f7b8248a36d53dceb430c573534edc9b6132823aa359797714f3e', '74b7c5731eecd7487333ce24206ffba21a9dd5c997f6c6ec929593775df43b04', '2026-07-20 14:26:55'),
(156, 2, 'DTR_APPROVED', 'dtr_entries', 8, '{\"for_user_id\":1}', '::1', '74b7c5731eecd7487333ce24206ffba21a9dd5c997f6c6ec929593775df43b04', 'c6e7a163852d3cdcae68fa65700ffedfee76eb37d6108d7ca85d4b9207dc5200', '2026-07-20 14:26:55'),
(157, 2, 'DTR_APPROVED', 'dtr_entries', 13, '{\"for_user_id\":1}', '::1', 'c6e7a163852d3cdcae68fa65700ffedfee76eb37d6108d7ca85d4b9207dc5200', '5c1108f3598ab669225827c9adbd2053f008bdf299d95ab233d14a8b6015d7db', '2026-07-20 14:26:55'),
(158, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 11, '{\"work_date\":\"2026-07-07\",\"time_in\":\"2026-07-07 06:30:00\",\"time_out\":\"2026-07-07 20:00:00\"}', '::1', '5c1108f3598ab669225827c9adbd2053f008bdf299d95ab233d14a8b6015d7db', 'fcfa9b806fe0d908211be2ca59b24b0fd44947c1a5f2abdcadd0a9e294748bbd', '2026-07-20 14:27:37'),
(159, 2, 'DTR_ENTRY_EDITED', 'dtr_entries', 11, '{\"work_date\":\"2026-07-07\",\"time_in\":\"2026-07-07 06:30:00\",\"time_out\":\"2026-07-07 20:00:00\"}', '::1', 'fcfa9b806fe0d908211be2ca59b24b0fd44947c1a5f2abdcadd0a9e294748bbd', '2fda677041fa4a78e1b6dde18c838dbccd6d4062dfe7377f017aa2beff035806', '2026-07-20 14:27:40'),
(160, 2, 'ALL_DTR_ENTRIES_DELETED', 'dtr_entries', 0, '{\"total_deleted\":11}', '::1', '2fda677041fa4a78e1b6dde18c838dbccd6d4062dfe7377f017aa2beff035806', '4ff7b2a4bf3e0beb68bf8891d2a28d7a8f0863f3526935870ff21cbc2051874b', '2026-07-20 14:27:52'),
(161, 1, 'LOGOUT', 'users', 1, '[]', '::1', '4ff7b2a4bf3e0beb68bf8891d2a28d7a8f0863f3526935870ff21cbc2051874b', '6eccb77161b1550525ab7a053b11f3534b93a5c20a53165336031412368ea2a6', '2026-07-20 14:29:54'),
(162, 2, 'LOGOUT', 'users', 2, '[]', '::1', '6eccb77161b1550525ab7a053b11f3534b93a5c20a53165336031412368ea2a6', '784b4eba99d6866c176007e12b904fe78791a663fa140fa06a81e7697546822d', '2026-07-20 14:34:00'),
(163, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '784b4eba99d6866c176007e12b904fe78791a663fa140fa06a81e7697546822d', '5bb125d921a2134696e25f59c86c637d24b65888244f2391c586e75323d667da', '2026-07-21 00:58:31'),
(164, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '5bb125d921a2134696e25f59c86c637d24b65888244f2391c586e75323d667da', '37b37806288d7ed4866df9698d5743aee2551a8b6aa35a6cc5778b92bace7e98', '2026-07-21 01:08:39'),
(165, 1, 'LOGOUT', 'users', 1, '[]', '::1', '37b37806288d7ed4866df9698d5743aee2551a8b6aa35a6cc5778b92bace7e98', '6dd0e8dd9ed15bbb734e736230441a6030180d716698186d939c4d622de5a895', '2026-07-21 01:08:47'),
(166, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '6dd0e8dd9ed15bbb734e736230441a6030180d716698186d939c4d622de5a895', '0d2c80a124c5dad340c35e9bee32214f955a6637d59d68842b42098c89b7c212', '2026-07-21 01:08:53'),
(167, 2, 'LOGOUT', 'users', 2, '[]', '::1', '0d2c80a124c5dad340c35e9bee32214f955a6637d59d68842b42098c89b7c212', 'a597023dce8b1d1216725b661c37e63e129b8d7e18ed2771915b6494301744c6', '2026-07-21 03:22:48'),
(168, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'a597023dce8b1d1216725b661c37e63e129b8d7e18ed2771915b6494301744c6', 'aad961f8933bf8c2e72ad87d0c6dae39a224c94f8ac56e5a5ed891a17c68e4d1', '2026-07-21 03:22:54'),
(169, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'aad961f8933bf8c2e72ad87d0c6dae39a224c94f8ac56e5a5ed891a17c68e4d1', '64ee348313e0ccc400c9d2a8427a5a3990a4688845c64489b446ae87ea72ad4a', '2026-07-21 03:24:57'),
(170, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '64ee348313e0ccc400c9d2a8427a5a3990a4688845c64489b446ae87ea72ad4a', '0fdb5cbf0fe246453a59020abb41841caec885823eed019c3f5c58a27b827a7b', '2026-07-21 03:25:07'),
(171, 2, 'LOGOUT', 'users', 2, '[]', '::1', '0fdb5cbf0fe246453a59020abb41841caec885823eed019c3f5c58a27b827a7b', 'a7871e7bb26af41bd37a95c1d481191f24a0c9ccc73a6623bd8b3be5708e25de', '2026-07-21 03:25:28'),
(172, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'a7871e7bb26af41bd37a95c1d481191f24a0c9ccc73a6623bd8b3be5708e25de', '0cea2a0f37ced8570923415ba2a65f8f9987469bb9bd21e6095b3968789b2e71', '2026-07-21 03:25:33'),
(173, 1, 'LOGOUT', 'users', 1, '[]', '::1', '0cea2a0f37ced8570923415ba2a65f8f9987469bb9bd21e6095b3968789b2e71', '0d713e2434aa83eafd810ed7efdf811062623999a9268fe1cec459faa3bced3b', '2026-07-21 03:28:57'),
(174, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '0d713e2434aa83eafd810ed7efdf811062623999a9268fe1cec459faa3bced3b', '337750c6a457ae1732c9ffe640b0be2a9437c83651f83cd58610385f80534e52', '2026-07-21 03:35:36'),
(175, 2, 'LOGOUT', 'users', 2, '[]', '::1', '337750c6a457ae1732c9ffe640b0be2a9437c83651f83cd58610385f80534e52', 'c7a4d8a9ca010bc8b77bddaf106600e060d4b65455aa641cd4caa331c350b9bc', '2026-07-21 03:36:05'),
(176, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'c7a4d8a9ca010bc8b77bddaf106600e060d4b65455aa641cd4caa331c350b9bc', 'f9b511e4c3afac8ab895203e0bf51390e9b0b3a73cd17abfaf71c96748069c84', '2026-07-21 03:38:49'),
(177, 2, 'LOGOUT', 'users', 2, '[]', '::1', 'f9b511e4c3afac8ab895203e0bf51390e9b0b3a73cd17abfaf71c96748069c84', '978ed6aaab723a31398c3b2de77a0ff20a53c1689f637b8d9c9c6696abfb8ce0', '2026-07-21 03:41:16'),
(178, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '978ed6aaab723a31398c3b2de77a0ff20a53c1689f637b8d9c9c6696abfb8ce0', '42c1569b4bd5da4a9e9f5c69ac31a915572f26a62ab5b92fb926b34e78b2eafa', '2026-07-21 03:44:54'),
(179, 2, 'LOGOUT', 'users', 2, '[]', '::1', '42c1569b4bd5da4a9e9f5c69ac31a915572f26a62ab5b92fb926b34e78b2eafa', '969b52726df246ab3446ba63a3fb94f1bcd3385e1e2a65aef9b395f8db4abba9', '2026-07-21 03:50:56'),
(180, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '::1', '969b52726df246ab3446ba63a3fb94f1bcd3385e1e2a65aef9b395f8db4abba9', 'ca10182a378045d59094b5273a88d1973c9e192bcc0121bc99532a8efc9417e3', '2026-07-21 04:03:25'),
(181, 3, 'LOGOUT', 'users', 3, '[]', '::1', 'ca10182a378045d59094b5273a88d1973c9e192bcc0121bc99532a8efc9417e3', 'e01a63f542e991223ae91a0b221d71664590d871ba8a8eb19fd71a0649c443fb', '2026-07-21 04:04:57'),
(182, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '::1', 'e01a63f542e991223ae91a0b221d71664590d871ba8a8eb19fd71a0649c443fb', 'f02fa3b759b8cadff714de81554c621787c196a3de2c811fbf2d60a4f92cfae8', '2026-07-21 04:05:13'),
(183, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'f02fa3b759b8cadff714de81554c621787c196a3de2c811fbf2d60a4f92cfae8', 'd7cbd1544710de287dfaf30145487922d1e7bddc1b467fcde11cd9d5d46f1af7', '2026-07-21 08:19:52'),
(184, 3, 'LOGOUT', 'users', 3, '[]', '::1', 'd7cbd1544710de287dfaf30145487922d1e7bddc1b467fcde11cd9d5d46f1af7', 'e28bd2baa1a4b539c46516d31e1b01f329da6135335fbb0df4ee8d650cd81d5b', '2026-07-21 08:22:19'),
(185, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '::1', 'e28bd2baa1a4b539c46516d31e1b01f329da6135335fbb0df4ee8d650cd81d5b', 'a4089eb2070d90bcadd79cb9ff1a051ae253b218d2915272a110528dc07c0301', '2026-07-21 08:22:25'),
(186, 3, 'LOGOUT', 'users', 3, '[]', '::1', 'a4089eb2070d90bcadd79cb9ff1a051ae253b218d2915272a110528dc07c0301', 'f6235971d69f350b43e16fed7e41a26ca74f8f4a5e0e81e01d45aab5f7461c7e', '2026-07-21 09:08:33'),
(187, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'f6235971d69f350b43e16fed7e41a26ca74f8f4a5e0e81e01d45aab5f7461c7e', '2d090d3d64f2c666bcb7544f6c502f6878aad0728f63c9ffddff11bc2e540a2f', '2026-07-21 09:08:38'),
(188, 2, 'DTR_ENTRY_ADDED', 'dtr_entries', 17, '{\"for_user_id\":3,\"work_date\":\"2026-07-01\",\"time_in\":\"2026-07-01 06:30:00\",\"time_out\":\"2026-07-01 20:00:00\"}', '::1', '2d090d3d64f2c666bcb7544f6c502f6878aad0728f63c9ffddff11bc2e540a2f', '149ff967884e3c687afd214e55c120047568cf0d8f24451c3ae2037d73d24af0', '2026-07-21 09:13:24'),
(189, 2, 'LOGOUT', 'users', 2, '[]', '::1', '149ff967884e3c687afd214e55c120047568cf0d8f24451c3ae2037d73d24af0', 'f04555d4deb3dd2c76b05a13d19207b9e4aa885fdb6561d2ecd60bbb9b47df4f', '2026-07-21 09:20:46'),
(190, 5, 'LOGIN_SUCCESS', 'users', 5, '[]', '::1', 'f04555d4deb3dd2c76b05a13d19207b9e4aa885fdb6561d2ecd60bbb9b47df4f', '5f125744460531a0350a71a2914b7121247227ca4e08b5b4a6c59a049fea2183', '2026-07-21 09:21:00'),
(191, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '5f125744460531a0350a71a2914b7121247227ca4e08b5b4a6c59a049fea2183', '5344daf428bd761e1a7f3578fc276864b27a56a32481a6b776331deb2b839bac', '2026-07-21 09:22:50'),
(192, 5, 'LOGOUT', 'users', 5, '[]', '::1', '5344daf428bd761e1a7f3578fc276864b27a56a32481a6b776331deb2b839bac', '001dc8a9b74a7e47262d569a9fcb6aada73080e75015fd9bc320c2ee7aec7aff', '2026-07-21 09:23:17'),
(193, 6, 'LOGIN_SUCCESS', 'users', 6, '[]', '::1', '001dc8a9b74a7e47262d569a9fcb6aada73080e75015fd9bc320c2ee7aec7aff', 'a9911a2890ac911b4991cbe2411e9ec894509bd883138c0698d971df2cf76ab0', '2026-07-21 09:23:38'),
(194, 6, 'LOGOUT', 'users', 6, '[]', '::1', 'a9911a2890ac911b4991cbe2411e9ec894509bd883138c0698d971df2cf76ab0', '44664979c0a1586d80a4ef85c109c725a6c92a3a0cb69eafc07913deeb066709', '2026-07-21 09:25:27'),
(195, 5, 'LOGIN_SUCCESS', 'users', 5, '[]', '::1', '44664979c0a1586d80a4ef85c109c725a6c92a3a0cb69eafc07913deeb066709', 'ff3e6209fd27b9d19143627af9ac14e170f37e1917aa3671eeaa1ba7a45c4e79', '2026-07-21 09:25:36'),
(196, 5, 'LOGOUT', 'users', 5, '[]', '::1', 'ff3e6209fd27b9d19143627af9ac14e170f37e1917aa3671eeaa1ba7a45c4e79', '1c37a23c3c66cfac992e3c261c8f264a97d451e39abd3e3e866b8b5466cbd507', '2026-07-21 09:27:05'),
(197, 6, 'LOGIN_SUCCESS', 'users', 6, '[]', '::1', '1c37a23c3c66cfac992e3c261c8f264a97d451e39abd3e3e866b8b5466cbd507', 'dd1dd9022aa86970aec933fb05fd49c646fb66d57060b3b299753a0c252e9bd9', '2026-07-21 09:27:14'),
(198, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 1, '{\"hours\":72}', '::1', 'dd1dd9022aa86970aec933fb05fd49c646fb66d57060b3b299753a0c252e9bd9', '8ac34cc79e50dd769e2f0e236d8d86c33aa4d581a4a5250185fd704051a911d4', '2026-07-21 09:29:33'),
(199, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 1, '{\"status\":\"approved\"}', '::1', '8ac34cc79e50dd769e2f0e236d8d86c33aa4d581a4a5250185fd704051a911d4', '0b14a5585b55c28b35c1a168747bf30117a8c064c04089df72d8ff6df1e72375', '2026-07-21 09:29:47'),
(200, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 2, '{\"hours\":72}', '::1', '0b14a5585b55c28b35c1a168747bf30117a8c064c04089df72d8ff6df1e72375', '84fa26650a652221c1142de3cf83fefaac4e7fe66afd71cd02f274bebf9be0ca', '2026-07-21 09:32:10'),
(201, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 3, '{\"hours\":72}', '::1', '84fa26650a652221c1142de3cf83fefaac4e7fe66afd71cd02f274bebf9be0ca', '50003ad1958fc62ca47a9a109fdb70a123729f05c44c3781e1fb80b33295219d', '2026-07-21 09:32:12'),
(202, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 4, '{\"hours\":72}', '::1', '50003ad1958fc62ca47a9a109fdb70a123729f05c44c3781e1fb80b33295219d', '25c904d4dd8befb7b12ce3ac37530076a4dd30cd320ccc2b5df6180c2edaa0cb', '2026-07-21 09:32:19'),
(203, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 2, '{\"status\":\"rejected\"}', '::1', '25c904d4dd8befb7b12ce3ac37530076a4dd30cd320ccc2b5df6180c2edaa0cb', '232c63f108157c3ec33bce631a665156a3bc0ab3685f8ceb82f4c89aa36e03c4', '2026-07-21 09:32:34'),
(204, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 3, '{\"status\":\"rejected\"}', '::1', '232c63f108157c3ec33bce631a665156a3bc0ab3685f8ceb82f4c89aa36e03c4', '26fa7e2ec440ea4fdac984cd697cb7e9b4545c7ea7ec17c675acb5c5da1490a1', '2026-07-21 09:32:38'),
(205, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 4, '{\"status\":\"rejected\"}', '::1', '26fa7e2ec440ea4fdac984cd697cb7e9b4545c7ea7ec17c675acb5c5da1490a1', '4f605da2ba9205f29154c8c784eb69ad8a6fecdbdbe5c914d2336663ba42c680', '2026-07-21 09:32:40'),
(206, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 5, '{\"hours\":72}', '::1', '4f605da2ba9205f29154c8c784eb69ad8a6fecdbdbe5c914d2336663ba42c680', '662086bf1aba5b1a285becf9d2c8ce9fe8df834462d8d22174d56bc6eaaef211', '2026-07-21 09:34:39'),
(207, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 6, '{\"hours\":72}', '::1', '662086bf1aba5b1a285becf9d2c8ce9fe8df834462d8d22174d56bc6eaaef211', '356e32b19f32ae66940908782c9b4a17e05f05333e3317b5bff208619830d7ab', '2026-07-21 09:45:29'),
(208, 6, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 7, '{\"hours\":72}', '::1', '356e32b19f32ae66940908782c9b4a17e05f05333e3317b5bff208619830d7ab', 'c9bcc1affb3d5fab824b38d7df43c27a8fad850bc5a63d8a49e59753a1679aa2', '2026-07-21 09:45:31'),
(209, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 5, '{\"status\":\"rejected\"}', '::1', 'c9bcc1affb3d5fab824b38d7df43c27a8fad850bc5a63d8a49e59753a1679aa2', '730219582f4c3eff98c1be13fa13146e0d6be7984b75f9684ae75be20c0d1a24', '2026-07-21 09:50:27'),
(210, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 6, '{\"status\":\"rejected\"}', '::1', '730219582f4c3eff98c1be13fa13146e0d6be7984b75f9684ae75be20c0d1a24', 'b9bf8b65bece30f3a77749555df1de0d4139dfc0c92ca44168f99c4248141ca3', '2026-07-21 09:50:37'),
(211, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 7, '{\"status\":\"rejected\"}', '::1', 'b9bf8b65bece30f3a77749555df1de0d4139dfc0c92ca44168f99c4248141ca3', '21fc2e42998da81da6cd83d436444255363226189cecc7833e1c5138a8ff7d35', '2026-07-21 09:50:40'),
(212, 2, 'ALL_DTR_ENTRIES_DELETED', 'dtr_entries', 0, '{\"total_deleted\":115}', '::1', '21fc2e42998da81da6cd83d436444255363226189cecc7833e1c5138a8ff7d35', '018f804842a00a4e234959ee8113358a5eae0ee8d2c7d9dabd08134022844d25', '2026-07-21 09:51:03'),
(213, 2, 'LOGOUT', 'users', 2, '[]', '::1', '018f804842a00a4e234959ee8113358a5eae0ee8d2c7d9dabd08134022844d25', '1a179d015a1ea9f18aeb45cd773c1ea3a8aec874b34c7557b5fb813e7eb9569c', '2026-07-21 09:57:24'),
(214, 6, 'LOGOUT', 'users', 6, '[]', '::1', '1a179d015a1ea9f18aeb45cd773c1ea3a8aec874b34c7557b5fb813e7eb9569c', 'eaccf4c44ce35d5220d953ae563a2bebce3ff6cc5ebd8b8934b5ae204d471eaa', '2026-07-21 09:57:34'),
(215, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'eaccf4c44ce35d5220d953ae563a2bebce3ff6cc5ebd8b8934b5ae204d471eaa', '3743e4ee90860fb319e1b5cb1ba9d269d3d2e8318eb8f1a2b007ed7c72a2e924', '2026-07-21 12:23:06'),
(216, 2, 'LOGOUT', 'users', 2, '[]', '::1', '3743e4ee90860fb319e1b5cb1ba9d269d3d2e8318eb8f1a2b007ed7c72a2e924', '23abda40ae7364fcd0aed9bb663bd654035e7bb891f7c3478bf11d3ce2f41564', '2026-07-21 12:23:12'),
(217, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '::1', '23abda40ae7364fcd0aed9bb663bd654035e7bb891f7c3478bf11d3ce2f41564', 'b439481ffbdf581b6fc91b9e3952f23d26803b10ed28df584f02f09eec037c6b', '2026-07-21 12:23:21'),
(218, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'b439481ffbdf581b6fc91b9e3952f23d26803b10ed28df584f02f09eec037c6b', '8a2dbbe26cfdf7304cd87dbd36bae85808e7e66a5362af0226eeeebaf4f45759', '2026-07-21 12:23:29'),
(219, 1, 'LOGOUT', 'users', 1, '[]', '::1', '8a2dbbe26cfdf7304cd87dbd36bae85808e7e66a5362af0226eeeebaf4f45759', 'f0580e4e60aafcccbc917d3ca08eaa128c447b4563dae604f182b5b14ab34cff', '2026-07-21 12:23:56'),
(220, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'f0580e4e60aafcccbc917d3ca08eaa128c447b4563dae604f182b5b14ab34cff', 'c25849012e37744e7b546a880fd9e9a95bfa1d1b0ce59246822bf644992ba796', '2026-07-21 12:24:19'),
(221, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'c25849012e37744e7b546a880fd9e9a95bfa1d1b0ce59246822bf644992ba796', 'a624a7795a90849183dc153a11ca56095f18bf81a391ca154e198388ef32143f', '2026-07-21 12:24:28'),
(222, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'a624a7795a90849183dc153a11ca56095f18bf81a391ca154e198388ef32143f', '25afcbccbc73f415954189424015c5ec0b952fdf8c0bc09d9169fe3ebe5359de', '2026-07-21 12:24:35'),
(223, 2, 'LOGOUT', 'users', 2, '[]', '::1', '25afcbccbc73f415954189424015c5ec0b952fdf8c0bc09d9169fe3ebe5359de', 'd37b8110ddbdb595c55f2d8efc509e00e5d6bd628d6370159bab0ebc8ad05240', '2026-07-21 12:24:42'),
(224, 5, 'LOGIN_SUCCESS', 'users', 5, '[]', '::1', 'd37b8110ddbdb595c55f2d8efc509e00e5d6bd628d6370159bab0ebc8ad05240', '39d7223b3946803e5e50099f68706f16defa3e97e5d8ea761b94ec79c708584c', '2026-07-21 12:25:43'),
(225, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '39d7223b3946803e5e50099f68706f16defa3e97e5d8ea761b94ec79c708584c', '7f06cb62ef403b67537d523ebd0507e3450a3186d04f979b8e82dae1f530a104', '2026-07-21 12:27:10'),
(226, 1, 'LOGOUT', 'users', 1, '[]', '::1', '7f06cb62ef403b67537d523ebd0507e3450a3186d04f979b8e82dae1f530a104', '6d604ba0b31bbbe0eba6a6149f881fa5ebc8bc0f77f0f6f7ef717018e1a11930', '2026-07-21 12:27:24'),
(227, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', '6d604ba0b31bbbe0eba6a6149f881fa5ebc8bc0f77f0f6f7ef717018e1a11930', 'aabdfc47260a0bcd5dfdc25442187d28bc8043dd8263cef0c52da5e0ed66ef88', '2026-07-21 12:29:26'),
(228, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'aabdfc47260a0bcd5dfdc25442187d28bc8043dd8263cef0c52da5e0ed66ef88', 'fd36f68c48158619ba721d48095d86e3116f3f565aec0f5e5e8049fa077d333f', '2026-07-21 12:30:54'),
(229, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'fd36f68c48158619ba721d48095d86e3116f3f565aec0f5e5e8049fa077d333f', 'bdfe5ca6f5e24eba3ed91edf545d1cb2f8f08641e825a1f32db9a64dcae7f4ed', '2026-07-21 12:32:26'),
(230, 1, 'LOGOUT', 'users', 1, '[]', '::1', 'bdfe5ca6f5e24eba3ed91edf545d1cb2f8f08641e825a1f32db9a64dcae7f4ed', 'd2d64c109bef62779224594c1a61c3511350b9503134ade586e07b808b5d4084', '2026-07-21 12:34:55'),
(231, 2, 'LOGIN_FAILED', 'users', 2, '{\"id_number\":\"1-210213A\"}', '::1', 'd2d64c109bef62779224594c1a61c3511350b9503134ade586e07b808b5d4084', '71d8dcccec02b0b681bc92f21e3bdab14abca5134b6a784ad089787e494a91e2', '2026-07-21 12:35:06'),
(232, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '71d8dcccec02b0b681bc92f21e3bdab14abca5134b6a784ad089787e494a91e2', '7f2354326db74a4ba29b02b951396f4ba89e91350346e8f9b664e5ec12837c21', '2026-07-21 12:35:13'),
(233, 2, 'LOGOUT', 'users', 2, '[]', '::1', '7f2354326db74a4ba29b02b951396f4ba89e91350346e8f9b664e5ec12837c21', 'ab69f03836ddcd150dc2a248f24a05f1eae001d20b83bd47174f7b988f19b712', '2026-07-21 12:40:26'),
(234, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '::1', 'ab69f03836ddcd150dc2a248f24a05f1eae001d20b83bd47174f7b988f19b712', '4e2f2e1296c737847402c089376dd813a63a3e8926512286f2b61b62a4bc00ab', '2026-07-21 12:40:33'),
(235, 2, 'LOGIN_FAILED', 'users', 2, '{\"id_number\":\"1-210213A\"}', '::1', '4e2f2e1296c737847402c089376dd813a63a3e8926512286f2b61b62a4bc00ab', 'a778f4b1a289836f2f6f9157c02867e80ce5626551be8da73cc56b85565c5fcc', '2026-07-21 12:41:18'),
(236, 2, 'LOGIN_FAILED', 'users', 2, '{\"id_number\":\"1-210213A\"}', '::1', 'a778f4b1a289836f2f6f9157c02867e80ce5626551be8da73cc56b85565c5fcc', '03358f0c6e5ee9d3e29e0f9d3e360acaaa7144f4793def4f04615283fa3ce72b', '2026-07-21 12:41:22'),
(237, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '03358f0c6e5ee9d3e29e0f9d3e360acaaa7144f4793def4f04615283fa3ce72b', '1da21e1c82352cb7cf4c959c76dda83569e9b603ed66ad2f304c7f15d37c5f30', '2026-07-21 12:41:23'),
(238, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '1da21e1c82352cb7cf4c959c76dda83569e9b603ed66ad2f304c7f15d37c5f30', '5226b9a71d37d05a1a7ff7745377d8302274f57f7b1b36a31dcc20d80ed3e113', '2026-07-21 12:41:36'),
(239, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"432\"}', '::1', '5226b9a71d37d05a1a7ff7745377d8302274f57f7b1b36a31dcc20d80ed3e113', '4b23688e548ab43eb2686ce6279a521a8bc71f3da059a6397f698d921c5aa22c', '2026-07-21 12:41:36');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(240, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '4b23688e548ab43eb2686ce6279a521a8bc71f3da059a6397f698d921c5aa22c', '38cbfb923a3e48ecf451485e11ccb42d491c182010314521b015d16f933ca8cd', '2026-07-21 12:41:36'),
(241, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '38cbfb923a3e48ecf451485e11ccb42d491c182010314521b015d16f933ca8cd', '3ddf6e9ea722ae3a8ff640d0659dfb640914b26640931bf7d2fb0d769f49cb88', '2026-07-21 12:41:36'),
(242, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '3ddf6e9ea722ae3a8ff640d0659dfb640914b26640931bf7d2fb0d769f49cb88', '0049a9ff772660b96f86d2f300ce03c555a6dfaf20ce207b6457663888011ed7', '2026-07-21 12:41:36'),
(243, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '0049a9ff772660b96f86d2f300ce03c555a6dfaf20ce207b6457663888011ed7', '6ef323dcccf1ce8859d56add43eeeb782ada8ddf43040f5b1f925af3f970decf', '2026-07-21 12:41:36'),
(244, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '6ef323dcccf1ce8859d56add43eeeb782ada8ddf43040f5b1f925af3f970decf', '68a638ab362fc95f8d52ae6dc3ea2d20dfffc5b0a76bb0edc333f8fef0a2e315', '2026-07-21 12:41:39'),
(245, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"432\"}', '::1', '68a638ab362fc95f8d52ae6dc3ea2d20dfffc5b0a76bb0edc333f8fef0a2e315', '0d68af0a65e82c37f4796a8b731fa55e8e18d8b4fb0f5308bfbaf37248afd457', '2026-07-21 12:41:39'),
(246, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '0d68af0a65e82c37f4796a8b731fa55e8e18d8b4fb0f5308bfbaf37248afd457', 'b3803314a5369a99dcb8208190fc98d7fc3a6cabe96930f9cc71dc2f536ae084', '2026-07-21 12:41:39'),
(247, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'b3803314a5369a99dcb8208190fc98d7fc3a6cabe96930f9cc71dc2f536ae084', 'acec1be5d79ba99e9c63e1f60f6f4d39334df57fea2935b91410ea54ec96abb1', '2026-07-21 12:41:39'),
(248, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'acec1be5d79ba99e9c63e1f60f6f4d39334df57fea2935b91410ea54ec96abb1', '49bdb93614b45ddc8add1c15dde91bbb1a390ec5eb08081168df8304ec190bc1', '2026-07-21 12:41:39'),
(249, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '49bdb93614b45ddc8add1c15dde91bbb1a390ec5eb08081168df8304ec190bc1', 'a0d596dfbd6e2472711e516d547adcf9753ad54ef97e6471319678b32c7a45d8', '2026-07-21 12:41:39'),
(250, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'a0d596dfbd6e2472711e516d547adcf9753ad54ef97e6471319678b32c7a45d8', '007676605c687a06bc0a4f2f47369bfa44c93a78cbf6bec621df2eaee764b504', '2026-07-21 12:41:47'),
(251, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', '007676605c687a06bc0a4f2f47369bfa44c93a78cbf6bec621df2eaee764b504', '588a1b43cede8f307e4c9f84dd7058e218442ecd397929203654798815fbc13f', '2026-07-21 12:41:47'),
(252, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '588a1b43cede8f307e4c9f84dd7058e218442ecd397929203654798815fbc13f', '5d4f92a82d488209608655cb80a0309be02124efbf8d7a3cc802370a17c64734', '2026-07-21 12:41:47'),
(253, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '5d4f92a82d488209608655cb80a0309be02124efbf8d7a3cc802370a17c64734', '4cd026137bfd3b7fe60984dc40ed72572e5f51ebc56bb3d32734c253d9821722', '2026-07-21 12:41:47'),
(254, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '4cd026137bfd3b7fe60984dc40ed72572e5f51ebc56bb3d32734c253d9821722', '09b5b060d24a872de7c570748dff3f57c4041525427e2eadf6708660b41cb3ac', '2026-07-21 12:41:47'),
(255, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '09b5b060d24a872de7c570748dff3f57c4041525427e2eadf6708660b41cb3ac', 'f30d558f59ff8f46d1bbc88b28a12910abcb3312693ec97086167396d2d55eaa', '2026-07-21 12:41:47'),
(256, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'f30d558f59ff8f46d1bbc88b28a12910abcb3312693ec97086167396d2d55eaa', 'dc7e45996f6da34920a2ba838c538a53101a3968e29880a764103df25c2cde89', '2026-07-21 12:41:50'),
(257, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', 'dc7e45996f6da34920a2ba838c538a53101a3968e29880a764103df25c2cde89', '942b45d743404b6252aabbcf2bacc3baa9e5075d78dfacbf6e5d41e69304de25', '2026-07-21 12:41:50'),
(258, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '942b45d743404b6252aabbcf2bacc3baa9e5075d78dfacbf6e5d41e69304de25', '06da4508461e6ce63883ab04240368cb8e2e0dc80c707d37464b1940a4e14ec9', '2026-07-21 12:41:50'),
(259, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '06da4508461e6ce63883ab04240368cb8e2e0dc80c707d37464b1940a4e14ec9', 'e13205de5f072778cde6aaacf2e7bc731e40425d1e744bb0f5c0a5f761ee7bc4', '2026-07-21 12:41:50'),
(260, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'e13205de5f072778cde6aaacf2e7bc731e40425d1e744bb0f5c0a5f761ee7bc4', 'dab290ac966b81f5980d6cc84d1809a8ddd2a76bc0e37e088b19c770c371e15e', '2026-07-21 12:41:50'),
(261, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'dab290ac966b81f5980d6cc84d1809a8ddd2a76bc0e37e088b19c770c371e15e', '81edcc634a277c264ba5a7efa4ae97da4a2658da4109095be521d566a60bdab7', '2026-07-21 12:41:50'),
(262, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '81edcc634a277c264ba5a7efa4ae97da4a2658da4109095be521d566a60bdab7', 'bff6f9f892e0e61816e963367fc5fe6d42473830ae31f9c6e22e8ee2d0cc7762', '2026-07-21 12:42:24'),
(263, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', 'bff6f9f892e0e61816e963367fc5fe6d42473830ae31f9c6e22e8ee2d0cc7762', 'ce51b2be73ddae95a11e36f087201fdb9a3526b08e7a11d57061a15b4b278b26', '2026-07-21 12:42:24'),
(264, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'ce51b2be73ddae95a11e36f087201fdb9a3526b08e7a11d57061a15b4b278b26', 'c948ce2e69d1c3e21448489c5acf997784dfd2fa3eb8ae692e0d67ae3bec34be', '2026-07-21 12:42:24'),
(265, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'c948ce2e69d1c3e21448489c5acf997784dfd2fa3eb8ae692e0d67ae3bec34be', 'df73d1454f4aba9cf8f99abd41544a121c3b42b8d99e6478d1baceea1fc6f798', '2026-07-21 12:42:24'),
(266, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'df73d1454f4aba9cf8f99abd41544a121c3b42b8d99e6478d1baceea1fc6f798', '5fd1e91ea02d879aacf76d4d361dc1b41181c5cc224deb02e658203b55fc0351', '2026-07-21 12:42:24'),
(267, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '5fd1e91ea02d879aacf76d4d361dc1b41181c5cc224deb02e658203b55fc0351', 'd1c1edbb6e04b888ef4edc41a7c747b4af27cf19bdc187f3b36d547d4ac2876e', '2026-07-21 12:42:24'),
(268, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 132, '{\"work_date\":\"2026-07-01\"}', '::1', 'd1c1edbb6e04b888ef4edc41a7c747b4af27cf19bdc187f3b36d547d4ac2876e', '8b68534a3052b9d1659eebdc078496e60b919b9c5aa65b8bcb3f5b3ad99e3b74', '2026-07-21 13:05:33'),
(269, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 133, '{\"work_date\":\"2026-07-02\"}', '::1', '8b68534a3052b9d1659eebdc078496e60b919b9c5aa65b8bcb3f5b3ad99e3b74', 'c0a40a46e0e63d6c0168ad2d13dd4f9369e3ddcbe7916544f84010ff4d9193ed', '2026-07-21 13:05:33'),
(270, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 134, '{\"work_date\":\"2026-07-03\"}', '::1', 'c0a40a46e0e63d6c0168ad2d13dd4f9369e3ddcbe7916544f84010ff4d9193ed', '921d98b2690afcb9e0def5b6bebb1233fab1ab449ae5a3f2aa9e77eb3f9f5805', '2026-07-21 13:05:33'),
(271, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 135, '{\"work_date\":\"2026-07-06\"}', '::1', '921d98b2690afcb9e0def5b6bebb1233fab1ab449ae5a3f2aa9e77eb3f9f5805', '4e3f5b8a56de0c302c3a990913fedbc6cd5613df8ae59fcf8d4d0b24202e69ec', '2026-07-21 13:05:33'),
(272, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 136, '{\"work_date\":\"2026-07-07\"}', '::1', '4e3f5b8a56de0c302c3a990913fedbc6cd5613df8ae59fcf8d4d0b24202e69ec', 'f5a6553e7f50c048bb2049dff8d59a7f2686e5c41dae6c144296f9715b527b2c', '2026-07-21 13:05:33'),
(273, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 137, '{\"work_date\":\"2026-07-08\"}', '::1', 'f5a6553e7f50c048bb2049dff8d59a7f2686e5c41dae6c144296f9715b527b2c', 'd5f524755c92ba4cebb821b6bc19b717a4ef966f5aa46ec12ffa659a6787e13f', '2026-07-21 13:05:33'),
(274, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 138, '{\"work_date\":\"2026-07-09\"}', '::1', 'd5f524755c92ba4cebb821b6bc19b717a4ef966f5aa46ec12ffa659a6787e13f', '75c2d1efcbefb671aaa5b1ae2acf3075a5954085ebf0ff71d9370489c1f16d55', '2026-07-21 13:05:33'),
(275, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 139, '{\"work_date\":\"2026-07-10\"}', '::1', '75c2d1efcbefb671aaa5b1ae2acf3075a5954085ebf0ff71d9370489c1f16d55', '82c5747849e4b15ee9beafbd7ef585560974fb566c6dd870608265170ba51a6c', '2026-07-21 13:05:33'),
(276, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 140, '{\"work_date\":\"2026-07-13\"}', '::1', '82c5747849e4b15ee9beafbd7ef585560974fb566c6dd870608265170ba51a6c', 'bdbef08c2e461d6dab518f6b8c895e3aa37fcc466448540f962361ecc8b3b58d', '2026-07-21 13:05:33'),
(277, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 141, '{\"work_date\":\"2026-07-14\"}', '::1', 'bdbef08c2e461d6dab518f6b8c895e3aa37fcc466448540f962361ecc8b3b58d', '74d2ec44e91c56f57995c15da5be94bc90cf214d609491f3278d03957efe15ab', '2026-07-21 13:05:33'),
(278, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 142, '{\"work_date\":\"2026-07-15\"}', '::1', '74d2ec44e91c56f57995c15da5be94bc90cf214d609491f3278d03957efe15ab', 'd34941297b45019622d695eb0c178d0af6f5ed3ac1515637f9086198297fea1e', '2026-07-21 13:05:33'),
(279, 2, 'LOGOUT', 'users', 2, '[]', '::1', 'd34941297b45019622d695eb0c178d0af6f5ed3ac1515637f9086198297fea1e', '511f243a1ce01d00fa9fcee0f8c5c41baa99ac2d16ccec2788d7388f2fee4f14', '2026-07-21 13:08:48'),
(280, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', '511f243a1ce01d00fa9fcee0f8c5c41baa99ac2d16ccec2788d7388f2fee4f14', 'd533f4e99591610cc758bfd3849985bc403b20fced3af5b96e7471dfe960c574', '2026-07-21 13:08:54'),
(281, 2, 'OT_CASHOUT_DELETED', 'ot_cashouts', 7, '{\"was_for_user_id\":6,\"hours_requested\":\"72.00\",\"status_before_delete\":\"rejected\"}', '::1', 'd533f4e99591610cc758bfd3849985bc403b20fced3af5b96e7471dfe960c574', '1786320dfbfb85dc520c78599334c2dd050c5210238a84a92c1cd8ea92078e82', '2026-07-21 15:41:24'),
(282, 2, 'ALL_OT_CASHOUTS_DELETED', 'ot_cashouts', 0, '{\"count_deleted\":6}', '::1', '1786320dfbfb85dc520c78599334c2dd050c5210238a84a92c1cd8ea92078e82', '3113d24d5d97acd2e7b423fc5bd6cdd3b6c0db4c12a2ae457e21d950c789d673', '2026-07-21 15:46:16'),
(283, 2, 'DTR_ENTRY_DELETED', 'dtr_entries', 142, '{\"was_for_user_id\":1,\"work_date\":\"2026-07-15\",\"time_in\":\"2026-07-15 06:30:00\",\"time_out\":\"2026-07-15 20:00:00\"}', '::1', '3113d24d5d97acd2e7b423fc5bd6cdd3b6c0db4c12a2ae457e21d950c789d673', '719b6f7be5f2000879637725e4b6a073f0180d75bc034cd0b94d23f85b17dd90', '2026-07-21 15:48:07'),
(284, 2, 'DTR_APPROVED', 'dtr_entries', 132, '{\"for_user_id\":1}', '::1', '719b6f7be5f2000879637725e4b6a073f0180d75bc034cd0b94d23f85b17dd90', 'f5bfd27930f5de56c5dc0f5a2579d82cbe6dc48eb54c6001ed0f83d88534e673', '2026-07-21 15:48:46'),
(285, 2, 'DTR_APPROVED', 'dtr_entries', 133, '{\"for_user_id\":1}', '::1', 'f5bfd27930f5de56c5dc0f5a2579d82cbe6dc48eb54c6001ed0f83d88534e673', 'e69c71c7abb90fa1d1810d1a18733288752252f28ad3e28c2d62f8b275a7bb06', '2026-07-21 15:48:47'),
(286, 2, 'DTR_APPROVED', 'dtr_entries', 134, '{\"for_user_id\":1}', '::1', 'e69c71c7abb90fa1d1810d1a18733288752252f28ad3e28c2d62f8b275a7bb06', 'ff9805cdd7938d79846efa64e3b91eeaea40b4680084c85b1d9dbd499ea6ec29', '2026-07-21 15:48:47'),
(287, 2, 'DTR_APPROVED', 'dtr_entries', 135, '{\"for_user_id\":1}', '::1', 'ff9805cdd7938d79846efa64e3b91eeaea40b4680084c85b1d9dbd499ea6ec29', 'afc3d0ce8e1d7c732870530ce7b32275beadba7d762018f45ecdbbad55b40343', '2026-07-21 15:48:47'),
(288, 2, 'DTR_APPROVED', 'dtr_entries', 136, '{\"for_user_id\":1}', '::1', 'afc3d0ce8e1d7c732870530ce7b32275beadba7d762018f45ecdbbad55b40343', '2e63d55f90635be0411103090f9a120107a54838af4afa49f8593132973a8f0e', '2026-07-21 15:48:47'),
(289, 2, 'DTR_APPROVED', 'dtr_entries', 137, '{\"for_user_id\":1}', '::1', '2e63d55f90635be0411103090f9a120107a54838af4afa49f8593132973a8f0e', '21aec57c486b26738f22c8700dad89c5482d043b0ba4e1bbc6ae8d75ca8a82d3', '2026-07-21 15:48:47'),
(290, 2, 'DTR_APPROVED', 'dtr_entries', 138, '{\"for_user_id\":1}', '::1', '21aec57c486b26738f22c8700dad89c5482d043b0ba4e1bbc6ae8d75ca8a82d3', '6a8ae8e10b1ad66f36f420fb11415cfe545b34943a4755a2213371342979f7fd', '2026-07-21 15:48:47'),
(291, 2, 'DTR_APPROVED', 'dtr_entries', 139, '{\"for_user_id\":1}', '::1', '6a8ae8e10b1ad66f36f420fb11415cfe545b34943a4755a2213371342979f7fd', '227867bfea47851aa867ba1c944ebb722a6a0ff69ac8c916cec82b3ce46a7f33', '2026-07-21 15:48:47'),
(292, 2, 'DTR_APPROVED', 'dtr_entries', 140, '{\"for_user_id\":1}', '::1', '227867bfea47851aa867ba1c944ebb722a6a0ff69ac8c916cec82b3ce46a7f33', '0fd1df3861bb3992709ee77099dffbba9c52ceb1cf5b5e14d7b5e243bf1e53a8', '2026-07-21 15:48:47'),
(293, 2, 'DTR_APPROVED', 'dtr_entries', 141, '{\"for_user_id\":1}', '::1', '0fd1df3861bb3992709ee77099dffbba9c52ceb1cf5b5e14d7b5e243bf1e53a8', '035576855e607974ae0b55ddef0b46fe5568adad705eae08b5cecdc434b0f807', '2026-07-21 15:48:47'),
(294, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 143, '{\"work_date\":\"2026-06-16\"}', '::1', '035576855e607974ae0b55ddef0b46fe5568adad705eae08b5cecdc434b0f807', '9192726a7ba90a4add3b8609ebbd26e35de3460f073b4720213613ca65194fd5', '2026-07-21 15:53:49'),
(295, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 144, '{\"work_date\":\"2026-06-17\"}', '::1', '9192726a7ba90a4add3b8609ebbd26e35de3460f073b4720213613ca65194fd5', 'd232de5c37c1c0d8545e8810fbfe8929b550236ec2f44c52112df2711bf77d00', '2026-07-21 15:53:49'),
(296, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 145, '{\"work_date\":\"2026-06-18\"}', '::1', 'd232de5c37c1c0d8545e8810fbfe8929b550236ec2f44c52112df2711bf77d00', '59fcdf642518e3171ca005fa7b09d5a9ad9644dcc5a66f05db71657a104110e9', '2026-07-21 15:53:49'),
(297, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 146, '{\"work_date\":\"2026-06-19\"}', '::1', '59fcdf642518e3171ca005fa7b09d5a9ad9644dcc5a66f05db71657a104110e9', '6e7611762dd8dc2b3b972b88756791f6b35e714c3bbf0fdc79c2d37f7dab9d80', '2026-07-21 15:53:50'),
(298, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 147, '{\"work_date\":\"2026-06-21\"}', '::1', '6e7611762dd8dc2b3b972b88756791f6b35e714c3bbf0fdc79c2d37f7dab9d80', 'c6c1a754f9a6d2e7441d69b37d8eae8bfcae76147d0caeb266a45ce78e385664', '2026-07-21 15:53:50'),
(299, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 148, '{\"work_date\":\"2026-06-22\"}', '::1', 'c6c1a754f9a6d2e7441d69b37d8eae8bfcae76147d0caeb266a45ce78e385664', '12e6ac928994ec95984c384ab38f2baae1197d31e822eabaad9977f059e8cdcb', '2026-07-21 15:53:50'),
(300, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 149, '{\"work_date\":\"2026-06-23\"}', '::1', '12e6ac928994ec95984c384ab38f2baae1197d31e822eabaad9977f059e8cdcb', '34d06993f2cb4cf1b2d3aac634390d915e78ca06cfc2c13541b45538766bee4c', '2026-07-21 15:53:50'),
(301, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 150, '{\"work_date\":\"2026-06-24\"}', '::1', '34d06993f2cb4cf1b2d3aac634390d915e78ca06cfc2c13541b45538766bee4c', '0fb042f71ccaaf60184514f316f4debd861c15a07ffbbdef4242cd169af41ae5', '2026-07-21 15:53:50'),
(302, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 151, '{\"work_date\":\"2026-06-25\"}', '::1', '0fb042f71ccaaf60184514f316f4debd861c15a07ffbbdef4242cd169af41ae5', 'b929d8f89a3a83498b99c5b4dd1ab72989dbdc6487f7d75250b76a1d6ffba303', '2026-07-21 15:53:50'),
(303, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 152, '{\"work_date\":\"2026-06-26\"}', '::1', 'b929d8f89a3a83498b99c5b4dd1ab72989dbdc6487f7d75250b76a1d6ffba303', '0f1a9f385e519a6a18993dc215beeabd5afe6825ea1eb18cee45682aee91641c', '2026-07-21 15:53:50'),
(304, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 153, '{\"work_date\":\"2026-06-29\"}', '::1', '0f1a9f385e519a6a18993dc215beeabd5afe6825ea1eb18cee45682aee91641c', '59d72dd7ca795ff52e0146acd3a59c39643a23a0227eb1d30f5ed097f22ece44', '2026-07-21 15:53:50'),
(305, 1, 'DTR_SELF_SUBMITTED', 'dtr_entries', 154, '{\"work_date\":\"2026-06-30\"}', '::1', '59d72dd7ca795ff52e0146acd3a59c39643a23a0227eb1d30f5ed097f22ece44', '917931629d29e392c6abf9678f49dc894a4a515ac0d616c395daa802b643aab0', '2026-07-21 15:53:50'),
(306, 2, 'DTR_APPROVED', 'dtr_entries', 145, '{\"for_user_id\":1}', '::1', '917931629d29e392c6abf9678f49dc894a4a515ac0d616c395daa802b643aab0', 'b742bb51317e0169ac26e6a3aac18b50f086b6368c170209aa6c197533d0e632', '2026-07-21 15:55:14'),
(307, 2, 'DTR_APPROVED', 'dtr_entries', 144, '{\"for_user_id\":1}', '::1', 'b742bb51317e0169ac26e6a3aac18b50f086b6368c170209aa6c197533d0e632', '46f82e5e162dc872cf58ae4231cb7c754ea3d55589b358b35170f22c4c3f3bb3', '2026-07-21 15:55:14'),
(308, 2, 'DTR_APPROVED', 'dtr_entries', 143, '{\"for_user_id\":1}', '::1', '46f82e5e162dc872cf58ae4231cb7c754ea3d55589b358b35170f22c4c3f3bb3', '3aa33eb0302c54bab2ea867fa96d8cda4cd17483483c707bc4b58511db203be4', '2026-07-21 15:55:14'),
(309, 2, 'DTR_APPROVED', 'dtr_entries', 146, '{\"for_user_id\":1}', '::1', '3aa33eb0302c54bab2ea867fa96d8cda4cd17483483c707bc4b58511db203be4', '56c45abe82de04893273b967935d5bd69d5d960597128a520d800fcaffd5a573', '2026-07-21 15:55:14'),
(310, 2, 'DTR_APPROVED', 'dtr_entries', 151, '{\"for_user_id\":1}', '::1', '56c45abe82de04893273b967935d5bd69d5d960597128a520d800fcaffd5a573', 'f85783229a98acf2bfe77578ba6ec81e88ae36bc8ff3b910b93722f005a04b0c', '2026-07-21 15:55:14'),
(311, 2, 'DTR_APPROVED', 'dtr_entries', 150, '{\"for_user_id\":1}', '::1', 'f85783229a98acf2bfe77578ba6ec81e88ae36bc8ff3b910b93722f005a04b0c', '9c8f1e74c7a02ab81ff240e94e0d053cdab24bc7b2f7fc24561efbff25b5b5bf', '2026-07-21 15:55:14'),
(312, 2, 'DTR_APPROVED', 'dtr_entries', 149, '{\"for_user_id\":1}', '::1', '9c8f1e74c7a02ab81ff240e94e0d053cdab24bc7b2f7fc24561efbff25b5b5bf', '9d86488ca9693e96dea7a073e76d7f242318b00a00ea6e27dc8daf7915788ecb', '2026-07-21 15:55:14'),
(313, 2, 'DTR_APPROVED', 'dtr_entries', 154, '{\"for_user_id\":1}', '::1', '9d86488ca9693e96dea7a073e76d7f242318b00a00ea6e27dc8daf7915788ecb', '33b606c84dadf88035531c168b40c5f65ecaf6fde8bb04ac13b093a2af9778f5', '2026-07-21 15:55:14'),
(314, 2, 'DTR_APPROVED', 'dtr_entries', 148, '{\"for_user_id\":1}', '::1', '33b606c84dadf88035531c168b40c5f65ecaf6fde8bb04ac13b093a2af9778f5', '3a5a3b0ebbe9a41b52df85b40eaecf569b4706024573f0e548162df9af1031a3', '2026-07-21 15:55:14'),
(315, 2, 'DTR_APPROVED', 'dtr_entries', 153, '{\"for_user_id\":1}', '::1', '3a5a3b0ebbe9a41b52df85b40eaecf569b4706024573f0e548162df9af1031a3', 'b09ac486a72c4000671c5446a8329b8d880b3ceb0fd8b727088a10cee4dbab15', '2026-07-21 15:55:14'),
(316, 2, 'DTR_APPROVED', 'dtr_entries', 147, '{\"for_user_id\":1}', '::1', 'b09ac486a72c4000671c5446a8329b8d880b3ceb0fd8b727088a10cee4dbab15', 'a1c17e080e603f6939aec1f76d930e10e8453985e9522b1a03ea1eefc9b90058', '2026-07-21 15:55:14');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(317, 2, 'DTR_APPROVED', 'dtr_entries', 152, '{\"for_user_id\":1}', '::1', 'a1c17e080e603f6939aec1f76d930e10e8453985e9522b1a03ea1eefc9b90058', '46004533e3493d25c2f79115653bbdbaf09675fbd567d3116bd051c0b0dde286', '2026-07-21 15:55:14'),
(318, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '46004533e3493d25c2f79115653bbdbaf09675fbd567d3116bd051c0b0dde286', 'a5bba12e66c5b410c8ff8392b85949c8b8c7d3dfdfa800c6b97c0768d9b255ee', '2026-07-21 15:56:06'),
(319, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', 'a5bba12e66c5b410c8ff8392b85949c8b8c7d3dfdfa800c6b97c0768d9b255ee', 'd7daaaba21f1faebe98c66b1b083be68f4f03545bfe490ce34f80a0714b3a23a', '2026-07-21 15:56:06'),
(320, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'd7daaaba21f1faebe98c66b1b083be68f4f03545bfe490ce34f80a0714b3a23a', 'ac4213c5fec53f527b878af171c969368f3968bc397a082e40cea90f6c89eb6a', '2026-07-21 15:56:06'),
(321, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'ac4213c5fec53f527b878af171c969368f3968bc397a082e40cea90f6c89eb6a', '5b5831e087ef90e978dad0149230488b0dff5909ebe727e93afd3c9d2143de1e', '2026-07-21 15:56:06'),
(322, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '5b5831e087ef90e978dad0149230488b0dff5909ebe727e93afd3c9d2143de1e', '272dbebf2ae777c53344fbd2f65af5fa91ba7c121dc7db5e8a74968301013f64', '2026-07-21 15:56:06'),
(323, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '272dbebf2ae777c53344fbd2f65af5fa91ba7c121dc7db5e8a74968301013f64', 'ada869328ef409e341aec3325ceb118dcf888302f6c2dc0e7f45408d539d135d', '2026-07-21 15:56:06'),
(324, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'ada869328ef409e341aec3325ceb118dcf888302f6c2dc0e7f45408d539d135d', 'e317cae5faf8539ad352b7b355cb8fc49c990c45745168d451308855cbabf9fb', '2026-07-21 15:56:12'),
(325, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', 'e317cae5faf8539ad352b7b355cb8fc49c990c45745168d451308855cbabf9fb', '8c9066b3c63efb0c775d0d7052821931fdc1b89fea4b5608ebe7f1e2c8bcb78b', '2026-07-21 15:56:12'),
(326, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '8c9066b3c63efb0c775d0d7052821931fdc1b89fea4b5608ebe7f1e2c8bcb78b', '6b313a1fe33563b03de0c119ac85d8b5bdbdfd5e539d95896843b107fd11c5b7', '2026-07-21 15:56:12'),
(327, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '6b313a1fe33563b03de0c119ac85d8b5bdbdfd5e539d95896843b107fd11c5b7', '6951526da74d98d3ce82c11af8078dd271937e04955137494f3dfb5f3341ed5d', '2026-07-21 15:56:12'),
(328, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '6951526da74d98d3ce82c11af8078dd271937e04955137494f3dfb5f3341ed5d', '28d96ef39667db9eff3b6b3408a0b40e8a63bfe21ef65db68e0bb36f2726eedb', '2026-07-21 15:56:12'),
(329, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '28d96ef39667db9eff3b6b3408a0b40e8a63bfe21ef65db68e0bb36f2726eedb', 'f28d4a56878f42517c30ce891c7cd61f615f22a45584a29af1dfd17391639d03', '2026-07-21 15:56:12'),
(330, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'f28d4a56878f42517c30ce891c7cd61f615f22a45584a29af1dfd17391639d03', '8fa4d433076b3027a79d572dadbac98493264cc87eff1a06de3a6f0e7351609a', '2026-07-21 16:02:31'),
(331, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '8fa4d433076b3027a79d572dadbac98493264cc87eff1a06de3a6f0e7351609a', 'ccc76a67cb13480dada69aa77f38c7d6325380932377e139bbfd6edf73937bfc', '2026-07-21 16:02:31'),
(332, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'ccc76a67cb13480dada69aa77f38c7d6325380932377e139bbfd6edf73937bfc', 'd5d569952d04c3ec5d9f666b523c8ae1f233fb60b19888f6f289a289ac40d48b', '2026-07-21 16:02:31'),
(333, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'd5d569952d04c3ec5d9f666b523c8ae1f233fb60b19888f6f289a289ac40d48b', 'bb6154680d5613ae9077392fbc887164905bceb31b03c5037d0c37d11a3976dd', '2026-07-21 16:02:31'),
(334, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'bb6154680d5613ae9077392fbc887164905bceb31b03c5037d0c37d11a3976dd', '33495563d9c79c35da81cb88e27660b2577142e132f3352dbee769ee2913888e', '2026-07-21 16:02:31'),
(335, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '33495563d9c79c35da81cb88e27660b2577142e132f3352dbee769ee2913888e', 'af77d191c019cb62cd996e92f11cfd9a8ba38476506b611bbfda5d38346e1e9c', '2026-07-21 16:02:31'),
(336, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 8, '{\"hours\":25.5}', '::1', 'af77d191c019cb62cd996e92f11cfd9a8ba38476506b611bbfda5d38346e1e9c', 'fd4503be19a7d89614201775a243c609665780412c9c02cd348c0bce21b6bbc5', '2026-07-21 16:26:19'),
(337, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 8, '{\"status\":\"approved\"}', '::1', 'fd4503be19a7d89614201775a243c609665780412c9c02cd348c0bce21b6bbc5', 'f5bcdcbfd7d097cda6858d74518ffb0a4b2b834a242f17d6e80723d4aed4221e', '2026-07-21 16:26:37'),
(338, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '::1', 'f5bcdcbfd7d097cda6858d74518ffb0a4b2b834a242f17d6e80723d4aed4221e', '396c305d614769a0f8e86a8fc545eba60b0bcd7157c2eaffe94c8a6c27a9cd16', '2026-07-21 16:38:09'),
(339, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '396c305d614769a0f8e86a8fc545eba60b0bcd7157c2eaffe94c8a6c27a9cd16', '3f5118cfd0510a1e92aa2ebb9857579e9ff10452bdca6ed166daf58c1f670404', '2026-07-21 16:52:13'),
(340, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '3f5118cfd0510a1e92aa2ebb9857579e9ff10452bdca6ed166daf58c1f670404', '0adf5f608c222e11d7d5ff4001fb9890d82ede26ddaef64452bed8cd779897fd', '2026-07-21 16:52:13'),
(341, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '0adf5f608c222e11d7d5ff4001fb9890d82ede26ddaef64452bed8cd779897fd', 'b35a1ad1504ad5425aefec42243d8f3d6ab7e996c4133e4b59b2ae9a4ee52f42', '2026-07-21 16:52:13'),
(342, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'b35a1ad1504ad5425aefec42243d8f3d6ab7e996c4133e4b59b2ae9a4ee52f42', '1b5b78babb196b986b8f418c28600d71fc85c1af97fc84c3d454e7957a84df8c', '2026-07-21 16:52:13'),
(343, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '1b5b78babb196b986b8f418c28600d71fc85c1af97fc84c3d454e7957a84df8c', '14631ec27edd30030802aa67c8431d7804d8577fd99982dd9b5be8346715fb21', '2026-07-21 16:52:13'),
(344, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '14631ec27edd30030802aa67c8431d7804d8577fd99982dd9b5be8346715fb21', '071951b7f8ef8a5aea46cba0f3995f5257f6019e98874f4c9572d819c850fcaa', '2026-07-21 16:52:13'),
(345, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '071951b7f8ef8a5aea46cba0f3995f5257f6019e98874f4c9572d819c850fcaa', '6d9bcfab10d9b15fc6946c047d1ff15586f43b0b333aa6f4b4ae96c132689c19', '2026-07-21 16:52:15'),
(346, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '6d9bcfab10d9b15fc6946c047d1ff15586f43b0b333aa6f4b4ae96c132689c19', 'e7e38fd9449956a010ff2b7d79616b2b74958efe3e80f4bab6fb25a1cbcf8c95', '2026-07-21 16:52:15'),
(347, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'e7e38fd9449956a010ff2b7d79616b2b74958efe3e80f4bab6fb25a1cbcf8c95', 'a4e9f63a475ae97b2e626fc3c7aff6eb10b7f715bd132dd2dea5cf2d8b873b73', '2026-07-21 16:52:15'),
(348, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'a4e9f63a475ae97b2e626fc3c7aff6eb10b7f715bd132dd2dea5cf2d8b873b73', 'aabc80834d704046f45c112c58393f6ff425fc694249268333c06bd8dc2d7cdc', '2026-07-21 16:52:15'),
(349, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'aabc80834d704046f45c112c58393f6ff425fc694249268333c06bd8dc2d7cdc', 'ec5774cc74d88f55dc0cd8071ed649c26473014b00885a53104f3ba4a7f39a68', '2026-07-21 16:52:15'),
(350, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'ec5774cc74d88f55dc0cd8071ed649c26473014b00885a53104f3ba4a7f39a68', 'a2333fc3a812b43da9f075dba53f07cfd0926ba927f67c53f7ff338bac3aa163', '2026-07-21 16:52:15'),
(351, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'a2333fc3a812b43da9f075dba53f07cfd0926ba927f67c53f7ff338bac3aa163', '61040d8a6621238b5913c883f47565e295e705cd79a4b53c19e856a0673950a9', '2026-07-21 16:52:18'),
(352, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '61040d8a6621238b5913c883f47565e295e705cd79a4b53c19e856a0673950a9', '49b8f33eda28b00e666d668ef6c6c10257ea894d25fd7b3d9b566a1bde4ebfb7', '2026-07-21 16:52:18'),
(353, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '49b8f33eda28b00e666d668ef6c6c10257ea894d25fd7b3d9b566a1bde4ebfb7', '5face730322832b7d4f0e6274f2c9b13cb5073fc277f92151b3346542d589839', '2026-07-21 16:52:18'),
(354, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '5face730322832b7d4f0e6274f2c9b13cb5073fc277f92151b3346542d589839', '3616a848eaafc491641795298ef37bb3f08c5c1a5727b0f8e06e97cd32aa27b4', '2026-07-21 16:52:18'),
(355, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '3616a848eaafc491641795298ef37bb3f08c5c1a5727b0f8e06e97cd32aa27b4', '9fe73465fc49b60be30c2e82791fdf30a853baa1bdeb7ef41519aaf5716bd3b4', '2026-07-21 16:52:18'),
(356, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '9fe73465fc49b60be30c2e82791fdf30a853baa1bdeb7ef41519aaf5716bd3b4', 'f7187fc488a628926d9ba6e9d3ed4203474854f10b07fe31f922b4d53e8b9d4d', '2026-07-21 16:52:18'),
(357, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'f7187fc488a628926d9ba6e9d3ed4203474854f10b07fe31f922b4d53e8b9d4d', '043c257dd676166b41c537b31251df7400cbc20a2a3bf1a1e862261d11f1d0ea', '2026-07-21 16:52:27'),
(358, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"50\"}', '::1', '043c257dd676166b41c537b31251df7400cbc20a2a3bf1a1e862261d11f1d0ea', 'b816f4f76a4503756d0ca42b3a09554d785c822eb3d43837c47b9c8fc25b5b96', '2026-07-21 16:52:27'),
(359, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'b816f4f76a4503756d0ca42b3a09554d785c822eb3d43837c47b9c8fc25b5b96', 'f88b9f946116c1a1f8bfa8fd94edc07a0b3a7baedc99ea505f86e438ea0dece9', '2026-07-21 16:52:27'),
(360, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'f88b9f946116c1a1f8bfa8fd94edc07a0b3a7baedc99ea505f86e438ea0dece9', '96e9438c4b5b22fa9afe219f60dc11252e2ae796e4f58a242322cd46afe07faf', '2026-07-21 16:52:27'),
(361, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '96e9438c4b5b22fa9afe219f60dc11252e2ae796e4f58a242322cd46afe07faf', '28e79e4256e4bcfa60b5c04fdd11f39e40e37a4a60374f0fa813f98459b2730a', '2026-07-21 16:52:27'),
(362, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '28e79e4256e4bcfa60b5c04fdd11f39e40e37a4a60374f0fa813f98459b2730a', '07284fc59352f6a97e936414f1843d408fba40ad25e7abfe429e9aed5d1e039d', '2026-07-21 16:52:27'),
(363, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '07284fc59352f6a97e936414f1843d408fba40ad25e7abfe429e9aed5d1e039d', '2300d1fb7eb8704c8ce3bff97f3697c39cc8b3a358a02e469d09f7cfcda1af5d', '2026-07-21 16:52:29'),
(364, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '2300d1fb7eb8704c8ce3bff97f3697c39cc8b3a358a02e469d09f7cfcda1af5d', '51c831c282331cd65280acf25c30db06a030f29a6a65367b39a05b19444b94d3', '2026-07-21 16:52:29'),
(365, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '51c831c282331cd65280acf25c30db06a030f29a6a65367b39a05b19444b94d3', '55954f962db27ee001c05d1be33639131e745633cc1b4f72ed26ab545456e487', '2026-07-21 16:52:29'),
(366, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '55954f962db27ee001c05d1be33639131e745633cc1b4f72ed26ab545456e487', 'd88a48131035e10df6e0b6be88bb271e4805a5380bef598b96e30be47fd083d5', '2026-07-21 16:52:29'),
(367, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'd88a48131035e10df6e0b6be88bb271e4805a5380bef598b96e30be47fd083d5', '7d4b2e506802b53c60274ddb2ad64ba7d7239b1c8fe94ec71a6e9aedc3d827a4', '2026-07-21 16:52:29'),
(368, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '7d4b2e506802b53c60274ddb2ad64ba7d7239b1c8fe94ec71a6e9aedc3d827a4', '39a586cb032143fb9ea7d8cd9e1566e2c7fedd51e7cac012e981a8d39f60ddca', '2026-07-21 16:52:29'),
(369, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '39a586cb032143fb9ea7d8cd9e1566e2c7fedd51e7cac012e981a8d39f60ddca', 'b7316d9bce9c951ffe8f98d5947fdbc8a4a5d91445d8389c0e126de9dc0f4f50', '2026-07-21 16:52:33'),
(370, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', 'b7316d9bce9c951ffe8f98d5947fdbc8a4a5d91445d8389c0e126de9dc0f4f50', '516c86e3d2b569a7393b3de37eae31c2f7e491c68cf5b8dfe272702c5c5867d8', '2026-07-21 16:52:33'),
(371, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '516c86e3d2b569a7393b3de37eae31c2f7e491c68cf5b8dfe272702c5c5867d8', '6606cb0292b4797a488be61adce305832e01b029c017102a72c6c4084b4e8f5b', '2026-07-21 16:52:33'),
(372, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '6606cb0292b4797a488be61adce305832e01b029c017102a72c6c4084b4e8f5b', '3b8615095daeafd7aec209632603510044b3e15057ec61bfed627d41cd5b41e9', '2026-07-21 16:52:33'),
(373, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '3b8615095daeafd7aec209632603510044b3e15057ec61bfed627d41cd5b41e9', '8fd2df0b2f439fd07760e404e630f7da1f517ec7d89ca830c7b06804b583ed38', '2026-07-21 16:52:33'),
(374, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '8fd2df0b2f439fd07760e404e630f7da1f517ec7d89ca830c7b06804b583ed38', '86782743a744dfdc70ba25c28333b82bdca68bc031b2478dc5132c82d64e44cc', '2026-07-21 16:52:33'),
(375, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '86782743a744dfdc70ba25c28333b82bdca68bc031b2478dc5132c82d64e44cc', 'f2a895edce58a38832a6a84cfbc2d21fa868b112e7a8b28f379bdbaac3bbcb41', '2026-07-21 16:52:41'),
(376, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', 'f2a895edce58a38832a6a84cfbc2d21fa868b112e7a8b28f379bdbaac3bbcb41', 'a3f4ff860742b0ca30737cdc0e30ee56de5e1bbe47ce05c8b39420181a3fff4e', '2026-07-21 16:52:41'),
(377, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'a3f4ff860742b0ca30737cdc0e30ee56de5e1bbe47ce05c8b39420181a3fff4e', 'df062dac4787a2533933214bf8285b96ea6269792df2d5091a7923b26d6cffab', '2026-07-21 16:52:41'),
(378, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'df062dac4787a2533933214bf8285b96ea6269792df2d5091a7923b26d6cffab', '36ae052089fb335430b5da114653eff3d9b4c2616cd5d2420ed244bc29e29ec2', '2026-07-21 16:52:41'),
(379, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '36ae052089fb335430b5da114653eff3d9b4c2616cd5d2420ed244bc29e29ec2', 'ed23f114108a123aa91d65c7ca7616e5c2e234f6e2ab41aa6133f4c8d2573ac7', '2026-07-21 16:52:41'),
(380, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'ed23f114108a123aa91d65c7ca7616e5c2e234f6e2ab41aa6133f4c8d2573ac7', '70d401b307b76ba0f60b596aac967f9bcaecaae269f20e532f4afc0c3f1714ac', '2026-07-21 16:52:41'),
(381, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '70d401b307b76ba0f60b596aac967f9bcaecaae269f20e532f4afc0c3f1714ac', 'ee5a82c6071d889b3b69165eb94e7a93c216f45581532854599a2ec3f9dc5676', '2026-07-21 16:52:45'),
(382, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"150\"}', '::1', 'ee5a82c6071d889b3b69165eb94e7a93c216f45581532854599a2ec3f9dc5676', '03d8750c3ff5da1d94f7407c9c06a78f29a8cfe4c6f8d93e5a2de3c04c7ee8a7', '2026-07-21 16:52:45'),
(383, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '03d8750c3ff5da1d94f7407c9c06a78f29a8cfe4c6f8d93e5a2de3c04c7ee8a7', '516c7c52af7bf8334ec24e7cf5c15749a838a0bfc112e069fac2b5a8c03c96ba', '2026-07-21 16:52:45'),
(384, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '516c7c52af7bf8334ec24e7cf5c15749a838a0bfc112e069fac2b5a8c03c96ba', 'e7c7669d4a16c84975c5f2fd0c6cc26c49bc37d91da162a0b424f417f2318b94', '2026-07-21 16:52:45'),
(385, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'e7c7669d4a16c84975c5f2fd0c6cc26c49bc37d91da162a0b424f417f2318b94', '136498ccd76e394d5d3f8e2d40726094e11f8098af6362dd04a60de853f762ef', '2026-07-21 16:52:45'),
(386, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '136498ccd76e394d5d3f8e2d40726094e11f8098af6362dd04a60de853f762ef', '4a8d5fc852b2f4be64f6afb4f3c43b9c9a9750bbaf82806f70609802d932eb62', '2026-07-21 16:52:45'),
(387, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '4a8d5fc852b2f4be64f6afb4f3c43b9c9a9750bbaf82806f70609802d932eb62', '9bac7e750560e069807e0e78395d7fb68ebce75950bff03155e57c7a7a19159a', '2026-07-21 16:52:52'),
(388, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"150\"}', '::1', '9bac7e750560e069807e0e78395d7fb68ebce75950bff03155e57c7a7a19159a', '42304b5e33b595489f3f1f378ae831847688cf792d43537051d04cc57b16d0b0', '2026-07-21 16:52:52');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(389, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '42304b5e33b595489f3f1f378ae831847688cf792d43537051d04cc57b16d0b0', '45ae27bc953e642e813a95be9007aee453d4b0d59429eb6d55cc08d9ccc51259', '2026-07-21 16:52:52'),
(390, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '45ae27bc953e642e813a95be9007aee453d4b0d59429eb6d55cc08d9ccc51259', '8eed9981b6d5d3588f9a885e46be3e21d8118f887d9a75ce3a36f2644fb8e43d', '2026-07-21 16:52:52'),
(391, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '8eed9981b6d5d3588f9a885e46be3e21d8118f887d9a75ce3a36f2644fb8e43d', '582c2272867a5aefc5dc62463ef2b2f709d56419220902bcce46f80b0ed5d37e', '2026-07-21 16:52:52'),
(392, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '582c2272867a5aefc5dc62463ef2b2f709d56419220902bcce46f80b0ed5d37e', 'e24f0d25f3b84e0ee7b6d93846a892ade83e4c4a8661774b863b82577e201171', '2026-07-21 16:52:52'),
(393, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'e24f0d25f3b84e0ee7b6d93846a892ade83e4c4a8661774b863b82577e201171', '42373a9ab5b657288f9c757ec615e8f89b75d2a9f794d7b02c7e0b9afe44a699', '2026-07-21 16:52:56'),
(394, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"150\"}', '::1', '42373a9ab5b657288f9c757ec615e8f89b75d2a9f794d7b02c7e0b9afe44a699', '03bab79ae934bd1e4b7a8f73c13d63059f35dc79b4484685111e034c59eeed7f', '2026-07-21 16:52:56'),
(395, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '03bab79ae934bd1e4b7a8f73c13d63059f35dc79b4484685111e034c59eeed7f', '5583afb02007484cefff87bf6a49a03c2ffd5ee2ece0f2c92dfa63ec1e5b6960', '2026-07-21 16:52:56'),
(396, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '5583afb02007484cefff87bf6a49a03c2ffd5ee2ece0f2c92dfa63ec1e5b6960', '0f2a371f7354a4861a65e30e01d9029fb95ced20a1f3b36947767e383ac1fc90', '2026-07-21 16:52:56'),
(397, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '0f2a371f7354a4861a65e30e01d9029fb95ced20a1f3b36947767e383ac1fc90', 'db9b9799c525e957d932d6a5f183df35cc06812af63636bf1c2d120198bc9480', '2026-07-21 16:52:56'),
(398, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'db9b9799c525e957d932d6a5f183df35cc06812af63636bf1c2d120198bc9480', 'cce1f406567c154ce378b5e6c7f49c885a881e3ef2af11711e58d6d123dd0ac7', '2026-07-21 16:52:56'),
(399, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'cce1f406567c154ce378b5e6c7f49c885a881e3ef2af11711e58d6d123dd0ac7', '7650aeca4435a25557acb49f06482aea78794d221af31ba2c9e32b9441184624', '2026-07-21 16:59:02'),
(400, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"150\"}', '::1', '7650aeca4435a25557acb49f06482aea78794d221af31ba2c9e32b9441184624', '55080700628dbd4dc9c51892abffb38bf7a65eb011d4525bb98d3969c136dcf9', '2026-07-21 16:59:02'),
(401, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '55080700628dbd4dc9c51892abffb38bf7a65eb011d4525bb98d3969c136dcf9', 'ece11b4506fc0396b088452971d864891b72ffaddd16d3921d2e56caec4d5715', '2026-07-21 16:59:02'),
(402, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'ece11b4506fc0396b088452971d864891b72ffaddd16d3921d2e56caec4d5715', 'bfde59615d8c6edf85bfb076139696015060adba9220ee1d4f2371a4c7cbbae8', '2026-07-21 16:59:02'),
(403, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'bfde59615d8c6edf85bfb076139696015060adba9220ee1d4f2371a4c7cbbae8', 'fb751d35197155c0edc2cce6603a2c5624ec9b4bf49ada7031d9fd9aaaa28d28', '2026-07-21 16:59:02'),
(404, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', 'fb751d35197155c0edc2cce6603a2c5624ec9b4bf49ada7031d9fd9aaaa28d28', '63e6fba2a86b1b3da0816e531098417974fb8d9242067496579d3c4f2039481d', '2026-07-21 16:59:02'),
(405, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 2, '{\"hours\":25.49}', '::1', '63e6fba2a86b1b3da0816e531098417974fb8d9242067496579d3c4f2039481d', '6106e049b6a5f1ef25571c786ad017e6868c087159cbaa3da2fcc45f8a24df6f', '2026-07-21 16:59:29'),
(406, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '6106e049b6a5f1ef25571c786ad017e6868c087159cbaa3da2fcc45f8a24df6f', '073a5cb3fd8cbe61d47945d08636929e96f4b9dc26c8601856b1dbc0edb41fd7', '2026-07-21 16:59:46'),
(407, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', '::1', '073a5cb3fd8cbe61d47945d08636929e96f4b9dc26c8601856b1dbc0edb41fd7', '758e7ba7904c2b1f04f751a8c9eb0f079dcf29609f9889ef6085814f2e5eaf6e', '2026-07-21 16:59:46'),
(408, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '758e7ba7904c2b1f04f751a8c9eb0f079dcf29609f9889ef6085814f2e5eaf6e', 'e59a37d34cb2938f5eed04d29a4f2e10423abfaf05523ffad804cebc206a888d', '2026-07-21 16:59:46'),
(409, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'e59a37d34cb2938f5eed04d29a4f2e10423abfaf05523ffad804cebc206a888d', 'd8a15cc364b76cb6af7e05011040e3f9c3d663369fcf6cd4df11f1f09229c9c1', '2026-07-21 16:59:46'),
(410, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'd8a15cc364b76cb6af7e05011040e3f9c3d663369fcf6cd4df11f1f09229c9c1', '49e4d62a88c2a426aef2fe5e15135fe2509a161d66d02c292557edeac41dec79', '2026-07-21 16:59:46'),
(411, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '49e4d62a88c2a426aef2fe5e15135fe2509a161d66d02c292557edeac41dec79', 'd07f38c3c5ea25fac5617de672e29f2abe1e26e35efb20ab95f5d54d8f9be844', '2026-07-21 16:59:46'),
(412, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 1, '{\"status\":\"rejected\"}', '::1', 'd07f38c3c5ea25fac5617de672e29f2abe1e26e35efb20ab95f5d54d8f9be844', 'ffeacebd875d066e5b4058c0ef9324e582d9f78811f84479e34c0f66d43f0831', '2026-07-21 17:00:11'),
(413, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 3, '{\"hours\":0.01}', '::1', 'ffeacebd875d066e5b4058c0ef9324e582d9f78811f84479e34c0f66d43f0831', 'a8019fdee7ae58e47081a9cf4335dc67a589ffc80a54121d56b9ebc94b619851', '2026-07-21 17:00:21'),
(414, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 2, '{\"status\":\"approved\"}', '::1', 'a8019fdee7ae58e47081a9cf4335dc67a589ffc80a54121d56b9ebc94b619851', '36abf0a2798a98dadd2865d8c5b79570df43f084943086825f9f100067f468ac', '2026-07-21 17:00:34'),
(415, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 3, '{\"status\":\"approved\"}', '::1', '36abf0a2798a98dadd2865d8c5b79570df43f084943086825f9f100067f468ac', '3edfe1be7c0ff697ed9f31e869965c89372a178f26fcdde0157e68351795699d', '2026-07-21 17:00:35'),
(416, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 4, '{\"hours\":0.01}', '::1', '3edfe1be7c0ff697ed9f31e869965c89372a178f26fcdde0157e68351795699d', '03076a2a852ef68c3e4c24bdf93f19181b8a199a7f084ae1210b6b81c833db81', '2026-07-21 17:02:35'),
(417, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 4, '{\"status\":\"rejected\"}', '::1', '03076a2a852ef68c3e4c24bdf93f19181b8a199a7f084ae1210b6b81c833db81', '501659a452a600e51aea029ece58a1d5aad47fdf3f3d6bc4beb7642ce947403b', '2026-07-21 17:02:59'),
(418, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 5, '{\"hours\":0.01}', '::1', '501659a452a600e51aea029ece58a1d5aad47fdf3f3d6bc4beb7642ce947403b', '1f90a7b578400d5c03d1f2ee90763c03c3722bd3bb2d95fe1cac90a336ca8df6', '2026-07-21 17:03:03'),
(419, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 5, '{\"status\":\"rejected\"}', '::1', '1f90a7b578400d5c03d1f2ee90763c03c3722bd3bb2d95fe1cac90a336ca8df6', '6e01e3fdc64f8f20603aabd7f9d6058d889fb5cd35151b8bdbba04417518d960', '2026-07-21 17:03:15'),
(420, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 6, '{\"hours\":0.01}', '::1', '6e01e3fdc64f8f20603aabd7f9d6058d889fb5cd35151b8bdbba04417518d960', '3ed7979bfa4cc1528f286eb903361fa7f831ff47f51a317d22dfccc15b87c9ab', '2026-07-21 17:03:21'),
(421, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 6, '{\"status\":\"rejected\"}', '::1', '3ed7979bfa4cc1528f286eb903361fa7f831ff47f51a317d22dfccc15b87c9ab', 'b6d6a3bf727ee22e128daa7999922f42c0ddc41104b23fb699e3e35fa8125675', '2026-07-21 17:04:36'),
(422, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 7, '{\"hours\":0.01}', '::1', 'b6d6a3bf727ee22e128daa7999922f42c0ddc41104b23fb699e3e35fa8125675', 'b988403e3d85a981b843ebe2122ba9b7ba13eaf027482d4f04b00f459bdb0eb9', '2026-07-21 17:08:54'),
(423, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 7, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"pending\"}', '::1', 'b988403e3d85a981b843ebe2122ba9b7ba13eaf027482d4f04b00f459bdb0eb9', '9d896452f312c6a215c1d52a2a8f71c6fb2ddaf848860318a633bbbc12edcacb', '2026-07-21 17:09:08'),
(424, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 8, '{\"hours\":0.01}', '::1', '9d896452f312c6a215c1d52a2a8f71c6fb2ddaf848860318a633bbbc12edcacb', 'de68cda3e580daae1803e3a1b5520a5f276c1906a37f873700c794f011cde736', '2026-07-21 17:09:12'),
(425, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 6, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', 'de68cda3e580daae1803e3a1b5520a5f276c1906a37f873700c794f011cde736', '39e0a2f79140c9f0f0ee196be153e5ad3dcab36c947438cb42ea49880e159456', '2026-07-21 17:09:38'),
(426, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 5, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '39e0a2f79140c9f0f0ee196be153e5ad3dcab36c947438cb42ea49880e159456', 'a0477925e323747752590c2acb350565870f2ca3722066b8b9f75da323cf75df', '2026-07-21 17:09:40'),
(427, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 4, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', 'a0477925e323747752590c2acb350565870f2ca3722066b8b9f75da323cf75df', '13d43873532aa012e3436dd08ea427bad1f3fef0d92d1d4e39efa9517e190eeb', '2026-07-21 17:09:41'),
(428, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 3, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '13d43873532aa012e3436dd08ea427bad1f3fef0d92d1d4e39efa9517e190eeb', '7abf7f41001c144835147beab710a6cca8380b8acba3c9815d256c5a2c8e8a6b', '2026-07-21 17:09:42'),
(429, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 1, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '7abf7f41001c144835147beab710a6cca8380b8acba3c9815d256c5a2c8e8a6b', '34ffb8652a02f70ee2a55318de26abe2c00b646a4ea1a2860e0aac424b699115', '2026-07-21 17:09:44'),
(430, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 8, '{\"status\":\"rejected\"}', '::1', '34ffb8652a02f70ee2a55318de26abe2c00b646a4ea1a2860e0aac424b699115', '4473d60337af5d9250f8975aace2cc2e3a1c53a37d7e346472bb162dbfcf9c61', '2026-07-21 17:09:56'),
(431, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 9, '{\"hours\":0.01}', '::1', '4473d60337af5d9250f8975aace2cc2e3a1c53a37d7e346472bb162dbfcf9c61', 'a13aaeaff7d13c87067a68f1f2188cbd8d083f813d90d0349d500de98281ac32', '2026-07-21 17:09:58'),
(432, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 9, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"pending\"}', '::1', 'a13aaeaff7d13c87067a68f1f2188cbd8d083f813d90d0349d500de98281ac32', 'eb0ee4eaa4847287cd2e13aff562b02d8171a6f9f7ae2563e6bd6a2b48cc0b9f', '2026-07-21 17:10:19'),
(433, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 11, '{\"hours\":0.01}', '::1', 'eb0ee4eaa4847287cd2e13aff562b02d8171a6f9f7ae2563e6bd6a2b48cc0b9f', 'c5ae72b49dc6421ab587125f380def3c54e37507fcc274334a5181d6b8df3e04', '2026-07-21 17:10:24'),
(434, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 11, '{\"status\":\"rejected\"}', '::1', 'c5ae72b49dc6421ab587125f380def3c54e37507fcc274334a5181d6b8df3e04', 'a4bdec5aef5b2a5a27b15e4b0b2626fac54d3c176a8c2ac69a7def2964fbb4bf', '2026-07-21 17:12:15'),
(435, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 12, '{\"hours\":0.01}', '::1', 'a4bdec5aef5b2a5a27b15e4b0b2626fac54d3c176a8c2ac69a7def2964fbb4bf', '4db55a24911bdbd9a40a5d94e1929b084affa20be202c0b8ede658c11195ecd6', '2026-07-21 17:12:17'),
(436, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 13, '{\"status\":\"rejected\"}', 'cli', '4db55a24911bdbd9a40a5d94e1929b084affa20be202c0b8ede658c11195ecd6', '7c294bcbd366e755ae2263f50377b7a295b22207d63a6c312c815d5e005a17da', '2026-07-21 17:15:18'),
(437, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 12, '{\"status\":\"rejected\"}', '::1', '7c294bcbd366e755ae2263f50377b7a295b22207d63a6c312c815d5e005a17da', 'b6cf817d7cbb3dab33c686f965add9bd8efd0a1322ccee05ef1a73a73d267079', '2026-07-21 17:15:57'),
(438, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 14, '{\"hours\":0.01}', '::1', 'b6cf817d7cbb3dab33c686f965add9bd8efd0a1322ccee05ef1a73a73d267079', '21fd955e77af1b1bbf0d769950d027f25289b945bf81853c71ada6222055c4d4', '2026-07-21 17:16:02'),
(439, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 14, '{\"status\":\"rejected\"}', '::1', '21fd955e77af1b1bbf0d769950d027f25289b945bf81853c71ada6222055c4d4', '5d5bdb4b0af2302b61e02c3d55ac682e0be7aa6602fbfbf0311f1e52bdecdc7d', '2026-07-21 17:17:53'),
(440, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 15, '{\"hours\":0.01}', '::1', '5d5bdb4b0af2302b61e02c3d55ac682e0be7aa6602fbfbf0311f1e52bdecdc7d', '6a41e3f8efdc938495d016f3bee1e27f4cf2e23b7f5d84a71b201a551814bc38', '2026-07-21 17:17:57'),
(441, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 15, '{\"status\":\"rejected\"}', '::1', '6a41e3f8efdc938495d016f3bee1e27f4cf2e23b7f5d84a71b201a551814bc38', 'f3be2248712bae8371cf45e3d5d64dd8532e0675c2cac74ce51b7c4cdc45f4eb', '2026-07-21 17:25:29'),
(442, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 15, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', 'f3be2248712bae8371cf45e3d5d64dd8532e0675c2cac74ce51b7c4cdc45f4eb', '9433db5b3becb063fbe2de4a7a0eb7ed5a4f4a74057133186b6b43cac075f03f', '2026-07-21 17:25:46'),
(443, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 14, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '9433db5b3becb063fbe2de4a7a0eb7ed5a4f4a74057133186b6b43cac075f03f', '38ddab7343d9ed54b077e503dde6186328a1b5d5e71f0ca8d80c572c3c5137ed', '2026-07-21 17:25:48'),
(444, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 12, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '38ddab7343d9ed54b077e503dde6186328a1b5d5e71f0ca8d80c572c3c5137ed', '21cee90571e571899ceed29e9dbcc8db6e9ffce6ece07a59ae76e3a51ce4c47a', '2026-07-21 17:25:49'),
(445, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 11, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '21cee90571e571899ceed29e9dbcc8db6e9ffce6ece07a59ae76e3a51ce4c47a', '1fc135106723313687597ac40d7bb8c8cc00a5e7a3ac47c875b0d5f9d84ae96b', '2026-07-21 17:25:50'),
(446, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 8, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"rejected\"}', '::1', '1fc135106723313687597ac40d7bb8c8cc00a5e7a3ac47c875b0d5f9d84ae96b', 'b4178b131641f6fffe147c9a9cff4c22ea2384a45a6e96772b3f7f7f7a5ea74c', '2026-07-21 17:25:51'),
(447, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 16, '{\"hours\":0.01}', '::1', 'b4178b131641f6fffe147c9a9cff4c22ea2384a45a6e96772b3f7f7f7a5ea74c', '50098c9c75499c5f855c14c833cef7ca12f065e530855feb435b77c9437294e7', '2026-07-21 17:25:57'),
(448, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 16, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"pending\"}', '::1', '50098c9c75499c5f855c14c833cef7ca12f065e530855feb435b77c9437294e7', '83891114ade7ead877482a7cb0cebbf58827f797f47e9c549015bfc0c1eeec8f', '2026-07-21 17:26:02'),
(449, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 17, '{\"hours\":0.01}', '::1', '83891114ade7ead877482a7cb0cebbf58827f797f47e9c549015bfc0c1eeec8f', '039c2fd0413cb076cf36044f93655cfa8c1e2028a89160ab6ab179a93d87b9f6', '2026-07-21 17:26:05'),
(450, 2, 'OT_ADVANCE_DELETED', 'ot_advances', 17, '{\"was_for_user_id\":1,\"hours_requested\":\"0.01\",\"status_before_delete\":\"pending\"}', '::1', '039c2fd0413cb076cf36044f93655cfa8c1e2028a89160ab6ab179a93d87b9f6', '8f12e2cd7c4fea16b609cea948392fc5f8afd507ee6dca7bef96be74163e494e', '2026-07-21 17:26:15'),
(451, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 18, '{\"hours\":0.01}', '::1', '8f12e2cd7c4fea16b609cea948392fc5f8afd507ee6dca7bef96be74163e494e', 'dcc2eccc07b601e87fc1663adee812dc356e1f8235816655734ccf3e543de34a', '2026-07-21 17:26:19'),
(452, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 18, '{\"status\":\"approved\"}', '::1', 'dcc2eccc07b601e87fc1663adee812dc356e1f8235816655734ccf3e543de34a', '36fcff7299696708486202ccdb5618a9b10360d9e11ce3e57476ad6ed8413884', '2026-07-21 17:26:23'),
(453, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":2}', '::1', '36fcff7299696708486202ccdb5618a9b10360d9e11ce3e57476ad6ed8413884', '832e17895e5505233d13e172a3e16391840a4374c28653101d75249a116de06e', '2026-07-21 17:27:01'),
(454, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 19, '{\"hours\":0.01}', '::1', '832e17895e5505233d13e172a3e16391840a4374c28653101d75249a116de06e', 'e73d393e570ea0a43f9c8727853cd01934c85fd6290c92a8b3832dc13cb7884b', '2026-07-21 17:27:04'),
(455, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":1}', '::1', 'e73d393e570ea0a43f9c8727853cd01934c85fd6290c92a8b3832dc13cb7884b', '20ab1357e9adf14f6afec0cf2e26945603d7e636c05118a961f9cacae7307646', '2026-07-21 17:27:09'),
(456, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 20, '{\"hours\":0.01}', '::1', '20ab1357e9adf14f6afec0cf2e26945603d7e636c05118a961f9cacae7307646', '6465d5b37385ce15a99811b10c09fb5c072ecc5619e6c165e4b8ab5ea4651d87', '2026-07-21 17:27:14'),
(457, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 21, '{\"hours\":0.01}', '::1', '6465d5b37385ce15a99811b10c09fb5c072ecc5619e6c165e4b8ab5ea4651d87', 'b7ebb7ab1042d331c78a4aec29a0e22e0dae511e81223e867e5a7711d95b024e', '2026-07-21 17:27:15'),
(458, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 22, '{\"hours\":0.01}', '::1', 'b7ebb7ab1042d331c78a4aec29a0e22e0dae511e81223e867e5a7711d95b024e', '2dce502676e4200ac9c319a6a36903422638982b77ab3ca4194735987e9e74cf', '2026-07-21 17:27:16'),
(459, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 23, '{\"hours\":0.01}', '::1', '2dce502676e4200ac9c319a6a36903422638982b77ab3ca4194735987e9e74cf', '7b40dd629c4d9643dcc9d25836c9aa5ff2d84bd8b9083f4b794b67af6a2700b2', '2026-07-21 17:27:17'),
(460, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 24, '{\"hours\":0.01}', '::1', '7b40dd629c4d9643dcc9d25836c9aa5ff2d84bd8b9083f4b794b67af6a2700b2', '8a245df4ed74e342de73687c0c52669559fb30027f706ee5041e1f626fe2efc7', '2026-07-21 17:27:17'),
(461, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 25, '{\"hours\":0.01}', '::1', '8a245df4ed74e342de73687c0c52669559fb30027f706ee5041e1f626fe2efc7', 'c02ded4ee17878a01c20276f0ec135f6f1c5dace2621e6612d0deed6ffca7da7', '2026-07-21 17:27:17'),
(462, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 26, '{\"hours\":0.01}', '::1', 'c02ded4ee17878a01c20276f0ec135f6f1c5dace2621e6612d0deed6ffca7da7', 'f2531de7397010aa12320167d24e7f9371854480c9ecc0b33be59c87cf462c83', '2026-07-21 17:27:18'),
(463, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 27, '{\"hours\":0.01}', '::1', 'f2531de7397010aa12320167d24e7f9371854480c9ecc0b33be59c87cf462c83', '0568e55d8f53bdb7f1bb4e8285769d696b26108a0572dcedb36c1c853a5f2211', '2026-07-21 17:27:18');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(464, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":8}', '::1', '0568e55d8f53bdb7f1bb4e8285769d696b26108a0572dcedb36c1c853a5f2211', '70adf53211746e73582756b773dda44162740bfd207efa76f1347e575604a72e', '2026-07-21 17:27:20'),
(465, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 28, '{\"hours\":0.01}', '::1', '70adf53211746e73582756b773dda44162740bfd207efa76f1347e575604a72e', '33cf068b430145be2434b1d93d7de09848fa2970b4ab68bb5ea8be65ff86eec4', '2026-07-21 17:27:35'),
(466, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 29, '{\"hours\":0.01}', '::1', '33cf068b430145be2434b1d93d7de09848fa2970b4ab68bb5ea8be65ff86eec4', '647afe5b5cedd5195f645d96803d477c47e36e111fb51b7a701c2f1ded7347d4', '2026-07-21 17:27:38'),
(467, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 30, '{\"hours\":0.01}', '::1', '647afe5b5cedd5195f645d96803d477c47e36e111fb51b7a701c2f1ded7347d4', 'f24a05c3f110563b277c265f3e042d322680bbc781531392fc881a1858f6d3d2', '2026-07-21 17:27:40'),
(468, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 31, '{\"hours\":0.01}', '::1', 'f24a05c3f110563b277c265f3e042d322680bbc781531392fc881a1858f6d3d2', '38147cbb923643acbab94a32793ca41bf776cf50d721d40be324aab8bb2e898a', '2026-07-21 17:27:42'),
(469, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":4}', '::1', '38147cbb923643acbab94a32793ca41bf776cf50d721d40be324aab8bb2e898a', 'f27ec1a158db2cc6dd822bd46a05df146d9f08fb7f6524a1afe544b1c8b095dc', '2026-07-21 17:28:01'),
(470, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 32, '{\"hours\":25.5}', '::1', 'f27ec1a158db2cc6dd822bd46a05df146d9f08fb7f6524a1afe544b1c8b095dc', '93604b394742c18f0c34973c87f453c99eb83994a309816cdceb4db24f6b2e6d', '2026-07-21 17:28:27'),
(471, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":1}', '::1', '93604b394742c18f0c34973c87f453c99eb83994a309816cdceb4db24f6b2e6d', 'ca55c99c417efd9bda0a9b8d51e17195e27735d68013b94544d6a909b41c4848', '2026-07-21 17:28:32'),
(472, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 33, '{\"hours\":25.5}', '::1', 'ca55c99c417efd9bda0a9b8d51e17195e27735d68013b94544d6a909b41c4848', 'ab80fd2c8eb683644e508b655cb983cf8ff19d7552ef5db252ce41528604bd2b', '2026-07-21 17:28:41'),
(473, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 33, '{\"status\":\"approved\"}', '::1', 'ab80fd2c8eb683644e508b655cb983cf8ff19d7552ef5db252ce41528604bd2b', 'ec7070f84894953cc24f0394b45b8816a4daf4737f3ab0e097d1082b2c305e6a', '2026-07-21 17:28:54'),
(474, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":1}', '::1', 'ec7070f84894953cc24f0394b45b8816a4daf4737f3ab0e097d1082b2c305e6a', 'e7d62ff01a195d5876a76c1fdf683b259e672b3a316ae1de4de134335849f087', '2026-07-21 17:29:04'),
(475, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 34, '{\"hours\":25.5}', '::1', 'e7d62ff01a195d5876a76c1fdf683b259e672b3a316ae1de4de134335849f087', '42aa2672dbc71c7c3c4dbc281e236bb61558f1f544182bf787edb623f43b5962', '2026-07-21 17:30:55'),
(476, 2, 'ALL_OT_ADVANCES_DELETED', 'ot_advances', 0, '{\"count_deleted\":1}', '::1', '42aa2672dbc71c7c3c4dbc281e236bb61558f1f544182bf787edb623f43b5962', 'f32cfe550a6ace0a3e24f51304d0f0cd7c854733bf0c55f499a573b6d57e13ff', '2026-07-21 17:30:57'),
(477, 1, 'OT_ADVANCE_REQUESTED', 'ot_advances', 35, '{\"hours\":25.5}', '::1', 'f32cfe550a6ace0a3e24f51304d0f0cd7c854733bf0c55f499a573b6d57e13ff', 'eadbacb833c58cc983aaea8c2fc54d74642ba25d5fd59003be08883a583ae085', '2026-07-21 17:31:07'),
(478, 2, 'OT_ADVANCE_RESOLVED', 'ot_advances', 35, '{\"status\":\"approved\"}', '::1', 'eadbacb833c58cc983aaea8c2fc54d74642ba25d5fd59003be08883a583ae085', 'b3ce12eefea21af7cb1c30e24af9487c3680abcb334c66be03e8fd79dbd3b0ef', '2026-07-21 17:31:23'),
(479, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 9, '{\"hours\":25.5}', '::1', 'b3ce12eefea21af7cb1c30e24af9487c3680abcb334c66be03e8fd79dbd3b0ef', '8ee04ad2d84947e2dd52eec030bd38011efbf1642fbcaf8108ada8270a552376', '2026-07-21 17:48:50'),
(480, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 9, '{\"status\":\"rejected\"}', '::1', '8ee04ad2d84947e2dd52eec030bd38011efbf1642fbcaf8108ada8270a552376', '657244c33ab823cfa170de36481199092219118dd3b8db1be2d6e4d69f597773', '2026-07-21 17:49:00'),
(481, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 10, '{\"hours\":25.5}', '::1', '657244c33ab823cfa170de36481199092219118dd3b8db1be2d6e4d69f597773', '4a0df9697123382d543c834f56539f0c405e67d0408ea6ab13d5879ba479231b', '2026-07-21 17:49:03'),
(482, 2, 'OT_CASHOUT_DELETED', 'ot_cashouts', 10, '{\"was_for_user_id\":1,\"hours_requested\":\"25.50\",\"status_before_delete\":\"pending\"}', '::1', '4a0df9697123382d543c834f56539f0c405e67d0408ea6ab13d5879ba479231b', 'a4d55b07b2a6a92b6b6329c8249f02d812c92b330ec9b89235830cf8850a3551', '2026-07-21 17:49:19'),
(483, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 11, '{\"hours\":25.5}', '::1', 'a4d55b07b2a6a92b6b6329c8249f02d812c92b330ec9b89235830cf8850a3551', 'f4349c1aa3215e04882a6119c1078e7c2ab37b334ef98b2218873a7f6cfb806b', '2026-07-21 17:49:38'),
(484, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 11, '{\"status\":\"rejected\"}', '::1', 'f4349c1aa3215e04882a6119c1078e7c2ab37b334ef98b2218873a7f6cfb806b', 'a31155db117446621931c0a3aa152f8520efaf103463863d92d4a76f0af55fda', '2026-07-21 17:49:46'),
(485, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 12, '{\"hours\":25.5}', '::1', 'a31155db117446621931c0a3aa152f8520efaf103463863d92d4a76f0af55fda', '894b578bb76d34b5352b717b60f07829a53b6b9d136059088973cc59bc415881', '2026-07-21 17:49:49'),
(486, 2, 'OT_CASHOUT_DELETED', 'ot_cashouts', 12, '{\"was_for_user_id\":1,\"hours_requested\":\"25.50\",\"status_before_delete\":\"pending\"}', '::1', '894b578bb76d34b5352b717b60f07829a53b6b9d136059088973cc59bc415881', '3885f6ece6c4ad611742b29f454fb245062cf26e955cfcb4be2ecea4aea2517f', '2026-07-21 17:50:04'),
(487, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 13, '{\"hours\":25.5}', '::1', '3885f6ece6c4ad611742b29f454fb245062cf26e955cfcb4be2ecea4aea2517f', '9e2fbb2ef31411a8f3d5ac7fa3a465cc3947200a1d014428d8fa9048100cf2f2', '2026-07-21 17:50:07'),
(488, 2, 'OT_CASHOUT_DELETED', 'ot_cashouts', 13, '{\"was_for_user_id\":1,\"hours_requested\":\"25.50\",\"status_before_delete\":\"pending\"}', '::1', '9e2fbb2ef31411a8f3d5ac7fa3a465cc3947200a1d014428d8fa9048100cf2f2', '71dbc524553c78eff4f5f5a6ba450832b55cfb3220765975231a8433579982d4', '2026-07-21 17:50:19'),
(489, 1, 'OT_CASHOUT_REQUESTED', 'ot_cashouts', 14, '{\"hours\":25.5}', '::1', '71dbc524553c78eff4f5f5a6ba450832b55cfb3220765975231a8433579982d4', 'd02209f811c158cf9ff0be10cc21d75a7e385c01bc0c375c399c973b49dc65d2', '2026-07-21 17:50:59'),
(490, 2, 'OT_CASHOUT_RESOLVED', 'ot_cashouts', 14, '{\"status\":\"rejected\"}', '::1', 'd02209f811c158cf9ff0be10cc21d75a7e385c01bc0c375c399c973b49dc65d2', 'e4e3f2f16e946d49bfcec52569fd62ac52b72bfd42eb7cdfd3aa0ce003ff7ce4', '2026-07-21 17:51:14'),
(491, 2, 'ALL_DTR_ENTRIES_DELETED', 'dtr_entries', 0, '{\"total_deleted\":22}', '::1', 'e4e3f2f16e946d49bfcec52569fd62ac52b72bfd42eb7cdfd3aa0ce003ff7ce4', '0fa4a9f21d21714b07f505e20e7084a7a4c1c169708d350208558eb9a5166033', '2026-07-21 17:52:11'),
(492, 2, 'ALL_OT_CASHOUTS_DELETED', 'ot_cashouts', 0, '{\"count_deleted\":4}', '::1', '0fa4a9f21d21714b07f505e20e7084a7a4c1c169708d350208558eb9a5166033', '9696cb6ab3ec67fcd1fee1366d774545274ab8290c6776f7ee068e438b9f9a09', '2026-07-21 17:57:14'),
(493, 2, 'DEFAULT_REQUIRED_HOURS_APPLIED', 'users', NULL, '{\"required_hours\":\"100\"}', 'cli', '9696cb6ab3ec67fcd1fee1366d774545274ab8290c6776f7ee068e438b9f9a09', '11774246a191e4208ecf06b0ef6301dc6699320547ce1afbe374535055cad218', '2026-07-21 18:04:38'),
(494, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"100\"}', 'cli', '11774246a191e4208ecf06b0ef6301dc6699320547ce1afbe374535055cad218', '740973ecf1d9f0e16a6008c5ad9384089954506f41a211e6a818158b37dd4463', '2026-07-21 18:04:38'),
(495, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '740973ecf1d9f0e16a6008c5ad9384089954506f41a211e6a818158b37dd4463', '8d12015ab5cc45d9e334d0a61fb33b24c5943a309304ac00f735cce942907fa5', '2026-07-21 18:05:16'),
(496, 2, 'DEFAULT_REQUIRED_HOURS_APPLIED', 'users', NULL, '{\"required_hours\":\"486\"}', '::1', '8d12015ab5cc45d9e334d0a61fb33b24c5943a309304ac00f735cce942907fa5', 'b853c0664366f603527d5dbad9c6cd295c40f0a4bcd1ff8c5f969385627ca756', '2026-07-21 18:05:16'),
(497, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', 'b853c0664366f603527d5dbad9c6cd295c40f0a4bcd1ff8c5f969385627ca756', '08a09719c1b32c24d129f1fdc0a6097994724de8a24529003e83c68b2aa9121a', '2026-07-21 18:05:16'),
(498, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '08a09719c1b32c24d129f1fdc0a6097994724de8a24529003e83c68b2aa9121a', '18732f9819a41713b89b7f53fcd100087e19c44d428230f6ae3bf0b9a0548a9e', '2026-07-21 18:05:16'),
(499, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', '18732f9819a41713b89b7f53fcd100087e19c44d428230f6ae3bf0b9a0548a9e', '00d6488ebf37a2f046a713c467b62c3a2bfc1b5f6966735925fd957d84dd121e', '2026-07-21 18:05:16'),
(500, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '00d6488ebf37a2f046a713c467b62c3a2bfc1b5f6966735925fd957d84dd121e', '6ace2ba5b6d34ece57f7c84983f8224c19932e894452b0ce22dfff81dccd5197', '2026-07-21 18:05:16'),
(501, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '6ace2ba5b6d34ece57f7c84983f8224c19932e894452b0ce22dfff81dccd5197', '91d130c2e8cd7609ed3f28224ded3eaff4f64ba89c965e3083634ea25c2053e5', '2026-07-21 18:05:16'),
(502, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', '91d130c2e8cd7609ed3f28224ded3eaff4f64ba89c965e3083634ea25c2053e5', '4aa001d5607c846bf2a5ee42b402f6f7cf2f4292e95301a70c1831e58d87b7ad', '2026-07-21 18:05:18'),
(503, 2, 'DEFAULT_REQUIRED_HOURS_APPLIED', 'users', NULL, '{\"required_hours\":\"486\"}', '::1', '4aa001d5607c846bf2a5ee42b402f6f7cf2f4292e95301a70c1831e58d87b7ad', 'df4a0819898cba7001aa7e133d0c38c2098de5fe2e165a2dcffb9f9309b22ffd', '2026-07-21 18:05:18'),
(504, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', 'df4a0819898cba7001aa7e133d0c38c2098de5fe2e165a2dcffb9f9309b22ffd', '9e9b8a0d319922c0fdf941a7ad8112fcf3b9fa6c5042ede3382e6dad04f29f0a', '2026-07-21 18:05:18'),
(505, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', '9e9b8a0d319922c0fdf941a7ad8112fcf3b9fa6c5042ede3382e6dad04f29f0a', 'db751e49fa9d39ef1b04e8db8e37fdc7ae5590ecba753d4bab0ae31592b7d3cc', '2026-07-21 18:05:18'),
(506, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'db751e49fa9d39ef1b04e8db8e37fdc7ae5590ecba753d4bab0ae31592b7d3cc', '32d3365a5459b945489152a2a949b3183a0f7cc4761aba2510ed74d02dee08e2', '2026-07-21 18:05:18'),
(507, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', '32d3365a5459b945489152a2a949b3183a0f7cc4761aba2510ed74d02dee08e2', '2dcbeaba347dda32ce7d7fc2f1b3c902458bb03d23f4bcd99756e34cd88ef338', '2026-07-21 18:05:18'),
(508, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '2dcbeaba347dda32ce7d7fc2f1b3c902458bb03d23f4bcd99756e34cd88ef338', 'a16162ed8518034cb437b8d76ddea0d09e9bcdfeb4770a98005ef7a8634e069a', '2026-07-21 18:05:18'),
(509, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"break_deduction_threshold_hours\",\"new_value\":\"8\"}', '::1', 'a16162ed8518034cb437b8d76ddea0d09e9bcdfeb4770a98005ef7a8634e069a', '436352888cf4d5188ae56f6ccb9983450b4f82804199283dfa419c3e5fb2a17e', '2026-07-21 18:05:21'),
(510, 2, 'DEFAULT_REQUIRED_HOURS_APPLIED', 'users', NULL, '{\"required_hours\":\"486\"}', '::1', '436352888cf4d5188ae56f6ccb9983450b4f82804199283dfa419c3e5fb2a17e', '76ae3f4a214484812886e00d3efb21177552ef0d6232801bb38bf8e88808492a', '2026-07-21 18:05:21'),
(511, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"default_required_hours\",\"new_value\":\"486\"}', '::1', '76ae3f4a214484812886e00d3efb21177552ef0d6232801bb38bf8e88808492a', 'fee0023e86acc4dda9230ee1bb3fb848f5276639cf7b732a9903b53947da0029', '2026-07-21 18:05:21'),
(512, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_max_attempts\",\"new_value\":\"5\"}', '::1', 'fee0023e86acc4dda9230ee1bb3fb848f5276639cf7b732a9903b53947da0029', 'b71b003d8c4470e00ef1b3a3ea6dc79e5d0e04fe83082365d73fb83e548f9665', '2026-07-21 18:05:21'),
(513, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"login_lockout_window_minutes\",\"new_value\":\"15\"}', '::1', 'b71b003d8c4470e00ef1b3a3ea6dc79e5d0e04fe83082365d73fb83e548f9665', 'a8fa1ba0cf6cfa555ba4eb4fa02df4f545af3e77d971b4d8b8862884c2f2940f', '2026-07-21 18:05:21'),
(514, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"max_photo_upload_mb\",\"new_value\":\"5\"}', '::1', 'a8fa1ba0cf6cfa555ba4eb4fa02df4f545af3e77d971b4d8b8862884c2f2940f', '50a551fb0be5ece28dd87161616ba7f666ac9f6d9b1d0ddd0bb41ce5d4e53f52', '2026-07-21 18:05:21'),
(515, 2, 'SETTING_UPDATED', 'app_settings', NULL, '{\"key\":\"deactivation_review_months\",\"new_value\":\"12\"}', '::1', '50a551fb0be5ece28dd87161616ba7f666ac9f6d9b1d0ddd0bb41ce5d4e53f52', '10f8de928f7a8b404b35dd27d1a214d29b006594e8682467fb822d3fc954c97a', '2026-07-21 18:05:21'),
(516, 2, 'LOGOUT', 'users', 2, '[]', '::1', '10f8de928f7a8b404b35dd27d1a214d29b006594e8682467fb822d3fc954c97a', '5d51e710cc4d2f3fae51bddca8e7809cc362c0c753923e312fe83e41066ba4d7', '2026-07-21 18:05:49'),
(517, 1, 'LOGOUT', 'users', 1, '[]', '::1', '5d51e710cc4d2f3fae51bddca8e7809cc362c0c753923e312fe83e41066ba4d7', '53f07164d35130ed9832999a476570129f6f80652000a1f2bf9ec5192518d1de', '2026-07-21 18:05:53'),
(518, 3, 'LOGIN_FAILED', 'users', 3, '{\"id_number\":\"1-210253e\"}', '203.189.116.64', '53f07164d35130ed9832999a476570129f6f80652000a1f2bf9ec5192518d1de', '7ba9594795e953b4f73f31765c3b2e8bd8d57c7e7687829106b8ec31ac939d1f', '2026-07-23 07:24:40'),
(519, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '203.189.116.64', '7ba9594795e953b4f73f31765c3b2e8bd8d57c7e7687829106b8ec31ac939d1f', 'ecf3e5dd48883facb8226c5e74e19272f8888412d6b1146b863ef78056bf5e22', '2026-07-23 07:24:56'),
(520, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '203.189.116.64', 'ecf3e5dd48883facb8226c5e74e19272f8888412d6b1146b863ef78056bf5e22', '5c8ded7a917afe49cee3cb437fc70991b764344c50c7cc36c65b858bb75c6cfb', '2026-07-23 07:30:09'),
(521, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '203.189.116.64', '5c8ded7a917afe49cee3cb437fc70991b764344c50c7cc36c65b858bb75c6cfb', '25042e63921b86ce147bb0f8ba7e094f4d8e11e3b3d5cf60aaf7d23ed6c5841a', '2026-07-23 07:30:18'),
(522, 1, 'LOGIN_FAILED', 'users', 1, '{\"id_number\":\"1-210253f\"}', '203.189.116.64', '25042e63921b86ce147bb0f8ba7e094f4d8e11e3b3d5cf60aaf7d23ed6c5841a', '52999ce9bcf7439a6c74ed5176ff8e1b602d57fb4670af9b17f5af313becb52e', '2026-07-23 07:31:17'),
(523, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '203.189.116.64', '52999ce9bcf7439a6c74ed5176ff8e1b602d57fb4670af9b17f5af313becb52e', '5d2280877b93b47d7e4050a7f0155fbf8af080c7a3b40be1e7b8d1ae3fffe76b', '2026-07-23 07:31:49'),
(524, 3, 'LOGOUT', 'users', 3, '[]', '203.189.116.64', '5d2280877b93b47d7e4050a7f0155fbf8af080c7a3b40be1e7b8d1ae3fffe76b', '1710c1706cfd02db101ce0f9dde3432f5bfca29c56a96c2d730dc1c02879a056', '2026-07-23 07:31:57'),
(525, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '203.189.116.64', '1710c1706cfd02db101ce0f9dde3432f5bfca29c56a96c2d730dc1c02879a056', '4a567670c6464e34a88df743c2dc1094f1944ab0873debdfe2607764b0988bff', '2026-07-23 07:32:49'),
(526, 2, 'LOGOUT', 'users', 2, '[]', '203.189.116.64', '4a567670c6464e34a88df743c2dc1094f1944ab0873debdfe2607764b0988bff', 'b10f4bfda7dfe971a99dc257dd023b832d40365b1d0ee5b275e206e51eb9f08e', '2026-07-23 07:33:22'),
(527, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '203.189.116.64', 'b10f4bfda7dfe971a99dc257dd023b832d40365b1d0ee5b275e206e51eb9f08e', '2cfec548a66873d013191c006e885873ab35066d0deaddee1a58bd5171b1b946', '2026-07-23 07:33:42'),
(528, 3, 'PASSWORD_CHANGED', 'users', 3, '[]', '203.189.116.64', '2cfec548a66873d013191c006e885873ab35066d0deaddee1a58bd5171b1b946', '18342b36edf9d808d686d6ae1c616f784d1fb007011d94ad48d67c4949bc091f', '2026-07-23 07:35:57'),
(529, 3, 'LOGOUT', 'users', 3, '[]', '203.189.116.64', '18342b36edf9d808d686d6ae1c616f784d1fb007011d94ad48d67c4949bc091f', '7dba65fc2ff9fcb2b5f52a63ffea947aca7d99c995677a5f42a77599873174f9', '2026-07-23 08:09:59'),
(530, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '203.189.116.64', '7dba65fc2ff9fcb2b5f52a63ffea947aca7d99c995677a5f42a77599873174f9', '2ac91fcc124e66d49c2d132b8f784dd3cebc8b86bffafaad002372275d0ec64a', '2026-07-23 08:11:35'),
(531, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '203.189.116.64', '2ac91fcc124e66d49c2d132b8f784dd3cebc8b86bffafaad002372275d0ec64a', '1c9f417d5bb34234ad8acfb1ae50b21bedff765beb6bfe5962755782324a914d', '2026-07-23 08:14:36'),
(532, 2, 'LOGOUT', 'users', 2, '[]', '203.189.116.64', '1c9f417d5bb34234ad8acfb1ae50b21bedff765beb6bfe5962755782324a914d', 'ca213f8fe652fc2f5a6a485780f2c43125d738e627e78c111a4de7f03ec60c88', '2026-07-23 08:18:42'),
(533, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '203.189.116.64', 'ca213f8fe652fc2f5a6a485780f2c43125d738e627e78c111a4de7f03ec60c88', '230549ebdf44dfafeef70bc1f1e245dd807a166689065b58b368f640877686c3', '2026-07-23 08:20:00'),
(534, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '203.189.116.64', '230549ebdf44dfafeef70bc1f1e245dd807a166689065b58b368f640877686c3', '683a41e12fc22374a3e88ee0279769c2b930cb6fbcec80a4c44b29a9e5771024', '2026-07-23 08:21:57'),
(535, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '203.189.116.64', '683a41e12fc22374a3e88ee0279769c2b930cb6fbcec80a4c44b29a9e5771024', 'fabb537c0d035d9daf4ccbcf278c8d4535375242ad063157315b31281d18ec2f', '2026-07-23 08:26:48'),
(536, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '203.189.116.64', 'fabb537c0d035d9daf4ccbcf278c8d4535375242ad063157315b31281d18ec2f', '34d807c20db636a4cff06f6084fa7c9c96ee9204063ecd7c11065d60b219c3b4', '2026-07-23 08:27:47'),
(537, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 155, '{\"work_date\":\"2026-07-01\"}', '203.189.116.64', '34d807c20db636a4cff06f6084fa7c9c96ee9204063ecd7c11065d60b219c3b4', 'e3a87450419c629dcd5e6d740d91df5bbada34f870402c33e6cb9163ae57785a', '2026-07-23 08:28:18'),
(538, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 156, '{\"work_date\":\"2026-07-02\"}', '203.189.116.64', 'e3a87450419c629dcd5e6d740d91df5bbada34f870402c33e6cb9163ae57785a', '8cc8054187fa2f1a919ae630e1d1c9099c27e0d85da2cf6d05bc8771ed684f99', '2026-07-23 08:28:18'),
(539, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 157, '{\"work_date\":\"2026-07-03\"}', '203.189.116.64', '8cc8054187fa2f1a919ae630e1d1c9099c27e0d85da2cf6d05bc8771ed684f99', '3a986e6fe5a194f265ff107629a85e34bcd3655228efdb305be4815f70674e46', '2026-07-23 08:28:18'),
(540, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 158, '{\"work_date\":\"2026-07-04\"}', '203.189.116.64', '3a986e6fe5a194f265ff107629a85e34bcd3655228efdb305be4815f70674e46', 'd36db27169b68329a79cd6e250a18f6c00384c8588846ad3efe79581507a8cd3', '2026-07-23 08:28:18'),
(541, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 159, '{\"work_date\":\"2026-07-05\"}', '203.189.116.64', 'd36db27169b68329a79cd6e250a18f6c00384c8588846ad3efe79581507a8cd3', 'a8f1304a99b255eb85649327e6c5e2c0f7bc6aea3befef17c6282a2b4967ff2e', '2026-07-23 08:28:18'),
(542, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 160, '{\"work_date\":\"2026-07-06\"}', '203.189.116.64', 'a8f1304a99b255eb85649327e6c5e2c0f7bc6aea3befef17c6282a2b4967ff2e', '622c111e5f5521a96b351ab2715f0d9ceeda68ae2e220c5971414da2451942e9', '2026-07-23 08:28:18');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(543, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 161, '{\"work_date\":\"2026-07-07\"}', '203.189.116.64', '622c111e5f5521a96b351ab2715f0d9ceeda68ae2e220c5971414da2451942e9', '0b9a39a96d903fc6a1176caa380f46a652c121868c9a3dd110f51d6fe880a725', '2026-07-23 08:28:18'),
(544, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 162, '{\"work_date\":\"2026-07-08\"}', '203.189.116.64', '0b9a39a96d903fc6a1176caa380f46a652c121868c9a3dd110f51d6fe880a725', '5bd2ccc24db94f5fe850b9c1cbaca58d75110eeedde35cd3aa4a5c9fc1d2a9df', '2026-07-23 08:28:18'),
(545, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 163, '{\"work_date\":\"2026-07-09\"}', '203.189.116.64', '5bd2ccc24db94f5fe850b9c1cbaca58d75110eeedde35cd3aa4a5c9fc1d2a9df', '75cd02f0c9936be362cce3fb783f7900b335fc7b1c0671997763cc5185f22b18', '2026-07-23 08:28:18'),
(546, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 164, '{\"work_date\":\"2026-07-10\"}', '203.189.116.64', '75cd02f0c9936be362cce3fb783f7900b335fc7b1c0671997763cc5185f22b18', 'a48405d0f80f5421d77418b3777fe74459ee6718a65fc192bd4b6c6d33c1edcc', '2026-07-23 08:28:18'),
(547, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 165, '{\"work_date\":\"2026-07-11\"}', '203.189.116.64', 'a48405d0f80f5421d77418b3777fe74459ee6718a65fc192bd4b6c6d33c1edcc', 'f49718d0e207afde7df1dd2123ab6ec04384ec6e7b9305ee005d25a889cc52a0', '2026-07-23 08:28:18'),
(548, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 166, '{\"work_date\":\"2026-07-12\"}', '203.189.116.64', 'f49718d0e207afde7df1dd2123ab6ec04384ec6e7b9305ee005d25a889cc52a0', '5805843f4c4fda7a34196d2d0358f3d8216a1be4988b42fc3e28e6ff43b9c816', '2026-07-23 08:28:18'),
(549, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 167, '{\"work_date\":\"2026-07-13\"}', '203.189.116.64', '5805843f4c4fda7a34196d2d0358f3d8216a1be4988b42fc3e28e6ff43b9c816', 'cd8d1eb435f4520117df77cd00007f37b806249a11806b675380ca6135ce12a9', '2026-07-23 08:28:18'),
(550, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 168, '{\"work_date\":\"2026-07-14\"}', '203.189.116.64', 'cd8d1eb435f4520117df77cd00007f37b806249a11806b675380ca6135ce12a9', 'ac4c799d361472a8fa36d0e0195312f86eba66a6103b6fd779e261002c375ec9', '2026-07-23 08:28:18'),
(551, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 169, '{\"work_date\":\"2026-07-15\"}', '203.189.116.64', 'ac4c799d361472a8fa36d0e0195312f86eba66a6103b6fd779e261002c375ec9', '6c2c1d0356faf3730f119864cf6e5898e89dc19933872c7882ed17c832e37a51', '2026-07-23 08:28:18'),
(552, 3, 'LOGOUT', 'users', 3, '[]', '203.189.116.64', '6c2c1d0356faf3730f119864cf6e5898e89dc19933872c7882ed17c832e37a51', 'a0d21bcf593aa8f9247e267c0149a9299de340f6b7643dcf246c04d9e941c5d0', '2026-07-23 08:28:37'),
(553, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '203.189.116.64', 'a0d21bcf593aa8f9247e267c0149a9299de340f6b7643dcf246c04d9e941c5d0', '3f4c52feacf89bc05ceb02ddd3d6bd7a7fb8c50296d2f0c9329311bd151a0cc5', '2026-07-23 08:29:10'),
(554, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '203.189.116.64', '3f4c52feacf89bc05ceb02ddd3d6bd7a7fb8c50296d2f0c9329311bd151a0cc5', 'd54c31f33d2513a4ca0bbbef491c176f47e2bdc820225d6d497bbe2fe37f39f1', '2026-07-23 08:31:31'),
(555, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 170, '{\"work_date\":\"2026-07-16\"}', '203.189.116.64', 'd54c31f33d2513a4ca0bbbef491c176f47e2bdc820225d6d497bbe2fe37f39f1', '42539888bfb23dd2f80308aca83824da0321415d74a3f4a404d9074cbff4f03a', '2026-07-23 08:39:37'),
(556, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 171, '{\"work_date\":\"2026-07-17\"}', '203.189.116.64', '42539888bfb23dd2f80308aca83824da0321415d74a3f4a404d9074cbff4f03a', '3742632860b2b8a600e066c77b066ba54235adbc7ecb71d4b7f20d1dabba9775', '2026-07-23 08:39:37'),
(557, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 172, '{\"work_date\":\"2026-07-18\"}', '203.189.116.64', '3742632860b2b8a600e066c77b066ba54235adbc7ecb71d4b7f20d1dabba9775', '0273d1c1d52cc5faab4a704d42b681f2993a1412b7b7396c4fdd9c882c6652dc', '2026-07-23 08:39:37'),
(558, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 173, '{\"work_date\":\"2026-07-19\"}', '203.189.116.64', '0273d1c1d52cc5faab4a704d42b681f2993a1412b7b7396c4fdd9c882c6652dc', '3fc68c6479e586e6d34c77f2ef3cba9c2b8df5b020e48367297866e1f39ebf59', '2026-07-23 08:39:37'),
(559, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 174, '{\"work_date\":\"2026-07-20\"}', '203.189.116.64', '3fc68c6479e586e6d34c77f2ef3cba9c2b8df5b020e48367297866e1f39ebf59', '2b4356532614af290fd9c49b973c8f212e0ad01502e078ef47c12da034be1298', '2026-07-23 08:39:37'),
(560, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 175, '{\"work_date\":\"2026-07-21\"}', '203.189.116.64', '2b4356532614af290fd9c49b973c8f212e0ad01502e078ef47c12da034be1298', 'aec082cecc1050af09491c77588f89efb92efec9baaef14f02f0a5a915eff566', '2026-07-23 08:39:37'),
(561, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 176, '{\"work_date\":\"2026-07-22\"}', '203.189.116.64', 'aec082cecc1050af09491c77588f89efb92efec9baaef14f02f0a5a915eff566', 'c097cc30295b31f674d1271de49100826c42c4dd81bd6e2a43857619a667efac', '2026-07-23 08:39:37'),
(562, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 177, '{\"work_date\":\"2026-07-23\"}', '203.189.116.64', 'c097cc30295b31f674d1271de49100826c42c4dd81bd6e2a43857619a667efac', '43ae0d906c7fe8bffe70da38d7d4a07bd81df0f4ec12eb31684f9ee1684a9e7e', '2026-07-23 08:39:37'),
(563, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 178, '{\"work_date\":\"2026-07-24\"}', '203.189.116.64', '43ae0d906c7fe8bffe70da38d7d4a07bd81df0f4ec12eb31684f9ee1684a9e7e', '56ab593a396187823b3637946e6414a4379b097167b758c9dc62b0c6d5f6b087', '2026-07-23 08:39:37'),
(564, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 179, '{\"work_date\":\"2026-07-25\"}', '203.189.116.64', '56ab593a396187823b3637946e6414a4379b097167b758c9dc62b0c6d5f6b087', '6c947a613b4906b2de7698239025dca0b9ed54488529cabc5e0d2ee2e74ba561', '2026-07-23 08:39:37'),
(565, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 180, '{\"work_date\":\"2026-07-26\"}', '203.189.116.64', '6c947a613b4906b2de7698239025dca0b9ed54488529cabc5e0d2ee2e74ba561', '21ef3c53b3d4848f1b4f46170ab36125d71e1951361b59e95ba5bab517377c1a', '2026-07-23 08:39:37'),
(566, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 181, '{\"work_date\":\"2026-07-27\"}', '203.189.116.64', '21ef3c53b3d4848f1b4f46170ab36125d71e1951361b59e95ba5bab517377c1a', '0b809b3f211609367950b1f614ef810a5f45c1ffb8a5ee93214134635b5e6bcf', '2026-07-23 08:39:37'),
(567, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 182, '{\"work_date\":\"2026-07-28\"}', '203.189.116.64', '0b809b3f211609367950b1f614ef810a5f45c1ffb8a5ee93214134635b5e6bcf', '8dbee4e83e57ce94e0c547bb95ef02dac981b071a35842da353a55fa2d0b1ec4', '2026-07-23 08:39:37'),
(568, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 183, '{\"work_date\":\"2026-07-29\"}', '203.189.116.64', '8dbee4e83e57ce94e0c547bb95ef02dac981b071a35842da353a55fa2d0b1ec4', '476cfdfeea41e3d7e74134c1c0d6780b5f897b0d4609b7e300f2b1867bcb14ad', '2026-07-23 08:39:37'),
(569, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 184, '{\"work_date\":\"2026-07-30\"}', '203.189.116.64', '476cfdfeea41e3d7e74134c1c0d6780b5f897b0d4609b7e300f2b1867bcb14ad', '1c958a44a92d59301600900b6bf95d2f6b5b77ac102e33905d2f352369c29a88', '2026-07-23 08:39:37'),
(570, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 185, '{\"work_date\":\"2026-07-31\"}', '203.189.116.64', '1c958a44a92d59301600900b6bf95d2f6b5b77ac102e33905d2f352369c29a88', '0d6e08870263b1658465d4dc66c63590d04002a102ffb6f82a4252cefdab7f38', '2026-07-23 08:39:37'),
(571, 2, 'DTR_APPROVED', 'dtr_entries', 159, '{\"for_user_id\":3}', '203.189.116.64', '0d6e08870263b1658465d4dc66c63590d04002a102ffb6f82a4252cefdab7f38', '34bea8956c72ac73bb6088776de6ca7563c291a6e29edb873da6257c12158501', '2026-07-23 08:41:02'),
(572, 2, 'DTR_APPROVED', 'dtr_entries', 164, '{\"for_user_id\":3}', '203.189.116.64', '34bea8956c72ac73bb6088776de6ca7563c291a6e29edb873da6257c12158501', '0ab4d206e96e102892687ac8a219143d9213752830300844dcb0b3fbb30d7033', '2026-07-23 08:41:02'),
(573, 2, 'DTR_APPROVED', 'dtr_entries', 169, '{\"for_user_id\":3}', '203.189.116.64', '0ab4d206e96e102892687ac8a219143d9213752830300844dcb0b3fbb30d7033', '0ff8df5efd84c6dc942532d555b93566aeff4f4f29cbebe0045a1b225d6fe6e2', '2026-07-23 08:41:02'),
(574, 2, 'DTR_APPROVED', 'dtr_entries', 158, '{\"for_user_id\":3}', '203.189.116.64', '0ff8df5efd84c6dc942532d555b93566aeff4f4f29cbebe0045a1b225d6fe6e2', '27b3ce0cea0e37cd20a9ac8c549e18fa310c9f540a4d72e01a0e2d1d1d158d50', '2026-07-23 08:41:02'),
(575, 2, 'DTR_APPROVED', 'dtr_entries', 163, '{\"for_user_id\":3}', '203.189.116.64', '27b3ce0cea0e37cd20a9ac8c549e18fa310c9f540a4d72e01a0e2d1d1d158d50', 'db6cdb2313f58995168a14bc41e05d083fe0f717f1a436a8c74ef1b3cdd3518b', '2026-07-23 08:41:02'),
(576, 2, 'DTR_APPROVED', 'dtr_entries', 168, '{\"for_user_id\":3}', '203.189.116.64', 'db6cdb2313f58995168a14bc41e05d083fe0f717f1a436a8c74ef1b3cdd3518b', '3fba22b60bf8287a5c8ad4f9adfb2114c7488e25884608c642d2db681c429319', '2026-07-23 08:41:02'),
(577, 2, 'DTR_APPROVED', 'dtr_entries', 157, '{\"for_user_id\":3}', '203.189.116.64', '3fba22b60bf8287a5c8ad4f9adfb2114c7488e25884608c642d2db681c429319', 'b80dc13717cb4d19a4dbd3cd9674ad79489701322f8c0110dec40cafb3ec06da', '2026-07-23 08:41:02'),
(578, 2, 'DTR_APPROVED', 'dtr_entries', 162, '{\"for_user_id\":3}', '203.189.116.64', 'b80dc13717cb4d19a4dbd3cd9674ad79489701322f8c0110dec40cafb3ec06da', 'e1b552d989b9fdfe5687b9141b1a57fe09f45531c04247a3f00ccb7b1f6930a0', '2026-07-23 08:41:02'),
(579, 2, 'DTR_APPROVED', 'dtr_entries', 167, '{\"for_user_id\":3}', '203.189.116.64', 'e1b552d989b9fdfe5687b9141b1a57fe09f45531c04247a3f00ccb7b1f6930a0', 'a9bebbb1059b4e894643b59ea0f72427bcc7172f318f10086f275190dced7c34', '2026-07-23 08:41:02'),
(580, 2, 'DTR_APPROVED', 'dtr_entries', 156, '{\"for_user_id\":3}', '203.189.116.64', 'a9bebbb1059b4e894643b59ea0f72427bcc7172f318f10086f275190dced7c34', 'd26fb650a1a07ab3fa50e612dfbf9a578ffba3eff6e407234c52d2325a7964a8', '2026-07-23 08:41:02'),
(581, 2, 'DTR_APPROVED', 'dtr_entries', 161, '{\"for_user_id\":3}', '203.189.116.64', 'd26fb650a1a07ab3fa50e612dfbf9a578ffba3eff6e407234c52d2325a7964a8', 'f0d3a0a88203b69ac6e293b375a621a787f71fa2778ecc444a44c5a6dc55c847', '2026-07-23 08:41:02'),
(582, 2, 'DTR_APPROVED', 'dtr_entries', 166, '{\"for_user_id\":3}', '203.189.116.64', 'f0d3a0a88203b69ac6e293b375a621a787f71fa2778ecc444a44c5a6dc55c847', '29f6ff44eaabebee5d2a9227b1e25420c1269256d3ebd1bc19e1347bed35595f', '2026-07-23 08:41:02'),
(583, 2, 'DTR_APPROVED', 'dtr_entries', 155, '{\"for_user_id\":3}', '203.189.116.64', '29f6ff44eaabebee5d2a9227b1e25420c1269256d3ebd1bc19e1347bed35595f', '3a17e5568f554100c2d86030ec888cb22759c169ad5b0741247ba1e4427c6d0c', '2026-07-23 08:41:02'),
(584, 2, 'DTR_APPROVED', 'dtr_entries', 160, '{\"for_user_id\":3}', '203.189.116.64', '3a17e5568f554100c2d86030ec888cb22759c169ad5b0741247ba1e4427c6d0c', 'c60b897273acdb37a12e1d99be15f83ef79ba9648313daff7f191646282679c2', '2026-07-23 08:41:02'),
(585, 2, 'DTR_APPROVED', 'dtr_entries', 165, '{\"for_user_id\":3}', '203.189.116.64', 'c60b897273acdb37a12e1d99be15f83ef79ba9648313daff7f191646282679c2', '58af2d744940f034deb65c0f47ad9def838572a98af34b78cbb5af42cfdf1e52', '2026-07-23 08:41:02'),
(586, 2, 'DTR_APPROVED', 'dtr_entries', 182, '{\"for_user_id\":3}', '203.189.116.64', '58af2d744940f034deb65c0f47ad9def838572a98af34b78cbb5af42cfdf1e52', 'b72a0b8ff02ff9eff1a212a5c3f8a8601feb54a0e6f6784c08e974074811455a', '2026-07-23 08:41:55'),
(587, 2, 'DTR_APPROVED', 'dtr_entries', 171, '{\"for_user_id\":3}', '203.189.116.64', 'b72a0b8ff02ff9eff1a212a5c3f8a8601feb54a0e6f6784c08e974074811455a', '5ffc985ba5ee4ceecd62406b233b853e061e332c35330dce1da6349437f80226', '2026-07-23 08:41:55'),
(588, 2, 'DTR_APPROVED', 'dtr_entries', 176, '{\"for_user_id\":3}', '203.189.116.64', '5ffc985ba5ee4ceecd62406b233b853e061e332c35330dce1da6349437f80226', '1c4aa7990bd5fda14e687b5c105149b79352e058faa38bf9cb1bc138952305a2', '2026-07-23 08:41:55'),
(589, 2, 'DTR_APPROVED', 'dtr_entries', 181, '{\"for_user_id\":3}', '203.189.116.64', '1c4aa7990bd5fda14e687b5c105149b79352e058faa38bf9cb1bc138952305a2', '0f3ec3ee3ed57c0d59a4e5fb1e34cc986bb866e2d1b7055dfd4d5103bf51f23e', '2026-07-23 08:41:55'),
(590, 2, 'DTR_APPROVED', 'dtr_entries', 170, '{\"for_user_id\":3}', '203.189.116.64', '0f3ec3ee3ed57c0d59a4e5fb1e34cc986bb866e2d1b7055dfd4d5103bf51f23e', 'fd7f16a597998c7e3eb455b9fb404cca64c4c1fc93fc7d15ec62c19792fb0274', '2026-07-23 08:41:55'),
(591, 2, 'DTR_APPROVED', 'dtr_entries', 175, '{\"for_user_id\":3}', '203.189.116.64', 'fd7f16a597998c7e3eb455b9fb404cca64c4c1fc93fc7d15ec62c19792fb0274', 'c67c64f26d699681c8d24cf455ab9f63460513f3595edfb21328d73781d1eda8', '2026-07-23 08:41:55'),
(592, 2, 'DTR_APPROVED', 'dtr_entries', 180, '{\"for_user_id\":3}', '203.189.116.64', 'c67c64f26d699681c8d24cf455ab9f63460513f3595edfb21328d73781d1eda8', '9b1a8238d5b95f43ae4da687f71435883563bc5a67b7c6969c2c474c15324734', '2026-07-23 08:41:55'),
(593, 2, 'DTR_APPROVED', 'dtr_entries', 185, '{\"for_user_id\":3}', '203.189.116.64', '9b1a8238d5b95f43ae4da687f71435883563bc5a67b7c6969c2c474c15324734', 'a1db19c2eea0343d0b07a25547b2ea1ca756f9f2cd85541ac94f0457f20aa745', '2026-07-23 08:41:55'),
(594, 2, 'DTR_APPROVED', 'dtr_entries', 174, '{\"for_user_id\":3}', '203.189.116.64', 'a1db19c2eea0343d0b07a25547b2ea1ca756f9f2cd85541ac94f0457f20aa745', 'ffb1063b92e8d992754062f43ec2fc8bcce792669231df224bfb065d464770fe', '2026-07-23 08:41:55'),
(595, 2, 'DTR_APPROVED', 'dtr_entries', 179, '{\"for_user_id\":3}', '203.189.116.64', 'ffb1063b92e8d992754062f43ec2fc8bcce792669231df224bfb065d464770fe', 'd6348f44c4380f21539a4fdb31d976a4e4c40ad8b49e47a8bab9080ce154b04d', '2026-07-23 08:41:55'),
(596, 2, 'DTR_APPROVED', 'dtr_entries', 184, '{\"for_user_id\":3}', '203.189.116.64', 'd6348f44c4380f21539a4fdb31d976a4e4c40ad8b49e47a8bab9080ce154b04d', 'ca55930d548c32bfcbf95cea3f2c41e535ecc11938a420f3a77213f14025726e', '2026-07-23 08:41:55'),
(597, 2, 'DTR_APPROVED', 'dtr_entries', 173, '{\"for_user_id\":3}', '203.189.116.64', 'ca55930d548c32bfcbf95cea3f2c41e535ecc11938a420f3a77213f14025726e', 'aa446c3f960f683739e70351d9339702c439c862c407c11dd7034290f3b251d0', '2026-07-23 08:41:55'),
(598, 2, 'DTR_APPROVED', 'dtr_entries', 178, '{\"for_user_id\":3}', '203.189.116.64', 'aa446c3f960f683739e70351d9339702c439c862c407c11dd7034290f3b251d0', '7abb0018682321850854adac02729920b482c13e89364d830d4ee6f2112ed2b2', '2026-07-23 08:41:55'),
(599, 2, 'DTR_APPROVED', 'dtr_entries', 183, '{\"for_user_id\":3}', '203.189.116.64', '7abb0018682321850854adac02729920b482c13e89364d830d4ee6f2112ed2b2', 'fd3c79bebae66e1caa3e859853001497cfd78b56f7f917965d32c65fc5a9ea52', '2026-07-23 08:41:55'),
(600, 2, 'DTR_APPROVED', 'dtr_entries', 172, '{\"for_user_id\":3}', '203.189.116.64', 'fd3c79bebae66e1caa3e859853001497cfd78b56f7f917965d32c65fc5a9ea52', 'fedad5467c8059b5e61a0edacd50b5fff70a80a5555ea29d1624c451c399be51', '2026-07-23 08:41:55'),
(601, 2, 'DTR_APPROVED', 'dtr_entries', 177, '{\"for_user_id\":3}', '203.189.116.64', 'fedad5467c8059b5e61a0edacd50b5fff70a80a5555ea29d1624c451c399be51', '53ced145cb4c2b057cf6ffe82b9cb2d6599a09beaf2da26c10bf8b4b6d093468', '2026-07-23 08:41:55'),
(602, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '149.30.146.195', '53ced145cb4c2b057cf6ffe82b9cb2d6599a09beaf2da26c10bf8b4b6d093468', '994f50da721d083c8dcc8efd588eed56d2613f762acb5166d0c50db15f3230f8', '2026-07-23 13:01:27'),
(603, 1, 'LOGIN_SUCCESS', 'users', 1, '[]', '149.30.146.195', '994f50da721d083c8dcc8efd588eed56d2613f762acb5166d0c50db15f3230f8', '3246859095357126d7cbfba3b2632ba1edf47e0aa71ecc027aa6ab4edfdc6d06', '2026-07-23 14:23:31'),
(604, 3, 'LOGIN_SUCCESS', 'users', 3, '[]', '149.30.146.195', '3246859095357126d7cbfba3b2632ba1edf47e0aa71ecc027aa6ab4edfdc6d06', '6a336b901f509f3a7ca6dab5d452eb057d8025bf7aaa993d1a3c8d474939045d', '2026-07-23 14:25:13'),
(605, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '149.30.146.195', '6a336b901f509f3a7ca6dab5d452eb057d8025bf7aaa993d1a3c8d474939045d', '2f74753e3940c5c16e6abe8af339f968b397519b488ffafbb99b4251ff215457', '2026-07-23 14:27:28'),
(606, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 186, '{\"work_date\":\"2026-06-01\"}', '149.30.146.195', '2f74753e3940c5c16e6abe8af339f968b397519b488ffafbb99b4251ff215457', '177a2441dc6cbfdb1670f0de24e2865bededc62b415504e0cd3c7edaab90aca4', '2026-07-23 14:29:43'),
(607, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 187, '{\"work_date\":\"2026-06-02\"}', '149.30.146.195', '177a2441dc6cbfdb1670f0de24e2865bededc62b415504e0cd3c7edaab90aca4', '6b79a773671f154e460e6de62d2defd93b4709c2997056d18f65e384fb8c0ef4', '2026-07-23 14:36:21'),
(608, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 188, '{\"work_date\":\"2026-06-03\"}', '149.30.146.195', '6b79a773671f154e460e6de62d2defd93b4709c2997056d18f65e384fb8c0ef4', '84e2996cbb709a7a578d2ed89886e17b0636ebc3249a17bd68c203c36742e07b', '2026-07-23 14:36:21'),
(609, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 189, '{\"work_date\":\"2026-06-04\"}', '149.30.146.195', '84e2996cbb709a7a578d2ed89886e17b0636ebc3249a17bd68c203c36742e07b', 'baf505eb9cb94d29dffe4b701663363fab0c2fbfbef11785e1767c6d4e503376', '2026-07-23 14:36:21'),
(610, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 190, '{\"work_date\":\"2026-06-05\"}', '149.30.146.195', 'baf505eb9cb94d29dffe4b701663363fab0c2fbfbef11785e1767c6d4e503376', '3eb35a8686299b3edc9cf937e98cdc404954ac576069a1d0078ed27ff32992b4', '2026-07-23 14:36:21'),
(611, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 191, '{\"work_date\":\"2026-06-06\"}', '149.30.146.195', '3eb35a8686299b3edc9cf937e98cdc404954ac576069a1d0078ed27ff32992b4', 'f1ba4c668580f8eddb0c0acb4c4c7553800d291013cf1734121afae9df07cbdf', '2026-07-23 14:36:21'),
(612, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 192, '{\"work_date\":\"2026-06-07\"}', '149.30.146.195', 'f1ba4c668580f8eddb0c0acb4c4c7553800d291013cf1734121afae9df07cbdf', '52496df1b949c3a9d5d60a176a460c55ce3190cd812f5627fcf9fb9075c1acff', '2026-07-23 14:36:21'),
(613, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 193, '{\"work_date\":\"2026-06-08\"}', '149.30.146.195', '52496df1b949c3a9d5d60a176a460c55ce3190cd812f5627fcf9fb9075c1acff', '1f01b6d0cab51b0e4a52e408b1eed18bfe0928a5d97918bff1b168c0a01ebbfa', '2026-07-23 14:36:21'),
(614, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 194, '{\"work_date\":\"2026-06-09\"}', '149.30.146.195', '1f01b6d0cab51b0e4a52e408b1eed18bfe0928a5d97918bff1b168c0a01ebbfa', 'b568d71e831f068e972e8c3b6ecc4f5b42c28f9dfa9048b8970405eae840cb46', '2026-07-23 14:36:21'),
(615, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 195, '{\"work_date\":\"2026-06-10\"}', '149.30.146.195', 'b568d71e831f068e972e8c3b6ecc4f5b42c28f9dfa9048b8970405eae840cb46', 'ec769f16817bb7853970bf91495d65c7d30cbf577129aa399b176d819425c498', '2026-07-23 14:36:21'),
(616, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 196, '{\"work_date\":\"2026-06-11\"}', '149.30.146.195', 'ec769f16817bb7853970bf91495d65c7d30cbf577129aa399b176d819425c498', '63a619d9508a9a17f0a935835d1d20a64a6a859945cc4d7a6fe21df1381f9b54', '2026-07-23 14:36:21'),
(617, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 197, '{\"work_date\":\"2026-06-12\"}', '149.30.146.195', '63a619d9508a9a17f0a935835d1d20a64a6a859945cc4d7a6fe21df1381f9b54', '1e4f42e683e901010d1865467c5607cf708b3c30a49ce4e4231b5fd2a6a2df28', '2026-07-23 14:36:21'),
(618, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 198, '{\"work_date\":\"2026-06-13\"}', '149.30.146.195', '1e4f42e683e901010d1865467c5607cf708b3c30a49ce4e4231b5fd2a6a2df28', '90042f0224fc12882ffffae89b3b3eb7c97a993cdfa47db664000d5f010e8a1e', '2026-07-23 14:36:21'),
(619, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 199, '{\"work_date\":\"2026-06-14\"}', '149.30.146.195', '90042f0224fc12882ffffae89b3b3eb7c97a993cdfa47db664000d5f010e8a1e', '8d6e7ffc6645f46e49bbf16b392f2ee187d8ea8e5b9ac2324736ff885fc14aeb', '2026-07-23 14:36:21'),
(620, 3, 'DTR_SELF_SUBMITTED', 'dtr_entries', 200, '{\"work_date\":\"2026-06-15\"}', '149.30.146.195', '8d6e7ffc6645f46e49bbf16b392f2ee187d8ea8e5b9ac2324736ff885fc14aeb', '321b210b9e1cc8e9bdc00a908bb5144eb2ce83ff2ce1fbf0a2a488868625022f', '2026-07-23 14:36:21'),
(621, 2, 'DTR_APPROVED', 'dtr_entries', 187, '{\"for_user_id\":3}', '149.30.146.195', '321b210b9e1cc8e9bdc00a908bb5144eb2ce83ff2ce1fbf0a2a488868625022f', '0aa6a96133589f72a6235b680a9cab912229e396752417c93e7c18c0a6e5cd21', '2026-07-23 14:37:09');
INSERT INTO `audit_log` (`log_id`, `actor_user_id`, `action`, `target_table`, `target_id`, `details`, `ip_address`, `prev_hash`, `row_hash`, `created_at`) VALUES
(622, 2, 'DTR_APPROVED', 'dtr_entries', 188, '{\"for_user_id\":3}', '149.30.146.195', '0aa6a96133589f72a6235b680a9cab912229e396752417c93e7c18c0a6e5cd21', '9de2deeddd83d0561321cda59cda309fd8e3901f4eb98d6dc8a3d78c76489d64', '2026-07-23 14:37:09'),
(623, 2, 'DTR_APPROVED', 'dtr_entries', 189, '{\"for_user_id\":3}', '149.30.146.195', '9de2deeddd83d0561321cda59cda309fd8e3901f4eb98d6dc8a3d78c76489d64', '88c147f7c3e9934a7e065aeaed72c5ee0a2b969dca42247007fe851744471593', '2026-07-23 14:37:09'),
(624, 2, 'DTR_APPROVED', 'dtr_entries', 190, '{\"for_user_id\":3}', '149.30.146.195', '88c147f7c3e9934a7e065aeaed72c5ee0a2b969dca42247007fe851744471593', 'c6f4858ede2cd8fe19969555e33a39dda2a1e4af7b9738122455c2a360d22377', '2026-07-23 14:37:09'),
(625, 2, 'DTR_APPROVED', 'dtr_entries', 191, '{\"for_user_id\":3}', '149.30.146.195', 'c6f4858ede2cd8fe19969555e33a39dda2a1e4af7b9738122455c2a360d22377', '3df48711ac2b16b9debbe314b9b06f025379d6d88c89eeb7038a8985abc8843d', '2026-07-23 14:37:09'),
(626, 2, 'DTR_APPROVED', 'dtr_entries', 192, '{\"for_user_id\":3}', '149.30.146.195', '3df48711ac2b16b9debbe314b9b06f025379d6d88c89eeb7038a8985abc8843d', 'dd2faa361c5816ece8de0c4ede0c0af1d22855507d67a14aab55b470474d0b69', '2026-07-23 14:37:09'),
(627, 2, 'DTR_APPROVED', 'dtr_entries', 193, '{\"for_user_id\":3}', '149.30.146.195', 'dd2faa361c5816ece8de0c4ede0c0af1d22855507d67a14aab55b470474d0b69', '6187b4759490253c86a41bdb140aae5e87d54b01069a23fc15ce557e592aa580', '2026-07-23 14:37:09'),
(628, 2, 'DTR_APPROVED', 'dtr_entries', 194, '{\"for_user_id\":3}', '149.30.146.195', '6187b4759490253c86a41bdb140aae5e87d54b01069a23fc15ce557e592aa580', '9e15ee7ad2d58dfd0ec842455f1661f8e04506106bd7ed8cb449fd44d1e8261a', '2026-07-23 14:37:09'),
(629, 2, 'DTR_APPROVED', 'dtr_entries', 195, '{\"for_user_id\":3}', '149.30.146.195', '9e15ee7ad2d58dfd0ec842455f1661f8e04506106bd7ed8cb449fd44d1e8261a', '0857f008f237bf753853c597f7a538d814331c008fda4527886f621b6c4f94df', '2026-07-23 14:37:09'),
(630, 2, 'DTR_APPROVED', 'dtr_entries', 196, '{\"for_user_id\":3}', '149.30.146.195', '0857f008f237bf753853c597f7a538d814331c008fda4527886f621b6c4f94df', '479c7960d4a37006b3fd83d5418a9c7266921bf49630485502bee8fe524e6ea7', '2026-07-23 14:37:09'),
(631, 2, 'DTR_APPROVED', 'dtr_entries', 197, '{\"for_user_id\":3}', '149.30.146.195', '479c7960d4a37006b3fd83d5418a9c7266921bf49630485502bee8fe524e6ea7', '94ccf3dd2a0eacc44d73e065f2167f5c20a271117cda3ef60e609cde5349feb9', '2026-07-23 14:37:09'),
(632, 2, 'DTR_APPROVED', 'dtr_entries', 198, '{\"for_user_id\":3}', '149.30.146.195', '94ccf3dd2a0eacc44d73e065f2167f5c20a271117cda3ef60e609cde5349feb9', 'baf8d1c72777c9a827c4b38b6f22b1dac731be63dc12f72f12338970ca467c47', '2026-07-23 14:37:09'),
(633, 2, 'DTR_APPROVED', 'dtr_entries', 199, '{\"for_user_id\":3}', '149.30.146.195', 'baf8d1c72777c9a827c4b38b6f22b1dac731be63dc12f72f12338970ca467c47', 'e62b96dc68a40203380fc32ebddd95eb48979d46ceeccfc0c1479a959c85d7df', '2026-07-23 14:37:09'),
(634, 2, 'DTR_APPROVED', 'dtr_entries', 200, '{\"for_user_id\":3}', '149.30.146.195', 'e62b96dc68a40203380fc32ebddd95eb48979d46ceeccfc0c1479a959c85d7df', 'ac5eebf19d3e152b6245f5c6472b4ae4ccf4c4ae9beecb403bbce38eb6eddf70', '2026-07-23 14:37:09'),
(635, 2, 'DTR_APPROVED', 'dtr_entries', 186, '{\"for_user_id\":3}', '149.30.146.195', 'ac5eebf19d3e152b6245f5c6472b4ae4ccf4c4ae9beecb403bbce38eb6eddf70', '818b2fe5d64f1bc8a97d2e50cd4b12f2c412f8cd6568e103e792d3501484eb55', '2026-07-23 14:37:21'),
(636, 2, 'LOGOUT', 'users', 2, '[]', '149.30.146.195', '818b2fe5d64f1bc8a97d2e50cd4b12f2c412f8cd6568e103e792d3501484eb55', '2b29825cb4979c6034d661b99990e252dbf217579efddc946fcca1c6d7cfe2bc', '2026-07-23 15:13:18'),
(637, 3, 'LOGOUT', 'users', 3, '[]', '149.30.146.195', '2b29825cb4979c6034d661b99990e252dbf217579efddc946fcca1c6d7cfe2bc', '2641e3c80b83864fd40c2cebce243acf0a9883b2df52149dad40bde02d9feed5', '2026-07-23 15:16:05'),
(638, 1, 'LOGOUT', 'users', 1, '[]', '149.30.146.195', '2641e3c80b83864fd40c2cebce243acf0a9883b2df52149dad40bde02d9feed5', 'f46fdce769d9fb448802a4b2da0eb8699b29ae13d73e396ea51412e85680a84d', '2026-07-23 15:18:28'),
(639, 2, 'LOGIN_SUCCESS', 'users', 2, '[]', '149.30.146.195', 'f46fdce769d9fb448802a4b2da0eb8699b29ae13d73e396ea51412e85680a84d', 'e2a2cdf274e6c230176969b08d07d8f0d9a64b58728ae0b581bdc8a77bea2934', '2026-07-23 15:56:14'),
(640, 2, 'LOGOUT', 'users', 2, '[]', '149.30.146.195', 'e2a2cdf274e6c230176969b08d07d8f0d9a64b58728ae0b581bdc8a77bea2934', '803cf56ed4781925619993b977e9213fccdc55bd1103c13a9ec0baa6648da9eb', '2026-07-23 16:00:12');

-- --------------------------------------------------------

--
-- Table structure for table `dtr_entries`
--

CREATE TABLE `dtr_entries` (
  `dtr_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `work_date` date NOT NULL,
  `time_in` datetime NOT NULL,
  `time_out` datetime DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `computed_hours` decimal(5,2) GENERATED ALWAYS AS (case when `time_out` is null then NULL when timestampdiff(MINUTE,`time_in`,`time_out`) / 60 > 8 then round(timestampdiff(MINUTE,`time_in`,`time_out`) / 60 - 1,2) else round(timestampdiff(MINUTE,`time_in`,`time_out`) / 60,2) end) STORED,
  `status` enum('pending','approved','flagged_backdated','rejected') NOT NULL DEFAULT 'approved',
  `is_backdated` tinyint(1) NOT NULL DEFAULT 0,
  `approved_by` int(10) UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dtr_entries`
--

INSERT INTO `dtr_entries` (`dtr_id`, `user_id`, `work_date`, `time_in`, `time_out`, `photo_path`, `status`, `is_backdated`, `approved_by`, `approved_at`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(155, 3, '2026-07-01', '2026-07-01 06:30:00', '2026-07-01 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(156, 3, '2026-07-02', '2026-07-02 06:30:00', '2026-07-02 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(157, 3, '2026-07-03', '2026-07-03 06:30:00', '2026-07-03 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(158, 3, '2026-07-04', '2026-07-04 06:30:00', '2026-07-04 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(159, 3, '2026-07-05', '2026-07-05 06:30:00', '2026-07-05 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(160, 3, '2026-07-06', '2026-07-06 06:30:00', '2026-07-06 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(161, 3, '2026-07-07', '2026-07-07 06:30:00', '2026-07-07 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(162, 3, '2026-07-08', '2026-07-08 06:30:00', '2026-07-08 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(163, 3, '2026-07-09', '2026-07-09 06:30:00', '2026-07-09 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(164, 3, '2026-07-10', '2026-07-10 06:30:00', '2026-07-10 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(165, 3, '2026-07-11', '2026-07-11 06:30:00', '2026-07-11 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(166, 3, '2026-07-12', '2026-07-12 06:30:00', '2026-07-12 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(167, 3, '2026-07-13', '2026-07-13 06:30:00', '2026-07-13 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(168, 3, '2026-07-14', '2026-07-14 06:30:00', '2026-07-14 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(169, 3, '2026-07-15', '2026-07-15 06:30:00', '2026-07-15 21:00:00', 'f9f6e6f560607152a95ddc38b24ed429.png', 'approved', 0, 2, '2026-07-23 08:41:02', NULL, '2026-07-23 08:28:18', '2026-07-23 08:41:02'),
(170, 3, '2026-07-16', '2026-07-16 06:30:00', '2026-07-16 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(171, 3, '2026-07-17', '2026-07-17 06:30:00', '2026-07-17 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(172, 3, '2026-07-18', '2026-07-18 06:30:00', '2026-07-18 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(173, 3, '2026-07-19', '2026-07-19 06:30:00', '2026-07-19 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(174, 3, '2026-07-20', '2026-07-20 06:30:00', '2026-07-20 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(175, 3, '2026-07-21', '2026-07-21 06:30:00', '2026-07-21 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(176, 3, '2026-07-22', '2026-07-22 06:30:00', '2026-07-22 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(177, 3, '2026-07-23', '2026-07-23 06:30:00', '2026-07-23 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(178, 3, '2026-07-24', '2026-07-24 06:30:00', '2026-07-24 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(179, 3, '2026-07-25', '2026-07-25 06:30:00', '2026-07-25 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(180, 3, '2026-07-26', '2026-07-26 06:30:00', '2026-07-26 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(181, 3, '2026-07-27', '2026-07-27 06:30:00', '2026-07-27 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(182, 3, '2026-07-28', '2026-07-28 06:30:00', '2026-07-28 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(183, 3, '2026-07-29', '2026-07-29 06:30:00', '2026-07-29 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(184, 3, '2026-07-30', '2026-07-30 06:30:00', '2026-07-30 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(185, 3, '2026-07-31', '2026-07-31 06:30:00', '2026-07-31 18:00:00', 'f77936b9e7b2d0cedd2ea7335067b79c.jpg', 'approved', 0, 2, '2026-07-23 08:41:55', NULL, '2026-07-23 08:39:37', '2026-07-23 08:41:55'),
(186, 3, '2026-06-01', '2026-06-01 06:30:00', '2026-06-01 17:00:00', 'eff8193bbcc0a986d572708a56d3d000.jpg', 'approved', 0, 2, '2026-07-23 14:37:21', NULL, '2026-07-23 14:29:43', '2026-07-23 14:37:21'),
(187, 3, '2026-06-02', '2026-06-02 06:30:00', '2026-06-02 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(188, 3, '2026-06-03', '2026-06-03 06:30:00', '2026-06-03 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(189, 3, '2026-06-04', '2026-06-04 06:30:00', '2026-06-04 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(190, 3, '2026-06-05', '2026-06-05 06:30:00', '2026-06-05 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(191, 3, '2026-06-06', '2026-06-06 06:30:00', '2026-06-06 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(192, 3, '2026-06-07', '2026-06-07 06:30:00', '2026-06-07 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(193, 3, '2026-06-08', '2026-06-08 06:30:00', '2026-06-08 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(194, 3, '2026-06-09', '2026-06-09 06:30:00', '2026-06-09 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(195, 3, '2026-06-10', '2026-06-10 06:30:00', '2026-06-10 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(196, 3, '2026-06-11', '2026-06-11 06:30:00', '2026-06-11 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(197, 3, '2026-06-12', '2026-06-12 06:30:00', '2026-06-12 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(198, 3, '2026-06-13', '2026-06-13 06:30:00', '2026-06-13 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(199, 3, '2026-06-14', '2026-06-14 06:30:00', '2026-06-14 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09'),
(200, 3, '2026-06-15', '2026-06-15 06:30:00', '2026-06-15 17:00:00', 'efeed1e9a4bfda9056847a3826ce04a4.jpg', 'approved', 0, 2, '2026-07-23 14:37:09', NULL, '2026-07-23 14:36:21', '2026-07-23 14:37:09');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `attempt_id` int(10) UNSIGNED NOT NULL,
  `id_number` varchar(30) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `success` tinyint(1) NOT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `login_attempts`
--

INSERT INTO `login_attempts` (`attempt_id`, `id_number`, `ip_address`, `success`, `attempted_at`) VALUES
(1, '1-210253f', '::1', 1, '2026-07-17 01:03:56'),
(2, '1-210253f', '::1', 1, '2026-07-17 01:06:36'),
(3, '1-210253f', '::1', 1, '2026-07-17 01:09:42'),
(4, '1-210213A', '::1', 1, '2026-07-17 01:09:53'),
(5, '1-210253f', '::1', 1, '2026-07-17 01:54:53'),
(6, '1-210213A', '::1', 1, '2026-07-17 01:57:09'),
(7, '1-210213A', '::1', 1, '2026-07-17 03:00:18'),
(8, '1-210253f', '::1', 1, '2026-07-17 03:04:05'),
(9, '1-210213A', '::1', 1, '2026-07-17 07:48:35'),
(10, '1-210253', '::1', 0, '2026-07-17 07:48:44'),
(11, '1-210253f', '::1', 1, '2026-07-17 07:48:54'),
(12, '1-210253f', '::1', 0, '2026-07-18 03:03:59'),
(13, '1-210253F', '::1', 1, '2026-07-18 03:04:10'),
(14, 'raffylorico@example.com', '::1', 0, '2026-07-18 03:49:31'),
(15, 'raffylorico@example.com', '::1', 0, '2026-07-18 03:49:49'),
(16, 'raffylorico@example.com', '::1', 0, '2026-07-18 03:50:10'),
(17, 'raffylorico@example.com', '::1', 0, '2026-07-18 03:50:20'),
(18, 'raffylorico@example.com', '::1', 0, '2026-07-18 03:50:31'),
(19, '1-210213A', '::1', 1, '2026-07-18 03:50:57'),
(20, '1-210253f', '::1', 1, '2026-07-18 05:00:44'),
(21, 'raffylorico@example.com', '::1', 0, '2026-07-19 03:22:38'),
(22, 'raffylorico@example.com', '::1', 0, '2026-07-19 03:22:48'),
(23, '1-210253f', '::1', 1, '2026-07-19 03:22:55'),
(24, '1-210213A', '::1', 1, '2026-07-19 03:33:57'),
(25, '1-210253f', '::1', 1, '2026-07-19 03:34:15'),
(26, '1-210213A', '::1', 1, '2026-07-19 04:00:53'),
(27, '1-210213A', '::1', 1, '2026-07-19 04:04:40'),
(28, '1-210253f', '::1', 0, '2026-07-19 04:09:41'),
(29, '1-210253f', '::1', 0, '2026-07-19 04:09:48'),
(30, '1-210213A', '::1', 0, '2026-07-19 04:10:03'),
(31, '1-210213A', '::1', 0, '2026-07-19 04:10:13'),
(32, '1-210253f', '::1', 1, '2026-07-19 04:10:19'),
(33, '1-210253f', '::1', 1, '2026-07-19 04:11:37'),
(34, '1-210253f', '::1', 1, '2026-07-19 04:17:28'),
(35, '1-210253f', '::1', 1, '2026-07-19 04:30:02'),
(36, '1-210253f', '::1', 1, '2026-07-19 04:31:16'),
(37, '1-210253f', '::1', 1, '2026-07-19 04:34:49'),
(38, '1-210253f', '::1', 1, '2026-07-19 05:18:06'),
(39, '1-210213A', '::1', 0, '2026-07-19 05:48:24'),
(40, '1-210213A', '::1', 0, '2026-07-19 05:48:30'),
(41, '1-210213A', '::1', 1, '2026-07-19 05:48:49'),
(42, '1-210253f', '::1', 1, '2026-07-19 05:54:27'),
(43, '1-210213A', '::1', 1, '2026-07-19 06:26:57'),
(44, '1-210213A', '::1', 1, '2026-07-20 14:26:12'),
(45, '1-210253f', '::1', 1, '2026-07-20 14:26:37'),
(46, '1-210253f', '::1', 1, '2026-07-21 00:58:31'),
(47, '1-210253f', '::1', 1, '2026-07-21 01:08:39'),
(48, '1-210213A', '::1', 1, '2026-07-21 01:08:53'),
(49, '1-210253f', '::1', 1, '2026-07-21 03:22:54'),
(50, '1-210213A', '::1', 1, '2026-07-21 03:25:07'),
(51, '1-210253f', '::1', 1, '2026-07-21 03:25:33'),
(52, '1-210213A', '::1', 1, '2026-07-21 03:35:36'),
(53, '1-210213A', '::1', 1, '2026-07-21 03:38:49'),
(54, '1-210213A', '::1', 1, '2026-07-21 03:44:54'),
(55, '1-210253e', '::1', 1, '2026-07-21 04:03:25'),
(56, '1-210253e', '::1', 1, '2026-07-21 04:05:13'),
(57, '1-210213A', '::1', 1, '2026-07-21 08:19:52'),
(58, '1-210253e', '::1', 1, '2026-07-21 08:22:25'),
(59, '1-210213A', '::1', 1, '2026-07-21 09:08:38'),
(60, 'SA-001', '::1', 1, '2026-07-21 09:21:00'),
(61, '1-210213A', '::1', 1, '2026-07-21 09:22:50'),
(62, 'SA-002', '::1', 1, '2026-07-21 09:23:38'),
(63, 'SA-001', '::1', 1, '2026-07-21 09:25:36'),
(64, 'SA-002', '::1', 1, '2026-07-21 09:27:14'),
(65, '1-210213A', '::1', 1, '2026-07-21 12:23:06'),
(66, '1-210253f', '::1', 0, '2026-07-21 12:23:20'),
(67, '1-210253f', '::1', 1, '2026-07-21 12:23:29'),
(68, '1-210253f', '::1', 1, '2026-07-21 12:24:19'),
(69, '1-210213A', '::1', 1, '2026-07-21 12:24:35'),
(70, 'SA-001', '::1', 1, '2026-07-21 12:25:43'),
(71, '1-210253f', '::1', 1, '2026-07-21 12:27:10'),
(72, '1-210253f', '::1', 1, '2026-07-21 12:29:26'),
(73, '1-210253f', '::1', 1, '2026-07-21 12:32:26'),
(74, '1-210213A', '::1', 0, '2026-07-21 12:35:06'),
(75, '1-210213A', '::1', 1, '2026-07-21 12:35:13'),
(76, '1-210253f', '::1', 1, '2026-07-21 12:40:33'),
(77, '1-210213A', '::1', 0, '2026-07-21 12:41:18'),
(78, '1-210213A', '::1', 0, '2026-07-21 12:41:22'),
(79, '1-210213A', '::1', 1, '2026-07-21 12:41:23'),
(80, '1-210213A', '::1', 1, '2026-07-21 13:08:54'),
(81, '1-210213A', '::1', 1, '2026-07-21 16:38:09'),
(82, '1-210253e', '203.189.116.64', 0, '2026-07-23 07:24:40'),
(83, '1-210253f', '203.189.116.64', 0, '2026-07-23 07:24:56'),
(84, '1-210253f', '203.189.116.64', 0, '2026-07-23 07:30:09'),
(85, '1-210253f', '203.189.116.64', 0, '2026-07-23 07:30:18'),
(86, '1-210253f', '203.189.116.64', 0, '2026-07-23 07:31:17'),
(87, '1-210253e', '203.189.116.64', 1, '2026-07-23 07:31:49'),
(88, '1-210213A', '203.189.116.64', 1, '2026-07-23 07:32:49'),
(89, '1-210253e', '203.189.116.64', 1, '2026-07-23 07:33:42'),
(90, '1-210253f', '203.189.116.64', 1, '2026-07-23 08:11:35'),
(91, '1-210213A', '203.189.116.64', 1, '2026-07-23 08:14:36'),
(92, '1-210213A', '203.189.116.64', 1, '2026-07-23 08:20:00'),
(93, '1-210213A', '203.189.116.64', 1, '2026-07-23 08:21:57'),
(94, '1-210213A', '203.189.116.64', 1, '2026-07-23 08:26:48'),
(95, '1-210253e', '203.189.116.64', 1, '2026-07-23 08:27:47'),
(96, '1-210253f', '203.189.116.64', 1, '2026-07-23 08:29:10'),
(97, '1-210253e', '203.189.116.64', 1, '2026-07-23 08:31:31'),
(98, '1-210253f', '149.30.146.195', 1, '2026-07-23 13:01:27'),
(99, '1-210253f', '149.30.146.195', 1, '2026-07-23 14:23:31'),
(100, '1-210253e', '149.30.146.195', 1, '2026-07-23 14:25:13'),
(101, '1-210213A', '149.30.146.195', 1, '2026-07-23 14:27:28'),
(102, '1-210213A', '149.30.146.195', 1, '2026-07-23 15:56:14');

-- --------------------------------------------------------

--
-- Table structure for table `ot_advances`
--

CREATE TABLE `ot_advances` (
  `advance_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `hours_requested` decimal(5,2) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `rejection_reason` text DEFAULT NULL,
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved_by` int(10) UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ot_advances`
--

INSERT INTO `ot_advances` (`advance_id`, `user_id`, `hours_requested`, `status`, `rejection_reason`, `requested_at`, `resolved_by`, `resolved_at`) VALUES
(35, 1, '25.50', 'approved', '', '2026-07-21 17:31:07', 2, '2026-07-21 17:31:23');

-- --------------------------------------------------------

--
-- Table structure for table `ot_cashouts`
--

CREATE TABLE `ot_cashouts` (
  `cashout_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `hours_requested` decimal(5,2) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `rejection_reason` text DEFAULT NULL,
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved_by` int(10) UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `reset_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `id_number` varchar(30) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `role` enum('head_sa','student_assistant') NOT NULL DEFAULT 'student_assistant',
  `max_hours_week` decimal(5,2) NOT NULL DEFAULT 20.00,
  `required_hours` decimal(6,2) NOT NULL DEFAULT 200.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `deactivated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `id_number`, `full_name`, `email`, `password_hash`, `session_id`, `role`, `max_hours_week`, `required_hours`, `is_active`, `deactivated_at`, `created_at`, `updated_at`) VALUES
(1, '1-210253f', 'NICK RAMOS', 'johnlodiecrisostomo104@gmail.com', '$2y$12$wSP43Ik2omMAr5kNKqtiuOuXD4AhxuSiQFnBAhAY.SD8YzBcPP/22', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-17 01:01:29', '2026-07-23 15:18:28'),
(2, '1-210213A', 'Raffy Lorico', 'raffylorico@example.com', '$2y$12$wSP43Ik2omMAr5kNKqtiuOuXD4AhxuSiQFnBAhAY.SD8YzBcPP/22', NULL, 'head_sa', '0.00', '200.00', 1, NULL, '2026-07-17 01:08:51', '2026-07-23 16:00:12'),
(3, '1-210253e', 'NICOLE RAMOS', 'studentassistant2@example.com', '$2y$12$wSP43Ik2omMAr5kNKqtiuOuXD4AhxuSiQFnBAhAY.SD8YzBcPP/22', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-17 03:20:16', '2026-07-23 15:16:05'),
(4, '1-210213B', 'Kenshin Abesamis', 'studentassistant3@example.com', '$2y$12$wSP43Ik2omMAr5kNKqtiuOuXD4AhxuSiQFnBAhAY.SD8YzBcPP/22', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-19 06:03:24', '2026-07-23 07:36:31'),
(5, 'SA-001', 'Alice Smith', 'alice@test.com', '$2y$12$yqg3a//qtVi2eOX1cqZJTuIq0rBJI7dchYAz1CHRmOedCePQQfzEG', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-21 09:19:38', '2026-07-21 18:05:16'),
(6, 'SA-002', 'Bob Jones', 'bob@test.com', '$2y$12$G3HjHfIj01X3tGY7Gjs.4uUZhvZmZxwGkbvrH7RK8SZj5HDz/pQ1G', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-21 09:19:38', '2026-07-21 18:05:16'),
(7, 'SA-003', 'Charlie Brown', 'charlie@test.com', '$2y$10$j7mwcRWrCMuqoUFU7tE.nefCUzBe63iggdnPYtQ94x.9.qQcDRh.a', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-21 09:19:38', '2026-07-21 18:05:16'),
(8, 'SA-004', 'Diana Prince', 'diana@test.com', '$2y$10$j7mwcRWrCMuqoUFU7tE.nefCUzBe63iggdnPYtQ94x.9.qQcDRh.a', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-21 09:19:38', '2026-07-21 18:05:16'),
(9, 'SA-005', 'Evan Wright', 'evan@test.com', '$2y$10$j7mwcRWrCMuqoUFU7tE.nefCUzBe63iggdnPYtQ94x.9.qQcDRh.a', NULL, 'student_assistant', '20.00', '486.00', 1, NULL, '2026-07-21 09:19:38', '2026-07-21 18:05:16');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`setting_key`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `actor_user_id` (`actor_user_id`);

--
-- Indexes for table `dtr_entries`
--
ALTER TABLE `dtr_entries`
  ADD PRIMARY KEY (`dtr_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_user_date` (`user_id`,`work_date`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`attempt_id`),
  ADD KEY `idx_login_lookup` (`id_number`,`attempted_at`);

--
-- Indexes for table `ot_advances`
--
ALTER TABLE `ot_advances`
  ADD PRIMARY KEY (`advance_id`),
  ADD KEY `resolved_by` (`resolved_by`),
  ADD KEY `idx_ot_advances_status` (`status`),
  ADD KEY `idx_ot_advances_user` (`user_id`);

--
-- Indexes for table `ot_cashouts`
--
ALTER TABLE `ot_cashouts`
  ADD PRIMARY KEY (`cashout_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `resolved_by` (`resolved_by`),
  ADD KEY `idx_cashout_status` (`status`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`reset_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `id_number` (`id_number`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=641;

--
-- AUTO_INCREMENT for table `dtr_entries`
--
ALTER TABLE `dtr_entries`
  MODIFY `dtr_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `attempt_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `ot_advances`
--
ALTER TABLE `ot_advances`
  MODIFY `advance_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `ot_cashouts`
--
ALTER TABLE `ot_cashouts`
  MODIFY `cashout_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `reset_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `app_settings`
--
ALTER TABLE `app_settings`
  ADD CONSTRAINT `app_settings_ibfk_1` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `dtr_entries`
--
ALTER TABLE `dtr_entries`
  ADD CONSTRAINT `dtr_entries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `dtr_entries_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `ot_advances`
--
ALTER TABLE `ot_advances`
  ADD CONSTRAINT `ot_advances_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `ot_advances_ibfk_2` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `ot_cashouts`
--
ALTER TABLE `ot_cashouts`
  ADD CONSTRAINT `ot_cashouts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `ot_cashouts_ibfk_2` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Monthly Annual Hours Summary input (new records are separate from legacy DTR history).
--
CREATE TABLE `sa_monthly_hours` (
  `summary_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `summary_year` smallint(5) UNSIGNED NOT NULL,
  `summary_month` tinyint(3) UNSIGNED NOT NULL,
  `total_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
  `first_half_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
  `second_half_hours` decimal(7,2) NOT NULL DEFAULT 0.00,
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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
