-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Jun 29, 2026 at 12:15 PM
-- Server version: 8.0.40
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `close_x`
--

-- --------------------------------------------------------

--
-- Table structure for table `agencies`
--

CREATE TABLE `agencies` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ded_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agencies`
--

INSERT INTO `agencies` (`id`, `name`, `logo`, `orn`, `ded_license`, `address`, `attachments`, `city`, `email`, `phone`, `whatsapp`, `created_at`, `updated_at`) VALUES
(1, 'SKYLINE REALTY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(2, 'ELITE PROPERTIES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(3, 'NEXTGEN HOMES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(4, 'RENTAL SPECIALISTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 05:32:09', '2026-03-25 05:32:09'),
(5, 'Real Estate Hortage', '/storage/profiles/agency/logos/Cm5QhaEWdPOU1sRoD3tGU7UrzrBFJls0QiGhFpdA.jpg', '456758697865643', '34567897654', 'Malina Dubai', '[\"/storage/profiles/agency/attachments/hLr8727epcod8nMLRyqzw6tuNYVlAJzsmZUUOy65.webp\"]', 'Dubai', NULL, '1234567890', '1234567890', '2026-04-09 03:45:05', '2026-04-22 04:15:09'),
(6, 'Real Estate Hortage', '/storage/profiles/agency/logos/ztexhljSLVrZlcFa9dK23iIluYtYsDG3iZmPfkWr.jpg', '456758697865643', '34567897654', 'Malina Dubai', '[\"/storage/profiles/agency/attachments/JDabbHWOzyVQZQIrmGltzqDyNwcayZDsrZzlJ45z.webp\"]', 'Dubai', NULL, '1234567890', NULL, '2026-04-22 04:28:45', '2026-04-22 04:28:45'),
(7, 'Best property', NULL, 'oooooo', '123321jhg', 'gdhsufgdsbfds', '[]', 'Dubai', 'genusegulfam@gmail.com', '5551234567', '12343432343', '2026-04-22 06:45:00', '2026-05-08 09:02:09'),
(8, 'Test Agency LLC', NULL, NULL, NULL, NULL, NULL, NULL, 'agency@test.com', NULL, NULL, '2026-06-05 03:36:02', '2026-06-05 03:36:02'),
(9, 'Downtown Realty', NULL, NULL, NULL, NULL, NULL, NULL, 'a@test.com', NULL, NULL, '2026-06-05 03:40:39', '2026-06-05 03:40:39');

-- --------------------------------------------------------

--
-- Table structure for table `broker_profiles`
--

CREATE TABLE `broker_profiles` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `brn_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `experience_years` int UNSIGNED NOT NULL DEFAULT '0',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `show_whatsapp` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `broker_profiles`
--

