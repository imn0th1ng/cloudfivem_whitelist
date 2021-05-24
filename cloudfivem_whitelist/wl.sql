
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `essentialmode`;

-- tablo yapısı dökülüyor essentialmode.dcwl
CREATE TABLE IF NOT EXISTS `dcwl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hex` varchar(50) DEFAULT '',
  `dcid` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;