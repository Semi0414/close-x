-- MySQL dump 10.13  Distrib 9.3.0, for macos13.7 (x86_64)
--
-- Host: 127.0.0.1    Database: close_x
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `close_x`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `close_x` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `close_x`;

--
-- Table structure for table `agencies`
--

DROP TABLE IF EXISTS `agencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agencies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orn` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ded_license` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agencies`
--

LOCK TABLES `agencies` WRITE;
/*!40000 ALTER TABLE `agencies` DISABLE KEYS */;
INSERT INTO `agencies` VALUES (1,'SKYLINE REALTY',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-25 05:32:08','2026-03-25 05:32:08'),(2,'ELITE PROPERTIES',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-25 05:32:08','2026-03-25 05:32:08'),(3,'NEXTGEN HOMES',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-25 05:32:08','2026-03-25 05:32:08'),(4,'RENTAL SPECIALISTS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(5,'HI/ tect company','/storage/profiles/agency/logos/oZMXUxxIeC0Klzsj9gHgKu4ZEGJZM8jGRweaHm7n.png',NULL,NULL,'Ghakkhar mandi','[\"/storage/profiles/agency/attachments/FUEM2exW65X1TtIGcmSLzILbySIH3XDX8mYntJAf.pdf\"]',NULL,NULL,NULL,'2026-04-09 03:45:05','2026-04-09 11:43:56');
/*!40000 ALTER TABLE `agencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `broker_profiles`
--

DROP TABLE IF EXISTS `broker_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `broker_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `company_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `brn_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `experience_years` int unsigned NOT NULL DEFAULT '0',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `show_whatsapp` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `broker_profiles_user_id_foreign` (`user_id`),
  CONSTRAINT `broker_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broker_profiles`
--

LOCK TABLES `broker_profiles` WRITE;
/*!40000 ALTER TABLE `broker_profiles` DISABLE KEYS */;
INSERT INTO `broker_profiles` VALUES (1,1,'Palm Luxury Estates',NULL,NULL,5,1,1,1,'2026-03-25 05:32:08','2026-03-25 05:32:08'),(2,2,'Downtown Specialists',NULL,NULL,5,1,1,1,'2026-03-25 05:32:08','2026-03-25 05:32:08'),(3,3,'NextGen Homes',NULL,NULL,5,1,1,1,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(4,4,NULL,NULL,NULL,5,1,1,1,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(5,5,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-26 06:19:05','2026-03-26 06:19:05'),(6,6,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 02:26:19','2026-03-30 02:26:19'),(7,7,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:19:05','2026-03-30 03:19:05'),(8,8,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:24:23','2026-03-30 03:24:23'),(9,9,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:25:52','2026-03-30 03:25:52'),(10,10,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:27:25','2026-03-30 03:27:25'),(11,11,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:39:21','2026-03-30 03:39:21'),(12,12,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:53:15','2026-03-30 03:53:15'),(13,13,'Freelance Agent',NULL,NULL,0,1,1,1,'2026-03-30 03:57:43','2026-03-30 03:57:43');
/*!40000 ALTER TABLE `broker_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `favorites_user_id_listing_id_unique` (`user_id`,`listing_id`),
  KEY `favorites_listing_id_foreign` (`listing_id`),
  CONSTRAINT `favorites_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing_details`
--

DROP TABLE IF EXISTS `listing_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `listing_id` bigint unsigned NOT NULL,
  `payment_plan` text COLLATE utf8mb4_unicode_ci,
  `ownership` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `furnished` enum('furnished','unfurnished','semi') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `commission` decimal(10,2) DEFAULT NULL,
  `roi` decimal(5,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `amenities` json DEFAULT NULL,
  `extra` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `listing_details_listing_id_foreign` (`listing_id`),
  CONSTRAINT `listing_details_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing_details`
--

LOCK TABLES `listing_details` WRITE;
/*!40000 ALTER TABLE `listing_details` DISABLE KEYS */;
INSERT INTO `listing_details` VALUES (1,1,'60/40 (Post-Handover)',NULL,NULL,NULL,7.40,'Iconic skyline views, vacant on transfer. Full-floor luxury unit.',NULL,'{\"lat\": 25.08, \"lng\": 55.14, \"ai_verified\": true, \"completion_date\": \"Q4 2025\", \"service_charges\": \"12.5 / sqft\"}','2026-03-25 05:32:09','2026-03-25 05:32:09'),(2,2,NULL,NULL,NULL,NULL,NULL,'Client urgently needs 2BHK + Study in Downtown Dubai. High floor, Burj view preferred. Budget flexible for serious options.',NULL,'{\"ai_verified\": false, \"timeline_label\": \"Immediate\"}','2026-03-25 05:32:09','2026-03-25 05:32:09'),(3,3,'60/40 (Post-Handover)',NULL,NULL,NULL,7.40,'Fully furnished, ready to move. Close to park and community center.',NULL,'{\"lat\": 25.06, \"lng\": 55.21, \"ai_verified\": true, \"completion_date\": \"Q4 2025\", \"service_charges\": \"12.5 / sqft\"}','2026-03-25 05:32:09','2026-03-25 05:32:09'),(4,4,NULL,NULL,NULL,NULL,NULL,'Looking for furnished 1BHK in JLT or Marina. Prefer building with gym. Lease start March.',NULL,'{\"ai_verified\": false, \"timeline_label\": \"March\"}','2026-03-25 05:32:09','2026-03-25 05:32:09'),(5,5,NULL,NULL,NULL,NULL,NULL,'Cash buyer preferred',NULL,NULL,'2026-04-10 06:19:40','2026-04-10 06:19:40'),(6,6,NULL,NULL,NULL,NULL,NULL,'Cash buyer preferred',NULL,NULL,'2026-04-10 06:28:37','2026-04-10 06:28:37'),(7,7,NULL,NULL,NULL,20.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-10 06:55:16','2026-04-10 06:55:16'),(8,8,NULL,NULL,NULL,20.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 02:19:57','2026-04-13 02:19:57'),(9,9,NULL,NULL,NULL,0.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 02:22:33','2026-04-13 02:22:33'),(10,10,NULL,NULL,NULL,0.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 04:02:56','2026-04-13 04:02:56'),(11,11,NULL,NULL,NULL,0.00,NULL,NULL,NULL,NULL,'2026-04-13 04:08:09','2026-04-13 04:08:09'),(12,13,NULL,NULL,NULL,10.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 04:14:28','2026-04-13 04:14:28'),(13,14,NULL,NULL,NULL,10.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 06:10:50','2026-04-13 06:10:50'),(14,15,NULL,NULL,NULL,5.00,NULL,NULL,NULL,'{\"form-data\": {\"beds\": 3, \"tags\": [\"New\", \"Urgent\", \"Exclusive\"], \"price\": null}, \"commission_type\": \"percentage\"}','2026-04-13 06:33:03','2026-04-13 06:33:03'),(15,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"form-data\": {\"beds\": 3, \"tags\": [\"New\", \"Exclusive\"], \"price\": null}}','2026-04-13 06:34:43','2026-04-13 06:34:43'),(16,17,NULL,NULL,NULL,5.00,NULL,NULL,NULL,'{\"form-data\": {\"beds\": 3, \"tags\": [\"New\", \"Exclusive\"], \"price\": null}, \"commission_type\": \"percentage\"}','2026-04-13 09:34:48','2026-04-13 09:34:48'),(17,18,NULL,NULL,NULL,20.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 09:41:19','2026-04-13 09:41:19'),(18,19,NULL,NULL,NULL,20.00,NULL,NULL,NULL,'{\"form-data\": {\"beds\": 3, \"tags\": [\"New\", \"Urgent\", \"Distress\", \"Exclusive\"], \"price\": null}, \"commission_type\": \"fixed\"}','2026-04-13 09:49:36','2026-04-13 09:49:36'),(19,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"form-data\": {\"beds\": 3, \"tags\": [\"New\", \"Urgent\", \"Exclusive\"], \"price\": null}}','2026-04-13 09:55:53','2026-04-13 09:55:53'),(20,21,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 10:00:56','2026-04-13 10:00:56'),(21,22,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-13 11:19:56','2026-04-13 11:19:56'),(22,23,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"commission_type\": \"percentage\"}','2026-04-14 01:40:18','2026-04-14 01:40:18'),(23,24,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"kind\": \"for_sale\", \"commission_type\": \"percentage\"}','2026-04-14 04:21:46','2026-04-14 04:21:46'),(24,25,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"kind\": \"rent\", \"commission_type\": \"percentage\"}','2026-04-14 04:48:16','2026-04-14 04:48:16'),(25,26,NULL,NULL,NULL,15.00,NULL,NULL,NULL,'{\"kind\": \"rent\", \"commission_type\": \"percentage\"}','2026-04-14 05:04:54','2026-04-14 05:04:54'),(26,27,NULL,NULL,NULL,5.00,NULL,NULL,NULL,'{\"kind\": \"rent\", \"commission_type\": \"percentage\"}','2026-04-14 05:12:18','2026-04-14 05:12:18');
/*!40000 ALTER TABLE `listing_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing_media`
--

DROP TABLE IF EXISTS `listing_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing_media` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `listing_id` bigint unsigned NOT NULL,
  `type` enum('image','video','doc') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `listing_media_listing_id_foreign` (`listing_id`),
  CONSTRAINT `listing_media_listing_id_foreign` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing_media`
--

LOCK TABLES `listing_media` WRITE;
/*!40000 ALTER TABLE `listing_media` DISABLE KEYS */;
INSERT INTO `listing_media` VALUES (1,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',0,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(2,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',1,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(3,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',2,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(4,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',3,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(5,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',4,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(6,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',5,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(7,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',6,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(8,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',7,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(9,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',8,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(10,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',9,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(11,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',10,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(12,1,'image','https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg?auto=compress&w=1200',11,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(13,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',0,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(14,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',1,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(15,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',2,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(16,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',3,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(17,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',4,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(18,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',5,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(19,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',6,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(20,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',7,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(21,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',8,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(22,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',9,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(23,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',10,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(24,3,'image','https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&w=1200',11,'2026-03-25 05:32:09','2026-03-25 05:32:09'),(25,5,'image','http://localhost/storage/listing-media/UOHJQqhIHLFAKaWPrYoX7XOod6tUPEdCUFOMhQtm.jpg',0,'2026-04-10 06:19:40','2026-04-10 06:19:40'),(26,5,'image','http://localhost/storage/listing-media/U5ZB0gHlndqvGeuF9H60pf6Sv1T8NH7m7gF3lvtU.jpg',1,'2026-04-10 06:19:41','2026-04-10 06:19:41'),(27,7,'image','http://localhost/storage/listing-media/n6NL4LgcRQdkHjgvDKaXU3xI98lzQQh2WMKZSDEV.jpg',0,'2026-04-10 06:55:16','2026-04-10 06:55:16'),(28,7,'image','http://localhost/storage/listing-media/WB7JL3iNP6g95RNZJxTHKAJwfDCccb6TLYoljiRi.jpg',1,'2026-04-10 06:55:16','2026-04-10 06:55:16'),(29,15,'image','http://localhost/storage/listing-media/JS3UUzBFtO9EoGcYXePzua4bChMP8fTqLaoktMVf.jpg',0,'2026-04-13 06:33:03','2026-04-13 06:33:03'),(30,17,'image','http://localhost/storage/listing-media/CezJzTDBOuZ020IHe2kSwp0Zq7YDV1M5B3wXX6Vh.jpg',0,'2026-04-13 09:34:48','2026-04-13 09:34:48'),(31,20,'image','http://localhost/storage/listing-media/x0pKi4je13NLoksufaPhfMepPpsrHNVEzalcyt7N.jpg',0,'2026-04-13 09:55:53','2026-04-13 09:55:53');
/*!40000 ALTER TABLE `listing_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings`
--

DROP TABLE IF EXISTS `listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by` bigint unsigned NOT NULL,
  `listing_type` enum('sale','rent','requirement') COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AED',
  `size` decimal(10,2) DEFAULT NULL,
  `beds` tinyint unsigned DEFAULT NULL,
  `baths` tinyint unsigned DEFAULT NULL,
  `area` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `developer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','sold','rented','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `is_off_plan` tinyint(1) NOT NULL DEFAULT '0',
  `tags` json DEFAULT NULL,
  `views_count` bigint unsigned NOT NULL DEFAULT '0',
  `saves_count` bigint unsigned NOT NULL DEFAULT '0',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `listings_created_by_foreign` (`created_by`),
  KEY `listings_listing_type_status_index` (`listing_type`,`status`),
  KEY `listings_city_area_index` (`city`,`area`),
  KEY `listings_created_at_index` (`created_at`),
  CONSTRAINT `listings_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
INSERT INTO `listings` VALUES (1,1,'sale','Elite Penthouse',8800000.00,'AED',3450.00,4,5,'Dubai Marina','Sector 4',NULL,NULL,'active',1,'[\"EXCLUSIVE\", \"DISTRESS\"]',2,45,NULL,'2026-03-23 05:32:08','2026-03-25 05:32:08'),(2,2,'requirement','Looking for 2BHK + Study',3500000.00,'AED',NULL,2,2,'Downtown Dubai • Urgent requirement',NULL,NULL,NULL,'active',0,'[\"URGENT\"]',0,0,NULL,'2026-03-25 03:32:08','2026-03-25 05:32:08'),(3,3,'rent','Modern Studio',65000.00,'AED',480.00,1,1,'Jumeirah Village Circle',NULL,NULL,NULL,'active',1,'[]',2,45,NULL,'2026-03-17 05:32:08','2026-03-25 05:32:08'),(4,4,'requirement','Need 1BHK for 12 months',85000.00,'AED',NULL,1,1,'JLT • Ready to move next month',NULL,NULL,NULL,'active',0,'[\"RENT REQUEST\"]',0,0,NULL,'2026-03-24 05:32:08','2026-03-25 05:32:08'),(5,13,'sale','Apartment',1600000.00,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"EXCLUSIVE\", \"URGENT\"]',0,0,NULL,'2026-04-10 06:19:40','2026-04-10 06:19:40'),(6,13,'sale','Apartment',1600000.00,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"EXCLUSIVE\", \"URGENT\"]',0,0,NULL,'2026-04-10 06:28:37','2026-04-10 06:28:37'),(7,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-10 06:55:16','2026-04-10 06:55:16'),(8,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 02:19:57','2026-04-13 02:19:57'),(9,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 02:22:33','2026-04-13 02:22:33'),(10,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 04:02:56','2026-04-13 04:02:56'),(11,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 04:08:09','2026-04-13 04:08:09'),(12,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 04:08:19','2026-04-13 04:08:19'),(13,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 04:14:28','2026-04-13 04:14:28'),(14,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 06:10:50','2026-04-13 06:10:50'),(15,13,'sale','Untitled Post',NULL,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"NEW\", \"URGENT\", \"EXCLUSIVE\"]',0,0,NULL,'2026-04-13 06:33:03','2026-04-13 06:33:03'),(16,13,'sale','Untitled Post',NULL,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"NEW\", \"EXCLUSIVE\"]',0,0,NULL,'2026-04-13 06:34:43','2026-04-13 06:34:43'),(17,13,'sale','Untitled Post',NULL,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"NEW\", \"EXCLUSIVE\"]',0,0,NULL,'2026-04-13 09:34:48','2026-04-13 09:34:48'),(18,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 09:41:19','2026-04-13 09:41:19'),(19,13,'sale','Untitled Post',NULL,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"NEW\", \"URGENT\", \"DISTRESS\", \"EXCLUSIVE\"]',0,0,NULL,'2026-04-13 09:49:36','2026-04-13 09:49:36'),(20,13,'sale','Untitled Post',NULL,'AED',NULL,3,NULL,NULL,NULL,NULL,NULL,'active',0,'[\"NEW\", \"URGENT\", \"EXCLUSIVE\"]',0,0,NULL,'2026-04-13 09:55:53','2026-04-13 09:55:53'),(21,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 10:00:56','2026-04-13 10:00:56'),(22,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-13 11:19:56','2026-04-13 11:19:56'),(23,13,'sale','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-14 01:40:18','2026-04-14 01:40:18'),(24,13,'requirement','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-14 04:21:46','2026-04-14 04:21:46'),(25,13,'rent','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-14 04:48:16','2026-04-14 04:48:16'),(26,13,'rent','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',1,'[]',0,0,NULL,'2026-04-14 05:04:54','2026-04-14 05:04:54'),(27,13,'rent','Untitled Post',NULL,'AED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',0,'[]',0,0,NULL,'2026-04-14 05:12:18','2026-04-14 05:12:18');
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_resets_table',1),(3,'2019_08_19_000000_create_failed_jobs_table',1),(4,'2019_12_14_000001_create_personal_access_tokens_table',1),(5,'2026_02_12_000001_add_closex_fields_to_users_table',1),(6,'2026_02_12_000002_create_broker_profiles_table',1),(7,'2026_02_12_000003_create_agencies_table',1),(8,'2026_02_12_000004_create_listings_table',1),(9,'2026_02_12_000005_create_listing_details_table',1),(10,'2026_02_12_000006_create_listing_media_table',1),(11,'2026_02_12_000007_create_favorites_table',1),(12,'2026_02_12_000008_create_saved_searches_table',1),(13,'2026_02_12_000009_create_posts_table',1),(14,'2026_03_30_000001_add_first_last_name_to_users_table',2),(15,'2026_03_30_000002_add_oauth_provider_ids_to_users_table',3),(16,'2026_04_09_000001_add_profile_preferences_and_agency_assets',4);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (1,'App\\Models\\User',5,'auth_token','c72604b2a37e13ea2ddaf1d38a3f2f48adaa37354ae1014785b68cd97b15638f','[\"*\"]',NULL,'2026-03-26 06:19:05','2026-03-26 06:19:05'),(2,'App\\Models\\User',5,'auth_token','bb0ec1f43a22beb28b46fb7ea3652f2fcc9978ddac44c2482a11d499daff633f','[\"*\"]',NULL,'2026-03-26 06:33:18','2026-03-26 06:33:18'),(3,'App\\Models\\User',5,'auth_token','6095e3f0e637ec99a5e69cb6d2d1d760711e67f99236a0bf0fa9e259a13761c9','[\"*\"]',NULL,'2026-03-26 06:38:00','2026-03-26 06:38:00'),(4,'App\\Models\\User',5,'auth_token','7f64564502e93dc5c58d29094bf96e34bc8131f31a3d94d00a6f162636e7d609','[\"*\"]',NULL,'2026-03-30 01:35:34','2026-03-30 01:35:34'),(5,'App\\Models\\User',5,'auth_token','c9b72939b0bed0ca5b07b6f75682f7e4a23c6b0e59a79db685ab08f630b9b541','[\"*\"]',NULL,'2026-03-30 01:37:14','2026-03-30 01:37:14'),(6,'App\\Models\\User',5,'auth_token','de719a1a1713d0e2cad28b505e8b83e11cc742ec5592e4c7c120ce492b72c530','[\"*\"]',NULL,'2026-03-30 01:46:26','2026-03-30 01:46:26'),(7,'App\\Models\\User',5,'auth_token','3f7dbb39093a10f9c232bb25103711243dec34192b9495cd1e5ddb63bd84b905','[\"*\"]',NULL,'2026-03-30 02:15:53','2026-03-30 02:15:53'),(8,'App\\Models\\User',5,'auth_token','e81ea201bac0fed9be09efba66809b04e6c58b3ea171e07905ab8084ef2b000f','[\"*\"]',NULL,'2026-03-30 02:17:29','2026-03-30 02:17:29'),(9,'App\\Models\\User',5,'auth_token','fc56d17350b1c04f99323292ddcce8ce24859adbc7cf3ac439bdaee0bd93d47e','[\"*\"]',NULL,'2026-03-30 02:19:19','2026-03-30 02:19:19'),(10,'App\\Models\\User',5,'auth_token','d5f621a9d6428fe00c9a2480593c0f4e6c5a716201011977c2611d2c37429c58','[\"*\"]',NULL,'2026-03-30 02:19:54','2026-03-30 02:19:54'),(11,'App\\Models\\User',5,'auth_token','f9cc7738affe6556619ccae2eb0817c955caf9d8b83a1236298bbad6c5db1ae0','[\"*\"]',NULL,'2026-03-30 02:23:24','2026-03-30 02:23:24'),(12,'App\\Models\\User',5,'auth_token','14127a4b1c5254bc06f2468f42a1dd5cc32c618429eabf67cad255e67926bebd','[\"*\"]',NULL,'2026-03-30 02:23:40','2026-03-30 02:23:40'),(13,'App\\Models\\User',6,'auth_token','5086dae135ed7adfaf03fb01bf0329b9a5298ef94f2986652673732fea169673','[\"*\"]',NULL,'2026-03-30 02:26:19','2026-03-30 02:26:19'),(14,'App\\Models\\User',5,'auth_token','3a35b17aba765baa582e542dfa8b4d8ebe19b8b24970be28a5b4a5f7563d76fe','[\"*\"]',NULL,'2026-03-30 02:29:47','2026-03-30 02:29:47'),(15,'App\\Models\\User',5,'auth_token','6b64d7415e80466714bfbb9b93f42f790937003d89552c4750684dbebef3c24f','[\"*\"]',NULL,'2026-03-30 03:05:31','2026-03-30 03:05:31'),(16,'App\\Models\\User',7,'auth_token','e256934428d48590a999c0862bd4a8d66b95604d9d9cdd9c3338d5f03c1ae039','[\"*\"]',NULL,'2026-03-30 03:19:05','2026-03-30 03:19:05'),(17,'App\\Models\\User',8,'auth_token','21cf7d28b13a610fccf9b74001309bfe8a948aa1222e929fc23da12d807973bd','[\"*\"]',NULL,'2026-03-30 03:24:23','2026-03-30 03:24:23'),(18,'App\\Models\\User',9,'auth_token','036bfd5fefa8aad695cb043ec2b3044829770888bfef77cebde2330ebfc8e822','[\"*\"]',NULL,'2026-03-30 03:25:52','2026-03-30 03:25:52'),(19,'App\\Models\\User',10,'auth_token','b67778fd9397d279fbeaeee965dc4649a1cf43aac1ae60cc9e8f307b01fff7a9','[\"*\"]',NULL,'2026-03-30 03:27:25','2026-03-30 03:27:25'),(20,'App\\Models\\User',11,'auth_token','9bacdb06a76398799a98e07f7f0fcdfc6c40c15ded7e0d34c3e0b0b5bbdaffe8','[\"*\"]',NULL,'2026-03-30 03:39:21','2026-03-30 03:39:21'),(21,'App\\Models\\User',12,'auth_token','c3a790b5923b68fa39abdd02c12756846854982ef614b650f9e67269f25ca2a6','[\"*\"]',NULL,'2026-03-30 03:53:15','2026-03-30 03:53:15'),(22,'App\\Models\\User',13,'auth_token','897fa6c1032b0b64878d6e08b88ee8f7ac16f77c8ae8fb1c5203aae5da96caff','[\"*\"]',NULL,'2026-03-30 03:57:43','2026-03-30 03:57:43'),(23,'App\\Models\\User',13,'auth_token','7c99ecf50975446aaedadd9031345eaf6013c891a72052f579ad44d722805800','[\"*\"]',NULL,'2026-03-30 03:59:45','2026-03-30 03:59:45'),(24,'App\\Models\\User',13,'auth_token','7fa65e100dbbc11b81425f6d5f269b3adeccbea0773dd78ae700af3310c94b94','[\"*\"]',NULL,'2026-03-31 06:44:07','2026-03-31 06:44:07'),(25,'App\\Models\\User',5,'auth_token','1075c7ef50785c9ac93798e1ecce411dde6519cd3a6c6930e3a0b56eea0c4093','[\"*\"]',NULL,'2026-04-03 06:10:55','2026-04-03 06:10:55'),(26,'App\\Models\\User',13,'auth_token','43ee589c672e4f4d408d60a1660f71acd76c623662254c290a56f0fe8b3399db','[\"*\"]',NULL,'2026-04-03 06:11:01','2026-04-03 06:11:01'),(27,'App\\Models\\User',13,'auth_token','574e3d56ca38e482c23012df22391d52d510997ee7bb6445562a21ab00c11781','[\"*\"]',NULL,'2026-04-03 06:12:30','2026-04-03 06:12:30'),(28,'App\\Models\\User',13,'auth_token','2b2337d237b88e801b9ba3ada9be84de5ff5a4e976804caf4c68b470bc352e5d','[\"*\"]',NULL,'2026-04-08 04:05:37','2026-04-08 04:05:37'),(29,'App\\Models\\User',13,'auth_token','d79d07f39c9bcf829351a341ec3d8a833eaba14a75c64207d250b5f68f936a81','[\"*\"]',NULL,'2026-04-08 04:15:07','2026-04-08 04:15:07'),(30,'App\\Models\\User',13,'auth_token','c0c4c464d725ac6d8c6d63892063e5c0c9dc5df255e485407c75c568015dacc9','[\"*\"]',NULL,'2026-04-08 04:36:57','2026-04-08 04:36:57'),(31,'App\\Models\\User',13,'auth_token','10465a0ce848a2a8f6553e9350ca3a24a6773473a34d373823bce3ad39799941','[\"*\"]',NULL,'2026-04-08 09:26:11','2026-04-08 09:26:11'),(32,'App\\Models\\User',13,'auth_token','24dc1cdfb508ed120de8a9a492070a33c49da9514b39d20686088bd3b21b01b8','[\"*\"]',NULL,'2026-04-08 09:35:42','2026-04-08 09:35:42'),(33,'App\\Models\\User',13,'auth_token','38cae7ae62fdc89fe6ff3b6488480d0f2b3357d402f18170b5eda19e1c3ab3ad','[\"*\"]',NULL,'2026-04-08 10:21:40','2026-04-08 10:21:40'),(34,'App\\Models\\User',13,'auth_token','57f9514ad3efb3e025ca16f605e26e70f1f49604481897363be03510fd349b24','[\"*\"]',NULL,'2026-04-08 10:28:59','2026-04-08 10:28:59'),(35,'App\\Models\\User',13,'auth_token','874d2d85c139bbe40980f0c46eab2f6ecee940efc03f8accc55c58c017e426d3','[\"*\"]',NULL,'2026-04-08 10:57:55','2026-04-08 10:57:55'),(36,'App\\Models\\User',13,'auth_token','24bf438885496492bcaf5dcf1cc298ecf63a4c27a626e6e937ff409305d61618','[\"*\"]',NULL,'2026-04-08 11:13:21','2026-04-08 11:13:21'),(37,'App\\Models\\User',13,'auth_token','ada4627a2cec539bac88557f8370a0fd26c2bf0fca460f4bff3a2b2c2740aba5','[\"*\"]',NULL,'2026-04-09 01:05:22','2026-04-09 01:05:22'),(38,'App\\Models\\User',13,'auth_token','5999cc1c5c677252f7257344d86712ec6730bb5a5b7ac60cabafea5b50d69442','[\"*\"]',NULL,'2026-04-09 01:08:48','2026-04-09 01:08:48'),(39,'App\\Models\\User',13,'auth_token','5a2096dee7302a5bea5caa9a8e08b7ee91eebb629587f50dd273308a02935bb1','[\"*\"]',NULL,'2026-04-09 01:28:25','2026-04-09 01:28:25'),(40,'App\\Models\\User',13,'auth_token','b3ec1874777f7c890b153353e9549fa17f0dd08c94cb142c2086dbb3bd4e59a8','[\"*\"]',NULL,'2026-04-09 01:37:07','2026-04-09 01:37:07'),(41,'App\\Models\\User',5,'auth_token','d03e4706f15b7dbe84249496f9c7e4c14ff8ff63c1b7b1a558e0837c316a9d75','[\"*\"]',NULL,'2026-04-09 01:43:29','2026-04-09 01:43:29'),(42,'App\\Models\\User',13,'auth_token','30e19609a5edcbe7c27e055f921a4815e6fe957ae91ae9b1f22c9a10131dbd8e','[\"*\"]',NULL,'2026-04-09 01:49:31','2026-04-09 01:49:31'),(43,'App\\Models\\User',5,'auth_token','0dfefc9cfbb138356efbc09d1767144e9ed3b13ec43bcbd39ce7ad4048eb7109','[\"*\"]',NULL,'2026-04-09 02:54:44','2026-04-09 02:54:44'),(44,'App\\Models\\User',13,'auth_token','0674f7975a3290c182f48af8aed4ba56032974c87c733c64454cd7af9b14c7e7','[\"*\"]','2026-04-09 11:34:15','2026-04-09 02:56:20','2026-04-09 11:34:15'),(45,'App\\Models\\User',5,'auth_token','210aad279b592dae4d8a5ac57f8d9eb001bb17eecc5549994c6630b253119455','[\"*\"]',NULL,'2026-04-09 03:17:26','2026-04-09 03:17:26'),(46,'App\\Models\\User',13,'auth_token','29075562b205cfeda12f611b31fc8280372bc7f13d6898b83557cf7029920696','[\"*\"]',NULL,'2026-04-09 04:12:17','2026-04-09 04:12:17'),(47,'App\\Models\\User',14,'auth_token','c0595fea030259a7bc1a6b78588b2fafd4a0092660ee6b80482647d74e861c8a','[\"*\"]',NULL,'2026-04-09 04:12:19','2026-04-09 04:12:19'),(48,'App\\Models\\User',14,'auth_token','ddbc8946b80eb23e5b2c3ff898eacf041d27d807119f67e75a25f7e8dc88216d','[\"*\"]',NULL,'2026-04-09 04:15:53','2026-04-09 04:15:53'),(49,'App\\Models\\User',14,'auth_token','a3923b980528a6a8917aa38639df4cb6ceab17a466d5830d8803e71153df7f61','[\"*\"]',NULL,'2026-04-09 04:18:14','2026-04-09 04:18:14'),(50,'App\\Models\\User',14,'auth_token','630599930bd76695ff7848cb40d743ffd8098c28f1dfda18505e33f9a51c2c47','[\"*\"]',NULL,'2026-04-09 04:33:46','2026-04-09 04:33:46'),(51,'App\\Models\\User',14,'auth_token','80bab27bdd04397d87c006ddc3dfdf35b5f797eac47f427b9fe20c00507e290a','[\"*\"]',NULL,'2026-04-09 04:35:16','2026-04-09 04:35:16'),(52,'App\\Models\\User',14,'auth_token','caf3ca485238c0fe83185373fa6387e389388c490b8720067fb1879c51775458','[\"*\"]',NULL,'2026-04-09 04:37:53','2026-04-09 04:37:53'),(53,'App\\Models\\User',14,'auth_token','f4d662489eeebf5fdf6f8eca43f5d1190d94cb0cb20f3dab5145460847f33613','[\"*\"]',NULL,'2026-04-09 04:38:09','2026-04-09 04:38:09'),(54,'App\\Models\\User',14,'auth_token','6763fda39fbee7892ee389b0a60b18d06a74baf4fc725e4418421ea590d2d23b','[\"*\"]',NULL,'2026-04-09 04:39:54','2026-04-09 04:39:54'),(55,'App\\Models\\User',13,'auth_token','d5491e11a9e730ae686e3079df1a12303c79a65d8a858ae7f87831fb00fae317','[\"*\"]',NULL,'2026-04-09 05:15:03','2026-04-09 05:15:03'),(56,'App\\Models\\User',13,'auth_token','1d8f608c31843d6e526c18df378649258bbb4ab5467197c6c5b2f6bf01678c17','[\"*\"]',NULL,'2026-04-09 05:18:31','2026-04-09 05:18:31'),(57,'App\\Models\\User',13,'auth_token','332859a5416b1e5aebaaf0b997c7dc0913c9810776bbdcb0c5358133afbce28a','[\"*\"]',NULL,'2026-04-09 05:22:10','2026-04-09 05:22:10'),(58,'App\\Models\\User',13,'auth_token','7d3f6f684c5c5f01ce5cfb193ae37840ec8333e495865204b5c0c6669b40d702','[\"*\"]',NULL,'2026-04-09 05:24:31','2026-04-09 05:24:31'),(59,'App\\Models\\User',13,'auth_token','dba899b822cd61946fbfe52894f14f1e098874e5a204e72b4d76e1bb240395a4','[\"*\"]',NULL,'2026-04-09 05:28:59','2026-04-09 05:28:59'),(60,'App\\Models\\User',15,'auth_token','3f416823071a077f5b8596c27e2269be88acfc19616db554ae5228bd8d4224f2','[\"*\"]',NULL,'2026-04-09 06:40:05','2026-04-09 06:40:05'),(61,'App\\Models\\User',15,'auth_token','8be6a4ea1569e43e786545492c60aa006654a9fef07a215b0f97a0b07fa8e25d','[\"*\"]',NULL,'2026-04-09 06:44:35','2026-04-09 06:44:35'),(62,'App\\Models\\User',14,'auth_token','305143fc4b2848060f0681f289a577ddb68d42817aadc069e4fdac1bbd69fafa','[\"*\"]',NULL,'2026-04-09 07:05:38','2026-04-09 07:05:38'),(63,'App\\Models\\User',14,'auth_token','ef1a5eabfdde8c6c04c04e20cf9f994f31dbf616efcd554bc204f6b8a0a1a131','[\"*\"]',NULL,'2026-04-09 07:07:19','2026-04-09 07:07:19'),(64,'App\\Models\\User',13,'auth_token','daea5c7df6496d1987331f9945548ce159ea62dac2254f59e47616ad696aaa68','[\"*\"]',NULL,'2026-04-09 08:36:17','2026-04-09 08:36:17'),(65,'App\\Models\\User',5,'auth_token','2dad5770110d4ed058c0d139ff94e5bfa44ef8cf052568ebb265d8e6b46177ec','[\"*\"]',NULL,'2026-04-09 09:28:33','2026-04-09 09:28:33'),(66,'App\\Models\\User',13,'auth_token','2006b97fe10c4d6f042a5fcbb7a1c3ca8b346f10e7757ab86dfbb74ea3030dd6','[\"*\"]',NULL,'2026-04-09 09:29:27','2026-04-09 09:29:27'),(67,'App\\Models\\User',13,'auth_token','105d2378fcd38a6fcf5ef7b4c37cef0d2bdfda2841421532fc7a03a796c3711e','[\"*\"]',NULL,'2026-04-09 09:39:54','2026-04-09 09:39:54'),(68,'App\\Models\\User',13,'auth_token','eb8da09f8bcb4a696719275b691f92416827118e773a68f66fb05a6dc72d71aa','[\"*\"]',NULL,'2026-04-09 10:28:38','2026-04-09 10:28:38'),(69,'App\\Models\\User',13,'auth_token','f3d2fbd3885c2cc88404f7a8207247f0c8ab7adc05e6aef63a0c12e5f240205f','[\"*\"]','2026-04-09 11:42:19','2026-04-09 10:35:51','2026-04-09 11:42:19'),(70,'App\\Models\\User',13,'auth_token','b12636291fbfd3ffcee5337d7a9c17a21fec069d546a47a87035f2ee64183ac9','[\"*\"]','2026-04-09 11:49:46','2026-04-09 11:43:08','2026-04-09 11:49:46'),(71,'App\\Models\\User',14,'auth_token','c5acdb8c31829061bb0909f2611071137792d20e81bd45e446c9a617142cbdfb','[\"*\"]',NULL,'2026-04-09 11:54:43','2026-04-09 11:54:43'),(72,'App\\Models\\User',13,'auth_token','2d369b0a3f1896162a29e83f6a914e2580a9854713be9a9362d34bc3cf5fc8ee','[\"*\"]',NULL,'2026-04-09 11:56:05','2026-04-09 11:56:05'),(73,'App\\Models\\User',14,'auth_token','62363f5cd6f1899a7dd720c5d0c6c3a045a13e04ff8f85a9adaa971cb0dd146c','[\"*\"]',NULL,'2026-04-09 12:03:08','2026-04-09 12:03:08'),(74,'App\\Models\\User',13,'auth_token','9f9d79c258be09f6ad747cdc7e3a855af847af790300f64c8a6313f000cff139','[\"*\"]',NULL,'2026-04-09 12:07:41','2026-04-09 12:07:41'),(75,'App\\Models\\User',14,'auth_token','803454182f7907f5ad0a4dcfd44fe1c7f96e76d203d4e591887e32f6a3bda066','[\"*\"]',NULL,'2026-04-09 12:08:03','2026-04-09 12:08:03'),(76,'App\\Models\\User',14,'auth_token','42fc107637be3519a64bd689c2350ae8b10ffd2cf0682d30ffe420130d7a1ac0','[\"*\"]',NULL,'2026-04-09 12:10:28','2026-04-09 12:10:28'),(77,'App\\Models\\User',13,'auth_token','15910b7cdf16f16eac7b8fbbe279a09342881937df0c73ba1ceb005f351dfd7d','[\"*\"]',NULL,'2026-04-09 12:10:40','2026-04-09 12:10:40'),(78,'App\\Models\\User',14,'auth_token','3a37d4855c5b566057275aad2c1d968a9ebfc685c990a23e08b0d1b0903fdd27','[\"*\"]',NULL,'2026-04-09 12:14:28','2026-04-09 12:14:28'),(79,'App\\Models\\User',13,'auth_token','7b02927666e80688ad8203822c395f6ca4bda78eecc3a84c538fcafa5f2262d4','[\"*\"]',NULL,'2026-04-09 12:14:45','2026-04-09 12:14:45'),(80,'App\\Models\\User',13,'auth_token','f3bee2ea0dc0bb374f0c8fdb1be8c3d2d6128c6680eb0adc21231b08c5b7b459','[\"*\"]',NULL,'2026-04-10 00:41:34','2026-04-10 00:41:34'),(81,'App\\Models\\User',13,'auth_token','a7514daad0925995bc55ec1e988f5351892ca55979f3191d02c4d28ba7c9c16a','[\"*\"]',NULL,'2026-04-10 04:09:37','2026-04-10 04:09:37'),(82,'App\\Models\\User',13,'auth_token','5d20b49d7d2b21f43355e168362286dc840af52a7a4ac5c164173e0e6fd09aa0','[\"*\"]',NULL,'2026-04-10 04:33:56','2026-04-10 04:33:56'),(83,'App\\Models\\User',14,'auth_token','2fd277763ab5f1839730fc253d920d9fa676a053db215307cbca64f045af756e','[\"*\"]',NULL,'2026-04-10 05:09:22','2026-04-10 05:09:22'),(84,'App\\Models\\User',13,'auth_token','b51edd0af456c1a2b7069707c8fca267e2a006fa664ea2aa23e786c53af46e3a','[\"*\"]',NULL,'2026-04-10 05:09:38','2026-04-10 05:09:38'),(85,'App\\Models\\User',13,'auth_token','d40d20f6a793a96338a032ebb061f7492b9a5b94e23d218d1608330ce8ad370a','[\"*\"]',NULL,'2026-04-10 05:30:59','2026-04-10 05:30:59'),(86,'App\\Models\\User',13,'auth_token','e25c5796c1772cac64369d6304ec67363f2de912032a0ab9631deab1216ab016','[\"*\"]',NULL,'2026-04-10 05:51:41','2026-04-10 05:51:41'),(87,'App\\Models\\User',13,'auth_token','bbda9309d94ba506bbfa47d8d1857e492fa173920d0448b0bb4991363f554c95','[\"*\"]',NULL,'2026-04-10 06:02:05','2026-04-10 06:02:05'),(88,'App\\Models\\User',13,'auth_token','9c35fd0760de919a31d41744af899fcd1c146e41a284a8a97a56f6927667f2c0','[\"*\"]','2026-04-14 05:04:54','2026-04-10 06:08:43','2026-04-14 05:04:54'),(89,'App\\Models\\User',13,'auth_token','2c5f5ce5a51d8ee7f408a45ca603a4df4caa6ddb6f7e0f9e6b5277e813b70c84','[\"*\"]',NULL,'2026-04-10 06:33:11','2026-04-10 06:33:11'),(90,'App\\Models\\User',13,'auth_token','41b4856371e6d57c1fd4776807df9cb80dcdf289f39128dbe73f5d093f0cdd8c','[\"*\"]',NULL,'2026-04-13 02:13:12','2026-04-13 02:13:12'),(91,'App\\Models\\User',13,'auth_token','46208059ac55b64b46ebab1e0dc0587858e197aa0dab778d59b2d1b0a247e927','[\"*\"]',NULL,'2026-04-13 02:39:44','2026-04-13 02:39:44'),(92,'App\\Models\\User',13,'auth_token','617a5880997d5df36086768efb06b8036fba4e259ca90f629b0c97eca92455e2','[\"*\"]',NULL,'2026-04-13 02:40:56','2026-04-13 02:40:56'),(93,'App\\Models\\User',13,'auth_token','3814aec76f66ebda6597285a7e3240ad25eb95a0e93e3a626ffdc933d1333669','[\"*\"]',NULL,'2026-04-13 05:04:08','2026-04-13 05:04:08'),(94,'App\\Models\\User',13,'auth_token','098ec722b5fb496c332a37aee5db70bd69d77c9b33d3a96630c468d86720cef3','[\"*\"]',NULL,'2026-04-13 05:17:09','2026-04-13 05:17:09'),(95,'App\\Models\\User',13,'auth_token','a56c7002cee2a18eaf78db3626a5d0c2d12c116e8f93754af2c40c38c530ddcc','[\"*\"]',NULL,'2026-04-13 05:27:25','2026-04-13 05:27:25'),(96,'App\\Models\\User',13,'auth_token','31d40f8010c9cb0f28618c445f03060f2c4dfc00a6c9be7f8eafc81bdea24ea7','[\"*\"]',NULL,'2026-04-13 05:40:07','2026-04-13 05:40:07'),(97,'App\\Models\\User',13,'auth_token','ccfedb9261a3283c7020fd0b9f78c169c158bf187e4c09b800865b5b23a5e8d0','[\"*\"]',NULL,'2026-04-13 05:43:09','2026-04-13 05:43:09'),(98,'App\\Models\\User',13,'auth_token','0af940410d56d69c554d7bdfff2734378df4b485daa59b1b6a68be3289ccb1fa','[\"*\"]',NULL,'2026-04-13 06:02:21','2026-04-13 06:02:21'),(99,'App\\Models\\User',13,'auth_token','23a37ecad15dd78be358c6751026d75d65d6982b3a0960edb222e0597efbc0c2','[\"*\"]',NULL,'2026-04-13 06:13:04','2026-04-13 06:13:04'),(100,'App\\Models\\User',13,'auth_token','6a0699ca7bfa81a053fff5275aa081c6861332ba6818bfbd3de0a5835f213465','[\"*\"]',NULL,'2026-04-13 06:21:04','2026-04-13 06:21:04'),(101,'App\\Models\\User',13,'auth_token','b056e9b38e0f155c6c349a7587320554054c70a09fd566e28c8421348b60aea2','[\"*\"]',NULL,'2026-04-13 06:24:47','2026-04-13 06:24:47'),(102,'App\\Models\\User',13,'auth_token','7bcd1ec36ff66e2ec5f21535db964c33aa50e81a68d8435d4713616c778fbaa0','[\"*\"]','2026-04-13 06:34:43','2026-04-13 06:32:28','2026-04-13 06:34:43'),(103,'App\\Models\\User',13,'auth_token','a9f6f5c232cf67cc685041b56f30ea89da3ff651c06bb84e398013b9cb631da4','[\"*\"]','2026-04-13 09:34:48','2026-04-13 09:33:42','2026-04-13 09:34:48'),(104,'App\\Models\\User',13,'auth_token','7fe51d7a37700dda88e1ac91999052f923f5689350ab13dbbc1d5a27b01663a2','[\"*\"]','2026-04-13 09:49:36','2026-04-13 09:35:55','2026-04-13 09:49:36'),(105,'App\\Models\\User',13,'auth_token','ad252957ebac95e7ce16346d4203cbc6d72e51c7bf45f2f8f7fb4a98f3731345','[\"*\"]','2026-04-13 09:55:53','2026-04-13 09:50:39','2026-04-13 09:55:53'),(106,'App\\Models\\User',13,'auth_token','dcd3782f0008c55273b7c4cff369c831be3a069d75b5e1429fba52f6068a658b','[\"*\"]','2026-04-13 11:06:56','2026-04-13 10:15:37','2026-04-13 11:06:56'),(107,'App\\Models\\User',13,'auth_token','54a6ded39fe2f71829236db8a7c47ee37a5d96b2d1214d822eab83bc1b81ccdd','[\"*\"]','2026-04-13 11:18:16','2026-04-13 11:12:52','2026-04-13 11:18:16'),(108,'App\\Models\\User',13,'auth_token','963ac9c45f8f2ac597d335f67995a3460d67639ead4a6ff9d060f85873b17ca6','[\"*\"]',NULL,'2026-04-13 11:28:50','2026-04-13 11:28:50'),(109,'App\\Models\\User',13,'auth_token','7a2f0dbcb867274e6ce5eda921369709f27720ff3c37140615a5f33addb6e6fe','[\"*\"]',NULL,'2026-04-13 12:00:05','2026-04-13 12:00:05'),(110,'App\\Models\\User',13,'auth_token','5e9e879791f89a26bb5519c8b90d71c287fa2736a7817c402b574eb350a76593','[\"*\"]',NULL,'2026-04-14 04:16:07','2026-04-14 04:16:07'),(111,'App\\Models\\User',13,'auth_token','dbd77ff3467c7df573b14e97a0690a3dad04485c1fc77b62fad0b977452c895a','[\"*\"]','2026-04-14 05:00:28','2026-04-14 04:44:22','2026-04-14 05:00:28'),(112,'App\\Models\\User',13,'auth_token','bedf81e771b4406402b11a4f5fc1fb49bc3efb961fd15af9e2930bfacacf43f2','[\"*\"]','2026-04-14 05:12:18','2026-04-14 05:06:52','2026-04-14 05:12:18');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by` bigint unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `visibility` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_created_by_foreign` (`created_by`),
  CONSTRAINT `posts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_searches`
--

DROP TABLE IF EXISTS `saved_searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_searches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `filters` json NOT NULL,
  `alerts_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `saved_searches_user_id_foreign` (`user_id`),
  CONSTRAINT `saved_searches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_searches`
--

LOCK TABLES `saved_searches` WRITE;
/*!40000 ALTER TABLE `saved_searches` DISABLE KEYS */;
/*!40000 ALTER TABLE `saved_searches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agency_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apple_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('broker','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'broker',
  `status` enum('active','suspended','pending') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `language` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `messages_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `whatsapp_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `account_type` enum('personal','agency') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'personal',
  `last_active` timestamp NULL DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_phone_unique` (`phone`),
  UNIQUE KEY `users_google_id_unique` (`google_id`),
  UNIQUE KEY `users_facebook_id_unique` (`facebook_id`),
  UNIQUE KEY `users_apple_id_unique` (`apple_id`),
  KEY `users_agency_id_foreign` (`agency_id`),
  CONSTRAINT `users_agency_id_foreign` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Sarah Jenkins',NULL,NULL,'sarah@example.com',NULL,NULL,NULL,NULL,NULL,'broker','pending',NULL,NULL,1,1,1,'personal',NULL,'2026-03-25 05:32:08','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','QHZVCinxxH','2026-03-25 05:32:08','2026-03-25 05:32:08'),(2,2,'Ahmed Khan',NULL,NULL,'ahmed@example.com',NULL,NULL,NULL,NULL,NULL,'broker','pending',NULL,NULL,1,1,1,'personal',NULL,'2026-03-25 05:32:08','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','LAJJyahZ2O','2026-03-25 05:32:08','2026-03-25 05:32:08'),(3,3,'Maria Lee',NULL,NULL,'maria@example.com',NULL,NULL,NULL,NULL,NULL,'broker','pending',NULL,NULL,1,1,1,'personal',NULL,'2026-03-25 05:32:08','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','k4FLz6bb66','2026-03-25 05:32:08','2026-03-25 05:32:08'),(4,4,'Lynn Wong',NULL,NULL,'lynn@example.com',NULL,NULL,NULL,NULL,NULL,'broker','pending',NULL,NULL,1,1,1,'personal',NULL,'2026-03-25 05:32:09','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','qek4BcrsBI','2026-03-25 05:32:09','2026-03-25 05:32:09'),(5,NULL,'Muneeb Azhar',NULL,NULL,'muneeb@test.com','+971500000001',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$.NJma26x/9ZeirztEuQtd.QK5AAu42eYVFZlcEUs0b/bAeNdZsf/2',NULL,'2026-03-26 06:19:05','2026-03-26 06:19:05'),(6,NULL,'Muneeb Azhar',NULL,NULL,'muneeb123@test.com','+971500000002',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$zH7sBVgSnAtSotBRp5A/QOSmD9XhzD7HThtD/C79SELYLV9A7GOHi',NULL,'2026-03-30 02:26:19','2026-03-30 02:26:19'),(7,NULL,'Muneeb Azhar',NULL,NULL,'muneeb13@test.com','+971500000003',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$RPcq3TcU1tvTnRkOCNiVhu5dKesC5iiPTc2lmcC.bE3IPiM28r4Fq',NULL,'2026-03-30 03:19:05','2026-03-30 03:19:05'),(8,NULL,'Muneeb Azhar',NULL,NULL,'muneeb@4test.com','+971500000006',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$7rcd5w8y07AfLM3UjJxK2OeBVaCW.POw8Ck5RzMyEiUgHdMKXez7m',NULL,'2026-03-30 03:24:23','2026-03-30 03:24:23'),(9,NULL,'Muneeb Azhar',NULL,NULL,'muneeb@41test.com','+9715000000021',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$fp/i9bVe3Jh4bsNgJ7JjK.xNL9rFLP46kWHQI10KKrdMjj44taSGi',NULL,'2026-03-30 03:25:52','2026-03-30 03:25:52'),(10,NULL,'Muneeb Azhar',NULL,NULL,'muneeb@44test.com','+9715000000024',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$fdqMIL9tmWtwmZuHK0llJ.hssWF893SpKqqtAyor3vZKbl1/PPAIy',NULL,'2026-03-30 03:27:25','2026-03-30 03:27:25'),(11,NULL,'muneeb',NULL,NULL,'Muneeb @gmail.com','+971',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$nGpznkHV0qTl.DjbVT5hmOUcWDI0nZ5cn5000FCDzQmt70RxDul7.',NULL,'2026-03-30 03:39:21','2026-03-30 03:39:21'),(12,NULL,'Muneeb Azhar','Muneeb','Azhar','muneeb@444test.com','+97150000000244',NULL,NULL,NULL,NULL,'broker','active','en',NULL,1,1,1,'personal',NULL,NULL,'$2y$10$CSPgbscqKhOZulKKZhjnIedF5l5YkEXVeIOwRiiRq74Nh.A4g2/CG',NULL,'2026-03-30 03:53:15','2026-03-30 03:53:15'),(13,5,'Sami Ullah','Sami','Ullah','Sami@searlco.com','+923086181070',NULL,NULL,NULL,NULL,'broker','active','en','/storage/profiles/pictures/nGU1XBhcZTEZomUX0vj7sl0eV0FTSl2EIViUykMl.png',1,1,0,'personal',NULL,NULL,'$2y$10$FSlYKrmVMRG6PPv83.eIduu9NNFSAvJkf3yM3mIL6tYO7oODA7VCC',NULL,'2026-03-30 03:57:43','2026-04-09 11:49:45'),(14,NULL,'noraiz shamshad',NULL,NULL,'noraizshamshad60@gmail.com',NULL,'117897261584287989839',NULL,NULL,NULL,'broker','active',NULL,'https://lh3.googleusercontent.com/a/ACg8ocLOaeupCH8YEEun-CeiR4gEdAj1V9Bfstb3hOHUs1i9Mpba6Q=s96-c',1,1,1,'personal',NULL,NULL,'$2y$10$dvo2GZat/4gR58/ejbW.Xe2pq/zlJNsJKqSK5pJ/i1HOC2U/D9Dmy',NULL,'2026-04-09 04:12:19','2026-04-09 04:33:46'),(15,NULL,'Semi',NULL,NULL,'semi.u786@gmail.com',NULL,'105879016578946668493',NULL,NULL,NULL,'broker','active',NULL,'https://lh3.googleusercontent.com/a/ACg8ocIDrM5pL3KT6zWPq1uxTIRd5Wk4F8TVHo3zB8LBEUG-mkMX=s96-c',1,1,1,'personal',NULL,NULL,'$2y$10$LKc/RdyKMwc6g.8W4LSuYetIQRBUNQg9OizhbSPVBiKvK.galEvty',NULL,'2026-04-09 06:40:05','2026-04-09 06:40:05');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'close_x'
--

--
-- Dumping routines for database 'close_x'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-14 15:18:56
