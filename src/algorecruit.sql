/*
 Navicat Premium Data Transfer

 Source Server         : MacBook
 Source Server Type    : MySQL
 Source Server Version : 50138
 Source Host           : localhost
 Source Database       : algorecruit

 Target Server Type    : MySQL
 Target Server Version : 50138
 File Encoding         : utf-8

 Date: 08/19/2010 09:40:09 AM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `github_edges`
-- ----------------------------
DROP TABLE IF EXISTS `github_edges`;
CREATE TABLE `github_edges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3421 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `github_users`
-- ----------------------------
DROP TABLE IF EXISTS `github_users`;
CREATE TABLE `github_users` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `followers` blob NOT NULL,
  `followings` blob NOT NULL,
  `label` varchar(100) NOT NULL,
  `location` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=829 DEFAULT CHARSET=utf8;

