-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema gaming_site
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema gaming_site
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `gaming_site` DEFAULT CHARACTER SET utf8 ;
USE `gaming_site` ;

-- -----------------------------------------------------
-- Table `gaming_site`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`discounts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `percentage` INT NOT NULL,
  `started_at` DATETIME NOT NULL,
  `ended_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `is_male` TINYINT NOT NULL,
  `is_admin` TINYINT NOT NULL,
  `is_subscribed` TINYINT NOT NULL,
  `verified` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `userscol_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `price` DOUBLE NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `created_at` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `useridorders_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `useridorders`
    FOREIGN KEY (`user_id`)
    REFERENCES `gaming_site`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`sub_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`sub_categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `categoryid_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `categoryid`
    FOREIGN KEY (`category_id`)
    REFERENCES `gaming_site`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `brand` VARCHAR(45) NOT NULL,
  `price` DOUBLE NOT NULL,
  `sub_category` INT NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `discount_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `subcategoryid_idx` (`sub_category` ASC) VISIBLE,
  INDEX `discountidproduct_idx` (`discount_id` ASC) VISIBLE,
  CONSTRAINT `discountidproduct`
    FOREIGN KEY (`discount_id`)
    REFERENCES `gaming_site`.`discounts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `subcategoryid`
    FOREIGN KEY (`sub_category`)
    REFERENCES `gaming_site`.`sub_categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`orders_have_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`orders_have_products` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`order_id`, `product_id`),
  INDEX `haveproductsproductid_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `haveproductsordersid`
    FOREIGN KEY (`order_id`)
    REFERENCES `gaming_site`.`orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `haveproductsproductid`
    FOREIGN KEY (`product_id`)
    REFERENCES `gaming_site`.`products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`product_images`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`product_images` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(45) NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `productimageproductid_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `productimageproductid`
    FOREIGN KEY (`product_id`)
    REFERENCES `gaming_site`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`reviews` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `rating` INT NOT NULL,
  `comment` TEXT NULL DEFAULT NULL,
  `is_recommended` TINYINT NOT NULL,
  `created_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `reviewuserid_idx` (`user_id` ASC) VISIBLE,
  INDEX `reviewproductid_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `reviewproductid`
    FOREIGN KEY (`product_id`)
    REFERENCES `gaming_site`.`products` (`id`),
  CONSTRAINT `reviewuserid`
    FOREIGN KEY (`user_id`)
    REFERENCES `gaming_site`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`user_have_favourites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`user_have_favourites` (
  `user_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`product_id`, `user_id`),
  INDEX `useridonfavs_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `productidonfavs`
    FOREIGN KEY (`product_id`)
    REFERENCES `gaming_site`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `useridonfavs`
    FOREIGN KEY (`user_id`)
    REFERENCES `gaming_site`.`users` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `gaming_site`.`verifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `gaming_site`.`verifications` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `token` VARCHAR(250) NOT NULL,
  `user_id` INT NOT NULL,
  `expire_date` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `token_UNIQUE` (`token` ASC) VISIBLE,
  INDEX `verificationsuserid_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `verificationsuserid`
    FOREIGN KEY (`user_id`)
    REFERENCES `gaming_site`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
