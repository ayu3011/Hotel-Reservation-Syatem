-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER ;;

DROP PROCEDURE IF EXISTS `add_auditorium`;;
CREATE PROCEDURE `add_auditorium`(IN `aud_no` int(40), IN `aud_name` varchar(60), IN `area` int(40), IN `type` varchar(60), IN `b_id` int(40))
insert auditorium(Aud_no,Aud_name,Area,type,B_id) values(aud_no,aud_name,area,type,b_id);;

DROP PROCEDURE IF EXISTS `add_garden`;;
CREATE PROCEDURE `add_garden`(IN `g_no` int(40), IN `g_area` int(40), IN `type` varchar(60), IN `g_name` varchar(60), IN `B_id` int(40))
insert garden(g_no,g_area,g_name,g_type,B_id) values (g_no,g_area,g_name,type,B_id);;

DROP PROCEDURE IF EXISTS `add_marriage_hall`;;
CREATE PROCEDURE `add_marriage_hall`(IN `hall_no` int(40), IN `hall_area` int(40), IN `type` varchar(60), IN `b_id` int(40))
insert marriage_hall(Hall_no,Hall_area,type,B_id) values (hall_no,hall_area,type,b_id);;

DROP PROCEDURE IF EXISTS `add_new_customer`;;
CREATE PROCEDURE `add_new_customer`(IN `customer_id` int(40), IN `first_name` varchar(60), IN `last_name` varchar(60), IN `country` varchar(60), IN `city` varchar(60), IN `mob_no` decimal(10), IN `email_id` varchar(60), IN `b_id` int(40))
insert customer(Customer_id,First_name,Last_name,Country,City,Mob_no,Email,B_id) values (customer_id,first_name,Last_name,country,city,mob_no,email_id,b_id);;

DROP PROCEDURE IF EXISTS `add_room`;;
CREATE PROCEDURE `add_room`(IN `room_no` int(40), IN `type` varchar(60), IN `B_id` int(40))
insert rooms(Room_no,type,B_id) values (room_no,type,B_id);;

DROP PROCEDURE IF EXISTS `book_Auditorium`;;
CREATE PROCEDURE `book_Auditorium`(IN `Audi_id` int, IN `c_id` int, IN `day` int, IN `p_mode` varchar(60), IN `booked_from` datetime, IN `Audi_type` varchar(60), IN `area` int(40))
begin
if((select A_b_status from auditorium where Aud_no=Audi_id)=0)
then
/*inserting into booking datails */
call insertBookingDetails('auditorium',p_mode,day,(select Charge*day from aud_type where type=Audi_type),booked_from);
update auditorium set A_b_status=1 where Aud_no=Audi_id;
insert into auditorium_booking_details
values(c_id,Audi_id,(select max(Booking_id) from booking_details) );
else
select 'auditorium is already booked' as error;
end if;
end;;

DROP PROCEDURE IF EXISTS `book_garden`;;
CREATE PROCEDURE `book_garden`(IN `g_id` int, IN `c_id` int, IN `day` int, IN `p_mode` varchar(60), IN `booked_from` datetime, IN `g_type` varchar(60), IN `g_area` int(40))
begin
if((select g_b_status from garden where garden.G_no=g_id)=0)
then
/*inserting into booking datails */
call insertBookingDetails('garden',p_mode,day,(select charge*day from garden_type where type=g_type and area=g_area),booked_from);
update garden set g_b_status=1 where G_no=g_id;
insert into garden_booking_details
values(c_id,g_id,(select max(Booking_id) from booking_details) );
else
select 'Garden is already booked' as error;
end if;
end;;

DROP PROCEDURE IF EXISTS `book_marriage_hall`;;
CREATE PROCEDURE `book_marriage_hall`(IN `hall_id` int, IN `c_id` int, IN `day` int, IN `p_mode` varchar(60), IN `booked_from` datetime, IN `hall_type` varchar(60), IN `area` int(40))
begin
if((select H_B_status from marriage_hall where Hall_no=hall_id )=0)
then
/*inserting into booking datails */
call insertBookingDetails('marriage_hall',p_mode,day,(select charge*day from marriage_hall_type where type=hall_type and Area=area),booked_from);
update marriage_hall set H_B_status=1 where Hall_no=hall_id;
insert into marriage_hall_booking_details
values(c_id,hall_id,(select max(Booking_id) from booking_details) );
else
select 'hall is already booked' as error;
end if;
end;;

