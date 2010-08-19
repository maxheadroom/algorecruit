-- MySQL dump 10.13  Distrib 5.1.38, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: algorecruit
-- ------------------------------------------------------
-- Server version	5.1.38

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `github_edges`
--

DROP TABLE IF EXISTS `github_edges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `github_edges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `github_edges`
--

LOCK TABLES `github_edges` WRITE;
/*!40000 ALTER TABLE `github_edges` DISABLE KEYS */;
INSERT INTO `github_edges` VALUES (1,2,1),(2,4,3),(3,3,5),(4,7,6),(5,8,6),(6,10,11),(7,10,12),(8,10,13),(9,10,14),(10,10,15),(11,10,16),(12,10,17),(13,19,18),(14,22,21),(15,23,21),(16,24,21),(17,21,25),(18,21,26),(19,21,27),(20,21,22),(21,21,28),(22,21,29),(23,21,30),(24,21,31),(25,21,32),(26,21,33),(27,21,34),(28,21,35),(29,2,1),(30,4,3),(31,3,5),(32,7,6),(33,8,6),(34,10,11),(35,10,12),(36,10,13),(37,10,14),(38,10,15),(39,10,16),(40,10,17),(41,19,18),(42,22,21),(43,23,21),(44,24,21),(45,21,25),(46,21,26),(47,21,27),(48,21,22),(49,21,28),(50,21,29),(51,21,30),(52,21,31),(53,21,32),(54,21,33),(55,21,34),(56,21,35);
/*!40000 ALTER TABLE `github_edges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `github_users`
--

DROP TABLE IF EXISTS `github_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `github_users` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `followers` blob NOT NULL,
  `followings` blob NOT NULL,
  `label` varchar(100) NOT NULL,
  `location` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `github_users`
--

LOCK TABLES `github_users` WRITE;
/*!40000 ALTER TABLE `github_users` DISABLE KEYS */;
INSERT INTO `github_users` VALUES (1,'kiebel','','','kiebel','Magdeburg'),(2,'voitto','','','voitto','Portland, Oregon'),(3,'sebastian-guenther','','','sebastian-guenther','Germany'),(4,'sagarsunkle','','','sagarsunkle',NULL),(5,'kotp','','','kotp','Minnesota'),(6,'xrstf','','','xrstf','Magdeburg, Germany'),(7,'mediastuttgart','','','mediastuttgart',NULL),(8,'treshugart','','','treshugart','Sydney, Australia (from Santa Cruz, California)'),(9,'gnn','','','gnn','Magdeburg'),(10,'woodworker','','','woodworker','Magdeburg, Germany'),(11,'KrisJordan','','','KrisJordan','North Carolina'),(12,'recess','','','recess',NULL),(13,'palm','','','palm','Sunnyvale, CA'),(14,'kore','','','kore',NULL),(15,'sebastianbergmann','','','sebastianbergmann','Siegburg, Germany'),(16,'xauth','','','xauth',NULL),(17,'softlayer','','','softlayer','Dallas, TX USA'),(18,'kekrops','','','kekrops','Magdeburg'),(19,'anrichter','','','anrichter',NULL),(20,'davemecha','','','davemecha','Magdeburg'),(21,'scivi','','','scivi','Leipzig / Magdeburg, Germany'),(22,'fjl','','','fjl','Magdeburg, Germany'),(23,'skypher','','','skypher','Erfurt, Germany'),(24,'webiest','','','webiest',NULL),(25,'seancribbs','','','seancribbs','Chapel Hill, NC'),(26,'rubaidh','','','rubaidh','Edinburgh, Scotland'),(27,'govinda','','','govinda',NULL),(28,'pilu','','','pilu','Milan, Italy'),(29,'sproutit','','','sproutit','Los Altos, CA'),(30,'pluginaweek','','','pluginaweek','Boston, MA'),(31,'activescaffold','','','activescaffold',NULL),(32,'alltach','','','alltach',NULL),(33,'binarylogic','','','binarylogic','NY / NJ'),(34,'xing','','','xing','Hamburg Germany, Barcelona Spain'),(35,'cpetschnig','','','cpetschnig','Leipzig, Germany');
/*!40000 ALTER TABLE `github_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-08-19 16:32:53
