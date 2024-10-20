CREATE DATABASE  IF NOT EXISTS `book_exchange` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `book_exchange`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: book_exchange
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `address_line1` varchar(255) DEFAULT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `address_line3` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,'No. 4','Molpe Road','Katubedda','Moratuwa','Colombo','10400'),(2,'No. 6','Molpe Road','Katubedda','Moratuwa','Colombo','10400'),(3,'No 8','Mill Road','Katubedda','Moratuwa','Colombo','10400');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(512) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `edition` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'The Odyssey','Homer','4th'),(2,'The Kite Runner','Khaled Hosseini','10th'),(4,'Crimes and Punishments','Fyodor Dostoevsky','5th'),(5,'The Great Gatsby','F. Scott Fitzgerald','3rd'),(6,'The Hobbit','J. R. R. Tolkein','5th'),(7,'The Lord of the Rings','J. R. R. Tolkein','50th');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_number`
--

DROP TABLE IF EXISTS `phone_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_number` (
  `phone_number` varchar(12) NOT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`phone_number`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `phone_number_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_number`
--

LOCK TABLES `phone_number` WRITE;
/*!40000 ALTER TABLE `phone_number` DISABLE KEYS */;
INSERT INTO `phone_number` VALUES ('0777777767',1),('0771234568',2),('0711111111',3);
/*!40000 ALTER TABLE `phone_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request`
--

DROP TABLE IF EXISTS `request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `requestor_id` int DEFAULT NULL,
  `receiver_id` int DEFAULT NULL,
  `requestor_book_id` int DEFAULT NULL,
  `receiver_book_id` int DEFAULT NULL,
  `request_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_status` enum('pending','accepted','confirmed','cancelled') DEFAULT NULL,
  `response_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `confirmation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  UNIQUE KEY `unique_pending_request` (`requestor_id`,`receiver_id`,`requestor_book_id`,`receiver_book_id`,`request_status`),
  KEY `receiver_id` (`receiver_id`),
  KEY `requestor_book_id` (`requestor_book_id`),
  KEY `receiver_book_id` (`receiver_book_id`),
  KEY `requestor_id` (`requestor_id`),
  CONSTRAINT `request_ibfk_1` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `request_ibfk_2` FOREIGN KEY (`requestor_book_id`) REFERENCES `user_book` (`user_book_id`),
  CONSTRAINT `request_ibfk_3` FOREIGN KEY (`receiver_book_id`) REFERENCES `user_book` (`user_book_id`),
  CONSTRAINT `request_ibfk_4` FOREIGN KEY (`requestor_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request`
--

LOCK TABLES `request` WRITE;
/*!40000 ALTER TABLE `request` DISABLE KEYS */;
INSERT INTO `request` VALUES (1,3,1,1,6,'2024-10-20 16:18:00','confirmed','2024-10-20 16:18:00','2024-10-20 16:18:00'),(2,2,1,2,5,'2024-10-20 16:17:49','confirmed','2024-10-20 16:17:49','2024-10-20 16:17:49'),(3,1,2,5,2,'2024-10-20 16:20:43','confirmed','2024-10-20 16:20:43','2024-10-20 16:20:43');
/*!40000 ALTER TABLE `request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'user1','testuser','user1@gmail.com','user1','0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e','Male'),(2,'user2','testuser','user2@gmail.com','user2','6cf615d5bcaac778352a8f1f3360d23f02f34ec182e259897fd6ce485d7870d4','Female'),(3,'user3','testuser','user3@gmail.com','user3','5906ac361a137e2d286465cd6588ebb5ac3f5ae955001100bc41577c3d751764','Male');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `create_wishlist` AFTER INSERT ON `user` FOR EACH ROW BEGIN
  INSERT INTO wishlist(user_id, created_at, updated_at)
  VALUES (NEW.user_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `user_id` int NOT NULL,
  `address_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`address_id`),
  KEY `address_id` (`address_id`),
  CONSTRAINT `user_address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user_address_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,1),(2,2),(3,3);
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_book`
--

DROP TABLE IF EXISTS `user_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_book` (
  `user_book_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `image_path` varchar(512) DEFAULT '/images/books/default_book.jpg',
  PRIMARY KEY (`user_book_id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `user_book_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user_book_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_book`
--

LOCK TABLES `user_book` WRITE;
/*!40000 ALTER TABLE `user_book` DISABLE KEYS */;
INSERT INTO `user_book` VALUES (1,1,1,'/images/books/user1_The_Odyssey.jpg'),(2,1,2,'/images/books/user1_The_Kite_Runner.jpg'),(4,2,4,'/images/books/user2_Crimes_and_Punishments.jpg'),(5,2,5,'/images/books/user2_The_Great_Gatsby.jpg'),(6,3,6,'/images/books/user3_The_Hobbit.jpg'),(7,3,7,'/images/books/user3_The_Lord_of_the_RIngs.jpg');
/*!40000 ALTER TABLE `user_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (1,1,'2024-10-20 12:14:09','2024-10-20 12:14:09'),(2,2,'2024-10-20 12:18:39','2024-10-20 12:18:39'),(3,3,'2024-10-20 12:21:54','2024-10-20 12:21:54');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist_item`
--

DROP TABLE IF EXISTS `wishlist_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist_item` (
  `wishlist_item_id` int NOT NULL AUTO_INCREMENT,
  `wishlist_id` int DEFAULT NULL,
  `book_id` int DEFAULT '0',
  `title` varchar(45) DEFAULT NULL,
  `author` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`wishlist_item_id`),
  KEY `wishlist_id` (`wishlist_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `wishlist_item_ibfk_1` FOREIGN KEY (`wishlist_id`) REFERENCES `wishlist` (`wishlist_id`),
  CONSTRAINT `wishlist_item_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist_item`
--

LOCK TABLES `wishlist_item` WRITE;
/*!40000 ALTER TABLE `wishlist_item` DISABLE KEYS */;
INSERT INTO `wishlist_item` VALUES (2,3,4,'Crimes and Punishments','Fyodor Dostoevsky'),(3,1,6,'The Hobbit','J. R. R. Tolkein'),(4,1,5,'The Great Gatsby','F. Scott Fitzgerald'),(5,2,7,'The Lord of the Rings','J. R. R. Tolkein');
/*!40000 ALTER TABLE `wishlist_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_book_in_wishlist` BEFORE INSERT ON `wishlist_item` FOR EACH ROW BEGIN
    DECLARE existing_book_id INT;

    -- Check if the book with matching title and author exists in the book table
    SELECT book_id INTO existing_book_id
    FROM book
    WHERE LOWER(title) = LOWER(NEW.title)
      AND LOWER(author) = LOWER(NEW.author)
    LIMIT 1;

    -- If the book exists, update the book_id in the new wishlist item
    IF existing_book_id IS NOT NULL THEN
        SET NEW.book_id = existing_book_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'book_exchange'
--

--
-- Dumping routines for database 'book_exchange'
--
/*!50003 DROP FUNCTION IF EXISTS `user_match_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `user_match_count`(user_id INT) RETURNS int
    DETERMINISTIC
BEGIN
  DECLARE match_count INT;
  SELECT COUNT(*) INTO match_count 
  FROM `match` 
  WHERE user1_id = user_id OR user2_id = user_id;
  RETURN match_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser`(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email_address VARCHAR(100),
    IN p_user_name VARCHAR(100),
    IN p_password VARCHAR(100),
    IN p_gender ENUM('Male','Female','Other'),
    IN p_phone_number VARCHAR(12),
    -- Input parameters for address
    IN p_address_line1_1 VARCHAR(255),
    IN p_address_line2_1 VARCHAR(255),
    IN p_address_line3_1 VARCHAR(255),
    IN p_city_1 VARCHAR(255),
    IN p_district_1 VARCHAR(255),
    IN p_postal_code_1 VARCHAR(255)
)
BEGIN
    -- Declare variables at the top of the procedure
    DECLARE last_user_id INT;
    DECLARE last_address_id1 INT;

    -- Insert into user table
    INSERT INTO user (first_name, last_name, email_address, user_name, password, gender, phone_number)
    VALUES (p_first_name, p_last_name, p_email_address, p_user_name, p_password, p_gender,p_phone_number);
    
    -- Get the last inserted user_id
    SET last_user_id = LAST_INSERT_ID();

    -- Insert the first address into the address table
    INSERT INTO address (address_line1, address_line2, address_line3, city, district, postal_code)
    VALUES (p_address_line1_1, p_address_line2_1, p_address_line3_1, p_city_1, p_district_1, p_postal_code_1);
    
    -- Get the last inserted address_id for the first address
    SET last_address_id1 = LAST_INSERT_ID();

    -- Insert into user_address table for the first address
    INSERT INTO user_address (user_id, address_id)
    VALUES (last_user_id, last_address_id1);
    
    -- Insert into phone_number table
    INSERT INTO phone_number (phone_number, user_id)
    VALUES (p_phone_number, last_user_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetBookDetailsByTitle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookDetailsByTitle`(
    IN p_title VARCHAR(512)
)
BEGIN
    -- Select book details, user_book details, and corresponding user details
    SELECT 
        b.book_id,
        b.title,
        b.author,
        b.edition,
        ub.user_id,
        u.user_name
    FROM 
        book b
    -- Join with the user_book table to get the user_id related to the book_id
    LEFT JOIN 
        user_book ub ON b.book_id = ub.book_id
    -- Join with the user table to get the user's name
    LEFT JOIN 
        user u ON ub.user_id = u.user_id
    -- Filter by the title provided as the input parameter
    WHERE 
        b.title = p_title;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetMatchingUsersForExchange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMatchingUsersForExchange`(
    IN current_user_id INT,          
    IN selected_book_id INT    
)
BEGIN
    -- Check if the selected_book_id is 0
    IF selected_book_id = 0 THEN
        SELECT 'No other users have this book' AS message;
    ELSE
        -- Select users who have the selected book in their user_book table
        SELECT u.user_id, u.user_name, a.city, a.district, wi.book_id AS wishlist_book_id, b.title, b.author
        FROM user u
        JOIN user_address ua ON u.user_id = ua.user_id
        JOIN address a ON ua.address_id = a.address_id
        JOIN user_book ub ON u.user_id = ub.user_id
        JOIN wishlist_item wi ON wi.wishlist_id = u.user_id
        JOIN book b ON wi.book_id = b.book_id
        WHERE ub.book_id = selected_book_id 
          AND u.user_id != current_user_id        
          AND wi.book_id IN (
              SELECT book_id
              FROM user_book
              WHERE user_id = current_user_id
          );

        -- If no rows are returned, return a message
        IF ROW_COUNT() = 0 THEN
            SELECT 'No other users have this book' AS message;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertRequest`(
    IN p_requestor_id INT,
    IN p_receiver_id INT,
    IN p_requestor_book_id INT,
    IN p_receiver_book_id INT
)
BEGIN
        INSERT INTO request (
            requestor_id,
            receiver_id,
            requestor_book_id,
            receiver_book_id,
            request_date,
            request_status,
            response_date
        ) VALUES (
            p_requestor_id,
            p_receiver_id,
            p_requestor_book_id,
            p_receiver_book_id,
            NOW(), -- Use the current date and time
            'pending', -- Set the request status to pending
            NULL -- response_date should be NULL initially
        );

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ManageUserBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ManageUserBook`(
    IN p_user_id INT,
    IN p_action ENUM('add', 'remove'),
    IN p_title VARCHAR(512),  -- Input for book title (only for 'add' action)
    IN p_author VARCHAR(255), -- Input for book author (only for 'add' action)
    IN p_edition VARCHAR(20),  -- Input for book edition (only for 'add' action)
    IN p_image_path VARCHAR(512)  -- Input for book image path (optional for 'add' action)
)
BEGIN
    DECLARE p_book_id INT;
    DECLARE existing_entry INT DEFAULT 0;

    -- If the action is 'add', add a book for the user in both book and user_book tables
    IF p_action = 'add' THEN
        -- Check if the book already exists in the book table
        SELECT book_id INTO p_book_id
        FROM book
        WHERE title = p_title AND author = p_author AND edition = p_edition
        LIMIT 1;

        -- If the book doesn't exist, insert it into the book table
        IF p_book_id IS NULL THEN
            INSERT INTO book (title, author, edition)
            VALUES (p_title, p_author, p_edition);

            -- Get the last inserted book_id from the book table
            SET p_book_id = LAST_INSERT_ID();
        END IF;

        -- Check if the book is already assigned to the user
        SELECT COUNT(*) INTO existing_entry
        FROM user_book
        WHERE user_id = p_user_id AND book_id = p_book_id;

        -- If the book is not already assigned, insert it into the user_book table
        IF existing_entry = 0 THEN
            IF p_image_path IS NOT NULL THEN
                -- Insert with image path if provided
                INSERT INTO user_book (user_id, book_id, image_path)
                VALUES (p_user_id, p_book_id, p_image_path);
            ELSE
                -- Insert without image path
                INSERT INTO user_book (user_id, book_id)
                VALUES (p_user_id, p_book_id);
            END IF;
        ELSE
            -- Handle if the book is already assigned to the user
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book already assigned to the user.';
        END IF;

    -- If the action is 'remove', remove the book from both tables
    ELSEIF p_action = 'remove' THEN
        -- Get the book_id based on the title, author, and edition
        SELECT book_id INTO p_book_id
        FROM book
        WHERE title = p_title AND author = p_author AND edition = p_edition
        LIMIT 1;

        -- Debugging: Check if the book_id was found
        IF p_book_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book not found.';
        END IF;

        -- Check if the book is assigned to the user
        SELECT COUNT(*) INTO existing_entry
        FROM user_book
        WHERE user_id = p_user_id AND book_id = p_book_id;

        -- If the book is assigned, proceed to remove it from both user_book and book tables
        IF existing_entry > 0 THEN
            -- Remove from user_book table
            DELETE FROM user_book
            WHERE user_id = p_user_id AND book_id = p_book_id;

            -- Optionally: Remove from book table if it's not needed anymore
            DELETE FROM book
            WHERE book_id = p_book_id;
        ELSE
            -- Handle if the book is not assigned to the user
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book not assigned to the user.';
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ManageWishlistItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ManageWishlistItem`(
    IN p_user_id INT,
    IN p_title VARCHAR(45),
    IN p_author VARCHAR(45),
    IN p_action VARCHAR(10)
)
BEGIN
    IF p_action = 'ADD' THEN
        -- Add book to wishlist
        INSERT INTO wishlist_item (wishlist_id, title, author)
        VALUES (p_user_id, p_title, p_author);
    
    ELSEIF p_action = 'REMOVE' THEN
        -- Remove book from wishlist
        DELETE FROM wishlist_item
        WHERE wishlist_id = p_user_id
        AND title = p_title
        AND author = p_author;
    
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid action specified. Use "ADD" or "REMOVE".';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdatePhoneNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdatePhoneNumber`(
    IN p_user_id INT,
    IN p_phone_number VARCHAR(12)
)
BEGIN
    -- Update the phone number for the user
    UPDATE phone_number
    SET phone_number = p_phone_number
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateRequestAndAccept` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRequestAndAccept`(
    IN p_requestor_id INT,
    IN p_receiver_id INT,
    IN p_requestor_book_id INT,
    IN p_receiver_book_id INT,
    IN p_action VARCHAR(10)
)
BEGIN
    DECLARE new_status VARCHAR(10);
    
    IF p_action = 'accept' THEN
        SET new_status = 'accepted';
    ELSEIF p_action = 'reject' THEN
        SET new_status = 'cancelled';
    END IF;

    -- Update the existing request where requestor_id, receiver_id, requestor_book_id, and receiver_book_id match
    UPDATE request
    SET 
        request_status = new_status,       -- Set status based on action
        response_date = NOW()              -- Set response_date to current timestamp
    WHERE 
        requestor_id = p_requestor_id
        AND receiver_id = p_receiver_id
        AND requestor_book_id = p_requestor_book_id
        AND receiver_book_id = p_receiver_book_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateRequestAndConfirm` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRequestAndConfirm`(
    IN p_requestor_id INT,
    IN p_receiver_id INT,
    IN p_requestor_book_id INT,
    IN p_receiver_book_id INT,
    IN p_action VARCHAR(10)
)
BEGIN
    DECLARE new_status VARCHAR(10);
    DECLARE existing_session_id INT;

    IF p_action = 'confirm' THEN
        SET new_status = 'confirmed';
    ELSEIF p_action = 'cancel' THEN
        SET new_status = 'cancelled';
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid action specified. Use "confirm" or "cancel".';
    END IF;

    -- Update the existing request
    UPDATE request
    SET 
        request_status = new_status,
        confirmation_date = NOW()
    WHERE 
        requestor_id = p_requestor_id
        AND receiver_id = p_receiver_id
        AND requestor_book_id = p_requestor_book_id
        AND receiver_book_id = p_receiver_book_id;

    -- If the request is confirmed, create a chat session between the two users
    -- IF p_action = 'confirm' THEN
        -- Check if a chat session already exists between the two users
        -- SELECT session_id INTO existing_session_id 
        -- FROM chat_session
        -- WHERE (user1_id = p_requestor_id AND user2_id = p_receiver_id)
           -- OR (user1_id = p_receiver_id AND user2_id = p_requestor_id)
        -- LIMIT 1;

        -- If no existing session, create a new one
        -- IF existing_session_id IS NULL THEN
            -- INSERT INTO chat_session (user1_id, user2_id)
            -- VALUES (p_requestor_id, p_receiver_id);
        -- END IF;
    -- END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateUserAddress` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserAddress`(
    IN p_user_id INT,
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_address_line3 VARCHAR(255),
    IN p_city VARCHAR(255),
    IN p_district VARCHAR(255),
    IN p_postal_code VARCHAR(255)
)
BEGIN
    -- Update address details for the user
    UPDATE address
    SET
        address_line1 = p_address_line1,
        address_line2 = p_address_line2,
        address_line3 = p_address_line3,
        city = p_city,
        district = p_district,
        postal_code = p_postal_code
    WHERE address_id = (SELECT address_id FROM user_address WHERE user_id = p_user_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-20 23:13:34
