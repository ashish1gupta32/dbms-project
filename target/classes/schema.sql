-- H2 compatible schema script

DROP TABLE IF EXISTS `billing_details`;
DROP TABLE IF EXISTS `billing`;
DROP TABLE IF EXISTS `cart_details`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `dealer`;
DROP TABLE IF EXISTS `employee`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `profile`;
DROP TABLE IF EXISTS `user`;

--
-- Table structure for table `profile`
--

CREATE TABLE `profile` (
  `profile_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fname` varchar(10) DEFAULT NULL,
  `lname` varchar(10) DEFAULT NULL,
  `profile_type` int(11) DEFAULT NULL,
  `phone1` varchar(10) DEFAULT NULL,
  `phone2` varchar(10) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `idx_profile_phone1` (`phone1`),
  UNIQUE KEY `idx_profile_phone2` (`phone2`)
);

--
-- Dumping data for table `profile`
--

INSERT INTO `profile` VALUES (1,'Rahul','Chaubey',0,'9999999991','8888888881','rahul@example.com'),(3,'Rahul','Chaubey',1,'9999999992','8888888882','rahul2@example.com'),(4,'Rahul','Chaubey',2,'9999999993','8888888883','rahul3@example.com'),(5,'Nepal','Chaubey',2,'9999999994','8888888884','nepal@example.com'),(6,'Piyush','Chaubey',1,'9999999995','8888888885','piyush@example.com'),(7,'Piyush','Chawdhery',1,'9999999996','8888888886','piyush2@example.com'),(8,'Piyush','gupta',0,'9999999997','8888888887','piyush3@example.com'),(10,'Piyush','gupta',0,'9999999998',NULL,'piyush4@example.com'),(11,'Piyush','gupta',0,'9999999999',NULL,'piyush5@example.com'),(14,'piyush','maurya',0,'9999999900','8888888800','maurya@example.com'),(15,'abhishek','mittal',0,'9999999901','8888888801','abhishek@example.com'),(17,'Ashish','Gupta',1,'9999999902','8888888802','ashish@example.com');

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` bigint(20) NOT NULL,
  `house_number` varchar(10) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `profile` (`profile_id`)
);

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` VALUES (17,'akbarpur','821311','Bihar');

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `billing_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) DEFAULT NULL,
  `billing_date` varchar(20) DEFAULT NULL,
  `billing_price` bigint(20) DEFAULT '0',
  `modeofpayment` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  KEY `idx_billing_customer_id` (`customer_id`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` VALUES (1,17,'11/10/2018',0,'Cash'),(2,17,'11/10/2018',0,'Cash'),(3,17,'12/10/2018',0,'Cash'),(4,17,'12/10/2019',0,'cash'),(5,17,'12/10/2019',0,'casf'),(6,17,'12/11/',0,'as');

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `product_category` varchar(20) DEFAULT NULL,
  `stock` bigint(20) DEFAULT NULL,
  `discount` decimal(6,2) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `material` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
);

--
-- Dumping data for table `products`
--

INSERT INTO `products` VALUES (2,'lemon','ethnic','Saree',7,5.00,1200,'cotton'),(3,'lemon','ethnic','Suit',3,5.00,1200,'cotton'),(4,'lemon','casual','Suit',9,5.00,1200,'cotton'),(5,'lemon','ethnic','Suit',10,5.00,1200,'cotton'),(6,'lemon','ethnic','pant',10,5.00,1200,'cotton'),(8,'lemon','casual','Shirt',10,5.00,1200,'cotton'),(9,'lemon','formal','Shirt',10,5.00,1200,'cotton'),(10,'lemon','formal','pant',10,5.00,1200,'cotton'),(11,'Rukmani','ethnic','pant',12,10.00,120,'Cotton'),(12,'Rukmani','ethnic','pant',12,10.00,120,'Cotton');

--
-- Table structure for table `billing_details`
--

