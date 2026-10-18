-- EazyDeals E-Commerce Management System
-- MySQL Workbench Forward Engineering & Database Initialization Script

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema eazydeals
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eazydeals` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `eazydeals`;

-- -----------------------------------------------------
-- Table `eazydeals`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`admin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`category` (
  `cid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`cid`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`product` (
  `pid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NOT NULL,
  `description` VARCHAR(1000) NULL DEFAULT NULL,
  `price` VARCHAR(20) NOT NULL,
  `quantity` INT NULL DEFAULT 0,
  `discount` INT NULL DEFAULT 0,
  `image` VARCHAR(100) NULL DEFAULT NULL,
  `cid` INT NULL DEFAULT NULL,
  PRIMARY KEY (`pid`),
  INDEX `cid_idx` (`cid` ASC) VISIBLE,
  CONSTRAINT `fk_product_category`
    FOREIGN KEY (`cid`)
    REFERENCES `eazydeals`.`category` (`cid`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`user` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `gender` VARCHAR(20) NULL DEFAULT NULL,
  `registerdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `address` VARCHAR(250) NULL DEFAULT NULL,
  `city` VARCHAR(100) NULL DEFAULT NULL,
  `pincode` VARCHAR(10) NULL DEFAULT NULL,
  `state` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`cart` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uid` INT NULL DEFAULT NULL,
  `pid` INT NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `uid_idx` (`uid` ASC) VISIBLE,
  INDEX `pid_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_cart_product`
    FOREIGN KEY (`pid`)
    REFERENCES `eazydeals`.`product` (`pid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user`
    FOREIGN KEY (`uid`)
    REFERENCES `eazydeals`.`user` (`userid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `orderid` VARCHAR(100) NOT NULL,
  `status` VARCHAR(100) NULL DEFAULT 'Order Placed',
  `paymentType` VARCHAR(100) NULL DEFAULT 'Cash on Delivery',
  `userId` INT NULL DEFAULT NULL,
  `date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `userId_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `fk_order_user`
    FOREIGN KEY (`userId`)
    REFERENCES `eazydeals`.`user` (`userid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eazydeals`.`ordered_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eazydeals`.`ordered_product` (
  `oid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(250) NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT 1,
  `price` VARCHAR(45) NULL DEFAULT NULL,
  `image` VARCHAR(100) NULL DEFAULT NULL,
  `orderid` INT NULL DEFAULT NULL,
  PRIMARY KEY (`oid`),
  INDEX `orderid_idx` (`orderid` ASC) VISIBLE,
  CONSTRAINT `fk_ordered_product_order`
    FOREIGN KEY (`orderid`)
    REFERENCES `eazydeals`.`order` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Admin Account (password: Admin@123 hashed with SHA-256: e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7)
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`admin` (`id`, `name`, `email`, `password`, `phone`) VALUES
(1, 'System Administrator', 'admin@eazydeals.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', '9876543210')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `email`=VALUES(`email`), `password`=VALUES(`password`), `phone`=VALUES(`phone`);

-- -----------------------------------------------------
-- Seed Categories
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`category` (`cid`, `name`, `image`) VALUES
(1, 'Laptops', 'Laptop-Category.jpg'),
(2, 'Mobiles', 'Mobile-Category.jpeg'),
(3, 'Electronics', 'Electronics-Category.jpg'),
(4, 'Appliances', 'Appliances-Category.jpg'),
(5, 'Furniture', 'Furniture-Category.jpg'),
(6, 'Books', 'Books-Category.jpg')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `image`=VALUES(`image`);

-- -----------------------------------------------------
-- Seed Products
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`product` (`pid`, `name`, `description`, `price`, `quantity`, `discount`, `image`, `cid`) VALUES
(1, 'Apple MacBook Air M2', 'Stunning 13.6-inch Liquid Retina display. 8GB unified memory and 256GB SSD storage. Up to 18 hours battery life. Backlit Magic Keyboard with Touch ID.', '99900', 15, 12, 'Laptop1.jpg', 1),
(2, 'Dell XPS 15 InfinityEdge', '15.6-inch FHD+ anti-glare display. Intel Core i7 13th Gen, 16GB RAM, 512GB NVMe SSD. NVIDIA GeForce RTX 4050. Studio sound with quad speakers.', '145000', 10, 15, 'Laptop2.jpg', 1),
(3, 'HP Pavilion 15 Gaming', 'AMD Ryzen 7 processor, 16GB DDR5, 1TB SSD. 144Hz IPS display. Bang and Olufsen premium audio. Fast charge capability.', '76990', 20, 18, 'Laptop3.jpg', 1),
(4, 'Lenovo IdeaPad Slim 3', 'Intel Core i5 12th Gen. 15.6-inch FHD display. 8GB RAM, 512GB SSD. Lightweight design with privacy shutter webcam.', '49990', 25, 20, 'Laptop4.jpg', 1),
(5, 'Asus ROG Zephyrus G14', 'AMD Ryzen 9 7940HS, 16GB DDR5, 1TB PCIe 4.0 SSD, NVIDIA RTX 4060. 165Hz ROG Nebula HDR QHD display.', '139990', 12, 10, 'Laptop5.jpg', 1),
(6, 'Acer Swift Go 14 OLED', 'Intel Core Ultra 5 125H, 16GB LPDDR5X, 512GB SSD. 2.8K 90Hz OLED display with 100% DCI-P3 color gamut.', '69990', 18, 15, 'Laptop6.jpg', 1),
(7, 'Microsoft Surface Laptop 5', '13.5-inch PixelSense touchscreen display. Intel Evo Platform Core i5, 8GB RAM, 256GB SSD. Sleek aluminum finish.', '89990', 14, 22, 'Laptop7.jpg', 1),
(8, 'MSI Thin GF63 Gaming', 'Intel Core i7 12th Gen, 16GB RAM, 512GB NVMe SSD, GeForce RTX 3050 4GB graphics. 144Hz IPS gaming panel.', '58990', 22, 25, 'Laptop8.jpg', 1),
(9, 'iPhone 15 Pro Max', 'Titanium design with textured matte glass back. Action button, 48MP main camera system with 5x telephoto optical zoom. A17 Pro chip with 6-core GPU.', '134900', 30, 8, 'Mobile1.jpg', 2),
(10, 'Samsung Galaxy S24 Ultra', 'Built-in S Pen, 200MP camera with AI photo assist. Snapdragon 8 Gen 3 for Galaxy. 6.8-inch Dynamic AMOLED 2X flat display.', '129999', 25, 10, 'Mobile2.jpg', 2),
(11, 'Google Pixel 8 Pro', 'Google Tensor G3 chip with advanced Google AI. 50MP triple rear camera. Super Actua display. All-day battery life.', '89999', 18, 14, 'Mobile3.jpg', 2),
(12, 'OnePlus 12 5G', 'Snapdragon 8 Gen 3, 16GB RAM, 512GB storage. 4th Gen Hasselblad Camera for Mobile. 100W SUPERVOOC charging.', '64999', 22, 12, 'Mobile4.jpg', 2),
(13, 'Xiaomi 14 Ultra 5G', 'Leica quad camera system with 1-inch variable aperture sensor. Snapdragon 8 Gen 3, 16GB RAM, 512GB ROM.', '99999', 15, 10, 'Mobile5.jpg', 2),
(14, 'Vivo X100 Pro 5G', 'Zeiss APO telephoto camera with 1-inch main sensor. Dimensity 9300 processor, 16GB RAM, 100W FlashCharge.', '89999', 20, 15, 'Mobile6.jpg', 2),
(15, 'OnePlus Nord CE 4 5G', 'Snapdragon 7 Gen 3, 8GB RAM, 256GB storage. 100W SUPERVOOC with 5500mAh massive battery. 120Hz AMOLED.', '24999', 40, 20, 'Mobile7.jpg', 2),
(16, 'Nothing Phone (2) 5G', 'Unique transparent Glyph Interface, Snapdragon 8+ Gen 1, dual 50MP cameras. 6.7-inch flexible LTPO OLED.', '36999', 30, 25, 'Mobile8.jpg', 2),
(17, 'Sony WH-1000XM5 Wireless Headphones', 'Industry-leading noise canceling with two processors and 8 microphones. Magnificent sound engineered to perfection. Up to 30 hours battery life.', '29990', 40, 32, 'Electronic1.jpg', 3),
(18, 'Apple Watch Series 9', 'S9 SiP with Double Tap gesture. Brighter Always-On Retina display. Advanced health sensors and Crash Detection.', '41900', 30, 10, 'Electronic2.jpg', 3),
(19, 'JBL Flip 6 Portable Bluetooth Speaker', 'Powerful JBL Original Pro Sound with 2-way speaker system. IP67 waterproof and dustproof. 12 hours playtime.', '9999', 50, 35, 'Electronic3.jpg', 3),
(20, 'Bose QuietComfort 45 Headphones', 'High-fidelity audio with active noise cancellation, Aware Mode, lightweight comfort, and up to 24 hours battery life.', '26990', 25, 30, 'Electronic4.jpg', 3),
(21, 'Sony Bravia Theater Soundbar', 'Dolby Atmos and DTS:X support, 3.1 channel with wireless subwoofer. Bluetooth 5.3 and HDMI eARC connectivity.', '24990', 30, 38, 'Electronic5.jpg', 3),
(22, 'Canon EOS R50 Mirrorless Camera', '24.2MP APS-C sensor, 4K uncropped video at 30fps. Dual Pixel CMOS AF II with subject detection.', '56990', 16, 18, 'Electronic6.jpg', 3),
(23, 'GoPro HERO12 Black Action Camera', '5.3K60 Ultra HD video, HyperSmooth 6.0 stabilization, waterproof up to 33ft, front and rear LCD screens.', '37990', 25, 20, 'Electronic7.jpg', 3),
(24, 'Amazon Kindle Paperwhite 16GB', '6.8-inch glare-free display with adjustable warm light. Up to 10 weeks battery life. IPX8 waterproof.', '14999', 60, 30, 'Electronic8.jpg', 3),
(25, 'LG 55-inch 4K Smart OLED TV', 'Self-lit OLED pixels with infinite contrast. alpha 9 AI Processor 4K Gen6. Dolby Vision and Dolby Atmos.', '119990', 12, 35, 'Appliance1.jpg', 4),
(26, 'Samsung 653L French Door Refrigerator', 'Twin Cooling Plus with digital inverter compressor. Built-in water and ice dispenser. Fingerprint resistant finish.', '84990', 8, 22, 'Appliance2.jpg', 4),
(27, 'Dyson V12 Detect Slim Vacuum', 'Laser reveals microscopic dust. Powerful cordless cleaning with piezo sensor. Up to 60 minutes run time.', '47900', 15, 15, 'Appliance3.jpg', 4),
(28, 'Philips Digital Air Fryer XL', 'Rapid Air technology for up to 90% less fat. 1.2kg basket capacity with 7 preset digital cooking menus.', '10999', 45, 36, 'Appliance4.jpg', 4),
(29, 'IFB 8.5kg Front Load Washing Machine', 'AI-powered washing with Steam Wash, Aqua Energie, Cradle Wash for delicates, and 5-star energy efficiency rating.', '36990', 18, 28, 'Appliance5.jpg', 4),
(30, 'Panasonic 27L Convection Microwave', 'Zero Oil cooking recipes, 360-degree heat distribution, magic grill, and auto cook menus with touch keypad.', '14490', 25, 34, 'Appliance6.jpg', 4),
(31, 'Xiaomi Smart Air Purifier 4', 'True HEPA filter capturing 99.97% particles, OLED touch display, negative ion generator, voice assistant support.', '13999', 35, 30, 'Appliance7.jpg', 4),
(32, 'Morphy Richards Espresso Coffee Maker', '15-bar pressure pump for rich crema, milk frother steam wand, dual cup filter, stainless steel body.', '8999', 40, 40, 'Appliance8.jpg', 4),
(33, 'Ergonomic Executive Office Chair', 'High back breathable mesh with adjustable lumbar support and 3D armrests. Heavy-duty aluminum base.', '14999', 30, 40, 'Furniture1.jpg', 5),
(34, 'Solid Teak Wood 6-Seater Dining Table', 'Handcrafted solid teak wood table with cushioned chairs. Natural matte finish with durable joinery.', '38990', 10, 28, 'Furniture2.jpg', 5),
(35, 'Scandinavian Fabric 3-Seater Sofa', 'High-resilience foam cushions upholstered in premium stain-resistant fabric with tapered solid wood legs.', '28990', 15, 32, 'Furniture3.jpg', 5),
(36, 'Engineered Wood King Size Bed with Storage', 'Hydraulic lift storage system, headboard with shelf and charging slot. Scratch and moisture resistant finish.', '22990', 20, 35, 'Furniture4.jpg', 5),
(37, 'Modern Minimalist Glass Coffee Table', 'Tempered clear glass top with geometric solid oak base. Sleek centerpiece design for modern living rooms.', '7999', 30, 42, 'Furniture5.jpg', 5),
(38, 'Ergonomic Study Desk with Drawers', 'Spacious tabletop with cable grommet, dual smooth gliding storage drawers, and scratch-resistant matte laminate.', '9499', 25, 30, 'Furniture6.jpg', 5),
(39, 'Solid Sheesham Wood Bookcase Shelf', 'Multi-tier open display bookshelf made of 100% natural sheesham wood with rustic honey teak polish.', '13490', 18, 30, 'Furniture7.jpg', 5),
(40, 'Velvet Accent Armchair with Brass Legs', 'Plush channel-tufted velvet upholstery, barrel back design, reinforced metal legs with gold brass finish.', '11990', 22, 38, 'Furniture8.jpg', 5),
(41, 'Atomic Habits by James Clear', 'An easy and proven way to build good habits and break bad ones. International bestselling guide to self-improvement.', '599', 100, 35, 'Book1.jpg', 6),
(42, 'The Psychology of Money by Morgan Housel', 'Timeless lessons on wealth, greed, and happiness. Essential reading for smart financial decisions.', '450', 80, 30, 'Book2.jpg', 6),
(43, 'Think and Grow Rich by Napoleon Hill', 'The landmark bestseller on personal achievement, wealth creation, and cultivating an unstoppable success mindset.', '399', 90, 40, 'Book3.jpg', 6),
(44, 'Deep Work by Cal Newport', 'Rules for focused success in a distracted world. Master difficult tasks and produce better results in less time.', '499', 85, 32, 'Book4.jpg', 6),
(45, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari explores how biology and history have defined us and enhanced our understanding of what it means to be human.', '699', 75, 30, 'Book5.jpg', 6),
(46, 'Ikigai: Japanese Secret to Long Life', 'Discover your reason for being and find purpose, fulfillment, and longevity through traditional Japanese wisdom.', '399', 120, 35, 'Book6.jpg', 6),
(47, 'Rich Dad Poor Dad by Robert Kiyosaki', 'What the rich teach their kids about money that the poor and middle class do not. The #1 personal finance book of all time.', '499', 95, 38, 'Book7.jpg', 6),
(48, 'The 7 Habits of Highly Effective People', 'Stephen R. Covey presents a holistic, integrated, principle-centered approach for solving personal and professional problems.', '599', 70, 34, 'Book8.jpg', 6)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`), `price`=VALUES(`price`), `quantity`=VALUES(`quantity`), `discount`=VALUES(`discount`), `image`=VALUES(`image`), `cid`=VALUES(`cid`);

-- -----------------------------------------------------
-- Seed 10 Users (passwords hashed with SHA-256 for <Firstname>@123)
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`user` (`userid`, `name`, `email`, `password`, `phone`, `gender`, `address`, `city`, `pincode`, `state`) VALUES
(1, 'Aarav Sharma', 'aarav.sharma@gmail.com', 'e4b43e5ffd723ee7960bda416d7ed1da57aee1a92870f98ae3bc105632e2ef3a', '9820112233', 'Male', '402, Lotus Residency, MG Road', 'Mumbai', '400001', 'Maharashtra'),
(2, 'Priya Patel', 'priya.patel@gmail.com', '8332a769ae64c601ef99f0e2dd51786667f1b3d0e5d125c4ce8841e16cce15c9', '9820223344', 'Female', '12, Sunrise Apartments, CG Road', 'Ahmedabad', '380009', 'Gujarat'),
(3, 'Rohan Verma', 'rohan.verma@gmail.com', 'afc603767d10384e154581e81ffb87b155779152de40646a6ab8532f5717f3c5', '9820334455', 'Male', '88, Cyber City Phase 2', 'Gurugram', '122002', 'Haryana'),
(4, 'Sneha Reddy', 'sneha.reddy@gmail.com', '49cfea30d5fa98c83a03c75a86ef5cf2650d95cb0df8181a235d7a05f0b764c4', '9820445566', 'Female', '204, Jubilee Hills Road No. 36', 'Hyderabad', '500033', 'Telangana'),
(5, 'Vikram Singh', 'vikram.singh@gmail.com', '05d021dd0fa1429bf38839bcd33df400deb3b2b371acf77c4d39901d747ef656', '9820556677', 'Male', '15, Civil Lines, Near High Court', 'Jaipur', '302006', 'Rajasthan'),
(6, 'Ananya Iyer', 'ananya.iyer@gmail.com', 'f0ec6c416a429482c1e326183df502f582cd19464cef58da4da4ca146c189dda', '9820667788', 'Female', '55, Indiranagar 100ft Road', 'Bangalore', '560038', 'Karnataka'),
(7, 'Karan Malhotra', 'karan.malhotra@gmail.com', '8c0fb68cdf467bd0ffcdbe0086891ca03dbb7ea0519e8325570254a5c8a06381', '9820778899', 'Male', '72, Model Town Block B', 'Ludhiana', '141002', 'Punjab'),
(8, 'Divya Nair', 'divya.nair@gmail.com', 'd1917132becd2cdbceb113225994eb63fdaa40bff526c314b8aecca85d77fe49', '9820889900', 'Female', '18, Marine Drive, Kochi', 'Kochi', '682031', 'Kerala'),
(9, 'Arjun Das', 'arjun.das@gmail.com', '255ea3b51c4ca0814a74e3c1a2392fcf20edeeabcd1b1e6bbc705dde02686ebb', '9820990011', 'Male', '33, Salt Lake Sector 5', 'Kolkata', '700091', 'West Bengal'),
(10, 'Meera Joshi', 'meera.joshi@gmail.com', 'f0dc54ae6497b089cb3f48c1df7becd779d64c507750aa4cb86ab238168f185d', '9820101010', 'Female', '9, FC Road, Shivajinagar', 'Pune', '411005', 'Maharashtra')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `password`=VALUES(`password`), `phone`=VALUES(`phone`), `address`=VALUES(`address`), `city`=VALUES(`city`), `pincode`=VALUES(`pincode`), `state`=VALUES(`state`);

-- -----------------------------------------------------
-- Seed 10 Cart Records
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`cart` (`id`, `uid`, `pid`, `quantity`) VALUES
(1, 1, 1, 1),
(2, 2, 9, 1),
(3, 3, 17, 2),
(4, 4, 25, 1),
(5, 5, 33, 1),
(6, 6, 41, 3),
(7, 7, 3, 1),
(8, 8, 11, 1),
(9, 9, 19, 2),
(10, 10, 35, 1)
ON DUPLICATE KEY UPDATE `quantity`=VALUES(`quantity`);

-- -----------------------------------------------------
-- Seed 10 Orders
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`order` (`id`, `orderid`, `status`, `paymentType`, `userId`, `date`) VALUES
(1, 'ORD-20261018-001', 'Delivered', 'UPI / Net Banking', 1, '2026-10-10 11:20:00'),
(2, 'ORD-20261018-002', 'Out For Delivery', 'Credit/Debit Card', 2, '2026-10-12 14:35:00'),
(3, 'ORD-20261018-003', 'Order Confirmed', 'Cash on Delivery', 3, '2026-10-14 09:15:00'),
(4, 'ORD-20261018-004', 'Order Placed', 'UPI / Net Banking', 4, '2026-10-15 16:45:00'),
(5, 'ORD-20261018-005', 'Delivered', 'Cash on Delivery', 5, '2026-10-11 18:22:00'),
(6, 'ORD-20261018-006', 'Out For Delivery', 'UPI / Net Banking', 6, '2026-10-13 10:10:00'),
(7, 'ORD-20261018-007', 'Order Confirmed', 'Credit/Debit Card', 7, '2026-10-16 13:05:00'),
(8, 'ORD-20261018-008', 'Order Placed', 'Cash on Delivery', 8, '2026-10-17 17:50:00'),
(9, 'ORD-20261018-009', 'Delivered', 'UPI / Net Banking', 9, '2026-10-09 15:30:00'),
(10, 'ORD-20261018-010', 'Order Confirmed', 'Credit/Debit Card', 10, '2026-10-18 08:40:00')
ON DUPLICATE KEY UPDATE `status`=VALUES(`status`), `paymentType`=VALUES(`paymentType`), `date`=VALUES(`date`);

-- -----------------------------------------------------
-- Seed 10 Ordered Products
-- -----------------------------------------------------
INSERT INTO `eazydeals`.`ordered_product` (`oid`, `name`, `quantity`, `price`, `image`, `orderid`) VALUES
(1, 'Apple MacBook Air M2', 1, '87912', 'Laptop1.jpg', 1),
(2, 'iPhone 15 Pro Max', 1, '124108', 'Mobile1.jpg', 2),
(3, 'Sony WH-1000XM5 Wireless Headphones', 1, '20393', 'Electronic1.jpg', 3),
(4, 'LG 55-inch 4K Smart OLED TV', 1, '77993', 'Appliance1.jpg', 4),
(5, 'Ergonomic Executive Office Chair', 1, '8999', 'Furniture1.jpg', 5),
(6, 'Atomic Habits by James Clear', 2, '389', 'Book1.jpg', 6),
(7, 'HP Pavilion 15 Gaming', 1, '63131', 'Laptop3.jpg', 7),
(8, 'Google Pixel 8 Pro', 1, '77399', 'Mobile3.jpg', 8),
(9, 'JBL Flip 6 Portable Bluetooth Speaker', 1, '6499', 'Electronic3.jpg', 9),
(10, 'Scandinavian Fabric 3-Seater Sofa', 1, '19713', 'Furniture3.jpg', 10)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `quantity`=VALUES(`quantity`), `price`=VALUES(`price`), `image`=VALUES(`image`);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
