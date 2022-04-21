-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema tmarket
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(1) NOT NULL,
  `is_admin` TINYINT NOT NULL,
  `is_subscribed` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`discounts` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `percentage` INT NOT NULL,
  `started_at` DATE NOT NULL,
  `end_at` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`categories` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`subcategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`subcategories` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `categ_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `category_id_idx` (`categ_id` ASC) VISIBLE,
  CONSTRAINT `category_id`
    FOREIGN KEY (`categ_id`)
    REFERENCES `mydb`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`products` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `quantity` DOUBLE NOT NULL,
  `description` TEXT NOT NULL,
  `subcategory_id` INT NOT NULL,
  `price` DOUBLE NOT NULL,
  `producer` VARCHAR(45) NOT NULL,
  `is_new` TINYINT NOT NULL,
  `discount_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `discount_id_idx` (`discount_id` ASC) VISIBLE,
  INDEX `subcategory_id_idx` (`subcategory_id` ASC) VISIBLE,
  CONSTRAINT `discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `mydb`.`discounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `subcategory_id`
    FOREIGN KEY (`subcategory_id`)
    REFERENCES `mydb`.`subcategories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product_images`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product_images` (
  `id` INT NOT NULL,
  `url` VARCHAR(2050) NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`users_have_favourites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`users_have_favourites` (
  `user_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `product_id_idx` (`product_id` ASC) INVISIBLE,
  PRIMARY KEY (`user_id`, `product_id`),
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
  `id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `price` DOUBLE NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `created_at` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`users` (`password`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders_have_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`orders_have_products` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`order_id`, `product_id`),
  INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