DROP PROCEDURE IF EXISTS `book_room`;;
CREATE PROCEDURE `book_room`(IN `r_id` int, IN `c_id` int, IN `day` int, IN `p_mode` varchar(60), IN `booked_from` datetime, IN `r_type` varchar(60))
begin
if((select R_b_status from rooms where Room_no=r_id)=0)
then
/*inserting into booking datails */
call insertBookingDetails('rooms',p_mode,day,(select charge*day from room_type where type=r_type),booked_from);
update rooms set R_b_status=1 where Room_no=r_id;
insert into room_booking_details
values(c_id,r_id,(select max(Booking_id) from booking_details) );
else
select 'room is already booked' as error;
end if;
end;;

DROP PROCEDURE IF EXISTS `gardenWithFacility`;;
CREATE PROCEDURE `gardenWithFacility`(IN `branchId` tinyint, IN `gardenType` varchar(60))
begin
select G_name
from garden
where g_type=gardenType and B_id=branchId;
end;;

DROP PROCEDURE IF EXISTS `insertBookingDetails`;;
CREATE PROCEDURE `insertBookingDetails`(IN `booking_of` varchar(60), IN `p_mode` varchar(60), IN `day` int, IN `amount` bigint, IN `booking_from` datetime)
begin
insert into booking_details(Booking_of,payment_method,amount,booked_on,booked_from,booked_till)
values(booking_of,p_mode,amount,now(),booking_from,DATE_ADD(booking_from, INTERVAL day DAY));
end;;

DROP PROCEDURE IF EXISTS `insert_aud_type`;;
CREATE PROCEDURE `insert_aud_type`(IN `area` int(40), IN `type` varchar(60), IN `charge` int(40))
insert aud_type(Area,type,Charge) values (area,type,charge);;

DROP PROCEDURE IF EXISTS `insert_garden_type`;;
CREATE PROCEDURE `insert_garden_type`(IN `area` int(40), IN `type` varchar(60), IN `charge` int(40))
insert garden_type values(area,type,charge);;

DROP PROCEDURE IF EXISTS `insert_marriage_hall_type`;;
CREATE PROCEDURE `insert_marriage_hall_type`(IN `area` int(40), IN `type` varchar(60), IN `charge` int(40))
insert marriage_hall_type values (area,type,charge);;

DROP PROCEDURE IF EXISTS `insert_room_type`;;
CREATE PROCEDURE `insert_room_type`(IN `type` varchar(60), IN `charge` int(40))
insert room_type(type,charge) values (type,charge);;

DROP PROCEDURE IF EXISTS `open_branch`;;
CREATE PROCEDURE `open_branch`(IN `id` int(40), IN `name` varchar(60), IN `location` varchar(60))
begin
insert into branch 
values(id,name,location);







end;;

DROP PROCEDURE IF EXISTS `register_garden`;;
CREATE PROCEDURE `register_garden`(IN `name` varchar(30), IN `area` float, IN `branch_id` int)
begin
insert into garden(G_name,g_area,B_id) values(name,area,branch_id);
end;;

DROP PROCEDURE IF EXISTS `showAllAvailableGardenType`;;
CREATE PROCEDURE `showAllAvailableGardenType`()
begin
 select *
from garden_type;
end;;

DROP PROCEDURE IF EXISTS `showAllCustomerOfBranch`;;
CREATE PROCEDURE `showAllCustomerOfBranch`(IN `branchId` int(40))
begin
select *
from customer 
where B_id=branchId;
end;;

DROP PROCEDURE IF EXISTS `showCustomerDetail`;;
CREATE PROCEDURE `showCustomerDetail`(IN `c_id` int(40))
begin
select * from customer
where c_id=Customer_id;

end;;

DROP PROCEDURE IF EXISTS `showCustomerInRoom`;;
CREATE PROCEDURE `showCustomerInRoom`(IN `roomNumber` int(40))
begin
select *
from customer 
where Customer_id in(
select Customer_id
from room_booking_details
where Room_no=roomNumber);
end;;

DROP PROCEDURE IF EXISTS `show_branch`;;
CREATE PROCEDURE `show_branch`()
begin
select *from branch;

end;;

DELIMITER ;