INSERT INTO `broker_profiles` (`id`, `user_id`, `company_name`, `bio`, `brn_number`, `experience_years`, `verified`, `is_active`, `show_whatsapp`, `created_at`, `updated_at`) VALUES
(1, 1, 'Palm Luxury Estates', NULL, NULL, 5, 1, 1, 1, '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(2, 2, 'Downtown Specialists', NULL, NULL, 5, 1, 1, 1, '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(3, 3, 'NextGen Homes', NULL, NULL, 5, 1, 1, 1, '2026-03-25 05:32:09', '2026-03-25 05:32:09'),
(4, 4, NULL, NULL, NULL, 5, 1, 1, 1, '2026-03-25 05:32:09', '2026-03-25 05:32:09'),
(5, 5, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-26 06:19:05', '2026-03-26 06:19:05'),
(6, 6, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 02:26:19', '2026-03-30 02:26:19'),
(7, 7, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:19:05', '2026-03-30 03:19:05'),
(8, 8, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:24:23', '2026-03-30 03:24:23'),
(9, 9, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:25:52', '2026-03-30 03:25:52'),
(10, 10, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:27:25', '2026-03-30 03:27:25'),
(11, 11, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:39:21', '2026-03-30 03:39:21'),
(12, 12, 'Freelance Agent', NULL, NULL, 0, 1, 1, 1, '2026-03-30 03:53:15', '2026-03-30 03:53:15'),
(14, 16, 'Freelance Agent', NULL, 'sdsd6s7d8s', 0, 1, 1, 1, '2026-04-22 04:08:52', '2026-04-22 04:08:52'),
(15, 17, '', 'fghjklkjhgghjkjhg', '4384739abc', 0, 1, 1, 1, '2026-04-22 04:10:57', '2026-04-22 04:28:45'),
(16, 18, '', 'Am a professional broker', '1232000', 0, 1, 1, 1, '2026-04-22 05:57:26', '2026-04-22 06:40:04'),
(17, 20, '', 'wertyuio56789 dfghjk678 fghjgkh6786 gfjhgh67', 'sdsd6s7d8s', 0, 1, 1, 1, '2026-06-02 01:37:11', '2026-06-02 01:37:11'),
(18, 22, 'Old Co', NULL, NULL, 0, 0, 1, 1, '2026-06-05 03:40:39', '2026-06-05 03:40:39'),
(19, 30, 'Dubai Hills Realty', NULL, NULL, 0, 0, 1, 1, '2026-06-05 05:34:29', '2026-06-05 05:34:29'),
(20, 31, 'Dubai Hills Realty', NULL, NULL, 0, 0, 1, 1, '2026-06-05 05:35:20', '2026-06-05 05:35:20');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `commentable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `commentable_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `commentable_type`, `commentable_id`, `parent_id`, `body`, `created_at`, `updated_at`) VALUES
(1, 18, 'listing', 103, NULL, 'Is this still available?', '2026-05-07 04:51:14', '2026-05-07 04:51:14'),
(2, 18, 'listing', 103, 1, 'Yes available', '2026-05-07 04:53:16', '2026-05-07 04:53:16'),
(5, 18, 'post', 1, NULL, 'Very useful update', '2026-05-07 05:36:32', '2026-05-07 05:36:32'),
(6, 18, 'post', 1, 5, 'Thanks!', '2026-05-07 05:42:29', '2026-05-07 05:42:29'),
(7, 18, 'listing', 103, NULL, 'Is this still available?', '2026-05-22 06:41:43', '2026-05-22 06:41:43'),
(8, 18, 'listing', 155, NULL, 'Hello', '2026-05-22 07:11:14', '2026-05-22 07:11:14'),
(9, 18, 'listing', 154, NULL, 'Hi', '2026-05-23 15:05:05', '2026-05-23 15:05:05'),
(10, 14, 'listing', 154, NULL, 'Yes how can I help u', '2026-05-23 15:34:28', '2026-05-23 15:34:28'),
(11, 18, 'listing', 159, NULL, 'Heel', '2026-05-25 03:31:29', '2026-05-25 03:31:29');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `listing_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `listing_id`, `created_at`, `updated_at`) VALUES
(5, 18, 103, '2026-05-07 02:37:59', '2026-05-07 02:37:59'),
(14, 18, 132, '2026-05-08 09:35:19', '2026-05-08 09:35:19'),
(15, 18, 131, '2026-05-08 09:35:22', '2026-05-08 09:35:22');

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `likeable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `likeable_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `user_id`, `likeable_type`, `likeable_id`, `created_at`, `updated_at`) VALUES
(3, 18, 'post', 1, '2026-05-07 05:25:37', '2026-05-07 05:25:37'),
(7, 18, 'listing', 154, '2026-05-23 15:32:32', '2026-05-23 15:32:32'),
(8, 14, 'listing', 154, '2026-05-23 15:34:13', '2026-05-23 15:34:13'),
(9, 18, 'listing', 159, '2026-05-25 03:31:14', '2026-05-25 03:31:14');

-- --------------------------------------------------------

--
-- Table structure for table `listings`
--

CREATE TABLE `listings` (
  `id` bigint UNSIGNED NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `listing_type` enum('sale','rent','requirement') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AED',
  `size` decimal(10,2) DEFAULT NULL,
  `beds` tinyint UNSIGNED DEFAULT NULL,
  `baths` tinyint UNSIGNED DEFAULT NULL,
  `area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `developer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','processing','sold','rented','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `marked_as` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_off_plan` tinyint(1) NOT NULL DEFAULT '0',
  `tags` json DEFAULT NULL,
  `views_count` bigint UNSIGNED NOT NULL DEFAULT '0',
  `clicks_count` bigint UNSIGNED NOT NULL DEFAULT '0',
  `leads_count` bigint UNSIGNED NOT NULL DEFAULT '0',
  `saves_count` bigint UNSIGNED NOT NULL DEFAULT '0',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listings`
--

INSERT INTO `listings` (`id`, `created_by`, `listing_type`, `property_type`, `price`, `currency`, `size`, `beds`, `baths`, `area`, `city`, `project`, `developer`, `status`, `marked_as`, `is_off_plan`, `tags`, `views_count`, `clicks_count`, `leads_count`, `saves_count`, `expires_at`, `created_at`, `updated_at`) VALUES
(92, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\", \"VACANT\"]', 0, 0, 0, 0, '2026-07-05 00:28:43', '2026-04-29 03:26:36', '2026-06-05 00:28:43'),
(98, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-05 02:56:30', '2026-05-05 02:56:30', '2026-05-05 02:56:30'),
(99, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-05 03:13:48', '2026-05-05 03:13:48', '2026-05-05 03:13:48'),
(100, 18, 'requirement', 'Untitled Post', NULL, 'AED', NULL, NULL, NULL, NULL, 'dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"NEW\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-05 06:18:54', '2026-05-05 06:18:54', '2026-05-05 06:18:54'),
(101, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-05 06:28:21', '2026-05-05 06:28:21', '2026-05-06 06:27:04'),
(102, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-05 06:42:59', '2026-05-05 06:42:59', '2026-05-07 02:38:40'),
(103, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"BELOW MARKET\"]', 0, 0, 0, 1, '2026-06-05 10:11:45', '2026-05-05 10:11:45', '2026-05-07 02:37:59'),
(104, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"BELOW MARKET\", \"NEW\", \"URGENT\", \"DISTRESS\", \"EXCLUSIVE\", \"OFF-MARKET\", \"INVESTMENT\", \"VACANT\"]', 0, 0, 0, 0, '2026-06-05 11:10:38', '2026-05-05 11:10:38', '2026-05-07 02:39:01'),
(105, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:06:53', '2026-05-07 05:06:53', '2026-05-07 05:06:53'),
(106, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:08:57', '2026-05-07 05:08:57', '2026-05-07 05:08:57'),
(107, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:08:57', '2026-05-07 05:08:57', '2026-05-07 05:08:57'),
(108, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:08:57', '2026-05-07 05:08:57', '2026-05-25 11:48:41'),
(109, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:11:44', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(110, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:11:44', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(111, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:11:44', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(112, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:11:44', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(113, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:14:46', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(114, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, 'downtown Dubai', 'Dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:14:46', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(115, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-07 05:14:46', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(116, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, 'downtown Dubai', 'Dubai', NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-07 05:14:46', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(118, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"URGENT\", \"BELOW MARKET\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-08 06:37:08', '2026-05-08 06:37:08', '2026-05-08 06:37:08'),
(121, 18, 'rent', 'Flat JLT', 500000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-08 06:48:57', '2026-05-08 06:48:57', '2026-05-08 06:48:57'),
(122, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-08 06:50:45', '2026-05-08 06:50:45', '2026-05-08 06:50:45'),
(123, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-08 06:51:14', '2026-05-08 06:51:14', '2026-05-08 06:51:14'),
(124, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-08 06:51:39', '2026-05-08 06:51:39', '2026-05-08 06:51:39'),
(125, 18, 'rent', 'Flat JLT', 500000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-08 06:53:32', '2026-05-08 06:53:32', '2026-05-08 06:53:32'),
(126, 18, 'requirement', 'Flat JLT', 500000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', 'rented', 1, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-08 06:54:32', '2026-05-08 06:54:32', '2026-05-22 08:37:41'),
(127, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"URGENT\", \"BELOW MARKET\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-08 06:56:59', '2026-05-08 06:56:59', '2026-05-08 06:56:59'),
(128, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"URGENT\", \"BELOW MARKET\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-08 06:57:18', '2026-05-08 06:57:18', '2026-05-08 06:57:18'),
(129, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"URGENT\", \"BELOW MARKET\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-08 06:59:56', '2026-05-08 06:59:56', '2026-05-08 06:59:56'),
(130, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"URGENT\", \"BELOW MARKET\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-08 07:01:36', '2026-05-08 07:01:36', '2026-05-08 07:01:36'),
(131, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 1, '2026-06-08 07:03:56', '2026-05-08 07:03:56', '2026-05-08 09:35:22'),
(132, 18, 'requirement', 'villa', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\"]', 0, 0, 0, 1, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-08 09:35:19'),
(133, 18, 'requirement', 'villa', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(134, 18, 'requirement', 'villa', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[]', 0, 0, 0, 0, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(135, 18, 'requirement', 'townhouse', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[]', 0, 0, 0, 0, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(136, 18, 'requirement', 'townhouse', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[]', 0, 0, 0, 0, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(137, 18, 'requirement', 'townhouse', 5375000.00, 'AED', NULL, 5, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[]', 0, 0, 0, 0, '2026-06-08 09:29:18', '2026-05-08 09:29:18', '2026-05-22 10:02:36'),
(138, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, 'dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-11 10:12:29', '2026-05-11 10:12:29', '2026-05-11 10:12:29'),
(139, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, NULL, NULL, 'Jumeirah Lake Towers (JLT)', 'Dubai', 'Me Do Re', NULL, 'active', NULL, 1, '[\"EXCLUSIVE\", \"DISTRESS\", \"VACANT\"]', 0, 0, 0, 0, '2026-06-11 12:26:44', '2026-05-11 12:26:44', '2026-05-11 12:27:09'),
(140, 18, 'requirement', 'Villa', NULL, 'AED', NULL, NULL, NULL, 'Dubai Hills', 'Dubai', 'Maple Villas', 'Emaar', 'active', NULL, 1, '[\"BELOW MARKET\", \"EXCLUSIVE\", \"VACANT\"]', 0, 0, 0, 0, '2026-06-18 06:43:36', '2026-05-18 06:43:36', '2026-05-18 06:43:36'),
(141, 18, 'requirement', 'Villa', NULL, 'AED', NULL, NULL, NULL, 'Dubai Hills', 'Dubai', 'Maple Villas', 'Emaar', 'active', NULL, 1, '[\"EXCLUSIVE\", \"VACANT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-18 06:46:54', '2026-05-18 06:46:54', '2026-05-18 06:46:54'),
(142, 18, 'requirement', 'Villa', NULL, 'AED', NULL, NULL, NULL, 'Dubai Hills', 'Dubai', 'Maple Villas', 'Emaar', 'active', NULL, 1, '[\"BELOW MARKET\", \"EXCLUSIVE\", \"VACANT\"]', 0, 0, 0, 0, '2026-06-18 06:52:48', '2026-05-18 06:52:48', '2026-05-18 06:52:48'),
(143, 18, 'requirement', 'Villa', NULL, 'AED', NULL, NULL, NULL, 'Dubai Hills', 'Dubai', 'Maple Villas', 'Emaar', 'active', NULL, 1, '[\"EXCLUSIVE\", \"VACANT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-18 12:28:27', '2026-05-18 12:28:27', '2026-05-18 12:28:27'),
(144, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, NULL, NULL, 'Business Bay', 'Dubai', 'Sky Residences', 'Sobha', 'active', NULL, 0, '[\"OFF-MARKET\", \"INVESTMENT\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-18 12:35:24', '2026-05-18 12:35:24', '2026-05-18 12:35:24'),
(145, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, NULL, NULL, 'Business Bay', 'Dubai', 'Sky Residences', 'Sobha', 'active', NULL, 0, '[\"URGENT\", \"OFF-MARKET\", \"INVESTMENT\"]', 0, 0, 0, 0, '2026-06-18 12:40:59', '2026-05-18 12:40:59', '2026-05-18 12:40:59'),
(146, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, NULL, NULL, 'Business Bay', 'Dubai', 'Sky Residences', 'Sobha', 'active', NULL, 0, '[\"URGENT\", \"OFF-MARKET\", \"INVESTMENT\"]', 0, 0, 0, 0, '2026-06-18 12:43:43', '2026-05-18 12:43:43', '2026-05-18 12:43:43'),
(148, 18, 'requirement', 'Villa', NULL, 'AED', NULL, NULL, NULL, 'Dubai Hills', 'Dubai', 'Maple Villas', 'Emaar', 'active', NULL, 1, '[\"BELOW MARKET\", \"EXCLUSIVE\", \"VACANT\", \"NEW\"]', 0, 0, 0, 0, '2026-06-18 12:54:53', '2026-05-18 12:54:53', '2026-05-20 11:26:37'),
(150, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"NEW\", \"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-20 11:31:24', '2026-05-20 11:31:24', '2026-05-22 09:34:47'),
(151, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', 'sold', 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-20 11:33:37', '2026-05-20 11:33:37', '2026-05-22 08:36:56'),
(152, 18, 'requirement', 'apartment', NULL, 'AED', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-07-20 11:38:26', '2026-05-20 11:38:26', '2026-05-25 11:27:40'),
(154, 18, 'rent', 'Flat JLT', 600000.00, 'AED', NULL, 2, NULL, 'Dubai Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\", \"URGENT\"]', 2, 2, 2, 0, '2026-08-20 12:19:23', '2026-05-20 12:19:23', '2026-05-25 01:49:36'),
(156, 18, 'rent', 'Flat JLT', 600000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-25 02:12:46', '2026-05-25 02:12:46', '2026-05-25 02:12:46'),
(157, 1, 'rent', 'Flat JLT', 600000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\"]', 0, 0, 0, 0, NULL, '2026-05-25 02:18:01', '2026-05-25 02:18:01'),
(158, 18, 'rent', 'Flat JLT', 600000.00, 'AED', NULL, 2, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-25 02:19:43', '2026-05-25 02:19:43', '2026-05-25 02:19:43'),
(159, 18, 'requirement', 'Urgent hot deal', 85000.00, 'USD', NULL, 2, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\", \"NEW\", \"DISTRESS\"]', 0, 0, 0, 0, '2026-06-25 03:28:35', '2026-05-25 03:28:35', '2026-05-25 03:28:35'),
(160, 18, 'rent', 'Flat JLT', 300000.00, 'USD', NULL, 2, NULL, 'Dubai', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"BELOW MARKET\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-25 03:30:00', '2026-05-25 03:30:00', '2026-05-25 06:09:23'),
(161, 18, 'rent', 'Untitled Post', 90000.00, 'USD', NULL, 2, NULL, 'downtown Dubai', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\", \"URGENT\"]', 0, 0, 0, 0, '2026-06-25 05:52:26', '2026-05-25 05:52:26', '2026-05-25 06:02:32'),
(162, 18, 'rent', 'New furnished apartment for rent', 85000.00, 'USD', NULL, 2, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 1, '[\"URGENT\"]', 0, 0, 0, 0, '2026-06-25 06:14:34', '2026-05-25 06:14:34', '2026-05-25 06:14:34'),
(163, 18, 'rent', 'Urgent hot deal', 85000.00, 'USD', NULL, 2, NULL, NULL, 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"URGENT\"]', 0, 0, 0, 0, '2026-06-25 06:24:56', '2026-05-25 06:24:56', '2026-05-25 06:24:56'),
(164, 18, 'sale', '3BR luxury apartment JLT', 3100000.00, 'AED', NULL, 3, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"URGENT\", \"DISTRESS\", \"BELOW MARKET\", \"EXCLUSIVE\"]', 0, 0, 0, 0, '2026-06-25 06:28:03', '2026-05-25 06:28:03', '2026-05-25 06:28:03'),
(165, 18, 'requirement', '4BR apartment JLT', 2000.00, 'AED', NULL, 4, NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-25 06:52:18', '2026-05-25 06:52:18', '2026-05-25 06:53:09'),
(166, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, NULL, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 04:42:35', '2026-05-26 04:42:35', '2026-05-26 04:42:35'),
(167, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, NULL, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 04:44:45', '2026-05-26 04:44:45', '2026-05-26 04:44:45'),
(168, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, NULL, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 04:45:20', '2026-05-26 04:45:20', '2026-05-26 04:45:20'),
(169, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, NULL, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 04:45:29', '2026-05-26 04:45:29', '2026-05-26 04:45:29'),
(170, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, NULL, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', 'sold', 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 04:53:43', '2026-05-26 04:53:43', '2026-06-02 05:49:05'),
(171, 18, 'requirement', 'Villa', NULL, 'AED', NULL, 5, 5, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', 'sold', 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 05:24:57', '2026-05-26 05:24:57', '2026-06-02 04:09:18'),
(172, 18, 'requirement', 'Villa', 12000000.00, 'AED', NULL, 5, 5, 'Dubai Hills', 'Dubai', NULL, 'Emaar', 'active', NULL, 0, '[\"URGENT\", \"BELOW MARKET\"]', 0, 0, 0, 0, '2026-06-26 05:27:21', '2026-05-26 05:27:21', '2026-05-26 05:27:21'),
(173, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, 3, NULL, 'Business Bay', 'Dubai', NULL, 'Sobha', 'active', NULL, 0, '[\"DISTRESS\"]', 0, 0, 0, 0, '2026-06-26 05:48:21', '2026-05-26 05:48:21', '2026-05-26 05:48:21'),
(174, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, 3, NULL, NULL, 'Dubai', NULL, 'Sobha', 'active', NULL, 0, '[\"DISTRESS\", \"NEW\"]', 0, 0, 0, 0, '2026-06-26 05:49:43', '2026-05-26 05:49:43', '2026-05-26 05:49:43'),
(175, 18, 'requirement', 'Untitled Post', NULL, 'AED', NULL, NULL, 6, NULL, NULL, 'Maple Villas', NULL, 'active', NULL, 0, NULL, 0, 0, 0, 0, '2026-06-26 06:19:56', '2026-05-26 06:19:56', '2026-05-26 06:19:56'),
(176, 18, 'requirement', 'Apartment', NULL, 'AED', NULL, 2, NULL, 'Dubai Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"URGENT\"]', 0, 0, 0, 0, '2026-06-26 06:35:34', '2026-05-26 06:35:34', '2026-05-26 06:35:34'),
(177, 18, 'requirement', 'Studio', NULL, 'AED', NULL, 1, NULL, 'Business Bay', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-06-26 06:49:29', '2026-05-26 06:49:29', '2026-05-26 06:49:29'),
(178, 18, 'requirement', 'Studio', 95000.00, 'AED', NULL, 1, NULL, 'Business Bay', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-06-26 06:52:04', '2026-05-26 06:52:04', '2026-05-26 06:52:04'),
(179, 18, 'requirement', 'Studio', 95000.00, 'AED', NULL, 1, NULL, 'Business Bay', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 00:30:41', '2026-05-26 06:53:03', '2026-06-05 00:30:41'),
(180, 21, 'sale', 'Apartment', 1195290.00, 'AED', 625.00, 4, 1, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 03:36:02', '2026-06-05 03:36:02', '2026-06-05 03:36:02'),
(181, 22, 'sale', 'Apartment', 4240882.00, 'AED', 3211.00, 2, 3, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 03:40:39', '2026-06-05 03:40:39', '2026-06-05 03:40:39'),
(182, 23, 'sale', 'Apartment', 3950537.00, 'AED', 2796.00, 2, 2, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"FOR SALE\"]', 0, 0, 0, 0, '2026-07-05 05:15:27', '2026-06-05 05:15:27', '2026-06-05 05:15:28'),
(183, 24, 'sale', 'Apartment', 585496.00, 'AED', 2976.00, 1, 3, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:15:45', '2026-06-05 05:15:45', '2026-06-05 05:15:46'),
(184, 25, 'rent', 'Apartment', 3853698.00, 'AED', 3958.00, 2, 1, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:16:07', '2026-06-05 05:16:07', '2026-06-05 05:16:07'),
(185, 26, 'sale', 'Apartment', 1667496.00, 'AED', 2764.00, 2, 3, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:15', '2026-06-05 05:33:15', '2026-06-05 05:33:15'),
(186, 26, 'sale', 'Apartment', 2230256.00, 'AED', 2881.00, 3, 3, 'Dubai Hills', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:15', '2026-06-05 05:33:15', '2026-06-05 05:33:15'),
(187, 26, 'sale', 'Apartment', 3977240.00, 'AED', 2253.00, 1, 3, NULL, 'Dubai Hills', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:15', '2026-06-05 05:33:15', '2026-06-05 05:33:15'),
(188, 27, 'sale', 'Apartment', 2250310.00, 'AED', 945.00, 2, 3, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:46', '2026-06-05 05:33:46', '2026-06-05 05:33:46'),
(189, 27, 'sale', 'Apartment', 831048.00, 'AED', 2843.00, 1, 2, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:46', '2026-06-05 05:33:46', '2026-06-05 05:33:46'),
(190, 27, 'sale', 'Apartment', 689919.00, 'AED', 2768.00, 2, 2, 'Dubai Hills', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:33:46', '2026-06-05 05:33:46', '2026-06-05 05:33:46'),
(191, 28, 'sale', 'Apartment', 3212861.00, 'AED', 3626.00, 4, 2, NULL, 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:34:08', '2026-06-05 05:34:08', '2026-06-05 05:34:08'),
(192, 29, 'sale', 'Apartment', 2588113.00, 'AED', 3068.00, 3, 2, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:34:18', '2026-06-05 05:34:18', '2026-06-05 05:34:18'),
(193, 30, 'sale', 'Apartment', 2354123.00, 'AED', 1268.00, 2, 2, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:34:29', '2026-06-05 05:34:29', '2026-06-05 05:34:29'),
(194, 31, 'sale', 'Apartment', 2665258.00, 'AED', 3474.00, 2, 1, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:20', '2026-06-05 05:35:20', '2026-06-05 05:35:20'),
(195, 31, 'sale', 'Apartment', 1152616.00, 'AED', 897.00, 4, 3, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:20', '2026-06-05 05:35:20', '2026-06-05 05:35:20'),
(196, 31, 'sale', 'Apartment', 3494217.00, 'AED', 478.00, 2, 2, 'Dubai Hills', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:20', '2026-06-05 05:35:20', '2026-06-05 05:35:20'),
(197, 31, 'sale', 'Apartment', 938316.00, 'AED', 2093.00, 3, 3, NULL, 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:20', '2026-06-05 05:35:20', '2026-06-05 05:35:20'),
(198, 32, 'sale', 'Apartment', 2304921.00, 'AED', 1106.00, 2, 2, 'Marina', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:28', '2026-06-05 05:35:28', '2026-06-05 05:35:28'),
(199, 32, 'sale', 'Apartment', 2168065.00, 'AED', 1408.00, 2, 2, 'Downtown Dubai', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-05 05:35:28', '2026-06-05 05:35:28', '2026-06-05 05:35:28'),
(200, 33, 'requirement', 'Apartment', 1238815.00, 'AED', 2617.00, 4, 3, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\", \"BUY REQUEST\"]', 0, 0, 0, 0, '2026-07-05 05:47:27', '2026-06-05 05:47:27', '2026-06-05 05:53:12'),
(201, 33, 'sale', 'Apartment', 3539909.00, 'AED', 1467.00, 2, 1, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"FOR SALE\"]', 0, 0, 0, 0, '2026-07-05 05:59:07', '2026-06-05 05:59:07', '2026-06-05 08:43:24'),
(202, 34, 'sale', 'Apartment', 4470548.00, 'AED', 3239.00, 3, 3, 'JLT', 'Dubai', NULL, NULL, 'active', NULL, 0, '[\"NEW\"]', 0, 0, 0, 0, '2026-07-08 02:51:46', '2026-06-08 02:51:46', '2026-06-08 02:51:46');

-- --------------------------------------------------------

--
-- Table structure for table `listing_details`
--

CREATE TABLE `listing_details` (
  `id` bigint UNSIGNED NOT NULL,
  `listing_id` bigint UNSIGNED NOT NULL,
  `payment_plan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ownership` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `furnished` enum('furnished','unfurnished','semi') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `commission` decimal(10,2) DEFAULT NULL,
  `roi` decimal(5,2) DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `additional_notes` text COLLATE utf8mb4_unicode_ci,
  `amenities` json DEFAULT NULL,
  `form_data` json DEFAULT NULL,
  `extra` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_details`
--

INSERT INTO `listing_details` (`id`, `listing_id`, `payment_plan`, `ownership`, `furnished`, `commission`, `roi`, `notes`, `additional_notes`, `amenities`, `form_data`, `extra`, `created_at`, `updated_at`) VALUES
(15, 92, NULL, NULL, NULL, 9.00, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\", \"Vacant\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\", \"commission_type\": \"percentage\"}', '2026-04-29 03:26:36', '2026-04-29 03:26:36'),
(21, 98, NULL, NULL, NULL, 5.00, NULL, 'I love pakis tan', NULL, NULL, '{\"city\": \"Dubai\", \"tags\": [\"Exclusive\"], \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4 bed apartment in Dubai Rawi Hotel\", \"status\": \"buy request\", \"category\": \"residential\", \"furnishing\": \"non furnished\", \"plot_location\": \"Dubai Rawi Hotel\", \"property_type\": \"apartment\"}', '{\"kind\": \"buy request\", \"commission_type\": \"percentage\"}', '2026-05-05 02:56:30', '2026-05-05 02:56:30'),
(22, 99, NULL, NULL, NULL, 12.00, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"note\": \"Genuine unit – ready to share with serious buyers\", \"size\": {\"sqft\": \"1093\"}, \"tags\": [\"Below Market\"], \"build\": {\"type\": \"ready\"}, \"price\": {\"op\": \"2400000\", \"sp\": 2300000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"1\"}, \"tower\": \"Me Do Re 1\", \"status\": \"for sale\", \"category\": \"residential\", \"unit_type\": \"1.5 Bedroom (1BR + Study)\", \"buyer_type\": \"serious\", \"plot_location\": \"Jumeirah Lake Towers\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\", \"commission_type\": \"fixed\"}', '2026-05-05 03:13:48', '2026-05-05 03:13:48'),
(23, 100, NULL, NULL, NULL, NULL, NULL, 'this is a pakistan', NULL, NULL, '{\"city\": \"dubai\", \"size\": {\"sqft\": \"1660\"}, \"tags\": [\"Urgent\", \"New\", \"Distress\"], \"price\": {\"sp\": 3100000, \"currency\": \"$\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"3\"}, \"status\": \"buy request\", \"category\": \"residential\", \"plot_location\": \"downtown Dubai\"}', '{\"kind\": \"buy request\", \"commission_type\": \"not_disclosed\"}', '2026-05-05 06:18:54', '2026-05-05 06:18:54'),
(24, 101, NULL, NULL, NULL, NULL, NULL, 'this is a pakistan', NULL, NULL, '{\"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\", \"Exclusive\"], \"price\": {\"sp\": 1700000, \"currency\": \"dollars\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4BR apartment JLT\", \"status\": \"rent request\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"rent request\"}', '2026-05-05 06:28:21', '2026-05-05 06:28:21'),
(25, 102, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\", \"Exclusive\"], \"price\": {\"sp\": 1700000, \"currency\": \"dollars\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4BR apartment JLT\", \"status\": \"rent request\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"rent request\"}', '2026-05-05 06:43:00', '2026-05-05 06:43:00'),
(26, 103, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"1093\"}, \"tags\": [\"Below Market\"], \"price\": {\"op\": \"2400000\", \"sp\": 2300000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"1\"}, \"status\": \"ready to share with serious buyers\", \"category\": \"residential\", \"unit_type\": \"1BR + Study\", \"buyer_type\": \"serious buyers\", \"plot_location\": \"JLT – Me Do Re 1\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-05 10:11:45', '2026-05-05 10:11:45'),
(27, 104, NULL, NULL, NULL, NULL, NULL, 'This is a beautiful village many people visit this site and his review is very good ,  discount for only 20 days , and 10 day left', NULL, NULL, '{\"city\": \"Dubai\", \"note\": \"Genuine unit – ready to share with serious buyers\", \"size\": {\"sqft\": \"1093\"}, \"tags\": [\"Below Market\", \"New\", \"Urgent\", \"Distress\", \"Exclusive\", \"Off-Market\", \"Investment\", \"Vacant\"], \"build\": {\"type\": \"Me Do Re 1\"}, \"price\": {\"op\": \"2400000\", \"sp\": 2300000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"1\"}, \"tower\": \"Me Do Re 1\", \"status\": \"ready to share\", \"category\": \"residential\", \"unit_type\": \"1.5 Bedroom (1BR + Study)\", \"plot_location\": \"Jumeirah Lake Towers\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(28, 105, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"dubai\", \"size\": {\"sqft\": \"1660\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"3\"}, \"status\": \"buy request\", \"category\": \"residential\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"apartment\", \"timeline_label\": \"immediately\"}', '{\"kind\": \"buy request\"}', '2026-05-07 05:06:53', '2026-05-07 05:06:53'),
(29, 106, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-07 05:08:57', '2026-05-07 05:08:57'),
(30, 107, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"dubai\", \"size\": {\"sqft\": \"1500\"}, \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"status\": \"for rent\", \"category\": \"residential\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"apartment\", \"timeline_label\": \"march\"}', '{\"kind\": \"for rent\"}', '2026-05-07 05:08:57', '2026-05-07 05:08:57'),
(31, 108, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\", \"Exclusive\"], \"price\": {\"sp\": 1700000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4BR apartment JLT\", \"status\": \"rent request\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-07 05:08:57', '2026-05-07 05:08:57'),
(32, 109, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(33, 110, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"1500\"}, \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 85000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"title\": \"New furnished\", \"status\": \"for rent\", \"category\": \"residential\", \"furnishing\": \"furnished\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"apartment\", \"timeline_label\": \"march\"}', '{\"kind\": \"for rent\"}', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(34, 111, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\", \"Exclusive\"], \"price\": {\"sp\": 1700000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4BR apartment JLT\", \"status\": \"rent request\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"rent request\"}', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(35, 112, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"dubai\", \"size\": {\"sqft\": \"1660\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"status\": \"buy request\", \"category\": \"residential\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"apartment\"}', '{\"kind\": \"buy request\"}', '2026-05-07 05:11:44', '2026-05-07 05:11:44'),
(36, 113, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(37, 114, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"area\": \"downtown Dubai\", \"city\": \"Dubai\", \"size\": {\"sqft\": \"1500\"}, \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"title\": \"Furnished apartment for rent\", \"status\": \"for rent\", \"category\": \"residential\", \"furnishing\": \"furnished\", \"property_type\": \"apartment\", \"timeline_label\": \"March\"}', '{\"kind\": \"for rent\"}', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(38, 115, NULL, NULL, NULL, NULL, NULL, 'this is a pakistan', NULL, NULL, '{\"city\": \"Dubai\", \"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\", \"Exclusive\"], \"price\": {\"sp\": 1700000, \"currency\": \"USD\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"title\": \"4BR apartment JLT\", \"status\": \"rent request\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"rent request\"}', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(39, 116, NULL, NULL, NULL, NULL, NULL, 'This is a pakistal', NULL, NULL, '{\"area\": \"downtown Dubai\", \"city\": \"Dubai\", \"size\": {\"sqft\": \"1660\"}, \"price\": {\"sp\": 3100000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\"}, \"title\": \"3 + study apartment request\", \"status\": \"buy request\", \"category\": \"residential\", \"property_type\": \"apartment\"}', '{\"kind\": \"buy request\"}', '2026-05-07 05:14:46', '2026-05-07 05:14:46'),
(41, 121, NULL, NULL, NULL, 15.00, NULL, 'I Love You.', NULL, NULL, '{\"beds\": 2, \"tags\": [\"Below Market\", \"Urgent\"], \"price\": 500000, \"title\": \"Flat JLT\", \"description\": \"Cash buyer preferred in Marina\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-08 06:48:57', '2026-05-08 06:48:57'),
(42, 125, NULL, NULL, NULL, 15.00, NULL, 'I Love You.', NULL, NULL, '{\"beds\": 2, \"tags\": [\"Below Market\", \"Urgent\"], \"price\": 500000, \"title\": \"Flat JLT\", \"description\": \"Cash buyer preferred in Marina\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-08 06:53:32', '2026-05-08 06:53:32'),
(43, 126, NULL, NULL, NULL, NULL, NULL, 'Cash buyer preferred in Marina', NULL, NULL, '{\"beds\": 2, \"tags\": [\"Below Market\", \"Urgent\"], \"price\": 500000, \"title\": \"Flat JLT\", \"description\": \"Cash buyer preferred in Marina\"}', '{\"kind\": \"for rent\"}', '2026-05-08 06:54:32', '2026-05-08 06:54:32'),
(44, 130, '60/40', NULL, NULL, NULL, 7.40, NULL, NULL, NULL, '{\"roi\": \"7.4\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Exclusive\", \"Urgent\", \"Below Market\", \"Distress\"], \"build\": {\"type\": \"luxury\", \"handover\": \"Q4 2025\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3 Bed Luxury Apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"payment_plan\": \"60/40\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\", \"service_charge\": {\"amount\": \"12.5\", \"frequency\": \"sqft\"}}', '{\"kind\": \"for sale\"}', '2026-05-08 07:01:36', '2026-05-08 07:01:36'),
(45, 131, '60/40', NULL, NULL, NULL, 7.40, NULL, NULL, NULL, '{\"roi\": \"7.4\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"luxury\", \"handover\": \"Q4 2025\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3 Bed Luxury Apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"payment_plan\": \"60/40\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\", \"price_per_sqft\": \"1107.14\", \"service_charge\": {\"amount\": \"12.5\", \"frequency\": \"sqft\"}, \"timeline_label\": \"Q4 2025\"}', '{\"kind\": \"for sale\"}', '2026-05-08 07:03:56', '2026-05-08 07:03:56'),
(46, 132, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2229\"}, \"tags\": [\"Below Market\"], \"build\": {\"handover\": \"Q1 2026\"}, \"price\": {\"sp\": 4040000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Costa Brava 1\", \"property_type\": \"villa\"}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(47, 133, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2227.77\"}, \"price\": {\"sp\": 4800000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"status\": \"ready to move\", \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Santorini 1\", \"property_type\": \"villa\"}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(48, 134, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2073.77\"}, \"price\": {\"sp\": 3535000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"status\": \"handover soon\", \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Santorini 2\", \"property_type\": \"villa\"}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(49, 135, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2273.77\"}, \"view\": \"Park View\", \"build\": {\"handover\": \"Q1 2026\"}, \"price\": {\"sp\": 3840000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Malta 2\", \"property_type\": \"townhouse\", \"property_features\": [\"Single Row\"]}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(50, 136, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2073.77\"}, \"price\": {\"sp\": 3790000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"status\": \"ready to move\", \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Santorini 1\", \"property_type\": \"townhouse\"}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(51, 137, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"size\": {\"sqft\": \"2930.77\"}, \"view\": \"Prime Location Close to Park\", \"price\": {\"sp\": 5375000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"5\"}, \"status\": \"handover soon\", \"category\": \"residential\", \"plot_location\": \"Damac Lagoons – Santorini 2\", \"property_type\": \"townhouse\"}', '{\"kind\": \"for sale\"}', '2026-05-08 09:29:18', '2026-05-08 09:29:18'),
(52, 138, NULL, NULL, NULL, NULL, NULL, 'Tjis is a best apartment in dubai', NULL, NULL, '{\"city\": \"dubai\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment downtown dubai\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"downtown dubai\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-11 10:12:29', '2026-05-11 10:12:29'),
(53, 139, '60/40 (Post Handover)', 'freehold', NULL, NULL, 7.40, NULL, NULL, '[\"Pool\", \"Gym\", \"BBQ Area\", \"Kids Play Area\"]', '{\"Roi\": \"7.4%\", \"roi\": \"7.4\", \"Area\": \"Jumeirah Lake Towers (JLT)\", \"City\": \"Dubai\", \"Lead\": \"Direct\", \"Note\": \"Can close this week, serious buyer only\", \"Tags\": \"exclusive, distress, vacant\", \"View\": \"Lake View\", \"area\": \"Jumeirah Lake Towers (JLT)\", \"city\": \"Dubai\", \"lead\": \"Direct\", \"note\": \"Can close this week, serious buyer only\", \"size\": {\"bua\": \"2800\"}, \"tags\": [\"Exclusive\", \"Distress\", \"Vacant\"], \"view\": \"Lake View\", \"Tower\": \"Tower A\", \"build\": {\"type\": \"Ready\", \"handover\": \"New\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\", \"bathrooms\": \"4\", \"maids_room\": \"1\"}, \"tower\": \"Tower A\", \"Status\": \"for sale\", \"status\": \"for sale\", \"Parking\": \"2\", \"Project\": \"Me Do Re\", \"parking\": \"2\", \"project\": \"Me Do Re\", \"Category\": \"residential\", \"Price Sp\": \"3100000\", \"Size Bua\": \"2800\", \"category\": \"residential\", \"Amenities\": \"Pool, Gym, BBQ Area, Kids Play Area\", \"Ownership\": \"freehold\", \"Transport\": \"Near Metro\", \"amenities\": [\"Pool\", \"Gym\", \"BBQ Area\", \"Kids Play Area\"], \"ownership\": \"freehold\", \"transport\": \"Near Metro\", \"Build Type\": \"Ready\", \"Buyer Type\": \"All\", \"Furnishing\": \"semi-furnished\", \"buyer_type\": \"All\", \"furnishing\": \"semi-furnished\", \"Payment Plan\": \"60/40 (Post Handover)\", \"payment_plan\": \"60/40 (Post Handover)\", \"Property Type\": \"Apartment\", \"property_type\": \"Apartment\", \"Build Handover\": \"New\", \"Price Currency\": \"AED\", \"Price Per Sqft\": \"1107\", \"Rooms Bedrooms\": \"3\", \"Timeline Label\": \"this week\", \"price_per_sqft\": \"1107\", \"service_charge\": {\"amount\": \"12.5\", \"frequency\": \"Annually\"}, \"timeline_label\": \"this week\", \"Build Condition\": \"New\", \"Rooms Bathrooms\": \"4\", \"build_condition\": \"New\", \"Rooms Maids Room\": \"1\", \"Service Charge Amount\": \"12.5\", \"Service Charge Frequency\": \"Annually\"}', '{\"kind\": \"for sale\"}', '2026-05-11 12:26:44', '2026-05-11 12:26:44'),
(54, 142, 'Cash', 'Freehold', NULL, 4.00, 8.00, NULL, NULL, '[\"Pool\", \"Gym\", \"BBQ Area\"]', '{\"roi\": \"8\", \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"lead\": \"Direct\", \"note\": \"Ready to move, urgent sale, park facing villa\", \"size\": {\"bua\": \"4200\", \"sqft\": \"5200\"}, \"tags\": [\"Below Market\", \"Exclusive\", \"Vacant\"], \"view\": \"Park View\", \"build\": {\"type\": \"Ready\", \"handover\": \"New\"}, \"phase\": \"Phase 2\", \"price\": {\"op\": 8500000, \"sp\": 8800000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"5\", \"bathrooms\": \"6\", \"maids_room\": \"1\", \"powder_room\": \"1\"}, \"floors\": \"G+1 + Roof Top\", \"status\": \"for sale\", \"finance\": \"Mortgage\", \"parking\": \"3\", \"project\": \"Maple Villas\", \"category\": \"residential\", \"amenities\": [\"Pool\", \"Gym\", \"BBQ Area\"], \"developer\": \"Emaar\", \"ownership\": \"Freehold\", \"buyer_type\": \"All\", \"furnishing\": \"Furnished\", \"negotiable\": \"true\", \"payment_plan\": \"Cash\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"price_per_sqft\": \"2095\", \"service_charge\": {\"amount\": \"18000\", \"frequency\": \"Annually\"}, \"build_condition\": \"New\", \"property_features\": [\"Lift\", \"Roof Top Terrace\", \"Home Theatre\"]}', '{\"kind\": \"for sale\", \"commission_type\": \"percentage\"}', '2026-05-18 06:52:48', '2026-05-18 06:52:48'),
(55, 143, 'Cash', 'Freehold', NULL, 12.00, 8.00, NULL, NULL, '[\"Pool\", \"Gym\", \"BBQ Area\"]', '{\"Roi\": \"8%\", \"roi\": \"8\", \"Area\": \"Dubai Hills\", \"City\": \"Dubai\", \"Lead\": \"Direct\", \"Note\": \"Ready to move, urgent sale, park facing villa\", \"Tags\": \"Exclusive, Vacant, Below Market\", \"View\": \"Park View\", \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"lead\": \"Direct\", \"note\": \"Ready to move, urgent sale, park facing villa\", \"size\": {\"bua\": \"4200\", \"sqft\": \"5200\"}, \"tags\": [\"Exclusive\", \"Vacant\", \"Below Market\"], \"view\": \"Park View\", \"Phase\": \"Phase 2\", \"build\": {\"type\": \"Ready\", \"handover\": \"New\"}, \"phase\": \"Phase 2\", \"price\": {\"sp\": 8800000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"5\", \"bathrooms\": \"6\", \"maids_room\": \"1\", \"powder_room\": \"1\"}, \"Floors\": \"G+1 + Roof Top\", \"Status\": \"for sale\", \"floors\": \"G+1 + Roof Top\", \"status\": \"for sale\", \"Finance\": \"Mortgage\", \"Parking\": \"3\", \"Project\": \"Maple Villas\", \"finance\": \"Mortgage\", \"parking\": \"3\", \"project\": \"Maple Villas\", \"Category\": \"residential\", \"Price Sp\": \"8800000\", \"Size Bua\": \"4200\", \"category\": \"residential\", \"Amenities\": \"Pool, Gym, BBQ Area\", \"Developer\": \"Emaar\", \"Ownership\": \"Freehold\", \"Size Sqft\": \"5200\", \"amenities\": [\"Pool\", \"Gym\", \"BBQ Area\"], \"developer\": \"Emaar\", \"ownership\": \"Freehold\", \"Build Type\": \"Ready\", \"Buyer Type\": \"All\", \"Furnishing\": \"Furnished\", \"Negotiable\": \"no\", \"buyer_type\": \"All\", \"furnishing\": \"Furnished\", \"negotiable\": \"no\", \"Rooms Study\": \"1\", \"Payment Plan\": \"Cash\", \"payment_plan\": \"Cash\", \"Plot Location\": \"Corner\", \"Property Type\": \"Villa\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"Build Handover\": \"New\", \"Price Currency\": \"AED\", \"Price Per Sqft\": \"2095\", \"Rooms Bedrooms\": \"5\", \"price_per_sqft\": \"2095\", \"service_charge\": {\"amount\": \"18000\", \"frequency\": \"Annually\"}, \"Build Condition\": \"New\", \"Rooms Bathrooms\": \"6\", \"build_condition\": \"New\", \"Rooms Maids Room\": \"1\", \"Property Features\": \"Lift, Roof Top Terrace, Home Theatre\", \"Rooms Powder Room\": \"1\", \"property_features\": [\"Lift\", \"Roof Top Terrace\", \"Home Theatre\"], \"Service Charge Amount\": \"18000\", \"Service Charge Frequency\": \"Annually\"}', '{\"kind\": \"for sale\", \"commission_type\": \"fixed\"}', '2026-05-18 12:28:27', '2026-05-18 12:28:27'),
(56, 145, '80/20', 'Freehold', NULL, 1200.00, 10.00, NULL, NULL, '[\"Pool\", \"Gym\", \"Kids Area\"]', '{\"roi\": \"10\", \"area\": \"Business Bay\", \"city\": \"Dubai\", \"lead\": \"Not Direct\", \"note\": \"Off plan investment unit, handover Q2 2028, GCC clients preferred\", \"size\": {\"gfa\": 1850, \"sqft\": 1850}, \"tags\": [\"Urgent\", \"Off-Market\", \"Investment\"], \"view\": \"Burj Khalifa View\", \"build\": {\"type\": \"Off Plan\", \"handover\": \"Q2 2028\"}, \"phase\": \"Phase 1\", \"price\": {\"op\": 4100000, \"sp\": 4500000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": 3, \"bathrooms\": 4, \"maids_room\": 1, \"powder_room\": 1}, \"tower\": \"Tower A\", \"floors\": \"High\", \"status\": \"for sale\", \"finance\": \"Cash Only\", \"parking\": 2, \"project\": \"Sky Residences\", \"category\": \"residential\", \"amenities\": [\"Pool\", \"Gym\", \"Kids Area\"], \"developer\": \"Sobha\", \"ownership\": \"Freehold\", \"buyer_type\": \"GCC Only\", \"furnishing\": \"Unfurnished\", \"payment_plan\": \"80/20\", \"plot_location\": \"Single Row\", \"property_type\": \"Apartment\", \"price_per_sqft\": 2432, \"service_charge\": {\"amount\": 9500, \"frequency\": \"Quarterly\"}, \"timeline_label\": \"Q2 2028\", \"property_features\": [\"Modern Elevation\", \"Lounge\", \"Roof Terrace\"]}', '{\"kind\": \"for sale\", \"commission_type\": \"fixed\"}', '2026-05-18 12:40:59', '2026-05-18 12:40:59'),
(57, 146, '80/20', 'Freehold', NULL, NULL, 10.00, NULL, NULL, '[\"Pool\", \"Gym\", \"Kids Area\"]', '{\"Roi\": \"10%\", \"roi\": \"10\", \"Area\": \"Business Bay\", \"City\": \"Dubai\", \"Lead\": \"Not Direct\", \"Note\": \"Off plan investment unit, handover Q2 2028, GCC clients preferred\", \"Tags\": \"Urgent, Off-Market, Investment\", \"View\": \"Burj Khalifa View\", \"area\": \"Business Bay\", \"city\": \"Dubai\", \"lead\": \"Not Direct\", \"note\": \"Off plan investment unit, handover Q2 2028, GCC clients preferred\", \"size\": {\"gfa\": 1850, \"sqft\": 1850}, \"tags\": [\"Urgent\", \"Off-Market\", \"Investment\"], \"view\": \"Burj Khalifa View\", \"Phase\": \"Phase 1\", \"Tower\": \"Tower A\", \"build\": {\"type\": \"Off Plan\", \"handover\": \"Q2 2028\"}, \"phase\": \"Phase 1\", \"price\": {\"op\": 4100000, \"sp\": 4500000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": 3, \"bathrooms\": 4, \"maids_room\": 1, \"powder_room\": 1}, \"tower\": \"Tower A\", \"Floors\": \"High\", \"Status\": \"for sale\", \"floors\": \"High\", \"status\": \"for sale\", \"Finance\": \"Cash Only\", \"Parking\": \"2\", \"Project\": \"Sky Residences\", \"finance\": \"Cash Only\", \"parking\": 2, \"project\": \"Sky Residences\", \"Category\": \"residential\", \"Price Op\": \"4100000\", \"Price Sp\": \"4500000\", \"Size Gfa\": \"1850\", \"category\": \"residential\", \"Amenities\": \"Pool, Gym, Kids Area\", \"Developer\": \"Sobha\", \"Ownership\": \"Freehold\", \"Size Sqft\": \"1850\", \"amenities\": [\"Pool\", \"Gym\", \"Kids Area\"], \"developer\": \"Sobha\", \"ownership\": \"Freehold\", \"Build Type\": \"Off Plan\", \"Buyer Type\": \"GCC Only\", \"Furnishing\": \"Unfurnished\", \"buyer_type\": \"GCC Only\", \"furnishing\": \"Unfurnished\", \"Payment Plan\": \"80/20\", \"payment_plan\": \"80/20\", \"Plot Location\": \"Single Row\", \"Property Type\": \"Apartment\", \"plot_location\": \"Single Row\", \"property_type\": \"Apartment\", \"Build Handover\": \"Q2 2028\", \"Price Currency\": \"AED\", \"Price Per Sqft\": \"2432\", \"Rooms Bedrooms\": \"3\", \"Timeline Label\": \"Q2 2028\", \"price_per_sqft\": 2432, \"service_charge\": {\"amount\": 9500, \"frequency\": \"Quarterly\"}, \"timeline_label\": \"Q2 2028\", \"Rooms Bathrooms\": \"4\", \"Rooms Maids Room\": \"1\", \"Property Features\": \"Modern Elevation, Lounge, Roof Terrace\", \"Rooms Powder Room\": \"1\", \"property_features\": [\"Modern Elevation\", \"Lounge\", \"Roof Terrace\"], \"Service Charge Amount\": \"9500\", \"Service Charge Frequency\": \"Quarterly\"}', '{\"kind\": \"for sale\"}', '2026-05-18 12:43:43', '2026-05-18 12:43:43'),
(59, 148, 'Cash', 'Freehold', NULL, NULL, 8.00, NULL, NULL, '[\"Pool\", \"Gym\", \"BBQ Area\"]', '{\"roi\": \"8\", \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"lead\": \"Direct\", \"note\": \"Ready to move, urgent sale, park facing villa\", \"size\": {\"bua\": \"4200\", \"sqft\": \"5200\"}, \"tags\": [\"Below Market\", \"Exclusive\", \"Vacant\", \"New\"], \"view\": \"Park View\", \"build\": {\"type\": \"New\", \"handover\": \"Ready\"}, \"phase\": \"Phase 2\", \"price\": {\"op\": 8500000, \"sp\": 8800000, \"currency\": \"AED\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"5\", \"bathrooms\": \"6\", \"maids_room\": \"1\", \"powder_room\": \"1\"}, \"floors\": \"G+1 + Roof Top\", \"status\": \"for sale\", \"finance\": \"Mortgage\", \"parking\": \"3\", \"project\": \"Maple Villas\", \"category\": \"residential\", \"amenities\": [\"Pool\", \"Gym\", \"BBQ Area\"], \"developer\": \"Emaar\", \"ownership\": \"Freehold\", \"buyer_type\": \"All\", \"furnishing\": \"Furnished\", \"negotiable\": true, \"payment_plan\": \"Cash\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"price_per_sqft\": \"2095\", \"service_charge\": {\"amount\": \"18000\", \"frequency\": \"Annually\"}, \"build_condition\": \"New\", \"property_features\": [\"Lift\", \"Roof Top Terrace\", \"Home Theatre\"]}', '{\"kind\": \"for sale\"}', '2026-05-18 12:54:53', '2026-05-18 12:54:53'),
(61, 150, NULL, NULL, NULL, 1122.00, NULL, NULL, NULL, NULL, '{\"Kind\": \"for sale\", \"Tags\": \"New, Urgent, Distress, Below Market, Exclusive\", \"kind\": \"for sale\", \"size\": null, \"tags\": [\"New\", \"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"Title\": \"3BR luxury apartment JLT\", \"build\": {\"type\": \"luxury\"}, \"notes\": null, \"price\": {\"sp\": null, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"Status\": \"for sale\", \"status\": \"for sale\", \"Category\": \"residential\", \"Price Sp\": \"100000\", \"category\": \"residential\", \"off_plan\": \"1\", \"Size Sqft\": \"2800\", \"Build Type\": \"luxury\", \"Commission\": \"1122\", \"commission\": \"1122\", \"Is Off Plan\": \"true\", \"is_off_plan\": true, \"Plot Location\": \"JLT\", \"Property Type\": \"apartment\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\", \"Price Currency\": \"AED\", \"Rooms Bedrooms\": \"3\", \"Build Condition\": \"new\", \"Commission Type\": \"fixed\", \"build_condition\": \"new\", \"commission_type\": \"fixed\"}', '{\"kind\": \"for sale\", \"commission_type\": \"fixed\"}', '2026-05-20 11:31:24', '2026-05-22 09:34:47'),
(62, 151, NULL, NULL, NULL, NULL, NULL, 'Jtl dubai', NULL, NULL, '{\"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT corner\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT corner\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-20 11:33:37', '2026-05-20 11:33:37'),
(63, 152, NULL, NULL, NULL, NULL, NULL, 'This is a new apartment  and its a luxury aprment', NULL, NULL, '{\"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"title\": \"3BR luxury apartment JLT\", \"status\": \"for sale\", \"category\": \"residential\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-20 11:38:26', '2026-05-20 11:38:26'),
(64, 154, NULL, NULL, 'furnished', 18.00, NULL, 'I Love You....', NULL, '[\"Pool\", \"Gym\", \"Kids Area\"]', '{\"beds\": 2, \"tags\": [\"Below Market\", \"Urgent\"], \"price\": 600000, \"title\": \"Flat JLT\", \"description\": \"Cash buyer preferred in Marina\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-20 12:19:23', '2026-05-25 01:49:36'),
(66, 157, NULL, NULL, NULL, 18.00, NULL, 'test', NULL, NULL, '{\"beds\": 2, \"tags\": [\"Below Market\"], \"price\": 600000, \"title\": \"Flat JLT\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-25 02:18:01', '2026-05-25 02:18:01'),
(67, 158, NULL, NULL, NULL, 18.00, NULL, 'I Love You....', NULL, NULL, '{\"beds\": 2, \"tags\": [\"Below Market\", \"Urgent\"], \"price\": 600000, \"title\": \"Flat JLT\", \"description\": \"Cash buyer preferred in Marina\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-25 02:19:43', '2026-05-25 02:19:43'),
(68, 159, NULL, NULL, NULL, 112.00, NULL, NULL, NULL, NULL, '{\"beds\": 2, \"city\": \"Dubai\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Urgent\", \"New\", \"Distress\"], \"build\": {\"type\": \"furnished\"}, \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"title\": \"Urgent hot deal\", \"status\": \"for rent\", \"category\": \"residential\", \"currency\": \"USD\", \"Commission\": \"112\", \"commission\": \"112\", \"furnishing\": \"furnished\", \"plot_location\": \"downtown Dubai\", \"price_per_sqft\": \"56.67\", \"timeline_label\": \"March\", \"Commission Type\": \"fixed\", \"commission_type\": \"fixed\", \"Commission Currency\": \"AED\", \"commission_currency\": \"AED\"}', '{\"kind\": \"for rent\", \"commission_type\": \"fixed\"}', '2026-05-25 03:28:35', '2026-05-25 03:28:35'),
(69, 160, NULL, NULL, 'furnished', 19.00, NULL, 'Cash buyer preferred in Marina', NULL, NULL, '{\"area\": \"Dubai\", \"city\": \"Dubai\", \"kind\": \"for rent\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Below Market\", \"Urgent\"], \"build\": {\"type\": \"New\"}, \"notes\": \"Abc\", \"price\": {\"sp\": 90000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"category\": \"residential\", \"currency\": \"USD\", \"furnished\": \"furnished\", \"commission\": 5, \"description\": \"Cash buyer preferred in Marina\", \"is_off_plan\": true, \"plot_location\": \"downtown Dubai\", \"property_type\": \"Urgent hot deal\", \"timeline_label\": \"March\", \"commission_type\": \"percentage\"}', '{\"kind\": \"rent\", \"commission_type\": \"percentage\"}', '2026-05-25 03:30:00', '2026-05-25 06:09:23'),
(70, 161, NULL, NULL, 'furnished', NULL, NULL, 'urgent hot deal', NULL, NULL, '{\"Area\": \"downtown Dubai\", \"Beds\": \"2\", \"City\": \"Dubai\", \"Kind\": \"for rent\", \"Note\": \"urgent hot deal\", \"Tags\": \"New, Urgent\", \"area\": \"downtown Dubai\", \"beds\": 2, \"city\": \"Dubai\", \"kind\": \"for rent\", \"note\": \"urgent hot deal\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"New\", \"Urgent\"], \"Notes\": \"urgent hot deal\", \"build\": {\"type\": \"furnished\"}, \"notes\": \"urgent hot deal\", \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"Status\": \"for rent\", \"status\": \"for rent\", \"Category\": \"residential\", \"Currency\": \"USD\", \"Price Sp\": \"90000\", \"category\": \"residential\", \"currency\": \"USD\", \"Furnished\": \"furnished\", \"Size Sqft\": \"1500\", \"furnished\": \"furnished\", \"Build Type\": \"furnished\", \"Furnishing\": \"furnished\", \"furnishing\": \"furnished\", \"Is Off Plan\": \"false\", \"Rooms Study\": \"1\", \"is_off_plan\": false, \"Property Type\": \"Untitled Post\", \"property_type\": \"Untitled Post\", \"Price Currency\": \"USD\", \"Rooms Bedrooms\": \"2\", \"Timeline Label\": \"March\", \"timeline_label\": \"March\"}', '{\"kind\": \"for rent\"}', '2026-05-25 05:52:26', '2026-05-25 06:02:32'),
(71, 162, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"kind\": \"for rent\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Urgent\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"category\": \"residential\", \"currency\": \"USD\", \"furnished\": \"furnished\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"apartment\", \"price_per_sqft\": \"56.67\", \"timeline_label\": \"March\"}', '{\"kind\": \"for rent\"}', '2026-05-25 06:14:34', '2026-05-25 06:14:34'),
(72, 163, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"kind\": \"for rent\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Urgent\"], \"build\": {\"type\": \"furnished\"}, \"price\": {\"sp\": 85000, \"currency\": \"USD\"}, \"rooms\": {\"study\": \"1\", \"bedrooms\": \"2\"}, \"category\": \"residential\", \"currency\": \"USD\", \"furnished\": \"furnished\", \"plot_location\": \"downtown Dubai\", \"property_type\": \"Urgent hot deal\", \"timeline_label\": \"March\"}', '{\"kind\": \"for rent\"}', '2026-05-25 06:24:56', '2026-05-25 06:24:56'),
(73, 164, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"kind\": \"for sale\", \"size\": {\"sqft\": \"2800\"}, \"tags\": [\"Urgent\", \"Distress\", \"Below Market\", \"Exclusive\"], \"build\": {\"type\": \"new\"}, \"price\": {\"sp\": 3100000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"category\": \"residential\", \"currency\": \"AED\", \"plot_location\": \"JLT\", \"property_type\": \"apartment\"}', '{\"kind\": \"for sale\"}', '2026-05-25 06:28:03', '2026-05-25 06:28:03'),
(74, 165, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"kind\": \"rent request\", \"size\": {\"sqft\": \"2000\"}, \"tags\": [\"Urgent\", \"Below Market\"], \"price\": {\"sp\": 2000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"4\"}, \"category\": \"residential\", \"currency\": \"AED\", \"is_off_plan\": false, \"plot_location\": \"JLT\", \"property_type\": \"4BR apartment JLT\", \"payment_frequency\": \"per month\"}', '{\"kind\": \"rent request\"}', '2026-05-25 06:52:19', '2026-05-25 06:53:09'),
(75, 170, NULL, NULL, NULL, NULL, 8.00, 'Need ready family villa, move in within 1 month, direct owner preferred', NULL, NULL, '{\"roi\": 8, \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"kind\": \"buy request\", \"size\": {\"sqft\": \"4500\"}, \"tags\": [\"Urgent\", \"Below Market\"], \"view\": \"Park View\", \"build\": {\"type\": \"Ready\"}, \"notes\": \"Need ready family villa, move in within 1 month, direct owner preferred\", \"price\": {\"sp\": 12000000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"5\"}, \"category\": \"residential\", \"currency\": \"AED\", \"developer\": \"Emaar\", \"buyer_type\": \"End User\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"timeline_label\": \"within 1 month\", \"payment_frequency\": \"Mortgage\"}', '{\"kind\": \"buy request\"}', '2026-05-26 04:53:43', '2026-05-26 04:53:43'),
(76, 171, NULL, NULL, NULL, NULL, 8.00, 'Need ready family villa, move in within 1 month, direct owner preferred', NULL, NULL, '{\"roi\": 8, \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"kind\": \"buy request\", \"size\": {\"sqft\": \"4500\"}, \"tags\": [\"Urgent\", \"Below Market\"], \"view\": \"Park View\", \"baths\": 5, \"notes\": \"Need ready family villa, move in within 1 month, direct owner preferred\", \"price\": {\"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"5\"}, \"finance\": \"Mortgage\", \"category\": \"residential\", \"currency\": \"AED\", \"developer\": \"Emaar\", \"buyer_type\": \"End User\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"timeline_label\": \"within 1 month\"}', '{\"kind\": \"buy request\"}', '2026-05-26 05:24:57', '2026-05-26 05:24:57'),
(77, 172, NULL, NULL, NULL, NULL, 8.00, 'Need ready family villa, move in within 1 month, direct owner preferred', NULL, NULL, '{\"roi\": 8, \"area\": \"Dubai Hills\", \"city\": \"Dubai\", \"kind\": \"buy request\", \"size\": {\"sqft\": \"4500\"}, \"tags\": [\"Urgent\", \"Below Market\"], \"view\": \"Park View\", \"baths\": 5, \"build\": {\"type\": \"Ready\"}, \"notes\": \"Need ready family villa, move in within 1 month, direct owner preferred\", \"price\": {\"sp\": 12000000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"5\"}, \"category\": \"residential\", \"currency\": \"AED\", \"developer\": \"Emaar\", \"buyer_type\": \"End User\", \"plot_location\": \"Corner\", \"property_type\": \"Villa\", \"timeline_label\": \"within 1 month\", \"build_condition\": \"Ready\", \"rooms_bathrooms\": \"5\", \"payment_frequency\": \"Mortgage\"}', '{\"kind\": \"buy request\"}', '2026-05-26 05:27:21', '2026-05-26 05:27:21'),
(78, 173, NULL, NULL, NULL, NULL, 10.00, 'Distress Deal', NULL, NULL, '{\"roi\": 10, \"area\": \"Business Bay\", \"city\": \"Dubai\", \"kind\": \"buy request\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Distress\"], \"view\": \"Burj Khalifa View\", \"build\": {\"type\": \"Off Plan\"}, \"notes\": \"Distress Deal\", \"price\": {\"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"category\": \"residential\", \"currency\": \"AED\", \"developer\": \"Sobha\", \"buyer_type\": \"investment\", \"plot_location\": \"Business Bay\", \"property_type\": \"Apartment\", \"build_handover\": \"before Q2 2028\", \"commission_type\": \"covered\", \"payment_frequency\": \"Cash\"}', '{\"kind\": \"buy request\", \"commission_type\": \"covered\"}', '2026-05-26 05:48:21', '2026-05-26 05:48:21'),
(79, 174, NULL, NULL, NULL, NULL, 10.00, 'Looking for off plan investment property, handover before Q2 2028 preferred', NULL, NULL, '{\"roi\": 10, \"city\": \"Dubai\", \"kind\": \"buy request\", \"size\": {\"sqft\": \"1500\"}, \"tags\": [\"Distress\", \"New\"], \"view\": \"Burj Khalifa View\", \"build\": {\"type\": \"Off Plan\"}, \"notes\": \"Looking for off plan investment property, handover before Q2 2028 preferred\", \"price\": {\"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"3\"}, \"finance\": \"Cash\", \"category\": \"residential\", \"currency\": \"AED\", \"developer\": \"Sobha\", \"plot_location\": \"Business Bay\", \"property_type\": \"Apartment\", \"build_handover\": \"before Q2 2028\", \"timeline_label\": \"Flexible\", \"commission_type\": \"covered\"}', '{\"kind\": \"buy request\", \"commission_type\": \"covered\"}', '2026-05-26 05:49:43', '2026-05-26 05:49:43'),
(80, 175, 'Mortgage', 'Freehold', NULL, 2.00, NULL, 'Direct owner preferred', NULL, '[\"Pool\", \"Gym\", \"BBQ Area\"]', '{\"kind\": \"buy request\", \"size\": {\"sqft\": \"4500\"}, \"baths\": 6, \"notes\": \"Direct owner preferred\", \"price\": {\"currency\": \"AED\"}, \"project\": \"Maple Villas\", \"category\": \"residential\", \"currency\": \"AED\", \"amenities\": [\"Pool\", \"Gym\", \"BBQ Area\"], \"furnished\": \"Unfurnished\", \"ownership\": \"Freehold\", \"commission\": 2, \"payment_plan\": \"Mortgage\"}', '{\"kind\": \"buy request\", \"commission_type\": \"percentage\"}', '2026-05-26 06:19:56', '2026-05-26 06:19:56'),
(81, 176, NULL, NULL, NULL, NULL, NULL, 'Direct only, near metro station preferred', NULL, '\"Pool\"', '{\"area\": \"Dubai Marina\", \"city\": \"Dubai\", \"kind\": \"rent request\", \"size\": {\"sqft\": \"1400\"}, \"tags\": [\"Urgent\"], \"view\": \"Marina View\", \"build\": {\"type\": \"Furnished\"}, \"notes\": \"Direct only, near metro station preferred\", \"price\": {\"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"2\"}, \"parking\": \"true\", \"category\": \"residential\", \"currency\": \"AED\", \"price_op\": \"180000\", \"amenities\": \"Pool\", \"furnished\": \"Furnished\", \"transport\": \"Metro\", \"buyer_type\": \"Family\", \"plot_location\": \"Dubai Marina\", \"property_type\": \"Apartment\", \"build_handover\": \"Ready\", \"timeline_label\": \"Urgent\", \"build_condition\": \"Ready\", \"commission_type\": \"covered\", \"payment_frequency\": \"per year\"}', '{\"kind\": \"rent request\", \"commission_type\": \"covered\"}', '2026-05-26 06:35:34', '2026-05-26 06:35:34'),
(82, 177, NULL, NULL, NULL, 123.00, NULL, 'Need specific building, direct owner preferred', NULL, '[\"Gym\"]', '{\"area\": \"Business Bay\", \"city\": \"Dubai\", \"kind\": \"rent request\", \"size\": {\"sqft\": \"700\"}, \"tags\": [\"New\"], \"view\": \"City View\", \"build\": {\"type\": \"New\"}, \"notes\": \"Need specific building, direct owner preferred\", \"price\": {\"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"1\"}, \"parking\": \"false\", \"category\": \"residential\", \"currency\": \"AED\", \"amenities\": [\"Gym\"], \"furnished\": \"Unfurnished\", \"buyer_type\": \"Bachelor\", \"commission\": 123, \"property_type\": \"Studio\", \"build_condition\": \"New\", \"commission_type\": \"fixed\", \"payment_frequency\": \"yearly\", \"commission_currency\": \"AED\"}', '{\"kind\": \"rent request\", \"commission_type\": \"fixed\"}', '2026-05-26 06:49:29', '2026-05-26 06:49:29'),
(83, 178, NULL, NULL, NULL, NULL, NULL, 'Need specific building, direct owner preferred', NULL, '\"Gym\"', '{\"area\": \"Business Bay\", \"city\": \"Dubai\", \"kind\": \"rent request\", \"size\": {\"sqft\": \"700\"}, \"tags\": [\"New\"], \"view\": \"City View\", \"build\": {\"type\": \"New\"}, \"notes\": \"Need specific building, direct owner preferred\", \"price\": {\"sp\": 95000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"1\"}, \"parking\": \"false\", \"category\": \"residential\", \"currency\": \"AED\", \"amenities\": \"Gym\", \"furnished\": \"Unfurnished\", \"buyer_type\": \"Bachelor\", \"plot_location\": \"Business Bay\", \"property_type\": \"Studio\", \"build_condition\": \"New\", \"payment_frequency\": \"per year\"}', '{\"kind\": \"rent request\"}', '2026-05-26 06:52:04', '2026-05-26 06:52:04'),
(84, 179, NULL, NULL, NULL, NULL, NULL, 'Need specific building, direct owner preferred', NULL, '\"Gym\"', '{\"area\": \"Business Bay\", \"city\": \"Dubai\", \"kind\": \"rent request\", \"size\": {\"sqft\": \"700\"}, \"tags\": [\"New\"], \"view\": \"City View\", \"build\": {\"type\": \"New\"}, \"notes\": \"Need specific building, direct owner preferred\", \"price\": {\"sp\": 95000, \"currency\": \"AED\"}, \"rooms\": {\"bedrooms\": \"1\"}, \"parking\": \"no\", \"category\": \"residential\", \"currency\": \"AED\", \"amenities\": \"Gym\", \"furnished\": \"Unfurnished\", \"buyer_type\": \"Bachelor\", \"plot_location\": \"Business Bay\", \"property_type\": \"Studio\", \"timeline_label\": \"Flexible\", \"build_condition\": \"New\", \"payment_frequency\": \"yearly\"}', '{\"kind\": \"rent request\"}', '2026-05-26 06:53:03', '2026-05-26 06:53:03'),
(85, 182, NULL, NULL, NULL, NULL, NULL, 'test', NULL, NULL, '{\"kind\": \"for sale\"}', '{\"kind\": \"for sale\"}', '2026-06-05 05:15:27', '2026-06-05 05:15:28'),
(86, 183, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"kind\": \"for sale\"}', '{\"kind\": \"for sale\"}', '2026-06-05 05:15:45', '2026-06-05 05:15:46'),
(87, 184, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"kind\": \"for rent\"}', '{\"kind\": \"for rent\"}', '2026-06-05 05:16:07', '2026-06-05 05:16:07'),
(88, 191, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\"}', NULL, '2026-06-05 05:34:08', '2026-06-05 05:34:08'),
(89, 200, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"kind\": \"buy request\"}', '{\"kind\": \"buy request\"}', '2026-06-05 05:47:27', '2026-06-05 05:53:12'),
(90, 201, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"city\": \"Dubai\", \"kind\": \"for sale\"}', '{\"kind\": \"for sale\"}', '2026-06-05 05:59:07', '2026-06-05 08:43:24');

-- --------------------------------------------------------

--
-- Table structure for table `listing_media`
--

CREATE TABLE `listing_media` (
  `id` bigint UNSIGNED NOT NULL,
  `listing_id` bigint UNSIGNED NOT NULL,
  `type` enum('image','video','doc') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_media`
--

INSERT INTO `listing_media` (`id`, `listing_id`, `type`, `url`, `order`, `created_at`, `updated_at`) VALUES
(12, 101, 'image', 'http://localhost/storage/listing-media/slXckdNenRlRmjkHzioT4hewntNPOVmKR2Zt2uTu.jpg', 0, '2026-05-05 06:28:21', '2026-05-05 06:28:21'),
(13, 102, 'image', '/storage/listing-media/wvM6JGxhn2ygV5KRXuIqlDRa83l6yz7ngoHOBg7F.jpg', 0, '2026-05-05 06:43:00', '2026-05-05 06:43:00'),
(14, 102, 'image', '/storage/listing-media/s9AvWzOj8r3A9gyZX6YBojLmjaqrCXu90K7u76Mk.jpg', 1, '2026-05-05 06:43:00', '2026-05-05 06:43:00'),
(15, 103, 'image', '/storage/listing-media/aU5yuchgjUemUlVXCLwX3JlavBTpWC7QVJMjZmfe.jpg', 0, '2026-05-05 10:11:45', '2026-05-05 10:11:45'),
(16, 103, 'image', '/storage/listing-media/1IaGqdx3MX6Igy3x3HOvBWz9AQyVUULfb1zhYqMT.jpg', 1, '2026-05-05 10:11:45', '2026-05-05 10:11:45'),
(17, 103, 'image', '/storage/listing-media/7cyfybubqQetXoPU11YxADOa828gOnkvoAwlMVCq.jpg', 2, '2026-05-05 10:11:45', '2026-05-05 10:11:45'),
(18, 103, 'image', '/storage/listing-media/Or7h9hSHeijVRxlIFS5nhSnHUnSSAMVMYSqOhmvg.jpg', 3, '2026-05-05 10:11:45', '2026-05-05 10:11:45'),
(19, 104, 'image', '/storage/listing-media/v6QNGfMgGMUex9AZ7XjDI3pGEXVHBiQagAcWSoP3.jpg', 0, '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(20, 104, 'image', '/storage/listing-media/0SSwgTWn9ZAKu73cxaSCc1YkicSkAi2zd7wvfwop.jpg', 1, '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(21, 104, 'image', '/storage/listing-media/b2bIExcdPlMjAf7Wa8NIujHayog9ZhytzSo40cZk.jpg', 2, '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(22, 104, 'image', '/storage/listing-media/JbMyujLNrEyUgqTD3c58CjwxrHt3j75XYMK2Y5JU.jpg', 3, '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(23, 104, 'image', '/storage/listing-media/9V4aWENpCUDzLtMj7nlakFqNXbF6wl7Nz1khDfba.jpg', 4, '2026-05-05 11:10:38', '2026-05-05 11:10:38'),
(24, 121, 'image', '/storage/listing-media/CwGMXkxAmriCHEMOJbatB0154QAHvHq7zCRqAsdG.jpg', 0, '2026-05-08 06:48:57', '2026-05-08 06:48:57'),
(25, 121, 'image', '/storage/listing-media/P0bMxX9esyTJZVM1c82OX52W4jeuGbqu6dfI6jOH.jpg', 1, '2026-05-08 06:48:57', '2026-05-08 06:48:57'),
(36, 154, 'image', '/storage/listing-media/4UNzqvO5UUDv9fYw0AnnXDqBZPt4qZo6CvhJ4PNm.jpg', 0, '2026-05-25 01:49:36', '2026-05-25 01:49:36'),
(37, 154, 'image', '/storage/listing-media/LmPPrfC0Vbp5oLgsVwQKTJLY6bYDjl0r3xM4s7kW.jpg', 1, '2026-05-25 01:49:36', '2026-05-25 01:49:36'),
(38, 154, 'image', '/storage/listing-media/4UNzqvO5UUDv9fYw0AnnXDqBZPt4qZo6CvhJ4PNm.jpg', 2, '2026-05-25 01:49:36', '2026-05-25 01:49:36'),
(39, 154, 'image', '/storage/listing-media/LmPPrfC0Vbp5oLgsVwQKTJLY6bYDjl0r3xM4s7kW.jpg', 3, '2026-05-25 01:49:36', '2026-05-25 01:49:36'),
(40, 158, 'image', '/storage/listing-media/uQq4l8lU7FePELwCGcf1Vx6nrMttFcAU8EAg2tVh.jpg', 0, '2026-05-25 02:19:43', '2026-05-25 02:19:43'),
(41, 158, 'image', '/storage/listing-media/UEnV373gvmUWnXbKAhPNocP2wEIuJC9ERkryUqZC.jpg', 1, '2026-05-25 02:19:43', '2026-05-25 02:19:43'),
(54, 160, 'image', '/storage/listing-media/gR04mjyw8396zK24DOJEUbpKk6V9GJVwwaltLSsd.jpg', 0, '2026-05-25 06:09:23', '2026-05-25 06:09:23'),
(55, 160, 'image', '/storage/listing-media/EuwkGYi4yCvrbF2yBdVEjWS1PG4OUtxNiOsWr9Qo.jpg', 1, '2026-05-25 06:09:23', '2026-05-25 06:09:23'),
(56, 160, 'image', '/storage/listing-media/gR04mjyw8396zK24DOJEUbpKk6V9GJVwwaltLSsd.jpg', 2, '2026-05-25 06:09:23', '2026-05-25 06:09:23'),
(57, 160, 'image', '/storage/listing-media/EuwkGYi4yCvrbF2yBdVEjWS1PG4OUtxNiOsWr9Qo.jpg', 3, '2026-05-25 06:09:23', '2026-05-25 06:09:23'),
(80, 201, 'image', '/storage/listing-media/keep.jpg', 0, '2026-06-05 08:44:21', '2026-06-05 08:44:21'),
(82, 202, 'image', '/storage/listing-media/keep.jpg', 0, '2026-06-08 02:51:46', '2026-06-08 02:51:46'),
(83, 202, 'image', '/storage/listing-media/remove.jpg', 1, '2026-06-08 02:51:46', '2026-06-08 02:51:46');

-- --------------------------------------------------------

--
-- Table structure for table `listing_metric_events`
--

CREATE TABLE `listing_metric_events` (
  `id` bigint UNSIGNED NOT NULL,
  `listing_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `metric` enum('view','click','lead') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_metric_events`
--

INSERT INTO `listing_metric_events` (`id`, `listing_id`, `user_id`, `metric`, `created_at`, `updated_at`) VALUES
(1, 154, 14, 'view', '2026-05-23 15:34:08', '2026-05-23 15:34:08'),
(2, 154, 14, 'click', '2026-05-23 15:34:08', '2026-05-23 15:34:08'),
(3, 154, 14, 'lead', '2026-05-23 15:34:37', '2026-05-23 15:34:37');

-- --------------------------------------------------------

--
-- Table structure for table `listing_reviews`
--

CREATE TABLE `listing_reviews` (
  `id` bigint UNSIGNED NOT NULL,
  `listing_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `rating` tinyint UNSIGNED NOT NULL,
  `review_text` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_reviews`
--

INSERT INTO `listing_reviews` (`id`, `listing_id`, `user_id`, `rating`, `review_text`, `created_at`, `updated_at`) VALUES
(1, 103, 18, 4, 'This is Beautiful Villa.', '2026-05-07 02:35:51', '2026-05-07 04:46:26');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2026_02_12_000001_add_closex_fields_to_users_table', 1),
(6, '2026_02_12_000002_create_broker_profiles_table', 1),
(7, '2026_02_12_000003_create_agencies_table', 1),
(8, '2026_02_12_000004_create_listings_table', 1),
(9, '2026_02_12_000005_create_listing_details_table', 1),
(10, '2026_02_12_000006_create_listing_media_table', 1),
(11, '2026_02_12_000007_create_favorites_table', 1),
(12, '2026_02_12_000008_create_saved_searches_table', 1),
(13, '2026_02_12_000009_create_posts_table', 1),
(14, '2026_03_30_000001_add_first_last_name_to_users_table', 2),
(15, '2026_03_30_000002_add_oauth_provider_ids_to_users_table', 3),
(16, '2026_04_09_000001_add_profile_preferences_and_agency_assets', 4),
(17, '2026_04_14_000010_add_form_data_to_listing_details_table', 5),
(18, '2026_04_17_000001_add_whatsapp_to_agencies_table', 6),
(19, '2026_04_17_000002_add_profile_completion_percent_to_users_table', 7),
(20, '2026_05_04_000001_add_additional_notes_to_listing_details_table', 8),
(21, '2026_05_06_000002_create_listing_reviews_table', 9),
(22, '2026_05_06_000003_create_likes_table', 9),
(23, '2026_05_06_000004_create_comments_table', 9),
(24, '2026_05_06_000005_add_name_to_saved_searches_table', 9),
(25, '2026_05_06_000006_add_processing_to_listings_status_enum', 10),
(26, '2026_05_06_000006_add_media_to_posts_table', 11),
(27, '2026_05_08_000001_add_clicks_and_leads_count_to_listings_table', 12),
(28, '2026_05_08_000002_add_marked_as_to_listings_table', 13),
(29, '2026_05_08_000003_create_listing_metric_events_table', 14),
(30, '2026_06_02_000001_add_unique_listing_metric_per_user', 15);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 5, 'auth_token', 'c72604b2a37e13ea2ddaf1d38a3f2f48adaa37354ae1014785b68cd97b15638f', '[\"*\"]', NULL, '2026-03-26 06:19:05', '2026-03-26 06:19:05'),
(2, 'App\\Models\\User', 5, 'auth_token', 'bb0ec1f43a22beb28b46fb7ea3652f2fcc9978ddac44c2482a11d499daff633f', '[\"*\"]', NULL, '2026-03-26 06:33:18', '2026-03-26 06:33:18'),
(3, 'App\\Models\\User', 5, 'auth_token', '6095e3f0e637ec99a5e69cb6d2d1d760711e67f99236a0bf0fa9e259a13761c9', '[\"*\"]', NULL, '2026-03-26 06:38:00', '2026-03-26 06:38:00'),
(4, 'App\\Models\\User', 5, 'auth_token', '7f64564502e93dc5c58d29094bf96e34bc8131f31a3d94d00a6f162636e7d609', '[\"*\"]', NULL, '2026-03-30 01:35:34', '2026-03-30 01:35:34'),
(5, 'App\\Models\\User', 5, 'auth_token', 'c9b72939b0bed0ca5b07b6f75682f7e4a23c6b0e59a79db685ab08f630b9b541', '[\"*\"]', NULL, '2026-03-30 01:37:14', '2026-03-30 01:37:14'),
(6, 'App\\Models\\User', 5, 'auth_token', 'de719a1a1713d0e2cad28b505e8b83e11cc742ec5592e4c7c120ce492b72c530', '[\"*\"]', NULL, '2026-03-30 01:46:26', '2026-03-30 01:46:26'),
(7, 'App\\Models\\User', 5, 'auth_token', '3f7dbb39093a10f9c232bb25103711243dec34192b9495cd1e5ddb63bd84b905', '[\"*\"]', NULL, '2026-03-30 02:15:53', '2026-03-30 02:15:53'),
(8, 'App\\Models\\User', 5, 'auth_token', 'e81ea201bac0fed9be09efba66809b04e6c58b3ea171e07905ab8084ef2b000f', '[\"*\"]', NULL, '2026-03-30 02:17:29', '2026-03-30 02:17:29'),
(9, 'App\\Models\\User', 5, 'auth_token', 'fc56d17350b1c04f99323292ddcce8ce24859adbc7cf3ac439bdaee0bd93d47e', '[\"*\"]', NULL, '2026-03-30 02:19:19', '2026-03-30 02:19:19'),
(10, 'App\\Models\\User', 5, 'auth_token', 'd5f621a9d6428fe00c9a2480593c0f4e6c5a716201011977c2611d2c37429c58', '[\"*\"]', NULL, '2026-03-30 02:19:54', '2026-03-30 02:19:54'),
(11, 'App\\Models\\User', 5, 'auth_token', 'f9cc7738affe6556619ccae2eb0817c955caf9d8b83a1236298bbad6c5db1ae0', '[\"*\"]', NULL, '2026-03-30 02:23:24', '2026-03-30 02:23:24'),
(12, 'App\\Models\\User', 5, 'auth_token', '14127a4b1c5254bc06f2468f42a1dd5cc32c618429eabf67cad255e67926bebd', '[\"*\"]', NULL, '2026-03-30 02:23:40', '2026-03-30 02:23:40'),
(13, 'App\\Models\\User', 6, 'auth_token', '5086dae135ed7adfaf03fb01bf0329b9a5298ef94f2986652673732fea169673', '[\"*\"]', NULL, '2026-03-30 02:26:19', '2026-03-30 02:26:19'),
(14, 'App\\Models\\User', 5, 'auth_token', '3a35b17aba765baa582e542dfa8b4d8ebe19b8b24970be28a5b4a5f7563d76fe', '[\"*\"]', NULL, '2026-03-30 02:29:47', '2026-03-30 02:29:47'),
(15, 'App\\Models\\User', 5, 'auth_token', '6b64d7415e80466714bfbb9b93f42f790937003d89552c4750684dbebef3c24f', '[\"*\"]', NULL, '2026-03-30 03:05:31', '2026-03-30 03:05:31'),
(16, 'App\\Models\\User', 7, 'auth_token', 'e256934428d48590a999c0862bd4a8d66b95604d9d9cdd9c3338d5f03c1ae039', '[\"*\"]', NULL, '2026-03-30 03:19:05', '2026-03-30 03:19:05'),
(17, 'App\\Models\\User', 8, 'auth_token', '21cf7d28b13a610fccf9b74001309bfe8a948aa1222e929fc23da12d807973bd', '[\"*\"]', NULL, '2026-03-30 03:24:23', '2026-03-30 03:24:23'),
(18, 'App\\Models\\User', 9, 'auth_token', '036bfd5fefa8aad695cb043ec2b3044829770888bfef77cebde2330ebfc8e822', '[\"*\"]', NULL, '2026-03-30 03:25:52', '2026-03-30 03:25:52'),
(19, 'App\\Models\\User', 10, 'auth_token', 'b67778fd9397d279fbeaeee965dc4649a1cf43aac1ae60cc9e8f307b01fff7a9', '[\"*\"]', NULL, '2026-03-30 03:27:25', '2026-03-30 03:27:25'),
(20, 'App\\Models\\User', 11, 'auth_token', '9bacdb06a76398799a98e07f7f0fcdfc6c40c15ded7e0d34c3e0b0b5bbdaffe8', '[\"*\"]', NULL, '2026-03-30 03:39:21', '2026-03-30 03:39:21'),
(21, 'App\\Models\\User', 12, 'auth_token', 'c3a790b5923b68fa39abdd02c12756846854982ef614b650f9e67269f25ca2a6', '[\"*\"]', NULL, '2026-03-30 03:53:15', '2026-03-30 03:53:15'),
(22, 'App\\Models\\User', 13, 'auth_token', '897fa6c1032b0b64878d6e08b88ee8f7ac16f77c8ae8fb1c5203aae5da96caff', '[\"*\"]', NULL, '2026-03-30 03:57:43', '2026-03-30 03:57:43'),
(23, 'App\\Models\\User', 13, 'auth_token', '7c99ecf50975446aaedadd9031345eaf6013c891a72052f579ad44d722805800', '[\"*\"]', NULL, '2026-03-30 03:59:45', '2026-03-30 03:59:45'),
(24, 'App\\Models\\User', 13, 'auth_token', '7fa65e100dbbc11b81425f6d5f269b3adeccbea0773dd78ae700af3310c94b94', '[\"*\"]', NULL, '2026-03-31 06:44:07', '2026-03-31 06:44:07'),
(25, 'App\\Models\\User', 5, 'auth_token', '1075c7ef50785c9ac93798e1ecce411dde6519cd3a6c6930e3a0b56eea0c4093', '[\"*\"]', NULL, '2026-04-03 06:10:55', '2026-04-03 06:10:55'),
(26, 'App\\Models\\User', 13, 'auth_token', '43ee589c672e4f4d408d60a1660f71acd76c623662254c290a56f0fe8b3399db', '[\"*\"]', NULL, '2026-04-03 06:11:01', '2026-04-03 06:11:01'),
(27, 'App\\Models\\User', 13, 'auth_token', '574e3d56ca38e482c23012df22391d52d510997ee7bb6445562a21ab00c11781', '[\"*\"]', NULL, '2026-04-03 06:12:30', '2026-04-03 06:12:30'),
(28, 'App\\Models\\User', 13, 'auth_token', '2b2337d237b88e801b9ba3ada9be84de5ff5a4e976804caf4c68b470bc352e5d', '[\"*\"]', NULL, '2026-04-08 04:05:37', '2026-04-08 04:05:37'),
(29, 'App\\Models\\User', 13, 'auth_token', 'd79d07f39c9bcf829351a341ec3d8a833eaba14a75c64207d250b5f68f936a81', '[\"*\"]', NULL, '2026-04-08 04:15:07', '2026-04-08 04:15:07'),
(30, 'App\\Models\\User', 13, 'auth_token', 'c0c4c464d725ac6d8c6d63892063e5c0c9dc5df255e485407c75c568015dacc9', '[\"*\"]', NULL, '2026-04-08 04:36:57', '2026-04-08 04:36:57'),
(31, 'App\\Models\\User', 13, 'auth_token', '10465a0ce848a2a8f6553e9350ca3a24a6773473a34d373823bce3ad39799941', '[\"*\"]', NULL, '2026-04-08 09:26:11', '2026-04-08 09:26:11'),
(32, 'App\\Models\\User', 13, 'auth_token', '24dc1cdfb508ed120de8a9a492070a33c49da9514b39d20686088bd3b21b01b8', '[\"*\"]', NULL, '2026-04-08 09:35:42', '2026-04-08 09:35:42'),
(33, 'App\\Models\\User', 13, 'auth_token', '38cae7ae62fdc89fe6ff3b6488480d0f2b3357d402f18170b5eda19e1c3ab3ad', '[\"*\"]', NULL, '2026-04-08 10:21:40', '2026-04-08 10:21:40'),
(34, 'App\\Models\\User', 13, 'auth_token', '57f9514ad3efb3e025ca16f605e26e70f1f49604481897363be03510fd349b24', '[\"*\"]', NULL, '2026-04-08 10:28:59', '2026-04-08 10:28:59'),
(35, 'App\\Models\\User', 13, 'auth_token', '874d2d85c139bbe40980f0c46eab2f6ecee940efc03f8accc55c58c017e426d3', '[\"*\"]', NULL, '2026-04-08 10:57:55', '2026-04-08 10:57:55'),
(36, 'App\\Models\\User', 13, 'auth_token', '24bf438885496492bcaf5dcf1cc298ecf63a4c27a626e6e937ff409305d61618', '[\"*\"]', NULL, '2026-04-08 11:13:21', '2026-04-08 11:13:21'),
(37, 'App\\Models\\User', 13, 'auth_token', 'ada4627a2cec539bac88557f8370a0fd26c2bf0fca460f4bff3a2b2c2740aba5', '[\"*\"]', NULL, '2026-04-09 01:05:22', '2026-04-09 01:05:22'),
(38, 'App\\Models\\User', 13, 'auth_token', '5999cc1c5c677252f7257344d86712ec6730bb5a5b7ac60cabafea5b50d69442', '[\"*\"]', NULL, '2026-04-09 01:08:48', '2026-04-09 01:08:48'),
(39, 'App\\Models\\User', 13, 'auth_token', '5a2096dee7302a5bea5caa9a8e08b7ee91eebb629587f50dd273308a02935bb1', '[\"*\"]', NULL, '2026-04-09 01:28:25', '2026-04-09 01:28:25'),
(40, 'App\\Models\\User', 13, 'auth_token', 'b3ec1874777f7c890b153353e9549fa17f0dd08c94cb142c2086dbb3bd4e59a8', '[\"*\"]', NULL, '2026-04-09 01:37:07', '2026-04-09 01:37:07'),
(41, 'App\\Models\\User', 5, 'auth_token', 'd03e4706f15b7dbe84249496f9c7e4c14ff8ff63c1b7b1a558e0837c316a9d75', '[\"*\"]', NULL, '2026-04-09 01:43:29', '2026-04-09 01:43:29'),
(42, 'App\\Models\\User', 13, 'auth_token', '30e19609a5edcbe7c27e055f921a4815e6fe957ae91ae9b1f22c9a10131dbd8e', '[\"*\"]', NULL, '2026-04-09 01:49:31', '2026-04-09 01:49:31'),
(43, 'App\\Models\\User', 5, 'auth_token', '0dfefc9cfbb138356efbc09d1767144e9ed3b13ec43bcbd39ce7ad4048eb7109', '[\"*\"]', NULL, '2026-04-09 02:54:44', '2026-04-09 02:54:44'),
(44, 'App\\Models\\User', 13, 'auth_token', '0674f7975a3290c182f48af8aed4ba56032974c87c733c64454cd7af9b14c7e7', '[\"*\"]', '2026-04-27 05:00:22', '2026-04-09 02:56:20', '2026-04-27 05:00:22'),
(45, 'App\\Models\\User', 5, 'auth_token', '210aad279b592dae4d8a5ac57f8d9eb001bb17eecc5549994c6630b253119455', '[\"*\"]', NULL, '2026-04-09 03:17:26', '2026-04-09 03:17:26'),
(46, 'App\\Models\\User', 13, 'auth_token', '29075562b205cfeda12f611b31fc8280372bc7f13d6898b83557cf7029920696', '[\"*\"]', NULL, '2026-04-09 04:12:17', '2026-04-09 04:12:17'),
(47, 'App\\Models\\User', 14, 'auth_token', 'c0595fea030259a7bc1a6b78588b2fafd4a0092660ee6b80482647d74e861c8a', '[\"*\"]', NULL, '2026-04-09 04:12:19', '2026-04-09 04:12:19'),
(48, 'App\\Models\\User', 14, 'auth_token', 'ddbc8946b80eb23e5b2c3ff898eacf041d27d807119f67e75a25f7e8dc88216d', '[\"*\"]', NULL, '2026-04-09 04:15:53', '2026-04-09 04:15:53'),
(49, 'App\\Models\\User', 14, 'auth_token', 'a3923b980528a6a8917aa38639df4cb6ceab17a466d5830d8803e71153df7f61', '[\"*\"]', NULL, '2026-04-09 04:18:14', '2026-04-09 04:18:14'),
(50, 'App\\Models\\User', 14, 'auth_token', '630599930bd76695ff7848cb40d743ffd8098c28f1dfda18505e33f9a51c2c47', '[\"*\"]', NULL, '2026-04-09 04:33:46', '2026-04-09 04:33:46'),
(51, 'App\\Models\\User', 14, 'auth_token', '80bab27bdd04397d87c006ddc3dfdf35b5f797eac47f427b9fe20c00507e290a', '[\"*\"]', NULL, '2026-04-09 04:35:16', '2026-04-09 04:35:16'),
(52, 'App\\Models\\User', 14, 'auth_token', 'caf3ca485238c0fe83185373fa6387e389388c490b8720067fb1879c51775458', '[\"*\"]', NULL, '2026-04-09 04:37:53', '2026-04-09 04:37:53'),
(53, 'App\\Models\\User', 14, 'auth_token', 'f4d662489eeebf5fdf6f8eca43f5d1190d94cb0cb20f3dab5145460847f33613', '[\"*\"]', NULL, '2026-04-09 04:38:09', '2026-04-09 04:38:09'),
(54, 'App\\Models\\User', 14, 'auth_token', '6763fda39fbee7892ee389b0a60b18d06a74baf4fc725e4418421ea590d2d23b', '[\"*\"]', NULL, '2026-04-09 04:39:54', '2026-04-09 04:39:54'),
(55, 'App\\Models\\User', 13, 'auth_token', 'd5491e11a9e730ae686e3079df1a12303c79a65d8a858ae7f87831fb00fae317', '[\"*\"]', NULL, '2026-04-09 05:15:03', '2026-04-09 05:15:03'),
(56, 'App\\Models\\User', 13, 'auth_token', '1d8f608c31843d6e526c18df378649258bbb4ab5467197c6c5b2f6bf01678c17', '[\"*\"]', NULL, '2026-04-09 05:18:31', '2026-04-09 05:18:31'),
(57, 'App\\Models\\User', 13, 'auth_token', '332859a5416b1e5aebaaf0b997c7dc0913c9810776bbdcb0c5358133afbce28a', '[\"*\"]', NULL, '2026-04-09 05:22:10', '2026-04-09 05:22:10'),
(58, 'App\\Models\\User', 13, 'auth_token', '7d3f6f684c5c5f01ce5cfb193ae37840ec8333e495865204b5c0c6669b40d702', '[\"*\"]', NULL, '2026-04-09 05:24:31', '2026-04-09 05:24:31'),
(59, 'App\\Models\\User', 13, 'auth_token', 'dba899b822cd61946fbfe52894f14f1e098874e5a204e72b4d76e1bb240395a4', '[\"*\"]', NULL, '2026-04-09 05:28:59', '2026-04-09 05:28:59'),
(60, 'App\\Models\\User', 15, 'auth_token', '3f416823071a077f5b8596c27e2269be88acfc19616db554ae5228bd8d4224f2', '[\"*\"]', NULL, '2026-04-09 06:40:05', '2026-04-09 06:40:05'),
(61, 'App\\Models\\User', 15, 'auth_token', '8be6a4ea1569e43e786545492c60aa006654a9fef07a215b0f97a0b07fa8e25d', '[\"*\"]', NULL, '2026-04-09 06:44:35', '2026-04-09 06:44:35'),
(62, 'App\\Models\\User', 14, 'auth_token', '305143fc4b2848060f0681f289a577ddb68d42817aadc069e4fdac1bbd69fafa', '[\"*\"]', NULL, '2026-04-09 07:05:38', '2026-04-09 07:05:38'),
(63, 'App\\Models\\User', 14, 'auth_token', 'ef1a5eabfdde8c6c04c04e20cf9f994f31dbf616efcd554bc204f6b8a0a1a131', '[\"*\"]', NULL, '2026-04-09 07:07:19', '2026-04-09 07:07:19'),
(64, 'App\\Models\\User', 13, 'auth_token', 'daea5c7df6496d1987331f9945548ce159ea62dac2254f59e47616ad696aaa68', '[\"*\"]', NULL, '2026-04-09 08:36:17', '2026-04-09 08:36:17'),
(65, 'App\\Models\\User', 5, 'auth_token', '2dad5770110d4ed058c0d139ff94e5bfa44ef8cf052568ebb265d8e6b46177ec', '[\"*\"]', NULL, '2026-04-09 09:28:33', '2026-04-09 09:28:33'),
(66, 'App\\Models\\User', 13, 'auth_token', '2006b97fe10c4d6f042a5fcbb7a1c3ca8b346f10e7757ab86dfbb74ea3030dd6', '[\"*\"]', NULL, '2026-04-09 09:29:27', '2026-04-09 09:29:27'),
(67, 'App\\Models\\User', 13, 'auth_token', '105d2378fcd38a6fcf5ef7b4c37cef0d2bdfda2841421532fc7a03a796c3711e', '[\"*\"]', NULL, '2026-04-09 09:39:54', '2026-04-09 09:39:54'),
(68, 'App\\Models\\User', 13, 'auth_token', 'eb8da09f8bcb4a696719275b691f92416827118e773a68f66fb05a6dc72d71aa', '[\"*\"]', NULL, '2026-04-09 10:28:38', '2026-04-09 10:28:38'),
(69, 'App\\Models\\User', 13, 'auth_token', 'f3d2fbd3885c2cc88404f7a8207247f0c8ab7adc05e6aef63a0c12e5f240205f', '[\"*\"]', '2026-04-09 11:42:19', '2026-04-09 10:35:51', '2026-04-09 11:42:19'),
(70, 'App\\Models\\User', 13, 'auth_token', 'b12636291fbfd3ffcee5337d7a9c17a21fec069d546a47a87035f2ee64183ac9', '[\"*\"]', '2026-04-09 11:49:46', '2026-04-09 11:43:08', '2026-04-09 11:49:46'),
(71, 'App\\Models\\User', 14, 'auth_token', 'c5acdb8c31829061bb0909f2611071137792d20e81bd45e446c9a617142cbdfb', '[\"*\"]', NULL, '2026-04-09 11:54:43', '2026-04-09 11:54:43'),
(72, 'App\\Models\\User', 13, 'auth_token', '2d369b0a3f1896162a29e83f6a914e2580a9854713be9a9362d34bc3cf5fc8ee', '[\"*\"]', NULL, '2026-04-09 11:56:05', '2026-04-09 11:56:05'),
(73, 'App\\Models\\User', 14, 'auth_token', '62363f5cd6f1899a7dd720c5d0c6c3a045a13e04ff8f85a9adaa971cb0dd146c', '[\"*\"]', NULL, '2026-04-09 12:03:08', '2026-04-09 12:03:08'),
(74, 'App\\Models\\User', 13, 'auth_token', '9f9d79c258be09f6ad747cdc7e3a855af847af790300f64c8a6313f000cff139', '[\"*\"]', NULL, '2026-04-09 12:07:41', '2026-04-09 12:07:41'),
(75, 'App\\Models\\User', 14, 'auth_token', '803454182f7907f5ad0a4dcfd44fe1c7f96e76d203d4e591887e32f6a3bda066', '[\"*\"]', NULL, '2026-04-09 12:08:03', '2026-04-09 12:08:03'),
(76, 'App\\Models\\User', 14, 'auth_token', '42fc107637be3519a64bd689c2350ae8b10ffd2cf0682d30ffe420130d7a1ac0', '[\"*\"]', NULL, '2026-04-09 12:10:28', '2026-04-09 12:10:28'),
(77, 'App\\Models\\User', 13, 'auth_token', '15910b7cdf16f16eac7b8fbbe279a09342881937df0c73ba1ceb005f351dfd7d', '[\"*\"]', NULL, '2026-04-09 12:10:40', '2026-04-09 12:10:40'),
(78, 'App\\Models\\User', 14, 'auth_token', '3a37d4855c5b566057275aad2c1d968a9ebfc685c990a23e08b0d1b0903fdd27', '[\"*\"]', NULL, '2026-04-09 12:14:28', '2026-04-09 12:14:28'),
(79, 'App\\Models\\User', 13, 'auth_token', '7b02927666e80688ad8203822c395f6ca4bda78eecc3a84c538fcafa5f2262d4', '[\"*\"]', NULL, '2026-04-09 12:14:45', '2026-04-09 12:14:45'),
(80, 'App\\Models\\User', 13, 'auth_token', 'f3bee2ea0dc0bb374f0c8fdb1be8c3d2d6128c6680eb0adc21231b08c5b7b459', '[\"*\"]', NULL, '2026-04-10 00:41:34', '2026-04-10 00:41:34'),
(81, 'App\\Models\\User', 13, 'auth_token', 'a7514daad0925995bc55ec1e988f5351892ca55979f3191d02c4d28ba7c9c16a', '[\"*\"]', NULL, '2026-04-10 04:09:37', '2026-04-10 04:09:37'),
(82, 'App\\Models\\User', 13, 'auth_token', '5d20b49d7d2b21f43355e168362286dc840af52a7a4ac5c164173e0e6fd09aa0', '[\"*\"]', NULL, '2026-04-10 04:33:56', '2026-04-10 04:33:56'),
(83, 'App\\Models\\User', 14, 'auth_token', '2fd277763ab5f1839730fc253d920d9fa676a053db215307cbca64f045af756e', '[\"*\"]', NULL, '2026-04-10 05:09:22', '2026-04-10 05:09:22'),
(84, 'App\\Models\\User', 13, 'auth_token', 'b51edd0af456c1a2b7069707c8fca267e2a006fa664ea2aa23e786c53af46e3a', '[\"*\"]', NULL, '2026-04-10 05:09:38', '2026-04-10 05:09:38'),
(85, 'App\\Models\\User', 13, 'auth_token', 'd40d20f6a793a96338a032ebb061f7492b9a5b94e23d218d1608330ce8ad370a', '[\"*\"]', NULL, '2026-04-10 05:30:59', '2026-04-10 05:30:59'),
(86, 'App\\Models\\User', 13, 'auth_token', 'e25c5796c1772cac64369d6304ec67363f2de912032a0ab9631deab1216ab016', '[\"*\"]', NULL, '2026-04-10 05:51:41', '2026-04-10 05:51:41'),
(87, 'App\\Models\\User', 13, 'auth_token', 'bbda9309d94ba506bbfa47d8d1857e492fa173920d0448b0bb4991363f554c95', '[\"*\"]', NULL, '2026-04-10 06:02:05', '2026-04-10 06:02:05'),
(88, 'App\\Models\\User', 13, 'auth_token', '9c35fd0760de919a31d41744af899fcd1c146e41a284a8a97a56f6927667f2c0', '[\"*\"]', '2026-05-05 02:47:08', '2026-04-10 06:08:43', '2026-05-05 02:47:08'),
(89, 'App\\Models\\User', 13, 'auth_token', '2c5f5ce5a51d8ee7f408a45ca603a4df4caa6ddb6f7e0f9e6b5277e813b70c84', '[\"*\"]', NULL, '2026-04-10 06:33:11', '2026-04-10 06:33:11'),
(90, 'App\\Models\\User', 13, 'auth_token', '41b4856371e6d57c1fd4776807df9cb80dcdf289f39128dbe73f5d093f0cdd8c', '[\"*\"]', NULL, '2026-04-13 02:13:12', '2026-04-13 02:13:12'),
(91, 'App\\Models\\User', 13, 'auth_token', '46208059ac55b64b46ebab1e0dc0587858e197aa0dab778d59b2d1b0a247e927', '[\"*\"]', NULL, '2026-04-13 02:39:44', '2026-04-13 02:39:44'),
(92, 'App\\Models\\User', 13, 'auth_token', '617a5880997d5df36086768efb06b8036fba4e259ca90f629b0c97eca92455e2', '[\"*\"]', NULL, '2026-04-13 02:40:56', '2026-04-13 02:40:56'),
(93, 'App\\Models\\User', 13, 'auth_token', '3814aec76f66ebda6597285a7e3240ad25eb95a0e93e3a626ffdc933d1333669', '[\"*\"]', NULL, '2026-04-13 05:04:08', '2026-04-13 05:04:08'),
(94, 'App\\Models\\User', 13, 'auth_token', '098ec722b5fb496c332a37aee5db70bd69d77c9b33d3a96630c468d86720cef3', '[\"*\"]', NULL, '2026-04-13 05:17:09', '2026-04-13 05:17:09'),
(95, 'App\\Models\\User', 13, 'auth_token', 'a56c7002cee2a18eaf78db3626a5d0c2d12c116e8f93754af2c40c38c530ddcc', '[\"*\"]', NULL, '2026-04-13 05:27:25', '2026-04-13 05:27:25'),
(96, 'App\\Models\\User', 13, 'auth_token', '31d40f8010c9cb0f28618c445f03060f2c4dfc00a6c9be7f8eafc81bdea24ea7', '[\"*\"]', NULL, '2026-04-13 05:40:07', '2026-04-13 05:40:07'),
(97, 'App\\Models\\User', 13, 'auth_token', 'ccfedb9261a3283c7020fd0b9f78c169c158bf187e4c09b800865b5b23a5e8d0', '[\"*\"]', NULL, '2026-04-13 05:43:09', '2026-04-13 05:43:09'),
(98, 'App\\Models\\User', 13, 'auth_token', '0af940410d56d69c554d7bdfff2734378df4b485daa59b1b6a68be3289ccb1fa', '[\"*\"]', NULL, '2026-04-13 06:02:21', '2026-04-13 06:02:21'),
(99, 'App\\Models\\User', 13, 'auth_token', '23a37ecad15dd78be358c6751026d75d65d6982b3a0960edb222e0597efbc0c2', '[\"*\"]', NULL, '2026-04-13 06:13:04', '2026-04-13 06:13:04'),
(100, 'App\\Models\\User', 13, 'auth_token', '6a0699ca7bfa81a053fff5275aa081c6861332ba6818bfbd3de0a5835f213465', '[\"*\"]', NULL, '2026-04-13 06:21:04', '2026-04-13 06:21:04'),
(101, 'App\\Models\\User', 13, 'auth_token', 'b056e9b38e0f155c6c349a7587320554054c70a09fd566e28c8421348b60aea2', '[\"*\"]', NULL, '2026-04-13 06:24:47', '2026-04-13 06:24:47'),
(102, 'App\\Models\\User', 13, 'auth_token', '7bcd1ec36ff66e2ec5f21535db964c33aa50e81a68d8435d4713616c778fbaa0', '[\"*\"]', '2026-04-13 06:34:43', '2026-04-13 06:32:28', '2026-04-13 06:34:43'),
(103, 'App\\Models\\User', 13, 'auth_token', 'a9f6f5c232cf67cc685041b56f30ea89da3ff651c06bb84e398013b9cb631da4', '[\"*\"]', '2026-04-13 09:34:48', '2026-04-13 09:33:42', '2026-04-13 09:34:48'),
(104, 'App\\Models\\User', 13, 'auth_token', '7fe51d7a37700dda88e1ac91999052f923f5689350ab13dbbc1d5a27b01663a2', '[\"*\"]', '2026-04-13 09:49:36', '2026-04-13 09:35:55', '2026-04-13 09:49:36'),
(105, 'App\\Models\\User', 13, 'auth_token', 'ad252957ebac95e7ce16346d4203cbc6d72e51c7bf45f2f8f7fb4a98f3731345', '[\"*\"]', '2026-04-13 09:55:53', '2026-04-13 09:50:39', '2026-04-13 09:55:53'),
(106, 'App\\Models\\User', 13, 'auth_token', 'dcd3782f0008c55273b7c4cff369c831be3a069d75b5e1429fba52f6068a658b', '[\"*\"]', '2026-04-13 11:06:56', '2026-04-13 10:15:37', '2026-04-13 11:06:56'),
(107, 'App\\Models\\User', 13, 'auth_token', '54a6ded39fe2f71829236db8a7c47ee37a5d96b2d1214d822eab83bc1b81ccdd', '[\"*\"]', '2026-04-13 11:18:16', '2026-04-13 11:12:52', '2026-04-13 11:18:16'),
(108, 'App\\Models\\User', 13, 'auth_token', '963ac9c45f8f2ac597d335f67995a3460d67639ead4a6ff9d060f85873b17ca6', '[\"*\"]', NULL, '2026-04-13 11:28:50', '2026-04-13 11:28:50'),
(109, 'App\\Models\\User', 13, 'auth_token', '7a2f0dbcb867274e6ce5eda921369709f27720ff3c37140615a5f33addb6e6fe', '[\"*\"]', NULL, '2026-04-13 12:00:05', '2026-04-13 12:00:05'),
(110, 'App\\Models\\User', 13, 'auth_token', '5e9e879791f89a26bb5519c8b90d71c287fa2736a7817c402b574eb350a76593', '[\"*\"]', NULL, '2026-04-14 04:16:07', '2026-04-14 04:16:07'),
(111, 'App\\Models\\User', 13, 'auth_token', 'dbd77ff3467c7df573b14e97a0690a3dad04485c1fc77b62fad0b977452c895a', '[\"*\"]', '2026-04-14 05:00:28', '2026-04-14 04:44:22', '2026-04-14 05:00:28'),
(112, 'App\\Models\\User', 13, 'auth_token', 'bedf81e771b4406402b11a4f5fc1fb49bc3efb961fd15af9e2930bfacacf43f2', '[\"*\"]', '2026-04-14 05:26:23', '2026-04-14 05:06:52', '2026-04-14 05:26:23'),
(113, 'App\\Models\\User', 13, 'auth_token', 'b49d92f9a81fdd8abdd8e928050d3be3f9e865d46e2b59b69db4f4f29c579a73', '[\"*\"]', '2026-04-14 05:58:48', '2026-04-14 05:39:52', '2026-04-14 05:58:48'),
(114, 'App\\Models\\User', 13, 'auth_token', '5b33fbd9e5b3dd5cd65f7bc3ae57ffced7bbd7d2b4109a9b3a04e759ae9ca7a3', '[\"*\"]', '2026-04-14 06:58:58', '2026-04-14 06:35:59', '2026-04-14 06:58:58'),
(115, 'App\\Models\\User', 13, 'auth_token', 'bf01f9e978e6ea03332bbe862b40a5dee6e921d63e331c7987217b31973308ac', '[\"*\"]', NULL, '2026-04-14 07:00:41', '2026-04-14 07:00:41'),
(116, 'App\\Models\\User', 13, 'auth_token', '3b1ab86ce0a1e4684d3db149bd9006b260f6a009473f8269c11e91cfad99563e', '[\"*\"]', NULL, '2026-04-15 01:54:38', '2026-04-15 01:54:38'),
(117, 'App\\Models\\User', 13, 'auth_token', 'd2e56748b773bab7b23150398851b51f18ccd630d4ebeaecfdc56fd4b8ef27fe', '[\"*\"]', NULL, '2026-04-15 02:01:58', '2026-04-15 02:01:58'),
(118, 'App\\Models\\User', 13, 'auth_token', '6c86770bfe3ab636baf7feeb79bcaae60242eb4138e0d6a48bc74956553a76f8', '[\"*\"]', NULL, '2026-04-15 02:52:07', '2026-04-15 02:52:07'),
(119, 'App\\Models\\User', 13, 'auth_token', 'f26d1c82cb14a5e450c69aa8e58ee642c0e6655176d89a1ea8b18c6c06f10f68', '[\"*\"]', NULL, '2026-04-15 03:12:07', '2026-04-15 03:12:07'),
(120, 'App\\Models\\User', 13, 'auth_token', '45487115f987ef073584767d572b1143e6269ba3917fe5bc8f7a24eb263ac447', '[\"*\"]', '2026-04-15 03:38:32', '2026-04-15 03:19:34', '2026-04-15 03:38:32'),
(121, 'App\\Models\\User', 13, 'auth_token', '17d4c2d3a8f8a5378e8f2f2af34c87e9c643ed95057e4132ab1de8adb8b1180a', '[\"*\"]', '2026-04-15 04:24:43', '2026-04-15 03:41:05', '2026-04-15 04:24:43'),
(122, 'App\\Models\\User', 13, 'auth_token', '3e7bf2a2d3d21bb5e6a737a6c4e790bf1073a50ff1febc83cca9129b6c089c85', '[\"*\"]', NULL, '2026-04-15 05:06:57', '2026-04-15 05:06:57'),
(123, 'App\\Models\\User', 13, 'auth_token', '49935daa467296da81278b36bf5ffd80a8ffe428b97821b9cf60d5e795d6841f', '[\"*\"]', NULL, '2026-04-15 05:46:53', '2026-04-15 05:46:53'),
(124, 'App\\Models\\User', 13, 'auth_token', '40abe8782bdef9b2810b8b906fd24b5fc1abedcf62718624dad302403803979f', '[\"*\"]', NULL, '2026-04-15 05:48:04', '2026-04-15 05:48:04'),
(125, 'App\\Models\\User', 13, 'auth_token', 'ef901a864b61c59d384c0f2b17235d0ddbb62ad01e042e54b859283e6299788f', '[\"*\"]', NULL, '2026-04-15 05:55:26', '2026-04-15 05:55:26'),
(126, 'App\\Models\\User', 13, 'auth_token', '167f76dfd9edfb73d1af0764b819fd323e0a5963f04a7b567b3b23a4dd5ab821', '[\"*\"]', '2026-04-15 06:02:37', '2026-04-15 05:56:01', '2026-04-15 06:02:37'),
(127, 'App\\Models\\User', 13, 'auth_token', '05912071aea6daa239e82fc4ed41e450e381cdfd3c74b7e12db908571d6a2736', '[\"*\"]', NULL, '2026-04-15 06:05:02', '2026-04-15 06:05:02'),
(128, 'App\\Models\\User', 13, 'auth_token', '1a2f62f75c81be6f7c020258295b589528b5a5a0224f0e916cd74cd4522d98c1', '[\"*\"]', '2026-04-15 06:19:59', '2026-04-15 06:18:33', '2026-04-15 06:19:59'),
(129, 'App\\Models\\User', 13, 'auth_token', '4d2d739e298a65a11ebe1cb5290ecca5d30c72390899a62625918184d4a870fa', '[\"*\"]', '2026-04-17 08:05:00', '2026-04-17 04:19:31', '2026-04-17 08:05:00'),
(130, 'App\\Models\\User', 13, 'auth_token', 'e229efbff93a4a3ff3798e6e9d5a8911fd3e7aedd2105947ab5d426245ee232d', '[\"*\"]', NULL, '2026-04-17 08:28:37', '2026-04-17 08:28:37'),
(131, 'App\\Models\\User', 13, 'auth_token', 'e5edb2fe1509533104fd497e31a58851c1f7e6e90cac0375f79c120e3d556fd8', '[\"*\"]', NULL, '2026-04-20 05:07:53', '2026-04-20 05:07:53'),
(132, 'App\\Models\\User', 13, 'auth_token', 'a4ba327edff67fde6870723b5cf2da42176323e0c9f1c047fba8338b56dba758', '[\"*\"]', NULL, '2026-04-20 05:23:25', '2026-04-20 05:23:25'),
(133, 'App\\Models\\User', 13, 'auth_token', '5a7d6c66892bde77741233977e3b4b98207ce7dfe48270e5f09d99ca8ac4f263', '[\"*\"]', NULL, '2026-04-20 05:40:44', '2026-04-20 05:40:44'),
(134, 'App\\Models\\User', 13, 'auth_token', '6dc85c613b9d7891d60379b04c76aa096736e4efeaaa343ab48bc31e5436a191', '[\"*\"]', NULL, '2026-04-20 05:59:21', '2026-04-20 05:59:21'),
(135, 'App\\Models\\User', 13, 'auth_token', '1a59f476a78478bfdb54e3bfe6ee2f802660a3a3801e342a544b9638d0cb2be7', '[\"*\"]', NULL, '2026-04-20 06:02:10', '2026-04-20 06:02:10'),
(136, 'App\\Models\\User', 14, 'auth_token', '351d372eec9f63c8d9bf7daca83a0cd3e2977b335aa72a4fdff24b7e091cff8e', '[\"*\"]', NULL, '2026-04-20 06:09:37', '2026-04-20 06:09:37'),
(137, 'App\\Models\\User', 14, 'auth_token', '6b8014854ab5e3e1a1b761132ad0eb5fa844a606eb1ba3612c9bbc896c7233fa', '[\"*\"]', '2026-04-20 06:22:51', '2026-04-20 06:11:19', '2026-04-20 06:22:51'),
(138, 'App\\Models\\User', 14, 'auth_token', '880825079a3395ec89a3eefe04124072e366c84fb971eb84ca504a083830051a', '[\"*\"]', NULL, '2026-04-20 06:25:22', '2026-04-20 06:25:22'),
(139, 'App\\Models\\User', 13, 'auth_token', '188cfe85c9b88bd9edb876756643add76e9bf395f335ac6908211f5e05ba132a', '[\"*\"]', NULL, '2026-04-20 06:26:03', '2026-04-20 06:26:03'),
(140, 'App\\Models\\User', 13, 'auth_token', '7d26a2e61892c5c9635e18f022724920aa0b7dd65525e377dcdcf330f4783a42', '[\"*\"]', '2026-04-20 06:37:24', '2026-04-20 06:28:21', '2026-04-20 06:37:24'),
(141, 'App\\Models\\User', 14, 'auth_token', 'e7f47ce028d6f91d92332aace30a3600fc2feb937e08db4664aa154ed2d15027', '[\"*\"]', NULL, '2026-04-20 06:38:29', '2026-04-20 06:38:29'),
(142, 'App\\Models\\User', 14, 'auth_token', 'd67e0194adb63fa7e677f71b90e1a575ed5332c34c2f5cf432a283e877c85f4c', '[\"*\"]', '2026-04-20 06:44:30', '2026-04-20 06:41:01', '2026-04-20 06:44:30'),
(143, 'App\\Models\\User', 14, 'auth_token', 'bd8a379a1ba51765863dea020be408a14ce3931c0c2476ff79a11c778b239148', '[\"*\"]', NULL, '2026-04-20 06:46:19', '2026-04-20 06:46:19'),
(144, 'App\\Models\\User', 13, 'auth_token', '8a32faae0c7b394f3d7bb24ac8e1124ec38cc123c5427c226c077f619dae04c5', '[\"*\"]', '2026-04-20 06:47:37', '2026-04-20 06:46:33', '2026-04-20 06:47:37'),
(145, 'App\\Models\\User', 14, 'auth_token', '62f1b06756992e4dd94f285ee7a59384a0b243622fc464c81383996f1f1c4c5d', '[\"*\"]', NULL, '2026-04-20 06:49:16', '2026-04-20 06:49:16'),
(146, 'App\\Models\\User', 13, 'auth_token', 'ea28398ab916962fa77ca0a144042ad0f4a48a6fa350eef02c0170214a2b17b5', '[\"*\"]', '2026-04-20 06:59:08', '2026-04-20 06:49:51', '2026-04-20 06:59:08'),
(147, 'App\\Models\\User', 13, 'auth_token', '87fa9bb5f78b3ddb5e04da94f3fe86f56a79cf0363c47cf9c19acdbf636a722d', '[\"*\"]', '2026-04-20 07:00:19', '2026-04-20 06:59:30', '2026-04-20 07:00:19'),
(148, 'App\\Models\\User', 14, 'auth_token', '754e3c62fd2da5d3ff033884fc6f563d4ef7f958a544e3c83f0a63ac08432c2a', '[\"*\"]', NULL, '2026-04-20 07:01:33', '2026-04-20 07:01:33'),
(149, 'App\\Models\\User', 13, 'auth_token', '08525001ff17c5415338e60ea44741835b858d96a0a157d1076a783181c7a608', '[\"*\"]', '2026-04-20 07:04:57', '2026-04-20 07:02:10', '2026-04-20 07:04:57'),
(150, 'App\\Models\\User', 16, 'auth_token', 'ee69cf8be57b4e0974e9d019faa158abd4cd01d6bf721e065c126ebb38e2cd7b', '[\"*\"]', NULL, '2026-04-22 04:08:52', '2026-04-22 04:08:52'),
(151, 'App\\Models\\User', 17, 'auth_token', '6d417de7031fe46ec1f24019ba7bed93fb14622f23f3c69e7b486f69ec68f257', '[\"*\"]', '2026-04-22 04:28:45', '2026-04-22 04:10:57', '2026-04-22 04:28:45'),
(152, 'App\\Models\\User', 13, 'auth_token', 'd0939222c180fdae21b7a602c54c2da998ee65115444425b5ffca19b7edfce03', '[\"*\"]', NULL, '2026-04-22 05:33:32', '2026-04-22 05:33:32'),
(153, 'App\\Models\\User', 18, 'auth_token', '90737c038d415175e14df256742304b70be458a99dc9f864317e19bcc516a695', '[\"*\"]', NULL, '2026-04-22 05:57:26', '2026-04-22 05:57:26'),
(154, 'App\\Models\\User', 18, 'auth_token', 'ff4e61df6fc8406d56c731df260e6cb44da84f63c1ec0c51c34c0ccf3bf92a6b', '[\"*\"]', NULL, '2026-04-22 05:58:11', '2026-04-22 05:58:11'),
(155, 'App\\Models\\User', 13, 'auth_token', 'e0580bd59ca59ba824b86c68c9f25dc6d5b6278368c0e9a427309314d08e689c', '[\"*\"]', NULL, '2026-04-22 06:06:37', '2026-04-22 06:06:37'),
(156, 'App\\Models\\User', 18, 'auth_token', '706be16741da2574e56ab83c593f0f1eba6dda38962510bbf4d5fd1cf7ddac2e', '[\"*\"]', NULL, '2026-04-22 06:08:02', '2026-04-22 06:08:02'),
(157, 'App\\Models\\User', 18, 'auth_token', '10407453b3339dfe22d7ef8965da6bd6cd34d5f9694247c4090dc4ace72f6bc0', '[\"*\"]', NULL, '2026-04-22 06:08:29', '2026-04-22 06:08:29'),
(158, 'App\\Models\\User', 13, 'auth_token', '3bb2802a30bd3786c31a1b5d81a7ff86fee272e71d681e65c0c520c512476c7e', '[\"*\"]', NULL, '2026-04-22 06:14:20', '2026-04-22 06:14:20'),
(159, 'App\\Models\\User', 18, 'auth_token', 'f5fd8a3d0c02129878771e4c677205614232572db25f1bc65881cecb934faf6d', '[\"*\"]', '2026-04-22 06:23:01', '2026-04-22 06:15:29', '2026-04-22 06:23:01'),
(160, 'App\\Models\\User', 18, 'auth_token', '21b8053fc51598ed5fad3c9b90e3e986301ba177cee7d9ef881b056b7c398514', '[\"*\"]', '2026-04-22 06:24:01', '2026-04-22 06:23:54', '2026-04-22 06:24:01'),
(161, 'App\\Models\\User', 18, 'auth_token', '6d1b98007a3e1ac3fe446875b9c805a82be48f692058fc157079641368ef3d8e', '[\"*\"]', '2026-04-22 06:33:22', '2026-04-22 06:31:47', '2026-04-22 06:33:22'),
(162, 'App\\Models\\User', 18, 'auth_token', '108169c6e38909660291ee057f0f81256e970160d9caa5a46f3c3c50fe2203fa', '[\"*\"]', '2026-04-22 06:40:04', '2026-04-22 06:39:12', '2026-04-22 06:40:04'),
(163, 'App\\Models\\User', 18, 'auth_token', 'a528a25a6f6a2912c05e84bec665a6afe714b925168fbdae2ace6db8c992fa23', '[\"*\"]', '2026-04-22 06:46:31', '2026-04-22 06:43:43', '2026-04-22 06:46:31'),
(164, 'App\\Models\\User', 18, 'auth_token', '23e03d9a02ae97b0f040527d48bc2b5bcad93f4e757a05b399db14d5873a5532', '[\"*\"]', '2026-04-22 07:19:30', '2026-04-22 06:47:06', '2026-04-22 07:19:30'),
(165, 'App\\Models\\User', 18, 'auth_token', 'a110f6fea9a7e9b190f4f2b3d6ac72c2befa456c51364fa16d859a852314353f', '[\"*\"]', '2026-04-22 07:27:40', '2026-04-22 07:24:24', '2026-04-22 07:27:40'),
(166, 'App\\Models\\User', 18, 'auth_token', 'c127565606007dbe985c5c8d0da6e1b2db99dc43a0828e4f585c9e4a4a37b1b3', '[\"*\"]', '2026-04-22 07:38:49', '2026-04-22 07:28:18', '2026-04-22 07:38:49'),
(167, 'App\\Models\\User', 18, 'auth_token', '625dbed031a7863449145302780ea1308c6a329a7305c72d18eee09053eb4429', '[\"*\"]', NULL, '2026-04-22 08:29:42', '2026-04-22 08:29:42'),
(168, 'App\\Models\\User', 18, 'auth_token', '86bd44b2d13c0ee79bc35ea8b5c194f9c0a6e85472fb711289d8c3d0f9b17a7b', '[\"*\"]', NULL, '2026-04-27 04:45:10', '2026-04-27 04:45:10'),
(169, 'App\\Models\\User', 18, 'auth_token', '095db33d1edb16c8a9404e0db3999fba40483413de72cac354e6d7621463b58b', '[\"*\"]', NULL, '2026-04-27 04:48:17', '2026-04-27 04:48:17'),
(170, 'App\\Models\\User', 18, 'auth_token', '46abf84947331d32fd594c2867094df63f9b388bb63b49d8f90621417a101f1c', '[\"*\"]', NULL, '2026-04-27 04:55:12', '2026-04-27 04:55:12'),
(171, 'App\\Models\\User', 18, 'auth_token', '7f041e1a83e4d8e76e72d4b09d9eb15823694d877361e11a43ab920cef586770', '[\"*\"]', NULL, '2026-04-27 04:58:04', '2026-04-27 04:58:04'),
(172, 'App\\Models\\User', 18, 'auth_token', '9f2ac301a26886c950dfeb5351b5b3358976b24ca77feab7b3f8fb6dc72d95bc', '[\"*\"]', NULL, '2026-04-27 05:02:37', '2026-04-27 05:02:37'),
(173, 'App\\Models\\User', 18, 'auth_token', '4acb93b59090fc94aff7fa1ab2d9d5e167318e99cf029db35f9ea9688231751c', '[\"*\"]', NULL, '2026-04-27 06:53:19', '2026-04-27 06:53:19'),
(174, 'App\\Models\\User', 18, 'auth_token', '6cde011f33ff05df305002b2e01529179701bed0b4a60317c72cb753a8baeeeb', '[\"*\"]', NULL, '2026-04-27 07:13:53', '2026-04-27 07:13:53'),
(175, 'App\\Models\\User', 18, 'auth_token', 'f3483947b9b120b212050bfd1ac05bdd40c924dd32a638b5c6de4b6b37854ba3', '[\"*\"]', NULL, '2026-04-29 03:00:15', '2026-04-29 03:00:15'),
(176, 'App\\Models\\User', 18, 'auth_token', 'd89682a58903d6f6686f4dee5af464a4b58c071bd1c3aae3e6a6ffa7543023a3', '[\"*\"]', '2026-04-29 03:32:06', '2026-04-29 03:02:39', '2026-04-29 03:32:06'),
(177, 'App\\Models\\User', 18, 'auth_token', '06a7085a37366c050e4b6d9de1f9d46019d2141aa081ad0aed976e811112675a', '[\"*\"]', NULL, '2026-04-29 04:35:09', '2026-04-29 04:35:09'),
(178, 'App\\Models\\User', 18, 'auth_token', 'c13c61efce50f011eb2419f4ec2968a2f5bea8e376ba0ea4c3e6828afeda04f0', '[\"*\"]', NULL, '2026-04-29 04:45:47', '2026-04-29 04:45:47'),
(179, 'App\\Models\\User', 18, 'auth_token', '33999981ed8c2ca278374d3df3c78a251dd205ea98fb3a7a05f455ae67ed36bc', '[\"*\"]', NULL, '2026-04-29 04:55:20', '2026-04-29 04:55:20'),
(180, 'App\\Models\\User', 18, 'auth_token', 'e885ba458b90a603495d3a8b9ac54d7365d5ce351f0750f5a80d9dcdca27ff50', '[\"*\"]', NULL, '2026-04-29 04:57:22', '2026-04-29 04:57:22'),
(181, 'App\\Models\\User', 18, 'auth_token', '96551cd384e7a0c5320e5b6731eaa38dd92f8e67b308a985bd1a04565d13ec43', '[\"*\"]', NULL, '2026-04-29 05:01:31', '2026-04-29 05:01:31'),
(182, 'App\\Models\\User', 18, 'auth_token', '167db8cd8981b7be4d03c66a1f2f8aabd34fd0dc99f8964a63b21dd939b6da64', '[\"*\"]', '2026-04-29 05:03:18', '2026-04-29 05:01:57', '2026-04-29 05:03:18'),
(183, 'App\\Models\\User', 18, 'auth_token', '8346704108d0dc768f865c753bac5feb706e7b41b1c4f51e5db04382bb2ed1b4', '[\"*\"]', NULL, '2026-04-29 05:15:39', '2026-04-29 05:15:39'),
(184, 'App\\Models\\User', 18, 'auth_token', '65061930ff6388a66f87adf7875bf54caaabf334b5f84a46011037abcbcc825d', '[\"*\"]', NULL, '2026-04-29 05:16:28', '2026-04-29 05:16:28'),
(185, 'App\\Models\\User', 18, 'auth_token', '4986856fb1549bafc79ba8fcc7141be0f14368c9f7ec4ee137e66d7352c85953', '[\"*\"]', NULL, '2026-04-29 05:20:10', '2026-04-29 05:20:10'),
(186, 'App\\Models\\User', 18, 'auth_token', '6c1229e6d65fb1e6db17cf9e00f4137ff3ac09b04042591ddfca21ba406085b7', '[\"*\"]', NULL, '2026-04-29 05:42:05', '2026-04-29 05:42:05'),
(187, 'App\\Models\\User', 18, 'auth_token', 'd5383b58139c9b8996eb51f24d0d3d934b7ef6f72034a8e7265730ffd6edc3e7', '[\"*\"]', NULL, '2026-04-29 06:10:47', '2026-04-29 06:10:47'),
(188, 'App\\Models\\User', 18, 'auth_token', 'fed87e001da9dda107e174ec14869bb59c35025c6b81e258fff5b0af9e67270b', '[\"*\"]', NULL, '2026-04-29 07:19:29', '2026-04-29 07:19:29'),
(189, 'App\\Models\\User', 18, 'auth_token', 'd601ccefbb22924c86d7e156b8a1273d00b9f1169be7b44b7c3cd8c9e910e51c', '[\"*\"]', NULL, '2026-04-29 07:25:48', '2026-04-29 07:25:48'),
(190, 'App\\Models\\User', 18, 'auth_token', 'd647794ba1e53be2ba740223bbd7d4f75da92049a5607870affbb604ca0cc2e8', '[\"*\"]', NULL, '2026-05-01 09:12:30', '2026-05-01 09:12:30'),
(191, 'App\\Models\\User', 18, 'auth_token', '39f43d0f50e44c059dd056efa7ba3f0ad6cabcb86a12d7d8529a6d21b032dc55', '[\"*\"]', NULL, '2026-05-04 02:18:25', '2026-05-04 02:18:25'),
(192, 'App\\Models\\User', 18, 'auth_token', '15d790f74c99041e97bfb7db390ad627f5022eeddfefb076ac21ed1cb4176ca8', '[\"*\"]', NULL, '2026-05-04 02:40:41', '2026-05-04 02:40:41'),
(193, 'App\\Models\\User', 18, 'auth_token', '3b5207313de966a732f089e5544063f19b0d30439c38221b7dad7edebcffd294', '[\"*\"]', NULL, '2026-05-04 03:30:36', '2026-05-04 03:30:36'),
(194, 'App\\Models\\User', 18, 'auth_token', '99ab61cce0762f322c59ea804b3951f9fc09c75d90b0e7be0adfd160e7d8170b', '[\"*\"]', NULL, '2026-05-04 04:25:58', '2026-05-04 04:25:58'),
(195, 'App\\Models\\User', 18, 'auth_token', 'd493a82a8209089a6390f81a70809e8a675bf3e13b543e6e79c1d79219834908', '[\"*\"]', NULL, '2026-05-04 04:36:49', '2026-05-04 04:36:49'),
(196, 'App\\Models\\User', 18, 'auth_token', 'df6049e70510aa708c6dfc042aa049d1602144be62344ec428a9281bb81cd07f', '[\"*\"]', NULL, '2026-05-04 05:06:21', '2026-05-04 05:06:21'),
(197, 'App\\Models\\User', 18, 'auth_token', '8b465cf45131e8b0d2564735b387edfb3696fe25149ac53048f6ab5af503c036', '[\"*\"]', NULL, '2026-05-04 06:10:11', '2026-05-04 06:10:11'),
(198, 'App\\Models\\User', 18, 'auth_token', '82fa91a048e82159df1832c6939c7b1c0e739b5ce13e09a76a8a7af21c514462', '[\"*\"]', NULL, '2026-05-04 06:17:57', '2026-05-04 06:17:57'),
(199, 'App\\Models\\User', 18, 'auth_token', 'd129498a5686700f3fa55cc5f40ba3aae6c75f59ba10fa43defd297cf5b9b827', '[\"*\"]', NULL, '2026-05-04 06:39:04', '2026-05-04 06:39:04'),
(200, 'App\\Models\\User', 18, 'auth_token', 'a1f7fcbd87958005a7851a63dc6d5659e505392ecab17f223da68ec4541b0a1c', '[\"*\"]', NULL, '2026-05-04 06:48:31', '2026-05-04 06:48:31'),
(201, 'App\\Models\\User', 18, 'auth_token', 'c3b27211744012cdd27a97d299a3c4bf9863bb1eeeedbc78e68a9b17237a7888', '[\"*\"]', NULL, '2026-05-04 06:55:58', '2026-05-04 06:55:58'),
(202, 'App\\Models\\User', 18, 'auth_token', 'd59e515ac60a119f0e57a068ead2fd3f5aec9dee703183cf84e12760b139e33c', '[\"*\"]', NULL, '2026-05-04 06:59:23', '2026-05-04 06:59:23'),
(203, 'App\\Models\\User', 18, 'auth_token', 'a7e2418fa29c5296b2d9245f1c6070e6dcc2d4d2f1f1cbcd316074a5c6a6a670', '[\"*\"]', NULL, '2026-05-04 07:09:32', '2026-05-04 07:09:32'),
(204, 'App\\Models\\User', 18, 'auth_token', '1b574f61c68f3991e61c589c5d8e875b1ef234260974e2671f03ef2b297379a6', '[\"*\"]', '2026-05-05 03:13:48', '2026-05-05 02:08:16', '2026-05-05 03:13:48'),
(205, 'App\\Models\\User', 18, 'auth_token', '0b95fca1e84783207dc6f481ccc2fe40480ec6a696f1349f7ad2bc449a1079bf', '[\"*\"]', '2026-05-05 09:40:15', '2026-05-05 04:15:09', '2026-05-05 09:40:15'),
(206, 'App\\Models\\User', 18, 'auth_token', '277946a3dc64566406accc20a95461f6e4e9f8324a1700611b9706fed80c2972', '[\"*\"]', NULL, '2026-05-05 09:50:22', '2026-05-05 09:50:22'),
(207, 'App\\Models\\User', 18, 'auth_token', '586cd21b93de1b83e53e38721db2f54380ef823201e22be868383b22cadae439', '[\"*\"]', '2026-05-05 10:11:45', '2026-05-05 09:57:15', '2026-05-05 10:11:45'),
(208, 'App\\Models\\User', 18, 'auth_token', 'c41fa4555fc5009c13573f64db1f7a3e490939c3aa61c50325eaccda1fa5d36c', '[\"*\"]', NULL, '2026-05-05 10:51:26', '2026-05-05 10:51:26'),
(209, 'App\\Models\\User', 18, 'auth_token', 'b403905a85b728e2b7ae2f50e1227e3c83ef1693f43f2bd68196155383452932', '[\"*\"]', '2026-05-05 11:10:38', '2026-05-05 11:05:13', '2026-05-05 11:10:38'),
(210, 'App\\Models\\User', 18, 'auth_token', '7a5947d6d669ac1e890a841a8e14fc4bc4628fc8a7ff63c7f27bf69224b44f2d', '[\"*\"]', NULL, '2026-05-05 11:14:44', '2026-05-05 11:14:44'),
(211, 'App\\Models\\User', 18, 'auth_token', 'e83062fd729934659b4c47b6ea5f50869f45e552ddb40d7ef0fe32468eb3a242', '[\"*\"]', NULL, '2026-05-05 11:38:52', '2026-05-05 11:38:52'),
(212, 'App\\Models\\User', 18, 'auth_token', 'f16068f21d1c1f10a027c99abf55a3cf5c137d94c3914b95a8790cfcb6640549', '[\"*\"]', NULL, '2026-05-06 02:11:25', '2026-05-06 02:11:25'),
(213, 'App\\Models\\User', 18, 'auth_token', '157817b4f5df72941a14505feaa940c4c1864dd297c79e87e6cb07abb56ef726', '[\"*\"]', NULL, '2026-05-06 02:14:50', '2026-05-06 02:14:50'),
(214, 'user', 18, 'auth_token', 'e60ea387886afbe581abf42dbf21dbdd9681e782c43f8bc895239878e5f798e2', '[\"*\"]', NULL, '2026-05-06 03:45:47', '2026-05-06 03:45:47'),
(215, 'user', 18, 'auth_token', 'fe942565f321bbbc087c4b623926786dcd4a965fe29209d7df3511510c82f3e7', '[\"*\"]', NULL, '2026-05-06 03:46:03', '2026-05-06 03:46:03'),
(216, 'user', 18, 'auth_token', '39d5547053d068dcfc408a3a49614ad07257e82e16dd608ec0ff4b7cf57cfcd3', '[\"*\"]', NULL, '2026-05-06 06:01:29', '2026-05-06 06:01:29'),
(217, 'user', 18, 'auth_token', '0ff78307b2b21da94a74f8a56ac0885b410f9089dcde718b5ee9758c72a3194a', '[\"*\"]', '2026-06-05 03:47:10', '2026-05-06 06:05:47', '2026-06-05 03:47:10'),
(218, 'user', 18, 'auth_token', 'a8516c59c992033a70235cf899990e66efebd0651b05f84388c341e84cbb3612', '[\"*\"]', NULL, '2026-05-07 01:51:11', '2026-05-07 01:51:11'),
(219, 'user', 18, 'auth_token', 'aa43a950126c1701c8f9d893ff455dd1745c285a85a18e66f9abb502ccc348cf', '[\"*\"]', '2026-05-07 02:37:41', '2026-05-07 01:52:18', '2026-05-07 02:37:41'),
(220, 'user', 18, 'auth_token', '1fd7181c51834386fb24e312841da4b9703e510b37fdd6cc86c3b661d758fd1b', '[\"*\"]', '2026-06-02 06:13:20', '2026-05-07 02:35:22', '2026-06-02 06:13:20'),
(221, 'user', 18, 'auth_token', 'ff7c6ad504daac1d13dafa6265e6c84350c2e990367494ecd8231c162e035f0c', '[\"*\"]', '2026-05-07 02:38:01', '2026-05-07 02:37:50', '2026-05-07 02:38:01'),
(222, 'user', 18, 'auth_token', '765bf6d2e65faf6e6448da5c291ba9395bc98edca5293541b0a47f39c7334a1d', '[\"*\"]', '2026-05-07 03:19:20', '2026-05-07 02:38:23', '2026-05-07 03:19:20'),
(223, 'user', 18, 'auth_token', '3f16400b4cc731b8c4c5ea45576719879250433605edce6ac40bbf6c0ed015d9', '[\"*\"]', '2026-05-07 03:26:07', '2026-05-07 03:20:07', '2026-05-07 03:26:07'),
(224, 'user', 18, 'auth_token', '2414242bc0987a146b44649ed736680731fc2ef194b622ff55e815f5102de871', '[\"*\"]', '2026-05-07 03:28:04', '2026-05-07 03:26:30', '2026-05-07 03:28:04'),
(225, 'user', 18, 'auth_token', '7903dd21075fe7b76c417333779c1a2e1642a23ad91c7ea4dc901c233568a846', '[\"*\"]', '2026-05-07 03:31:16', '2026-05-07 03:28:22', '2026-05-07 03:31:16'),
(226, 'user', 18, 'auth_token', 'a22df3d6ae644e93762555f29516316a77164e062d03f328db9904dc028e2302', '[\"*\"]', '2026-05-07 03:37:09', '2026-05-07 03:31:46', '2026-05-07 03:37:09'),
(227, 'user', 18, 'auth_token', 'bbc253a86d201521509fef785b1630e3675377ebeb8d490acc38d0009e68daff', '[\"*\"]', '2026-05-07 03:40:24', '2026-05-07 03:37:35', '2026-05-07 03:40:24'),
(228, 'user', 18, 'auth_token', 'adfa39b96aefbb40b754b2ec0a6bd0d4b2fb6203337276847e39ed6723fb1608', '[\"*\"]', '2026-05-07 03:51:40', '2026-05-07 03:41:48', '2026-05-07 03:51:40'),
(229, 'user', 18, 'auth_token', '62136e933fcc5a621d460f2aa0d2cd68a5f079406e2add85286905ea3af0b367', '[\"*\"]', '2026-05-07 04:08:49', '2026-05-07 04:00:01', '2026-05-07 04:08:49'),
(230, 'user', 18, 'auth_token', '7146d32c8b2344591d26f4eef9397c4390bed84dbffd16c97a2b15842dc6ae80', '[\"*\"]', '2026-05-07 05:14:50', '2026-05-07 04:09:13', '2026-05-07 05:14:50'),
(231, 'user', 18, 'auth_token', '6fcfd655d2081c9fc05a8b5ce83ae0bfe7570047e52f03391b6a68c7d6e842ff', '[\"*\"]', '2026-05-07 05:29:00', '2026-05-07 05:17:31', '2026-05-07 05:29:00'),
(232, 'user', 18, 'auth_token', '17615a61ebf79840c9313a5b86547b0f01a7104d4b9a5fb91deef834c20aa7e7', '[\"*\"]', '2026-05-07 05:34:51', '2026-05-07 05:32:57', '2026-05-07 05:34:51'),
(233, 'user', 18, 'auth_token', '57b51e4dffbd416d893062b3844ffafe0ebf57a55468c1e9c1a15abce97816de', '[\"*\"]', '2026-05-07 05:42:16', '2026-05-07 05:36:28', '2026-05-07 05:42:16'),
(234, 'user', 18, 'auth_token', 'da800aeb9d62150c76d2f030dfd00bf653b3234e1546b859d6813827fa5fed6d', '[\"*\"]', '2026-05-07 05:42:37', '2026-05-07 05:42:35', '2026-05-07 05:42:37'),
(235, 'user', 18, 'auth_token', 'c8d999203eb9d795ff0c203c5146260dc16784a7f68cfe521b52a05dd08858f1', '[\"*\"]', '2026-05-07 06:19:49', '2026-05-07 05:43:57', '2026-05-07 06:19:49'),
(236, 'user', 18, 'auth_token', '237aacbf37063f38e5b4cdb083801cce4ceab4f82c7e3b4b7f30902e7b76699b', '[\"*\"]', '2026-05-07 06:54:13', '2026-05-07 06:35:00', '2026-05-07 06:54:13'),
(237, 'user', 18, 'auth_token', 'c89b71dc07054f0fc69b61165a9686169af93700352fe1d1458d47699d96d631', '[\"*\"]', '2026-05-07 07:00:10', '2026-05-07 06:55:01', '2026-05-07 07:00:10'),
(238, 'user', 18, 'auth_token', 'b65dce211e64e6bbf3244dc8fca2eedf52576231df152561b90bcba9cba02f93', '[\"*\"]', '2026-05-07 07:07:56', '2026-05-07 07:01:11', '2026-05-07 07:07:56'),
(239, 'user', 18, 'auth_token', '09889a127c33ced295dfe020cf8df366886674e47b136c10900b784bd3718483', '[\"*\"]', '2026-05-07 07:19:57', '2026-05-07 07:18:14', '2026-05-07 07:19:57'),
(240, 'user', 18, 'auth_token', '0f3c97140d187105abfc06d99f7e6b3589bff94998e4adc51a002de0c622b784', '[\"*\"]', '2026-05-07 07:26:16', '2026-05-07 07:23:29', '2026-05-07 07:26:16'),
(241, 'user', 18, 'auth_token', '78e37ae22966f0c9d235b28bab07dc6d8b7bb4799a22e08a9d969a3ab621f4ff', '[\"*\"]', '2026-05-07 07:37:34', '2026-05-07 07:29:00', '2026-05-07 07:37:34'),
(242, 'user', 18, 'auth_token', '285cb8625444d041c9afbb6388a6873322102403aae19db44b626d02b5ab762a', '[\"*\"]', '2026-05-07 07:52:17', '2026-05-07 07:40:51', '2026-05-07 07:52:17'),
(243, 'user', 18, 'auth_token', 'c97d0e89a3e3baded0407d328e100fc8d11e6d8779e272d984493d39bdc340bd', '[\"*\"]', '2026-05-07 08:29:40', '2026-05-07 07:53:13', '2026-05-07 08:29:40'),
(244, 'user', 18, 'auth_token', 'b3c1bdd6fa7d082ab89ab176e1809b81f65a052f7f362bf3247dc4cfb35ca065', '[\"*\"]', '2026-05-07 09:45:00', '2026-05-07 08:30:07', '2026-05-07 09:45:00'),
(245, 'user', 18, 'auth_token', 'ac1f37c065427a029bcefff2478369a0cc795e53c1a26ff7685e33c11deba682', '[\"*\"]', '2026-05-07 10:10:30', '2026-05-07 09:45:22', '2026-05-07 10:10:30'),
(246, 'user', 18, 'auth_token', 'f8dd1b9c667419a5266143ff8a9ed9bc2d60aa5673e663739b71cae2a7c2b999', '[\"*\"]', '2026-05-07 10:36:47', '2026-05-07 10:17:01', '2026-05-07 10:36:47'),
(247, 'user', 18, 'auth_token', '4c5f70802430bbddde7c0e2c491d4d52024ff1fa2ce75cf73d6e99470b3b09b8', '[\"*\"]', '2026-05-08 01:44:58', '2026-05-08 00:28:29', '2026-05-08 01:44:58'),
(248, 'user', 18, 'auth_token', 'c53be2dca1cf26493399caaa3b834cdf41690ba4dbecc541afec30e0e868211b', '[\"*\"]', '2026-05-08 02:51:10', '2026-05-08 01:46:39', '2026-05-08 02:51:10'),
(249, 'user', 18, 'auth_token', 'fd37af4cc918c1f7825eb3165a847fc8527dc7a39abf3b66c54200cacb1ce9be', '[\"*\"]', '2026-05-08 05:57:31', '2026-05-08 02:51:52', '2026-05-08 05:57:31'),
(250, 'user', 18, 'auth_token', '988f27ddd80573cdb3266231723bed89d76838576efbfa0d9b45171155d63320', '[\"*\"]', '2026-05-08 06:49:18', '2026-05-08 06:21:40', '2026-05-08 06:49:18'),
(251, 'user', 18, 'auth_token', '5daead332aa49f223db318e3c40a67112f8977d08f9f5752064db7c9f68445db', '[\"*\"]', '2026-05-22 08:52:20', '2026-05-08 06:48:21', '2026-05-22 08:52:20'),
(252, 'user', 18, 'auth_token', 'd0f47302d3e3fcb8b9006ba5853322777046b683d977aa29bb5a229798d77c3e', '[\"*\"]', '2026-05-08 06:57:31', '2026-05-08 06:49:28', '2026-05-08 06:57:31'),
(253, 'user', 18, 'auth_token', '3d8e256040b94b4d6091537fefe74f771e08ea6a37d597b1c18534b0b5908d86', '[\"*\"]', '2026-05-08 06:54:32', '2026-05-08 06:53:00', '2026-05-08 06:54:32'),
(254, 'user', 18, 'auth_token', 'e85db93abc05442a5ecc009804e91d8e182a9933030f897632d74760d4cbb67d', '[\"*\"]', '2026-05-08 08:42:20', '2026-05-08 06:57:47', '2026-05-08 08:42:20'),
(255, 'user', 18, 'auth_token', '1974d85c282c9fcaabf151b38a02cfa928674de03767219d6ad0df74799e1c85', '[\"*\"]', '2026-05-08 09:46:19', '2026-05-08 08:58:30', '2026-05-08 09:46:19'),
(256, 'user', 18, 'auth_token', '0cb70888b717cf648123d9a33fc0d78f34ad65211641d2fe005904606e38af77', '[\"*\"]', '2026-05-11 06:39:33', '2026-05-11 04:08:30', '2026-05-11 06:39:33'),
(257, 'user', 18, 'auth_token', 'e3164c0de550f32f84a30d1ed7ceb916099d03f5c067e9d8cf63d303d5c5aa3f', '[\"*\"]', '2026-05-11 09:42:11', '2026-05-11 09:40:45', '2026-05-11 09:42:11'),
(258, 'user', 18, 'auth_token', '3522d8f447c0384b9c95c2b0ecd2882b641acd43f30a0609f2f27f78cd13c62a', '[\"*\"]', '2026-05-11 10:13:15', '2026-05-11 09:59:49', '2026-05-11 10:13:15'),
(259, 'user', 18, 'auth_token', '81f902ca381ca4dda4a42ce6d96754c7466fcc90dfcc7ae747df8ffa276243c4', '[\"*\"]', '2026-05-11 11:41:45', '2026-05-11 11:41:23', '2026-05-11 11:41:45'),
(260, 'user', 18, 'auth_token', '2b73baefb245a7c3281b94c7fe8662604fc68d353bb86039ae1ce6d3c00ee6f1', '[\"*\"]', '2026-05-11 12:07:48', '2026-05-11 11:43:27', '2026-05-11 12:07:48'),
(261, 'user', 18, 'auth_token', 'daa308395c8fca3cf5f710e8518855190e78ee06c9b0a34535cc3be807512154', '[\"*\"]', '2026-05-11 13:12:12', '2026-05-11 12:11:33', '2026-05-11 13:12:12'),
(262, 'user', 18, 'auth_token', 'd57d8114e58c83a84764f5c16203fc89544aeea6fd75e5bc9133c431a6daaf58', '[\"*\"]', '2026-05-18 06:46:54', '2026-05-18 05:26:39', '2026-05-18 06:46:54'),
(263, 'user', 18, 'auth_token', '7ddec77f413da8e7c622b5d045f36ecccbc1b6a86b232310e5410fad4ddee30f', '[\"*\"]', '2026-05-18 06:47:28', '2026-05-18 06:47:23', '2026-05-18 06:47:28'),
(264, 'user', 18, 'auth_token', 'ccbc7e4fc990e0c502dfcb64ceee60d7094001ff8a2ae1ace89a595ae9d3661a', '[\"*\"]', '2026-05-18 06:59:33', '2026-05-18 06:51:06', '2026-05-18 06:59:33'),
(265, 'user', 18, 'auth_token', '570e5ecfd953e0dd795f377dc08d6f2db94973947d594b63d87d044f8b7b4acf', '[\"*\"]', '2026-05-18 11:39:28', '2026-05-18 10:04:42', '2026-05-18 11:39:28'),
(266, 'user', 18, 'auth_token', 'cea63c96cb961d56411fe34ff3cf17e8c946db42a9d6cfb78dda898d10d27ba7', '[\"*\"]', '2026-05-18 11:54:03', '2026-05-18 11:43:20', '2026-05-18 11:54:03'),
(267, 'user', 18, 'auth_token', '8808bff9a5add39e0c02d9ca35ca4b393e525b50f1dae14349531f8168c52420', '[\"*\"]', '2026-05-18 12:02:40', '2026-05-18 11:54:40', '2026-05-18 12:02:40'),
(268, 'user', 18, 'auth_token', '6e50bf807a788272fc07023ed32eb3202b57d9ada92e146f09596f67d5dab7fa', '[\"*\"]', '2026-05-18 12:09:53', '2026-05-18 12:04:44', '2026-05-18 12:09:53'),
(269, 'user', 18, 'auth_token', '4f5a72b6472ac10a98d24ed03cb70647f2a8ac66d2e2152814ef748b6001ee83', '[\"*\"]', '2026-05-18 12:35:46', '2026-05-18 12:22:55', '2026-05-18 12:35:46'),
(270, 'user', 18, 'auth_token', '4602616af0811442c688b600ec401a6513de195a83881cf3a8185342c66a00f7', '[\"*\"]', '2026-05-18 13:17:40', '2026-05-18 12:37:10', '2026-05-18 13:17:40'),
(271, 'user', 18, 'auth_token', '72ced951fe68d511f2314d078e3817e62944e6788e403873539b0f95a8e22917', '[\"*\"]', '2026-05-18 13:25:52', '2026-05-18 13:18:46', '2026-05-18 13:25:52'),
(272, 'user', 18, 'auth_token', '9b04e0775bbd8d2605c42363fbd46f727bb583c0420a50deacdd29dc33e91f98', '[\"*\"]', '2026-05-18 13:26:34', '2026-05-18 13:26:16', '2026-05-18 13:26:34'),
(273, 'user', 18, 'auth_token', '0b2be6f6e1157be3b42e6919b016e6b5fb3ba442637a5e9fe8c49b047473ffd8', '[\"*\"]', '2026-05-20 09:27:48', '2026-05-20 09:27:46', '2026-05-20 09:27:48'),
(274, 'user', 18, 'auth_token', '7c7da6bee015dda149ea8729f72c81d1dc84713548860e16bfd01b41f4cbbff1', '[\"*\"]', '2026-05-20 11:08:42', '2026-05-20 10:57:34', '2026-05-20 11:08:42'),
(275, 'user', 18, 'auth_token', '61cbcb1072f4c982082b09c720d98141c02197f95c419fd4f22ae020aac39d9b', '[\"*\"]', '2026-05-20 11:25:34', '2026-05-20 11:09:03', '2026-05-20 11:25:34'),
(276, 'user', 18, 'auth_token', '35886bbcdfa375ac345e0b5db8f3e1f25a786f64f9c4c6029c40c8d362ec6f48', '[\"*\"]', '2026-05-20 11:42:23', '2026-05-20 11:26:03', '2026-05-20 11:42:23'),
(277, 'user', 18, 'auth_token', '5f67eb95268373595ff19cad1095d878bd6d771effac84e46c3423655a2fb747', '[\"*\"]', '2026-05-20 12:31:13', '2026-05-20 11:42:44', '2026-05-20 12:31:13'),
(278, 'user', 18, 'auth_token', '2d69c7bc06ffd3b825e4bf7ed9fad550d543c9c57c955f651924e67797b27625', '[\"*\"]', '2026-05-20 13:02:17', '2026-05-20 12:36:38', '2026-05-20 13:02:17'),
(279, 'user', 18, 'auth_token', '980a8dfa1d94bdf5d373318b963bdd215aa9b8e13e4d8e45987ed044d6d99a20', '[\"*\"]', '2026-05-20 13:02:57', '2026-05-20 13:02:47', '2026-05-20 13:02:57'),
(280, 'user', 18, 'auth_token', '1b0e05ccebb8509baea619317c50b555ad6fce71138fc4caa96133e43ea414a7', '[\"*\"]', NULL, '2026-05-21 04:42:23', '2026-05-21 04:42:23');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(281, 'user', 18, 'auth_token', 'f1a4f2d6f431fab0043a0452708bf3b3dbf80c8f845b26f97fa70e4ccaebdb81', '[\"*\"]', '2026-05-22 03:58:52', '2026-05-22 03:58:29', '2026-05-22 03:58:52'),
(282, 'user', 18, 'auth_token', '0b2dc1bf60493203e1bfc4a06ec7b94e2f82eadc2f8d42cb71fd35b86b49f41e', '[\"*\"]', '2026-05-22 03:59:49', '2026-05-22 03:59:35', '2026-05-22 03:59:49'),
(283, 'user', 18, 'auth_token', '72dd78826c538516ff067fd1d6f641cc4ed8db49acc2ee9275ec9f3429dc158d', '[\"*\"]', '2026-05-22 04:01:02', '2026-05-22 04:00:18', '2026-05-22 04:01:02'),
(284, 'user', 18, 'auth_token', '9234f07ef4c827a27ebf18701b48bc67c4296196d571a0a66fac835fb19ae352', '[\"*\"]', '2026-05-22 04:37:35', '2026-05-22 04:04:11', '2026-05-22 04:37:35'),
(285, 'user', 18, 'auth_token', 'e794c370b8913765db8ebc388b4fe96bdd982b64383c00c5ed5083616a61ac70', '[\"*\"]', '2026-05-22 05:19:35', '2026-05-22 04:49:59', '2026-05-22 05:19:35'),
(286, 'user', 14, 'auth_token', '3986acf928abf1761abcb4489ee7aca4d9d80411e3a6d1750ae6d5122e961cd8', '[\"*\"]', '2026-05-22 06:02:07', '2026-05-22 05:33:10', '2026-05-22 06:02:07'),
(287, 'user', 18, 'auth_token', '72661c0cde394c1230d3f830184ad56217bfa4aa7d624db0aba888e225081408', '[\"*\"]', '2026-05-22 05:56:59', '2026-05-22 05:36:19', '2026-05-22 05:56:59'),
(288, 'user', 18, 'auth_token', '746a63e6bf48edb9d3e6defe9059036ece06f178c244fab0b03fc9f36816e1ab', '[\"*\"]', '2026-05-22 07:23:41', '2026-05-22 06:00:17', '2026-05-22 07:23:41'),
(289, 'user', 18, 'auth_token', '02b9f3c0906d3283d51ecacad660767f8dca896b78c2c26a136d5143728d0711', '[\"*\"]', '2026-05-22 08:02:20', '2026-05-22 07:25:00', '2026-05-22 08:02:20'),
(290, 'user', 18, 'auth_token', '976c763f00f4dec0ec37cd5632183d9e76213aea35f15d1e23d0cc680aa5fb87', '[\"*\"]', '2026-05-22 09:06:09', '2026-05-22 08:02:42', '2026-05-22 09:06:09'),
(291, 'user', 18, 'auth_token', '32393b8ffabf631214f5c82406b637677a8a47040d483a275533f126054092c1', '[\"*\"]', '2026-05-22 09:19:04', '2026-05-22 09:08:13', '2026-05-22 09:19:04'),
(292, 'user', 18, 'auth_token', '995dc50ab169880bba738c20a5d971f829cd84c74930ef22d6522dc82a7d2cc1', '[\"*\"]', '2026-05-22 09:21:24', '2026-05-22 09:19:33', '2026-05-22 09:21:24'),
(293, 'user', 18, 'auth_token', '2533c9a479a857a4b549fa84d080d3897664bb9640d4dde17528c9c6296d0717', '[\"*\"]', '2026-05-22 09:23:49', '2026-05-22 09:22:30', '2026-05-22 09:23:49'),
(294, 'user', 18, 'auth_token', '0aca70d71bb477166e1bd1bb617645571fdd3a58f649a2e9d9f23847bbaf6d2e', '[\"*\"]', '2026-05-22 09:26:39', '2026-05-22 09:25:53', '2026-05-22 09:26:39'),
(295, 'user', 18, 'auth_token', 'eef36cf40711cadfc52e42e0966567b203eb216e1962c7a94db4d9ca6a982af7', '[\"*\"]', '2026-05-22 09:35:19', '2026-05-22 09:28:08', '2026-05-22 09:35:19'),
(296, 'user', 18, 'auth_token', '14851eab173e55b38e5c07bde7da038602ac9bb7cd72bfe62ce86376235feb50', '[\"*\"]', '2026-05-22 09:45:55', '2026-05-22 09:35:46', '2026-05-22 09:45:55'),
(297, 'user', 18, 'auth_token', '49e73af5639f7c5a56130f46aaa4f2a4570b8d392271d9c3ee92525642e4e7fa', '[\"*\"]', '2026-05-22 10:01:35', '2026-05-22 09:46:21', '2026-05-22 10:01:35'),
(298, 'user', 18, 'auth_token', '20a9ab58c73a60a156540f818baac18fb9a9e3f11dc220432e7e2ffd99c97ac3', '[\"*\"]', '2026-05-22 10:03:45', '2026-05-22 10:01:58', '2026-05-22 10:03:45'),
(299, 'user', 18, 'auth_token', 'c7b4fcf28e739eb6bb740cb4b957f08fc3cb366d7e22f36b3f41af96078d042a', '[\"*\"]', '2026-05-23 15:06:34', '2026-05-23 15:00:53', '2026-05-23 15:06:34'),
(300, 'user', 18, 'auth_token', 'cd2fe9c43b9ec94dc76c713f31f72e12a0f1c6d1203fc46ad3ffd1947d29fd13', '[\"*\"]', '2026-05-23 15:31:38', '2026-05-23 15:09:26', '2026-05-23 15:31:38'),
(301, 'user', 18, 'auth_token', 'f13e587753f8d4d80da1c3cab470ad8198a6f9108215a129b306cd25382eb5d0', '[\"*\"]', '2026-05-23 15:33:00', '2026-05-23 15:32:16', '2026-05-23 15:33:00'),
(302, 'user', 18, 'auth_token', '696e15dda0956ebb48ad42f085a7f616567f6b1134c7fe99ae765df2b6abdeae', '[\"*\"]', '2026-05-23 15:33:19', '2026-05-23 15:33:04', '2026-05-23 15:33:19'),
(303, 'user', 14, 'auth_token', '48c2b7e147b83c6eca02e40a1be19b89ebfdb683f623ae08e348e41d695f1db6', '[\"*\"]', '2026-05-23 15:34:45', '2026-05-23 15:33:46', '2026-05-23 15:34:45'),
(304, 'user', 18, 'auth_token', '4ec8099240c8b176f1f0d5ef1e16c383f067c3c15d68a741090b34646de345c4', '[\"*\"]', '2026-05-23 16:10:37', '2026-05-23 15:34:53', '2026-05-23 16:10:37'),
(305, 'user', 18, 'auth_token', 'd3e1920ebca0dbd7a8f4e061ad6f8f8c669d76e78dba0f923bcade71a34de746', '[\"*\"]', '2026-05-23 16:23:25', '2026-05-23 16:11:08', '2026-05-23 16:23:25'),
(306, 'user', 18, 'auth_token', 'eeba8cfa8ad4c961e73032119b9bb957d01a22ec930dfb35d5d76c0bb74e724f', '[\"*\"]', '2026-05-23 16:29:00', '2026-05-23 16:23:56', '2026-05-23 16:29:00'),
(307, 'user', 18, 'auth_token', 'c5866dd9e26f87173a667d8dc1997f5f4a9b45bd13b882f27b6974d3e6ba2cc7', '[\"*\"]', '2026-05-25 01:51:03', '2026-05-23 16:34:46', '2026-05-25 01:51:03'),
(308, 'user', 18, 'auth_token', 'd4c52d6cbaf6fed01fde26da1b94bad2ef312e63178bddfad8f9219842e0f100', '[\"*\"]', '2026-05-24 13:51:21', '2026-05-24 13:44:05', '2026-05-24 13:51:21'),
(309, 'user', 18, 'auth_token', '29ee4bc2e334e0eea939b580b112645af092e3f273fa180615ab9e0ae1be1e69', '[\"*\"]', '2026-05-24 14:12:20', '2026-05-24 13:56:58', '2026-05-24 14:12:20'),
(310, 'user', 18, 'auth_token', 'adfcfe08813f65e05e7a4cd672a07df628fe2eb8f95e384898203341b49c4478', '[\"*\"]', '2026-05-25 03:02:11', '2026-05-25 02:33:37', '2026-05-25 03:02:11'),
(311, 'user', 18, 'auth_token', '6cb41a74b23b9ccd83d6e414ee727f8fad409e2f360cb6ff2df8f67041f3efce', '[\"*\"]', '2026-05-25 03:09:54', '2026-05-25 03:06:27', '2026-05-25 03:09:54'),
(312, 'user', 18, 'auth_token', '30ad748aae7cf1cf6a3f3e1b0aa8a40eb251da8843a06ed228617930904da251', '[\"*\"]', '2026-05-25 03:10:02', '2026-05-25 03:09:59', '2026-05-25 03:10:02'),
(313, 'user', 18, 'auth_token', '4303b53554d02288ccce34fcf3790e8545d4b0e1936ea3761389970c7f981794', '[\"*\"]', '2026-05-25 04:33:55', '2026-05-25 03:10:55', '2026-05-25 04:33:55'),
(314, 'user', 18, 'auth_token', '0f3efa2fe0adf96b23e8e554dfd316f9d43f003b2fc3439dee69586c50de2dbf', '[\"*\"]', '2026-05-25 04:35:05', '2026-05-25 04:34:50', '2026-05-25 04:35:05'),
(315, 'user', 18, 'auth_token', 'b3fdcc14f3dc1bfd115c3fe3dc91aae56db355dde3f3bbeb2357d9f84de02b17', '[\"*\"]', '2026-05-25 05:47:52', '2026-05-25 05:05:20', '2026-05-25 05:47:52'),
(316, 'user', 18, 'auth_token', 'ccc765a45e866f899591e1ba082aaba338fb75b216236e63aba2ab4f0f406a13', '[\"*\"]', '2026-05-25 07:09:57', '2026-05-25 05:48:10', '2026-05-25 07:09:57'),
(317, 'user', 18, 'auth_token', 'c459fb5741f4108b2e3394a4705e17c96caaa23a23f771098468f9b0e44a9728', '[\"*\"]', '2026-05-25 09:26:10', '2026-05-25 09:26:09', '2026-05-25 09:26:10'),
(318, 'user', 18, 'auth_token', 'dc967fefb2bfc69c91bb4dd79591bc69bd7afd92f631d742ccf95b1f604f2354', '[\"*\"]', '2026-05-25 09:37:10', '2026-05-25 09:31:13', '2026-05-25 09:37:10'),
(319, 'user', 18, 'auth_token', 'e0a53d337fb8fc9b2a5f39dc13b7b34547034a0b4e164001c3d7ccf8376c5df5', '[\"*\"]', '2026-05-25 10:27:26', '2026-05-25 09:53:37', '2026-05-25 10:27:26'),
(320, 'user', 18, 'auth_token', '7922ad7363eddcf55cac634442a23f12bcada8aaf79ce88c66064b81f085f3e3', '[\"*\"]', '2026-05-25 10:38:03', '2026-05-25 10:27:57', '2026-05-25 10:38:03'),
(321, 'user', 18, 'auth_token', '60cedd8573b8141640b80e0940eea13986842b16ef7c08668082389c5887e47e', '[\"*\"]', '2026-05-25 10:41:35', '2026-05-25 10:38:39', '2026-05-25 10:41:35'),
(322, 'user', 18, 'auth_token', '57003e8dbc05e3de7272d5f2f31ae11f792145b1db2a21dc4a425a0caaae4846', '[\"*\"]', '2026-05-25 11:02:37', '2026-05-25 10:45:26', '2026-05-25 11:02:37'),
(323, 'user', 18, 'auth_token', '42a9ce18e0c94eb72cd00ed6a6915b9d6ebd2e13d7eae7c530d5b28ffd52e164', '[\"*\"]', '2026-05-25 11:03:51', '2026-05-25 11:03:01', '2026-05-25 11:03:51'),
(324, 'user', 18, 'auth_token', '13e301a2fe29c60e6743a7ecd0e5926370bfc27b1622e5c4230e842f50d3ed11', '[\"*\"]', '2026-05-25 11:12:15', '2026-05-25 11:04:12', '2026-05-25 11:12:15'),
(325, 'user', 18, 'auth_token', '1968412a5d0fef7e75c82bdf36d298039aca24575a345b02e80640613108eedc', '[\"*\"]', '2026-05-25 11:43:59', '2026-05-25 11:12:49', '2026-05-25 11:43:59'),
(326, 'user', 18, 'auth_token', '875c096dda58ea4bb0d2912c21143462c937c18d519c8ebc7de5824491ed3a93', '[\"*\"]', '2026-05-25 11:45:06', '2026-05-25 11:44:50', '2026-05-25 11:45:06'),
(327, 'user', 18, 'auth_token', '7b8002f98624fbfb9d10199f6637a0c718fa21b4e7b1878232ae39ff6cc32983', '[\"*\"]', '2026-05-25 11:48:03', '2026-05-25 11:45:56', '2026-05-25 11:48:03'),
(328, 'user', 18, 'auth_token', 'b855a2a560f5242799cbff9d3e046665382b77fb1397109076492cdc80fd5019', '[\"*\"]', '2026-05-25 11:55:48', '2026-05-25 11:48:30', '2026-05-25 11:55:48'),
(329, 'user', 18, 'auth_token', 'a851b7ff8727c2ecf55954d92f49bf05a955eed9dd1744c9ed5271aa52949401', '[\"*\"]', '2026-05-25 12:02:48', '2026-05-25 11:56:09', '2026-05-25 12:02:48'),
(330, 'user', 18, 'auth_token', '8a06e0329eaf58eaca82004d6d36551cece7d5871a468ae7250affe210c38e23', '[\"*\"]', '2026-05-25 12:05:57', '2026-05-25 12:05:37', '2026-05-25 12:05:57'),
(331, 'user', 19, 'auth_token', '8d9bcb6911367e2960833d1b41b7234b136129f833b25f95e8352d78c91e43e7', '[\"*\"]', '2026-05-25 12:07:10', '2026-05-25 12:06:15', '2026-05-25 12:07:10'),
(332, 'user', 19, 'auth_token', 'c9df1d9443c6554afb24edf28a5c5da311faaf5415628e01b43992ec6cdd47a5', '[\"*\"]', '2026-05-25 12:11:52', '2026-05-25 12:07:20', '2026-05-25 12:11:52'),
(333, 'user', 18, 'auth_token', '714abe16cc9733ed67669cec5c6714dd13cb8946338ae38f63c618c08416c098', '[\"*\"]', '2026-05-25 12:12:04', '2026-05-25 12:11:56', '2026-05-25 12:12:04'),
(334, 'user', 18, 'auth_token', 'fcd96bbb6eccfb61e1b7dcc0ed31e6040447f85e700fc31e8b5824921a881dc0', '[\"*\"]', '2026-05-25 12:27:08', '2026-05-25 12:12:07', '2026-05-25 12:27:08'),
(335, 'user', 18, 'auth_token', 'dc733ec9176bae5bf66ffed0c8edb77bdc08acd003f8b70ac1e5a45e11fe5f16', '[\"*\"]', '2026-05-25 12:34:27', '2026-05-25 12:30:51', '2026-05-25 12:34:27'),
(336, 'user', 18, 'auth_token', '9d050c5d2fedad027735b1880685fb7a442add8aa2786f0d8496adfc1c2aa06d', '[\"*\"]', '2026-05-25 13:41:28', '2026-05-25 13:25:09', '2026-05-25 13:41:28'),
(337, 'user', 18, 'auth_token', 'c870ec11f691c33ed431194737854c2cd6efe2aa3b4b361faf7fd2e21a57c96b', '[\"*\"]', '2026-05-25 13:52:45', '2026-05-25 13:42:01', '2026-05-25 13:52:45'),
(338, 'user', 18, 'auth_token', 'c5f7a8291a6d08f6a64b05ceefd19b7df5486cb5d763dac1765069cec6695cd4', '[\"*\"]', '2026-05-25 13:56:25', '2026-05-25 13:55:27', '2026-05-25 13:56:25'),
(339, 'user', 18, 'auth_token', '03db76007f386911881e735f0968d36ee9f22b331b67c8c1ceaa6c0fced95ae4', '[\"*\"]', '2026-05-26 04:45:29', '2026-05-26 04:40:29', '2026-05-26 04:45:29'),
(340, 'user', 18, 'auth_token', '91b557e71377fd5cfe756204cd6ea99c285ef75577810f5b8316aae7e79e887a', '[\"*\"]', '2026-05-26 07:15:28', '2026-05-26 04:52:44', '2026-05-26 07:15:28'),
(341, 'user', 18, 'auth_token', 'cdcda0e0c071190d2d181242227b27f713e23e52395290ec0a90af6e1691e6bf', '[\"*\"]', '2026-05-26 06:40:33', '2026-05-26 06:28:54', '2026-05-26 06:40:33'),
(342, 'user', 18, 'auth_token', '00e8afcd4c9a590cf144e51afe572bb3edc469c9c818c9689a36f2efb4865561', '[\"*\"]', '2026-05-26 07:00:12', '2026-05-26 06:46:40', '2026-05-26 07:00:12'),
(343, 'user', 18, 'auth_token', '54814b8bf679599bcfc5f88a0aeb5f93f79f7bfb3f8293dbcca2874c1d51274d', '[\"*\"]', '2026-05-26 07:23:17', '2026-05-26 07:15:48', '2026-05-26 07:23:17'),
(344, 'user', 18, 'auth_token', 'a88e653be8a13de3060789dd1c3aea9e4cb13ce184d2e666fcc19118679c2f91', '[\"*\"]', '2026-05-26 07:31:28', '2026-05-26 07:23:49', '2026-05-26 07:31:28'),
(345, 'user', 18, 'auth_token', '5717ca798c5b160266c7172b6e38b4afa802d53c4e6d981bd220e663c4737d7c', '[\"*\"]', '2026-05-26 07:49:43', '2026-05-26 07:35:16', '2026-05-26 07:49:43'),
(346, 'user', 18, 'auth_token', '2fcb14f6ae6a73779c2d3bdb195142f6a8166300cce6511cffde6ec712505bec', '[\"*\"]', '2026-05-26 08:07:57', '2026-05-26 07:51:58', '2026-05-26 08:07:57'),
(347, 'user', 18, 'auth_token', '82bf27a60fcc3851713efb8cf84fdc49541f0a0b8754477e29cfd95dbafce22e', '[\"*\"]', '2026-05-26 08:16:43', '2026-05-26 08:16:42', '2026-05-26 08:16:43'),
(348, 'user', 18, 'auth_token', '6c6b5d81363eb50900a243b7229bc94ba46997ce615697755bcb24e059cce74a', '[\"*\"]', '2026-05-26 08:26:23', '2026-05-26 08:25:57', '2026-05-26 08:26:23'),
(349, 'user', 18, 'auth_token', '8b3bb5452e1f023934a3ee50a73664874768cfb068af218974be72d4ae658727', '[\"*\"]', '2026-05-26 08:42:42', '2026-05-26 08:42:41', '2026-05-26 08:42:42'),
(350, 'user', 18, 'auth_token', '2405193b57e6da75dae7cace9845a31a14d3cf855e11a564b45663d53c953f97', '[\"*\"]', '2026-06-02 05:49:05', '2026-06-02 04:08:56', '2026-06-02 05:49:05'),
(351, 'user', 18, 'auth_token', '3b11c2066b36d994a05e020ff26104ca98d43f60b562e57910330cf3eebe83e0', '[\"*\"]', '2026-06-05 00:30:41', '2026-06-05 00:25:58', '2026-06-05 00:30:41'),
(352, 'user', 22, 't', 'df651080f5f35c1a894a91427121067f74ffb2223a09fbd569d7f146044fa458', '[\"*\"]', NULL, '2026-06-05 03:40:39', '2026-06-05 03:40:39'),
(353, 'user', 22, 't2', 'b4229b96bc33c6c01bc837254ec9dcf12ed84382c4e616ede26be0e8c5407e68', '[\"*\"]', '2026-06-05 03:40:49', '2026-06-05 03:40:49', '2026-06-05 03:40:49'),
(354, 'user', 22, 't3', '0f0d11cc28605b4c29ca0b5255a508d5ad0310cc5a177671735eb05271dc9c0c', '[\"*\"]', '2026-06-05 03:41:05', '2026-06-05 03:41:05', '2026-06-05 03:41:05'),
(355, 'user', 23, 'upd', '8579ebcf0a7b6a4ff987d6796430055ea28ef1f7c2b61172f9d569da4c749194', '[\"*\"]', '2026-06-05 05:15:27', '2026-06-05 05:15:27', '2026-06-05 05:15:27'),
(356, 'user', 24, 'upd2', '9e58635e3fc9831440e2a86e3b299c7afe9b449183fbe6824fb9a8882501b065', '[\"*\"]', '2026-06-05 05:15:45', '2026-06-05 05:15:45', '2026-06-05 05:15:45'),
(357, 'user', 25, 'upd3', '0079d7184f9aee8ebb27e380ee8db7f75366f3126e7e27d50e8e26c7e93b6d64', '[\"*\"]', '2026-06-05 05:16:07', '2026-06-05 05:16:07', '2026-06-05 05:16:07'),
(358, 'user', 33, 't', 'b059db827fe86b5e1118d9b363ef865a2fb9a6968f98c95aa68a96a73a5010c8', '[\"*\"]', '2026-06-05 05:47:27', '2026-06-05 05:47:27', '2026-06-05 05:47:27'),
(359, 'user', 33, 't2', 'c020eefeb48a1956d8b06015e733b802dc2b3048d55f2126cc71e8a63adb8c58', '[\"*\"]', '2026-06-05 05:48:40', '2026-06-05 05:48:40', '2026-06-05 05:48:40'),
(360, 'user', 33, 't3', '5ba715f3967bc864b0acd248a125624b67a7c9014eccb04aca6714719bc3ece1', '[\"*\"]', '2026-06-05 05:48:49', '2026-06-05 05:48:49', '2026-06-05 05:48:49'),
(361, 'user', 33, 't4', 'bc17180cb5c57532bbe73ba2a8e0cb7d30f8965d94a7a31db218136d093dc257', '[\"*\"]', '2026-06-05 05:48:56', '2026-06-05 05:48:56', '2026-06-05 05:48:56'),
(362, 'user', 33, 't5', '8b15836d2688665fac5431cc9028b65a894b2ba08899e3608f1f068463de16f8', '[\"*\"]', '2026-06-05 05:49:03', '2026-06-05 05:49:03', '2026-06-05 05:49:03'),
(363, 'user', 33, 't6', 'bdbe3b265d883ef44ca8c8d1b7e844e399a0f743325e6fa245ff84bdebb3cb46', '[\"*\"]', '2026-06-05 05:49:33', '2026-06-05 05:49:33', '2026-06-05 05:49:33'),
(364, 'user', 33, 't7', 'd930de1ee12538fa67fe588125fc58d72b5b57976bed55ae745a7f610379a013', '[\"*\"]', '2026-06-05 05:49:43', '2026-06-05 05:49:43', '2026-06-05 05:49:43'),
(365, 'user', 33, 't8', 'e0656a69280da88fb5122f6b05c36c88db5faf277775b6916fffa27aee56490a', '[\"*\"]', '2026-06-05 05:49:54', '2026-06-05 05:49:54', '2026-06-05 05:49:54'),
(366, 'user', 33, 't9', '17cf47b68923317cf22b662b2608d9a2d84c6d2905f6befcb6a5f3d63e154c5c', '[\"*\"]', '2026-06-05 05:52:41', '2026-06-05 05:52:40', '2026-06-05 05:52:41'),
(367, 'user', 33, 't10', 'a791f2f0a5a22c733ba74eb9232b660573827a8e8ab9b33a8b9b6be99a774606', '[\"*\"]', '2026-06-05 05:53:03', '2026-06-05 05:53:03', '2026-06-05 05:53:03'),
(368, 'user', 33, 't11', '56311820943c370d738cbb14fd1de6e80835609c252d622115b785f621c40a23', '[\"*\"]', '2026-06-05 05:53:12', '2026-06-05 05:53:12', '2026-06-05 05:53:12'),
(369, 'user', 33, 'updtest', 'b4f8a94cba8dcd49038fa7e40e98c554c7df30fec66d218c9d719dddc02b2572', '[\"*\"]', '2026-06-05 05:59:07', '2026-06-05 05:59:07', '2026-06-05 05:59:07'),
(370, 'user', 33, 'pk', '590d1dd0594487627a3f2c52d5f7d3fad28cb7a73a0af389f2d9d8853a2d1b9a', '[\"*\"]', '2026-06-05 06:05:24', '2026-06-05 06:05:24', '2026-06-05 06:05:24'),
(371, 'user', 33, 'pk2', 'f8d5188ebb490fb52c0730f55ee2743de2544695788ad1a8bfe5c437ae505420', '[\"*\"]', '2026-06-05 06:05:47', '2026-06-05 06:05:47', '2026-06-05 06:05:47'),
(372, 'user', 33, 'pk3', 'fa7f3dd5a17d2a659bd6c20276f3031d467087135c0aa84510f023029214560f', '[\"*\"]', '2026-06-05 06:06:20', '2026-06-05 06:06:20', '2026-06-05 06:06:20'),
(373, 'user', 33, 'img', 'b28e7935e4f0889b7d4ab961628ff0849c136fc867012d6cf69a3b86dd598136', '[\"*\"]', '2026-06-05 06:37:42', '2026-06-05 06:37:42', '2026-06-05 06:37:42'),
(374, 'user', 33, 'img2', '39c811e0c08041b7de930c1eb4a094f923dbe788f372d8d7d3eff123fdd43104', '[\"*\"]', '2026-06-05 06:37:52', '2026-06-05 06:37:52', '2026-06-05 06:37:52'),
(375, 'user', 33, 'img3', '13920fd38737772c02138b6cd7e870067f204074eb8e5f4a9000324571578fb5', '[\"*\"]', '2026-06-05 06:38:17', '2026-06-05 06:38:17', '2026-06-05 06:38:17'),
(376, 'user', 33, 'img4', '9569f68351c0a5c6d0a7f904bd5283c91c81c197d4c37cceeee0616e3c9a58ab', '[\"*\"]', '2026-06-05 06:38:43', '2026-06-05 06:38:43', '2026-06-05 06:38:43'),
(377, 'user', 33, 'img5', 'acfa93c12f146872a385f175b8c7c75ac53363dd889e8aa791ab8be1eb94445b', '[\"*\"]', '2026-06-05 06:38:49', '2026-06-05 06:38:49', '2026-06-05 06:38:49'),
(378, 'user', 33, 'img6', 'cbf90aca82b29e21010b8362f054b7b8c94a6ee246f657adf8a7ab18be1b9030', '[\"*\"]', '2026-06-05 06:39:01', '2026-06-05 06:39:00', '2026-06-05 06:39:01'),
(379, 'user', 33, 'img7', '9633bf707f9132a7a5d2dac172d391e69397b73165e9eecdb2fe46abcc60b1d2', '[\"*\"]', '2026-06-05 06:39:34', '2026-06-05 06:39:34', '2026-06-05 06:39:34'),
(380, 'user', 33, 'img', '1c3ac21bc20a14c210b800b0a3f96c133cf63c53972e7e03320ad9a85bbf55fb', '[\"*\"]', '2026-06-05 08:43:24', '2026-06-05 08:43:24', '2026-06-05 08:43:24'),
(381, 'user', 33, 'img2', '825debe4ee2666ea97c8f86dfafd89eb1a64de80fbb17bd6913e8ff5566a3bfe', '[\"*\"]', '2026-06-05 08:43:30', '2026-06-05 08:43:30', '2026-06-05 08:43:30'),
(382, 'user', 33, 'img3', 'c8e693020808fa355d31d6c181ea9c0a0c4fd2b5f042a4e7459c972046c80d45', '[\"*\"]', '2026-06-05 08:43:39', '2026-06-05 08:43:39', '2026-06-05 08:43:39'),
(383, 'user', 33, 'imgfix', '549facc5c2ad4f8a21ce4eff15e8ecd3e754a070268590629e7bc9e00b2cebad', '[\"*\"]', '2026-06-05 08:44:21', '2026-06-05 08:44:21', '2026-06-05 08:44:21');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint UNSIGNED NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json DEFAULT NULL,
  `videos` json DEFAULT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `visibility` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `created_by`, `title`, `content`, `images`, `videos`, `is_pinned`, `visibility`, `created_at`, `updated_at`) VALUES
(1, 18, 'Villa on Sale', 'This is 6 Bedrooms Villa for Sale of about AED 2.5M.', '[\"/storage/updates/images/nXgq3osbtCkS9OWPfKEx6Pm7YBn9XeSb8icZ8lLj.jpg\"]', '[]', 0, 'all', '2026-05-07 05:13:49', '2026-05-07 05:13:49'),
(2, 18, 'Houses on Rent', 'These are 4 bedrooms houses available for rent.', '[\"/storage/updates/images/6kAPrKA3wxDPGyJVgnxrLlIHNsKtqo0NSX71t4iN.jpg\", \"/storage/updates/images/yHWBAilSspeUG9ebafRKjm5mm0kJeiL0aRcz7t1a.jpg\"]', '[]', 0, 'all', '2026-05-07 05:24:21', '2026-05-07 05:24:21');

-- --------------------------------------------------------

--
-- Table structure for table `saved_searches`
--

CREATE TABLE `saved_searches` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filters` json NOT NULL,
  `alerts_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `saved_searches`
--

INSERT INTO `saved_searches` (`id`, `user_id`, `name`, `filters`, `alerts_enabled`, `created_at`, `updated_at`) VALUES
(3, 18, 'For Sale Saved Search', '{\"beds\": 3, \"city\": \"Dubai\", \"tags\": [\"urgent\", \"below market\"], \"status\": \"for sale\", \"keyword\": \"dubai\", \"off_plan\": true, \"max_price\": 8000000, \"min_price\": 1200000, \"property_type\": \"apartment\"}', 1, '2026-05-07 07:01:42', '2026-05-07 07:01:42'),
(4, 18, 'For Sale Saved Search', '{\"beds\": 3, \"city\": \"Dubai\", \"tags\": [\"urgent\", \"below market\"], \"status\": \"for sale\", \"keyword\": \"dubai\", \"off_plan\": true, \"max_price\": 8000000, \"min_price\": 1200000, \"property_type\": \"apartment\"}', 1, '2026-05-07 09:48:08', '2026-05-07 09:48:08'),
(5, 18, 'For Sale Saved Search', '{\"beds\": 3, \"city\": \"Dubai\", \"tags\": [\"urgent\", \"below market\"], \"status\": \"for sale\", \"keyword\": \"dubai\", \"off_plan\": true, \"max_price\": 8000000, \"min_price\": 1200000, \"property_type\": \"apartment\"}', 1, '2026-05-07 09:51:29', '2026-05-07 09:51:29'),
(6, 18, 'Uske turant baad prompt aayega:\n“Do you want to save this filter as a Saved Search?”\nYes / No', '{\"beds\": 3, \"city\": \"Al Mushrif\", \"tags\": [\"hot deal\"], \"keyword\": \"Pak\", \"max_price\": 15551234567, \"min_price\": 15551234567, \"property_type\": \"Office\"}', 1, '2026-05-07 10:09:57', '2026-05-07 10:09:57'),
(7, 18, 'Ttttt', '{\"beds\": 3, \"city\": \"Al Barsha\", \"tags\": [\"exclusive\"], \"off_plan\": true, \"max_price\": 15551234567, \"min_price\": 15551234567, \"property_type\": \"Duplex\"}', 1, '2026-05-07 10:18:32', '2026-05-07 10:18:32'),
(11, 18, 'New testing Ami', '{\"beds\": 2, \"city\": \"Al Barsha\", \"tags\": [\"hot deal\"], \"keyword\": \"Dubai\", \"off_plan\": 0, \"max_price\": 12000, \"min_price\": 112000, \"property_type\": \"Duplex\"}', 1, '2026-05-25 10:31:47', '2026-05-25 10:31:47'),
(14, 18, 'Yessssss', '{\"beds\": 4, \"city\": \"Al Barsha\", \"tags\": [\"hot deal\"], \"keyword\": \"Super deal yesterday\", \"off_plan\": 0, \"max_price\": 23, \"min_price\": 22, \"property_type\": \"Duplex\"}', 1, '2026-05-25 11:11:09', '2026-05-25 11:11:09'),
(16, 18, 'Noooo', '{\"beds\": 5, \"city\": \"Al Barsha\", \"tags\": [\"hot deal\"], \"keyword\": \"Oooo\", \"off_plan\": 1, \"max_price\": 333, \"min_price\": 22, \"property_type\": \"Duplex\"}', 1, '2026-05-25 11:13:46', '2026-05-25 11:13:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `agency_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apple_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('broker','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'broker',
  `status` enum('active','suspended','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `messages_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `whatsapp_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `account_type` enum('personal','agency') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal',
  `profile_completion_percent` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `last_active` timestamp NULL DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `agency_id`, `name`, `first_name`, `last_name`, `email`, `phone`, `google_id`, `facebook_id`, `apple_id`, `whatsapp`, `role`, `status`, `language`, `profile_photo`, `phone_notifications`, `messages_notifications`, `whatsapp_notifications`, `account_type`, `profile_completion_percent`, `last_active`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 1, 'Sarah Jenkins', NULL, NULL, 'sarah@example.com', NULL, NULL, NULL, NULL, NULL, 'broker', 'pending', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-03-25 05:32:08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'QHZVCinxxH', '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(2, 2, 'Ahmed Khan', NULL, NULL, 'ahmed@example.com', NULL, NULL, NULL, NULL, NULL, 'broker', 'pending', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-03-25 05:32:08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'LAJJyahZ2O', '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(3, 3, 'Maria Lee', NULL, NULL, 'maria@example.com', NULL, NULL, NULL, NULL, NULL, 'broker', 'pending', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-03-25 05:32:08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'k4FLz6bb66', '2026-03-25 05:32:08', '2026-03-25 05:32:08'),
(4, 4, 'Lynn Wong', NULL, NULL, 'lynn@example.com', NULL, NULL, NULL, NULL, NULL, 'broker', 'pending', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-03-25 05:32:09', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'qek4BcrsBI', '2026-03-25 05:32:09', '2026-03-25 05:32:09'),
(5, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb@test.com', '+971500000001', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$.NJma26x/9ZeirztEuQtd.QK5AAu42eYVFZlcEUs0b/bAeNdZsf/2', NULL, '2026-03-26 06:19:05', '2026-03-26 06:19:05'),
(6, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb123@test.com', '+971500000002', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$zH7sBVgSnAtSotBRp5A/QOSmD9XhzD7HThtD/C79SELYLV9A7GOHi', NULL, '2026-03-30 02:26:19', '2026-03-30 02:26:19'),
(7, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb13@test.com', '+971500000003', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$RPcq3TcU1tvTnRkOCNiVhu5dKesC5iiPTc2lmcC.bE3IPiM28r4Fq', NULL, '2026-03-30 03:19:05', '2026-03-30 03:19:05'),
(8, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb@4test.com', '+971500000006', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$7rcd5w8y07AfLM3UjJxK2OeBVaCW.POw8Ck5RzMyEiUgHdMKXez7m', NULL, '2026-03-30 03:24:23', '2026-03-30 03:24:23'),
(9, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb@41test.com', '+9715000000021', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$fp/i9bVe3Jh4bsNgJ7JjK.xNL9rFLP46kWHQI10KKrdMjj44taSGi', NULL, '2026-03-30 03:25:52', '2026-03-30 03:25:52'),
(10, NULL, 'Muneeb Azhar', NULL, NULL, 'muneeb@44test.com', '+9715000000024', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$fdqMIL9tmWtwmZuHK0llJ.hssWF893SpKqqtAyor3vZKbl1/PPAIy', NULL, '2026-03-30 03:27:25', '2026-03-30 03:27:25'),
(11, NULL, 'muneeb', NULL, NULL, 'Muneeb @gmail.com', '+971', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$nGpznkHV0qTl.DjbVT5hmOUcWDI0nZ5cn5000FCDzQmt70RxDul7.', NULL, '2026-03-30 03:39:21', '2026-03-30 03:39:21'),
(12, NULL, 'Muneeb Azhar', 'Muneeb', 'Azhar', 'muneeb@444test.com', '+97150000000244', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 100, NULL, NULL, '$2y$10$CSPgbscqKhOZulKKZhjnIedF5l5YkEXVeIOwRiiRq74Nh.A4g2/CG', NULL, '2026-03-30 03:53:15', '2026-03-30 03:53:15'),
(14, NULL, 'noraiz shamshad', NULL, NULL, 'noraizshamshad60@gmail.com', NULL, '117897261584287989839', NULL, NULL, NULL, 'broker', 'active', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLOaeupCH8YEEun-CeiR4gEdAj1V9Bfstb3hOHUs1i9Mpba6Q=s96-c', 1, 1, 1, 'personal', 33, NULL, NULL, '$2y$10$dvo2GZat/4gR58/ejbW.Xe2pq/zlJNsJKqSK5pJ/i1HOC2U/D9Dmy', NULL, '2026-04-09 04:12:19', '2026-04-20 06:22:51'),
(16, NULL, 'Muneeb Azhar', 'Muneeb Azhar', NULL, 'muneeb2@test.com', '+971500100002', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 0, NULL, NULL, '$2y$10$5vocXfBqYqQynUVHqI90ieY97Ykk6VPWHbb0cozIyBV//MYX7YeKC', NULL, '2026-04-22 04:08:52', '2026-04-22 04:08:52'),
(17, 6, 'Muneeb Azhar', 'Muneeb', 'Azhar', 'muneeb3@test.com', '+971500100102', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', '/storage/profiles/pictures/NEopbipcNLTPafCAzoLVPsmZtns33bz4izQ5vxdH.webp', 1, 0, 1, 'agency', 92, NULL, NULL, '$2y$10$6.kef29ie1KVpFgrJjE6B.QUfO4c3vdRwZGHMP11ASA2r5PRf9GVG', NULL, '2026-04-22 04:10:57', '2026-04-22 04:28:45'),
(18, 7, 'Gulfam Khan', 'Gulfam', 'Khan', 'sami123@gmail.com', '+923338240922', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', '/storage/profiles/pictures/RWepRzwTajB969OIdIDV8A4fgammQHWGBEOaA1jD.jpg', 1, 1, 1, 'agency', 100, NULL, NULL, '$2y$10$bE.lIwDSQW8Fwt3xNQjjFuIHcGQY0LDawWr04ttt1m/WKwkdBqwoS', NULL, '2026-04-22 05:57:26', '2026-05-25 11:56:50'),
(19, NULL, 'Abdul Rahman', NULL, NULL, 'ar6190751@gmail.com', NULL, '109096120145862859762', NULL, NULL, NULL, 'broker', 'active', NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLqHApgh3Y-jciamZvjTqzHkKyLF_wyUYQvF9Qmze6xp6DmkA=s96-c', 1, 1, 1, 'personal', 0, NULL, NULL, '$2y$10$gg3bMx.s1IppkN6L10741OK6uOkWeKbkt9uzunH/5enK4s/Hm426C', NULL, '2026-05-25 12:06:15', '2026-05-25 12:06:15'),
(20, NULL, 'Muneeb Azhar', 'Muneeb Azhar', NULL, 'muneeb4@test.com', '+971500100112', NULL, NULL, NULL, NULL, 'broker', 'active', 'en', NULL, 1, 1, 1, 'personal', 0, NULL, NULL, '$2y$10$OuHRrwIdmIuaZbdU3dMKS.sMPCcAP.MZkAQpr3fKPYzZVlccdL4pq', NULL, '2026-06-02 01:37:11', '2026-06-02 01:37:11'),
(21, 8, 'Dagmar Dibbert', NULL, NULL, 'mathilde.kris@example.org', '97154452110', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'agency', 0, NULL, '2026-06-05 03:36:01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '4SSPOSIzCS', '2026-06-05 03:36:01', '2026-06-05 03:36:02'),
(22, 9, 'Prof. Garry Hintz', NULL, NULL, 'ibeahan@example.org', '97151900204', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'agency', 100, NULL, '2026-06-05 03:40:39', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'THBYaeMabQ', '2026-06-05 03:40:39', '2026-06-05 03:40:39'),
(23, NULL, 'Jaquan Blick', NULL, NULL, 'sschroeder@example.com', '97154920416', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 100, NULL, '2026-06-05 05:15:26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'TeNEqJDInp', '2026-06-05 05:15:26', '2026-06-05 05:15:26'),
(24, NULL, 'Evans Balistreri', NULL, NULL, 'wunsch.domingo@example.net', '97155324069', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 100, NULL, '2026-06-05 05:15:45', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '1n6P91xVK6', '2026-06-05 05:15:45', '2026-06-05 05:15:45'),
(25, NULL, 'Alexandra Ritchie Sr.', NULL, NULL, 'oral59@example.com', '97159794813', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 100, NULL, '2026-06-05 05:16:07', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Rewp2hOkUm', '2026-06-05 05:16:07', '2026-06-05 05:16:07'),
(26, NULL, 'Connor Collins DDS', NULL, NULL, 'tod95@example.org', '97152304740', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:33:14', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '2RqzusMN1a', '2026-06-05 05:33:15', '2026-06-05 05:33:15'),
(27, NULL, 'Devan Volkman', NULL, NULL, 'alta24@example.com', '97158820029', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:33:46', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'jvJm7t0U6R', '2026-06-05 05:33:46', '2026-06-05 05:33:46'),
(28, NULL, 'Tanner Monahan', NULL, NULL, 'bdeckow@example.com', '97153450407', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:34:08', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ldKxFqHWJt', '2026-06-05 05:34:08', '2026-06-05 05:34:08'),
(29, NULL, 'Emelie Braun', 'Dubai', 'Hills', 'moore.jolie@example.net', '97154220350', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:34:17', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Xb7CwNKHNk', '2026-06-05 05:34:17', '2026-06-05 05:34:17'),
(30, NULL, 'Dubai Hills Broker', NULL, NULL, 'bashirian.dewitt@example.com', '97152989761', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:34:29', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'MQjZX09FkQ', '2026-06-05 05:34:29', '2026-06-05 05:34:29'),
(31, NULL, 'Dubai Hills Broker', NULL, NULL, 'rrohan@example.com', '97157594103', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:35:19', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'LsYyirrxq9', '2026-06-05 05:35:20', '2026-06-05 05:35:20'),
(32, NULL, 'Prof. Elmer Mitchell', NULL, NULL, 'haven14@example.net', '97154973377', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-05 05:35:28', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'l0yNov2xzS', '2026-06-05 05:35:28', '2026-06-05 05:35:28'),
(33, NULL, 'Alphonso O\'Kon II', NULL, NULL, 'breanna.aufderhar@example.org', '97154745369', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 100, NULL, '2026-06-05 05:47:26', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'l6C6K53UtL', '2026-06-05 05:47:27', '2026-06-05 05:47:27'),
(34, NULL, 'Marlee Wolf', NULL, NULL, 'ocie11@example.com', '97157486819', NULL, NULL, NULL, NULL, 'broker', 'active', NULL, NULL, 1, 1, 1, 'personal', 0, NULL, '2026-06-08 02:51:46', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0UxM1Jq0XH', '2026-06-08 02:51:46', '2026-06-08 02:51:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agencies`
--
ALTER TABLE `agencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `broker_profiles`
--
ALTER TABLE `broker_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `broker_profiles_user_id_foreign` (`user_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_commentable_type_commentable_id_index` (`commentable_type`,`commentable_id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_parent_id_foreign` (`parent_id`),
  ADD KEY `comments_commentable_type_commentable_id_parent_id_index` (`commentable_type`,`commentable_id`,`parent_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `favorites_user_id_listing_id_unique` (`user_id`,`listing_id`),
  ADD KEY `favorites_listing_id_foreign` (`listing_id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `likes_user_id_likeable_type_likeable_id_unique` (`user_id`,`likeable_type`,`likeable_id`),
  ADD KEY `likes_likeable_type_likeable_id_index` (`likeable_type`,`likeable_id`);

--
-- Indexes for table `listings`
--
ALTER TABLE `listings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `listings_created_by_foreign` (`created_by`),
  ADD KEY `listings_listing_type_status_index` (`listing_type`,`status`),
  ADD KEY `listings_city_area_index` (`city`,`area`),
  ADD KEY `listings_created_at_index` (`created_at`);

--
-- Indexes for table `listing_details`
--
ALTER TABLE `listing_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `listing_details_listing_id_foreign` (`listing_id`);

--
-- Indexes for table `listing_media`
--
ALTER TABLE `listing_media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `listing_media_listing_id_foreign` (`listing_id`);

--
-- Indexes for table `listing_metric_events`
--
ALTER TABLE `listing_metric_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `listing_metric_events_listing_user_metric_unique` (`listing_id`,`user_id`,`metric`),
  ADD KEY `listing_metric_events_listing_id_metric_index` (`listing_id`,`metric`),
  ADD KEY `listing_metric_events_user_id_metric_index` (`user_id`,`metric`);

--
-- Indexes for table `listing_reviews`
--
ALTER TABLE `listing_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `listing_reviews_listing_id_user_id_unique` (`listing_id`,`user_id`),
  ADD KEY `listing_reviews_user_id_foreign` (`user_id`),
  ADD KEY `listing_reviews_listing_id_rating_index` (`listing_id`,`rating`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `posts_created_by_foreign` (`created_by`);

--
-- Indexes for table `saved_searches`
--
ALTER TABLE `saved_searches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `saved_searches_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_phone_unique` (`phone`),
  ADD UNIQUE KEY `users_google_id_unique` (`google_id`),
  ADD UNIQUE KEY `users_facebook_id_unique` (`facebook_id`),
  ADD UNIQUE KEY `users_apple_id_unique` (`apple_id`),
  ADD KEY `users_agency_id_foreign` (`agency_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `agencies`
--
ALTER TABLE `agencies`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `broker_profiles`
--
ALTER TABLE `broker_profiles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `listings`
--
ALTER TABLE `listings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;

--
-- AUTO_INCREMENT for table `listing_details`
--
ALTER TABLE `listing_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `listing_media`
--
ALTER TABLE `listing_media`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `listing_metric_events`
--
ALTER TABLE `listing_metric_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `listing_reviews`
--
ALTER TABLE `listing_reviews`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=384;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `saved_searches`
--
ALTER TABLE `saved_searches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `broker_profiles`
--
ALTER TABLE `broker_profiles`
  ADD CONSTRAINT `broker_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `listings`
--
ALTER TABLE `listings`
  ADD CONSTRAINT `listings_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `listing_details`
--
ALTER TABLE `listing_details`
  ADD CONSTRAINT `listing_details_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `listing_media`
--
ALTER TABLE `listing_media`
  ADD CONSTRAINT `listing_media_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `listing_metric_events`
--
ALTER TABLE `listing_metric_events`
  ADD CONSTRAINT `listing_metric_events_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `listing_metric_events_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `listing_reviews`
--
ALTER TABLE `listing_reviews`
  ADD CONSTRAINT `listing_reviews_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `listing_reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_searches`
--
ALTER TABLE `saved_searches`
  ADD CONSTRAINT `saved_searches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_agency_id_foreign` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
