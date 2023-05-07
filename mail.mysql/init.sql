CREATE DATABASE /*!32312 IF NOT EXISTS*/`dovecot` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dovecot`;
/*Table structure for table `aliases` */

DROP TABLE IF EXISTS `aliases`;
CREATE TABLE `aliases` (
  `source` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(128) NOT NULL,
  `domain` varchar(128) NOT NULL,
  `password` varchar(64) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `uid` INT(11) DEFAULT '5000',
  `gid` INT(11) DEFAULT '5000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert  into `users`(`username`,`domain`,`password`,`active`) values ('vega','ezconn.tw','8253dee45bd36758d868cc8a45677521',1);

CREATE USER 'dovecot'@'%' IDENTIFIED BY 'dovecot';
GRANT ALL ON dovecot.* TO 'dovecot'@'%';
FLUSH PRIVILEGES;