DROP TABLE IF EXISTS `auditorium`;
CREATE TABLE `auditorium` (
  `Aud_no` int(40) NOT NULL AUTO_INCREMENT,
  `Aud_name` varchar(60) NOT NULL,
  `Area` int(40) NOT NULL,
  `type` varchar(60) NOT NULL,
  `A_b_status` int(40) NOT NULL DEFAULT '0',
  `B_id` int(40) NOT NULL,
  PRIMARY KEY (`Aud_no`),
  KEY `B_id` (`B_id`),
  KEY `Area` (`Area`,`type`),
  CONSTRAINT `auditorium_ibfk_1` FOREIGN KEY (`B_id`) REFERENCES `branch` (`B_id`),
  CONSTRAINT `auditorium_ibfk_2` FOREIGN KEY (`Area`, `type`) REFERENCES `aud_type` (`Area`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `auditorium` (`Aud_no`, `Aud_name`, `Area`, `type`, `A_b_status`, `B_id`) VALUES
(1,	'Krishna Auditorium',	2000,	'full AC',	0,	1),
(2,	'basudev auditorium',	2000,	'full AC',	1,	2);

DROP TABLE IF EXISTS `auditorium_booking_details`;
CREATE TABLE `auditorium_booking_details` (
  `Customer_id` int(40) NOT NULL,
  `Aud_no` int(40) NOT NULL,
  `Booking_id` int(40) NOT NULL,
  KEY `Customer_id` (`Customer_id`),
  KEY `Aud_no` (`Aud_no`),
  KEY `Booking_id` (`Booking_id`),
  CONSTRAINT `auditorium_booking_details_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `customer` (`Customer_id`),
  CONSTRAINT `auditorium_booking_details_ibfk_2` FOREIGN KEY (`Aud_no`) REFERENCES `auditorium` (`Aud_no`),
  CONSTRAINT `auditorium_booking_details_ibfk_3` FOREIGN KEY (`Booking_id`) REFERENCES `booking_details` (`Booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `auditorium_booking_details` (`Customer_id`, `Aud_no`, `Booking_id`) VALUES
(2,	2,	14);

DROP TABLE IF EXISTS `aud_type`;
CREATE TABLE `aud_type` (
  `Area` int(40) NOT NULL,
  `type` varchar(60) NOT NULL,
  `Charge` int(40) NOT NULL,
  PRIMARY KEY (`Area`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `aud_type` (`Area`, `type`, `Charge`) VALUES
(2000,	'full AC',	3000);

DROP TABLE IF EXISTS `booking_details`;
CREATE TABLE `booking_details` (
  `Booking_id` int(40) NOT NULL AUTO_INCREMENT,
  `Booking_of` varchar(60) NOT NULL,
  `Payment_method` varchar(60) NOT NULL,
  `Amount` int(40) NOT NULL,
  `booked_on` datetime NOT NULL,
  `Booked_from` datetime NOT NULL,
  `Booked_till` datetime NOT NULL,
  PRIMARY KEY (`Booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `booking_details` (`Booking_id`, `Booking_of`, `Payment_method`, `Amount`, `booked_on`, `Booked_from`, `Booked_till`) VALUES
(12,	'marriage_hall',	'bhim api',	40000,	'2018-01-05 00:16:43',	'2018-01-05 00:16:43',	'2018-01-07 00:16:43'),
(13,	'garden',	'tez',	200000,	'2018-01-05 00:20:38',	'2018-01-05 00:20:38',	'2018-01-07 00:20:38'),
(14,	'auditorium',	'tez',	18000,	'2018-01-05 00:25:38',	'2018-01-07 11:00:00',	'2018-01-11 00:25:38'),
(15,	'rooms',	'cash',	12000,	'2018-01-05 00:29:51',	'2018-01-07 23:02:12',	'2018-01-15 23:02:12'),
(16,	'garden',	'cash',	300000,	'2018-01-05 01:08:04',	'2018-01-05 01:08:04',	'2018-01-08 01:08:04');

DROP TABLE IF EXISTS `branch`;
CREATE TABLE `branch` (
  `B_id` int(40) NOT NULL AUTO_INCREMENT,
  `B_name` varchar(60) NOT NULL,
  `B_location` varchar(60) NOT NULL,
  PRIMARY KEY (`B_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `branch` (`B_id`, `B_name`, `B_location`) VALUES
(1,	'Garh Govind 1',	'Sardarpura'),
(2,	'Garh Govind 2',	'Ratanada'),
(3,	'garh_govind3',	'mandaur'),
(4,	'GarhGovind4',	'New Delhi'),
(5,	'Garh Govind 5',	'Mathura'),
(6,	'Garh Govind 6',	'Vrindawan'),
(7,	'Garh Govind 7',	'Dwarika');

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `Customer_id` int(40) NOT NULL AUTO_INCREMENT,
  `First_name` varchar(60) NOT NULL,
  `Last_name` varchar(60) NOT NULL,
  `Country` varchar(60) NOT NULL,
  `City` varchar(60) NOT NULL,
  `Mob_no` decimal(10,0) NOT NULL,
  `Email` varchar(60) NOT NULL,
  `B_id` int(40) NOT NULL,
  PRIMARY KEY (`Customer_id`),
  KEY `B_id` (`B_id`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`B_id`) REFERENCES `branch` (`B_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `customer` (`Customer_id`, `First_name`, `Last_name`, `Country`, `City`, `Mob_no`, `Email`, `B_id`) VALUES
(1,	'Kumar',	'Anshu',	'India',	'Madhubani',	9472906848,	'kumaranshumbm@gmail.com',	1),
(2,	'Kaushal',	'Raj',	'India',	'Nalanda',	7219920239,	'kaushal@gmail.com',	1),
(3,	'Deepak ',	'singh',	'India',	'Gopalganj',	7219920242,	'rasdeep@gmail.com',	2),
(4,	'Anshu',	'Kumar',	'U.S.A',	'California',	9472906848,	'iitiananshu@gmail.com',	1);

DROP TABLE IF EXISTS `garden`;
CREATE TABLE `garden` (
  `G_no` int(40) NOT NULL AUTO_INCREMENT,
  `G_name` varchar(60) NOT NULL,
  `g_area` int(40) NOT NULL,
  `g_type` varchar(60) NOT NULL,
  `G_b_status` bit(40) NOT NULL DEFAULT b'0',
  `B_id` int(40) NOT NULL,
  PRIMARY KEY (`G_no`),
  KEY `B_id` (`B_id`),
  KEY `g_area` (`g_area`,`g_type`),
  CONSTRAINT `garden_ibfk_1` FOREIGN KEY (`B_id`) REFERENCES `branch` (`B_id`),
  CONSTRAINT `garden_ibfk_2` FOREIGN KEY (`g_area`, `g_type`) REFERENCES `garden_type` (`Area`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `garden` (`G_no`, `G_name`, `g_area`, `g_type`, `G_b_status`, `B_id`) VALUES
(1,	'Radha Udyan',	5000,	'with_flower',	CONV('1', 2, 10) + 0,	1),
(2,	'krishna udayan',	5000,	'with_flower',	CONV('1', 2, 10) + 0,	2),
(3,	'yashoda udayan',	6000,	'without_flower',	CONV('0', 2, 10) + 0,	1);

DROP TABLE IF EXISTS `garden_booking_details`;
CREATE TABLE `garden_booking_details` (
  `Customer_id` int(40) NOT NULL,
  `G_no` int(40) NOT NULL,
  `Booking_id` int(40) NOT NULL,
  KEY `Customer_id` (`Customer_id`),
  KEY `G_no` (`G_no`),
  KEY `Booking_id` (`Booking_id`),
  CONSTRAINT `garden_booking_details_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `customer` (`Customer_id`),
  CONSTRAINT `garden_booking_details_ibfk_2` FOREIGN KEY (`G_no`) REFERENCES `garden` (`G_no`),
  CONSTRAINT `garden_booking_details_ibfk_3` FOREIGN KEY (`Booking_id`) REFERENCES `booking_details` (`Booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `garden_booking_details` (`Customer_id`, `G_no`, `Booking_id`) VALUES
(3,	2,	13),
(1,	1,	16);

DROP TABLE IF EXISTS `garden_type`;
CREATE TABLE `garden_type` (
  `Area` int(40) NOT NULL,
  `type` varchar(60) NOT NULL,
  `charge` int(40) NOT NULL,
  PRIMARY KEY (`Area`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `garden_type` (`Area`, `type`, `charge`) VALUES
(5000,	'with_flower',	100000),
(6000,	'without_flower',	3000);

DROP TABLE IF EXISTS `marriage_hall`;
CREATE TABLE `marriage_hall` (
  `Hall_no` int(40) NOT NULL AUTO_INCREMENT,
  `Hall_area` int(40) NOT NULL,
  `type` varchar(60) NOT NULL,
  `H_B_status` int(40) NOT NULL DEFAULT '0',
  `B_id` int(40) NOT NULL,
  PRIMARY KEY (`Hall_no`),
  KEY `B_id` (`B_id`),
  KEY `H_area` (`Hall_area`,`type`),
  CONSTRAINT `marriage_hall_ibfk_1` FOREIGN KEY (`B_id`) REFERENCES `branch` (`B_id`),
  CONSTRAINT `marriage_hall_ibfk_2` FOREIGN KEY (`Hall_area`, `type`) REFERENCES `marriage_hall_type` (`Area`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `marriage_hall` (`Hall_no`, `Hall_area`, `type`, `H_B_status`, `B_id`) VALUES
(1,	1000,	'full AC',	0,	1),
(2,	1000,	'full AC',	1,	2);

DROP TABLE IF EXISTS `marriage_hall_booking_details`;
CREATE TABLE `marriage_hall_booking_details` (
  `Customer_id` int(40) NOT NULL,
  `Hall_no` int(40) NOT NULL,
  `Booking_id` int(40) NOT NULL,
  KEY `Customer_id` (`Customer_id`),
  KEY `Hall_no` (`Hall_no`),
  KEY `Booking_id` (`Booking_id`),
  CONSTRAINT `marriage_hall_booking_details_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `customer` (`Customer_id`),
  CONSTRAINT `marriage_hall_booking_details_ibfk_2` FOREIGN KEY (`Hall_no`) REFERENCES `marriage_hall` (`Hall_no`),
  CONSTRAINT `marriage_hall_booking_details_ibfk_3` FOREIGN KEY (`Booking_id`) REFERENCES `booking_details` (`Booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `marriage_hall_booking_details` (`Customer_id`, `Hall_no`, `Booking_id`) VALUES
(2,	2,	12);

DROP TABLE IF EXISTS `marriage_hall_type`;
CREATE TABLE `marriage_hall_type` (
  `Area` int(40) NOT NULL,
  `type` varchar(60) NOT NULL,
  `charge` int(40) NOT NULL,
  PRIMARY KEY (`Area`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `marriage_hall_type` (`Area`, `type`, `charge`) VALUES
(1000,	'full AC',	20000);

DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms` (
  `Room_no` int(40) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL,
  `R_b_status` int(40) NOT NULL DEFAULT '0',
  `B_id` int(11) NOT NULL,
  PRIMARY KEY (`Room_no`),
  KEY `type` (`type`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`type`) REFERENCES `room_type` (`type`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `rooms` (`Room_no`, `type`, `R_b_status`, `B_id`) VALUES
(1,	'single bed AC',	0,	1),
(2,	'single bed AC',	1,	1);

DROP TABLE IF EXISTS `room_booking_details`;
CREATE TABLE `room_booking_details` (
  `Customer_id` int(40) NOT NULL,
  `Room_no` int(40) NOT NULL,
  `Booking_id` int(40) NOT NULL,
  KEY `Customer_id` (`Customer_id`),
  KEY `Room_no` (`Room_no`),
  KEY `Booking_id` (`Booking_id`),
  CONSTRAINT `room_booking_details_ibfk_1` FOREIGN KEY (`Customer_id`) REFERENCES `customer` (`Customer_id`),
  CONSTRAINT `room_booking_details_ibfk_2` FOREIGN KEY (`Room_no`) REFERENCES `rooms` (`Room_no`),
  CONSTRAINT `room_booking_details_ibfk_3` FOREIGN KEY (`Booking_id`) REFERENCES `booking_details` (`Booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `room_booking_details` (`Customer_id`, `Room_no`, `Booking_id`) VALUES
(3,	2,	15);

DROP TABLE IF EXISTS `room_type`;
CREATE TABLE `room_type` (
  `type` varchar(60) NOT NULL,
  `Charge` int(40) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `room_type` (`type`, `Charge`) VALUES
('single bed AC',	1500);

-- 2018-01-28 05:00:56