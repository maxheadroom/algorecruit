-- MySQL dump 10.11
--
-- Host: localhost    Database: algorecruit
-- ------------------------------------------------------
-- Server version	5.0.51a-3ubuntu5.7-log

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `github_edges` (
  `id` int(11) NOT NULL auto_increment,
  `source` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `github_edges`
--

LOCK TABLES `github_edges` WRITE;
/*!40000 ALTER TABLE `github_edges` DISABLE KEYS */;
INSERT INTO `github_edges` VALUES (1,2,1),(2,4,3),(3,3,5),(4,7,6),(5,8,6),(6,10,11),(7,10,12),(8,10,13),(9,10,14),(10,10,15),(11,10,16),(12,10,17),(13,19,18),(14,22,21),(15,23,21),(16,24,21),(17,21,25),(18,21,26),(19,21,27),(20,21,22),(21,21,28),(22,21,29),(23,21,30),(24,21,31),(25,21,32),(26,21,33),(27,21,34),(28,21,35),(29,2,1),(30,4,3),(31,3,5),(32,7,6),(33,8,6);
/*!40000 ALTER TABLE `github_edges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `github_users`
--

DROP TABLE IF EXISTS `github_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `github_users` (
  `id` mediumint(9) NOT NULL auto_increment,
  `username` varchar(100) NOT NULL,
  `followers` blob NOT NULL,
  `followings` blob NOT NULL,
  `label` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `github_users`
--

LOCK TABLES `github_users` WRITE;
/*!40000 ALTER TABLE `github_users` DISABLE KEYS */;
INSERT INTO `github_users` VALUES (1,'kiebel','','','kiebel'),(2,'voitto','','','voitto'),(3,'sebastian-guenther','','','sebastian-guenther'),(4,'sagarsunkle','','','sagarsunkle'),(5,'kotp','','','kotp'),(6,'xrstf','','','xrstf'),(7,'mediastuttgart','','','mediastuttgart'),(8,'treshugart','','','treshugart'),(9,'gnn','','','gnn'),(10,'woodworker','','','woodworker'),(11,'KrisJordan','','','KrisJordan'),(12,'recess','','','recess'),(13,'palm','','','palm'),(14,'kore','','','kore'),(15,'sebastianbergmann','','','sebastianbergmann'),(16,'xauth','','','xauth'),(17,'softlayer','','','softlayer'),(18,'kekrops','','','kekrops'),(19,'anrichter','','','anrichter'),(20,'davemecha','','','davemecha'),(21,'scivi','','','scivi'),(22,'fjl','','','fjl'),(23,'skypher','','','skypher'),(24,'webiest','','','webiest'),(25,'seancribbs','','','seancribbs'),(26,'rubaidh','','','rubaidh'),(27,'govinda','','','govinda'),(28,'pilu','','','pilu'),(29,'sproutit','','','sproutit'),(30,'pluginaweek','','','pluginaweek'),(31,'activescaffold','','','activescaffold'),(32,'alltach','','','alltach'),(33,'binarylogic','','','binarylogic'),(34,'xing','','','xing'),(35,'cpetschnig','','','cpetschnig');
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

-- Dump completed on 2010-08-16  7:18:38