CREATE TABLE `billing_details` (
  `billing_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` bigint(20) DEFAULT '0',
  PRIMARY KEY (`billing_id`,`product_id`),
  KEY `idx_billing_details_product_id` (`product_id`),
  CONSTRAINT `billing_details_ibfk_1` FOREIGN KEY (`billing_id`) REFERENCES `billing` (`billing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `billing_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Dumping data for table `billing_details`
--

INSERT INTO `billing_details` VALUES (3,2,5,0),(3,3,4,0),(3,4,1,0),(5,2,1,1200),(6,2,1,1200),(6,3,3,3600);

--
-- Table structure for table `cart_details`
--

CREATE TABLE `cart_details` (
  `cart_id` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` bigint(20) DEFAULT '1',
  `total_price` bigint(20) DEFAULT '0',
  PRIMARY KEY (`cart_id`,`product_id`),
  KEY `idx_cart_details_product_id` (`product_id`),
  CONSTRAINT `cart_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Dumping data for table `cart_details`
--

INSERT INTO `cart_details` VALUES ('ashishadmin',3,1,0),('cs',2,7,8400),('cs',6,1,0),('cs',8,1,0);

--
-- Table structure for table `dealer`
--

CREATE TABLE `dealer` (
  `dealer_id` bigint(20) NOT NULL,
  `shop_name` varchar(20) DEFAULT NULL,
  `city` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`dealer_id`),
  CONSTRAINT `dealer_ibfk_1` FOREIGN KEY (`dealer_id`) REFERENCES `profile` (`profile_id`)
);

--
-- Dumping data for table `dealer`
--


--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employee_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee_type` int(11) DEFAULT NULL,
  `joining_date` varchar(10) DEFAULT NULL,
  `holiday` int(11) DEFAULT '0',
  `salary` bigint(20) DEFAULT NULL,
  `adhar_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `profile` (`profile_id`)
);

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` VALUES (1,0,'23/11/2018',11,10000,'123456'),(8,3,'23/11/2018',15,10000,'13456'),(10,2,'23/11/2018',5,11000,'13457'),(15,2,'12/10/2014',0,1100,'123456');

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(250) DEFAULT NULL,
  `user_type` int(11) DEFAULT NULL,
  `fname` varchar(10) DEFAULT NULL,
  `lname` varchar(10) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `idx_user_phone` (`phone`)
);

--
-- Dumping data for table `user`
--

INSERT INTO `user` VALUES ('a','$2a$10$8IZVSP25sQfOdQW6AjNBBuEyCijFXyNbFWLr.ooNHGszFSFd85ynq',0,'Ashish','Gupta','1111111111','ashish@example.com'),('as','$2a$10$SU2q6vsQ07Kazk4nSJpeke7sCQRuV7V2eiSTyzwxC5w9IURpaq83e',0,'as','as','as','as'),('ashishadmin','$2a$10$yenQ.tQFBt7UKOxKy.TywOIn4XB5zDjjXU88VVjLKMyMQeAfr3FnC',1,'Ashish','Gupta','9999999902','ashish@example.com'),('cs','$2a$10$VENNMwGB.fAjv/7Lc/9i2OLIv25Zjydknkx8GqzGtkDvjrCUdjcZ.',0,'Ashish','Gupta','1111111112','ashish2@example.com'),('ds','$2a$10$USIgrEhPJo6e7nBik3l3J.XAwn8AAWlvvwW0pU5zI1HzF2MdbtBjy',0,'Ashish','Gupta','1111111113','ashish3@example.com'),('hh','$2a$10$iQgtchrlR/Pv0WmaMblnb.HPYypCaKZWtls/tEFcl2mPH9.BpEcXK',0,'ll','oo','p','lh'),('m','$2a$10$rn8oXHdgTurxf.dqVZb.KuamqynVRON6Bd9.vv5xXbxJiOiuDtXaq',0,'Ashish','Gupta','1111111114','ashish4@example.com'),('nepali','$2a$10$FoGNRIny7oHB3hJV7xbXdOo102ndkohCv/rIeIRnBdD.HdtkNd/Fm',0,'pankaj','jha','1111111115','nepali@example.com'),('nepali1','$2a$10$nhagqY.lV9im9QcuxWE5c.GnIWqBGpGilXyLbGAd6Tb684sY1XCXO',0,'pankaj','jha','1111111116','nepali2@example.com'),('venket@12','$2a$10$DBxKBGF.QxkQZ7kvjC0Dkem9MF8WlyIzuWMCtIV14MaiCE2ej86E6',0,'venket','kumar','123','venket@example.com'),('venket@125','$2a$10$0H1Nq8Qwgm2RqsdIf1eOW.HGAi5Yzze1YcdAxf6T2pH6FGfj5ysB6',0,'venket','kumar','1234','venket2@example.com');
