-- MySQL Script generated by MySQL Workbench
-- Tue Aug  1 12:00:55 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema autocvk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema autocvk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `autocvk` DEFAULT CHARACTER SET utf8 COLLATE utf8_czech_ci ;
USE `autocvk` ;

-- -----------------------------------------------------
-- Table `autocvk`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`users` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL,
  `password` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NULL,
  `role` ENUM('customer', 'admin') CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `name` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `surname` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_czech_ci' NOT NULL,
  `street` VARCHAR(50) NULL,
  `city` VARCHAR(45) NULL,
  `postcode` VARCHAR(5) NULL,
  `phone` VARCHAR(12) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB
ROW_FORMAT = Default;


-- -----------------------------------------------------
-- Table `autocvk`.`categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`categories` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `parent` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_categories_categories1_idx` (`parent` ASC),
  CONSTRAINT `fk_categories_categories1`
    FOREIGN KEY (`parent`)
    REFERENCES `autocvk`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`products` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`products` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(5000) NOT NULL,
  `price` MEDIUMINT(6) UNSIGNED NULL,
  `price_text` ENUM('od', 'dohodou', 'v textu') NULL,
  `weight` MEDIUMINT(6) NULL,
  `quantity` SMALLINT(5) UNSIGNED NULL,
  `timestamp` DATETIME NOT NULL,
  `category` INT NOT NULL,
  `show` TINYINT(1) NOT NULL,
  `photo` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_products_categories1_idx` (`category` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  FULLTEXT INDEX `name_fulltext` (`name` ASC),
  FULLTEXT INDEX `description_fulltext` (`description` ASC),
  FULLTEXT INDEX `fulltext_search` (`name` ASC, `description` ASC),
  CONSTRAINT `fk_products_categories1`
    FOREIGN KEY (`category`)
    REFERENCES `autocvk`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`delivery`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`delivery` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`delivery` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `price` MEDIUMINT(6) NULL,
  `show` TINYINT(1) NOT NULL,
  `tooltip` VARCHAR(300) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`payment` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`payment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `price` MEDIUMINT(6) NULL,
  `show` TINYINT(1) NOT NULL,
  `tooltip` VARCHAR(300) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`orders` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer` INT UNSIGNED NOT NULL,
  `delivery` INT UNSIGNED NULL,
  `payment` INT UNSIGNED NULL,
  `timestamp` DATETIME NOT NULL,
  `total` INT NULL,
  `state` ENUM('čeká na vyřízení', 'zboží odesláno', 'připraveno k vyzvednutí', 'objednávka vyřízena', 'objednávka zrušena') NOT NULL,
  `note` VARCHAR(1000) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_users_idx` (`customer` ASC),
  INDEX `fk_orders_delivery1_idx` (`delivery` ASC),
  INDEX `fk_orders_payment1_idx` (`payment` ASC),
  CONSTRAINT `fk_orders_users`
    FOREIGN KEY (`customer`)
    REFERENCES `autocvk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_delivery1`
    FOREIGN KEY (`delivery`)
    REFERENCES `autocvk`.`delivery` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_payment1`
    FOREIGN KEY (`payment`)
    REFERENCES `autocvk`.`payment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`baskets`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`baskets` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`baskets` (
  `users_id` INT UNSIGNED NOT NULL,
  `products_id` INT NOT NULL,
  `quantity` SMALLINT(5) NOT NULL,
  PRIMARY KEY (`users_id`, `products_id`),
  INDEX `fk_baskets_products1_idx` (`products_id` ASC),
  CONSTRAINT `fk_baskets_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `autocvk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_baskets_products1`
    FOREIGN KEY (`products_id`)
    REFERENCES `autocvk`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `autocvk`.`ordered_products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `autocvk`.`ordered_products` ;

CREATE TABLE IF NOT EXISTS `autocvk`.`ordered_products` (
  `orders_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `products_id` INT NOT NULL,
  `price` MEDIUMINT(6) UNSIGNED NULL,
  `price_text` ENUM('od', 'dohodou', 'v textu') NULL,
  `quantity` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`orders_id`, `products_id`),
  INDEX `fk_orders_has_products_products2_idx` (`products_id` ASC),
  INDEX `fk_orders_has_products_orders2_idx` (`orders_id` ASC),
  CONSTRAINT `fk_orders_has_products_orders2`
    FOREIGN KEY (`orders_id`)
    REFERENCES `autocvk`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_has_products_products2`
    FOREIGN KEY (`products_id`)
    REFERENCES `autocvk`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `autocvk` ;

-- -----------------------------------------------------
-- Placeholder table for view `autocvk`.`enum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autocvk`.`enum` (`TABLE` INT, `COLUMN` INT, `ENUM` INT);

-- -----------------------------------------------------
-- procedure default_user
-- -----------------------------------------------------

USE `autocvk`;
DROP procedure IF EXISTS `autocvk`.`default_user`;

DELIMITER $$
USE `autocvk`$$
CREATE PROCEDURE `default_user` ()
BEGIN

DELETE FROM `users`;
INSERT INTO `users` (`id`, `username`, `password`, `role`, `name`, `surname`, `street`, `city`, `postcode`,`phone`) VALUES
(1, 'vladankudlac@gmail.com', '$2y$10$GP0qWQoAHlKwi7M/JQO/CuQmHlFz8fvPx7GlelY5KL6Z8OXH2wWqi', 'customer', 'Vladan', 'Kudláč', NULL, NULL, NULL, NULL),
(2, 'a@b.cz', '$2y$10$WCEK2p1gdOv311jYloz4geIiIb.bbbv/ZVb6cr1hfveu.bEuv/XL6', 'customer', 'Vladan', 'Kudláč', 'Optátova 26', 'Brno', '62300', '420777050404'),
(4, 'master', '$2y$10$TVYlvBbaA8H2LzPr8kGKq.1TkW78wddlySIaC.DbvOQ2qBNno4MKq', 'admin', 'Vladimír', 'Kudláč', NULL, NULL, NULL, '003467346576');

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure default_catogories
-- -----------------------------------------------------

USE `autocvk`;
DROP procedure IF EXISTS `autocvk`.`default_catogories`;

DELIMITER $$
USE `autocvk`$$
CREATE PROCEDURE `default_catogories` ()
BEGIN

DELETE FROM `categories`;
INSERT INTO `categories` (`id`, `name`, `parent`) VALUES ('1', 'Ostatní', NULL);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure default_products
-- -----------------------------------------------------

USE `autocvk`;
DROP procedure IF EXISTS `autocvk`.`default_products`;

DELIMITER $$
USE `autocvk`$$
CREATE PROCEDURE `default_products` ()
BEGIN

DELETE FROM `products`;
INSERT INTO `products` (`id`, `name`, `description`, `condition`, `price`, `weight`, `quantity`, `timestamp`, `category`, `show`) VALUES
(1, 'Alternátor Citroen Xantia', 'Alternátor je točivý elektrický stroj pracující v generátorickém režimu tedy jako elektrický generátor; přeměňuje kinetickou energii (pohybovou energii) rotačního pohybu na energii elektrickou ve formě střídavého proudu. Výstupní střídavý proud (a odpovídající střídavé napětí) může být jednofázový nebo vícefázový. Alternátor pracuje na principu elektromagnetické indukce – ve vodiči je indukováno napětí, pokud se vodič a magnetické pole vůči sobě pohybují.', 'Použité', 1500, 1100, 1, '2016-04-03 00:00:00', 1, 1),
(2, 'Modul zapalování (Xsara, Berlingo, 306, 307)', 'Systém zapalování vytváří jiskru nebo ohřívá elektrodu na vysokou teplotu k zapálení směsi vzduchu a paliva v zážehových spalovacích motorech s vnitřním spalováním naftových a plynových kotlů, raketových motorů, atd. Nejširší aplikace pro zážehové motory s vnitřním spalováním je u zážehových silničních vozidel: vozy (Auta), čtyři-krát čtyřy (SUV), pick-upy, dodávky, nákladní automobily, autobusy. Vznětové motory dieselové vznícení směsi paliva a vzduchu pomocí kompresního tepla a nepotřebují jiskru. Obvykle mají žhavicí svíčky, které předehřívání do spalovací komory, aby začíná v chladném počasí. Ostatní motory mohou používat plamen, nebo vyhřívanou trubku, pro zapalování. I když je to běžné, velmi časných motorů je nyní vzácný. První elektrická jiskra byla pravděpodobně Alessandro Volta hračka elektrické pistole od 1780s.', 'Použité', 1500, 970, 2, '2016-04-04 00:00:00', 1, 1),
(3, 'Modul zapalování Xantia, ZX, Peugeot 306', '<table>\n<tr><td>Obsah motoru:<td><td>1.4i</id></tr>\n<tr><td>Rok výroby:<td><td>1996 - 1998</td></tr>\n</table>', 'Použité', 500, 400, 3, '2016-04-12 00:00:00', 1, 1),
(4, 'Sada předních brzdových destiček C4 Grand Picasso', 'Šířka 1 [mm]: 155,1<br>výška 1 [mm]: 72<br>Tloustka/sila 1 [mm]: 19,5<br>Šířka 2 [mm]: 155,1<br>výška 2 [mm]: 66,6<br>Tloustka/sila 2 [mm]: 18,7<br>výstražný kontakt: není určeno pro výstražný indikátor<br>výstražný kontakt: bez výstražného kontaktu<br>brzdový systém: ATE<br>zkušební značka: E1 90R-011104/952', 'Nové', 2100, 1000, 1, '2016-04-12 00:00:00', 1, 1),
(5, 'Sada předních brzdových kotoučů C4 Grand Picasso', 'průměr [mm]: 302<br>tloušťka brzdového kotouče [mm]: 26,0<br>minimální tloušťka [mm]: 24<br>typ brzdového kotouče: chlazeno<br>povrch: nater<br>Počet otvorů: 4<br>průměr kruhového otvoru [mm]: 108<br>výška [mm]: 34,2<br>Centrovaci prumer [mm]: 66<br>vnitřní průměr [mm]: 133<br>průměr otvoru [mm]: 13', 'Nové', 3500, 3000, 1, '2016-04-12 00:00:00', 1, 1),
(6, 'Řidící jednotka motoru BX', '<table>\r\n<tr><td>Obsah motoru:<td><td>1.6i jednobodové vstřikování</id></tr>\r\n<tr><td>Rok výroby:<td><td>1991</td></tr>\r\n</table>', 'Nové', 11000, 500, 1, '2016-04-12 00:00:00', 1, 1),
(7, 'Hydraulická kapalina LHM PLUS 25l', '<table>\r\n<tr><td>Výrobce:<td><td>Total</id></tr>\r\n</table>', 'Nové', 4000, 25000, 5, '2016-04-12 00:00:00', 1, 1),
(8, 'Zámek dveří ZX', '<table>\r\n<tr><td>Dveře<td><td>Pravé přední</id></tr>\r\n</table>', 'Použité', 300, 1000, 1, '2016-04-12 00:00:00', 1, 1),
(9, 'Snímač otáček motoru Xantia', '<table>\r\n<tr><td>Obsah motoru:<td><td>1.9TD</id></tr>\r\n<tr><td>Rok výroby:<td><td>1996 - 1998</td></tr>\r\n</table>', 'Použité', 200, 200, 1, '2016-04-12 00:00:00', 1, 1),
(10, 'Pravé zadní světlo Xsara Picasso', '', 'Použité', 500, 500, 2, '2016-04-12 00:00:00', 1, 1),
(11, 'Sada: Kryt kola Citroen Xsara Picasso', 'Rozměr: 15"\r\nPočet kusů v sadě: 4 ks', 'Nové', 400, 500, 1, '2016-04-12 00:00:00', 1, 1),
(12, 'Levé zadní světlo Citroen BX', '<table>\r\n<tr><td>Rok výroby:<td><td>od roku 1989</td></tr>\r\n</table>', 'Nové', 250, 500, 1, '2016-04-12 00:00:00', 1, 1);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure default_delivery
-- -----------------------------------------------------

USE `autocvk`;
DROP procedure IF EXISTS `autocvk`.`default_delivery`;

DELIMITER $$
USE `autocvk`$$
CREATE PROCEDURE `default_delivery` ()
BEGIN

DELETE FROM `delivery`;
INSERT INTO `delivery` (`id`, `name`, `price`, `show`, `tooltip`, `type`) VALUES
(1, 'Česká pošta', 99, 1, 'Doručení do 2 týdnů.', NULL),
(2, 'PPL', 99, 1, 'Rychlé, spolehlivé a oblíbené.', NULL),
(3, 'Uloženka', 20, 1, '', NULL);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure default_payment
-- -----------------------------------------------------

USE `autocvk`;
DROP procedure IF EXISTS `autocvk`.`default_payment`;

DELIMITER $$
USE `autocvk`$$
CREATE PROCEDURE `default_payment` ()
BEGIN

DELETE FROM `payment`;
INSERT INTO `payment` (`id`, `name`, `price`, `show`, `tooltip`, `type`) VALUES
(1, 'Převodem předem', '0', '1', NULL, NULL),
(2, 'Kartou online', '99', '1', NULL, NULL),
(3, 'Dobírkou při převzetí', '49', '1', NULL, NULL);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `autocvk`.`enum`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `autocvk`.`enum` ;
DROP TABLE IF EXISTS `autocvk`.`enum`;
USE `autocvk`;
CREATE  OR REPLACE VIEW `enum` AS
SELECT `schema`.`TABLE_NAME` AS `TABLE`, `schema`.`COLUMN_NAME` AS `COLUMN`, `schema`.`COLUMN_TYPE` AS `ENUM`
FROM information_schema.COLUMNS AS `schema`
WHERE `schema`.DATA_TYPE LIKE 'enum' && `schema`.TABLE_SCHEMA LIKE 'autocvk';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;