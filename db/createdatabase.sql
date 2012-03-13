SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `ambrosia` ;
CREATE SCHEMA IF NOT EXISTS `ambrosia` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `ambrosia` ;

-- -----------------------------------------------------
-- Table `ambrosia`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`user` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(64) NOT NULL ,
  `firstname` VARCHAR(45) NOT NULL ,
  `lastname` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`review` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`review` (
  `id` INT NOT NULL ,
  `grade` INT NOT NULL ,
  `description` VARCHAR(255) NULL ,
  `user_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_review_user1` (`user_id` ASC) ,
  CONSTRAINT `fk_review_user1`
    FOREIGN KEY (`user_id` )
    REFERENCES `ambrosia`.`user` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipe` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipe` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL ,
  `review_id` INT NOT NULL ,
  `creationdate` DATETIME NULL ,
  `modificationdate` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_recipe_review1` (`review_id` ASC) ,
  CONSTRAINT `fk_recipe_review1`
    FOREIGN KEY (`review_id` )
    REFERENCES `ambrosia`.`review` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`ingredient` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`ingredient` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`unit` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`unit` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipe_has_ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipe_has_ingredient` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipe_has_ingredient` (
  `recipe_id` INT NOT NULL ,
  `ingredient_id` INT NOT NULL ,
  `unit_id` INT NOT NULL ,
  `amount` FLOAT NOT NULL ,
  PRIMARY KEY (`recipe_id`, `ingredient_id`) ,
  INDEX `fk_recipy_has_ingredient_ingredient1` (`ingredient_id` ASC) ,
  INDEX `fk_recipy_has_ingredient_recipy` (`recipe_id` ASC) ,
  INDEX `fk_recipy_has_ingredient_unit1` (`unit_id` ASC) ,
  CONSTRAINT `fk_recipy_has_ingredient_recipy`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipy_has_ingredient_ingredient1`
    FOREIGN KEY (`ingredient_id` )
    REFERENCES `ambrosia`.`ingredient` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipy_has_ingredient_unit1`
    FOREIGN KEY (`unit_id` )
    REFERENCES `ambrosia`.`unit` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipe_has_recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipe_has_recipe` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipe_has_recipe` (
  `recipe_id` INT NOT NULL ,
  `recipe_id1` INT NOT NULL ,
  PRIMARY KEY (`recipe_id`, `recipe_id1`) ,
  INDEX `fk_recipe_has_recipe_recipe2` (`recipe_id1` ASC) ,
  INDEX `fk_recipe_has_recipe_recipe1` (`recipe_id` ASC) ,
  CONSTRAINT `fk_recipe_has_recipe_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_recipe_recipe2`
    FOREIGN KEY (`recipe_id1` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`tag` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`tag` (
  `id` INT NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipe_has_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipe_has_tag` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipe_has_tag` (
  `recipe_id` INT NOT NULL ,
  `tag_id` INT NOT NULL ,
  PRIMARY KEY (`recipe_id`, `tag_id`) ,
  INDEX `fk_recipe_has_tag_tag1` (`tag_id` ASC) ,
  INDEX `fk_recipe_has_tag_recipe1` (`recipe_id` ASC) ,
  CONSTRAINT `fk_recipe_has_tag_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_tag_tag1`
    FOREIGN KEY (`tag_id` )
    REFERENCES `ambrosia`.`tag` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`group` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`group` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`group_has_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`group_has_user` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`group_has_user` (
  `group_id` INT NOT NULL ,
  `user_id` INT NOT NULL ,
  PRIMARY KEY (`group_id`, `user_id`) ,
  INDEX `fk_group_has_user_user1` (`user_id` ASC) ,
  INDEX `fk_group_has_user_group1` (`group_id` ASC) ,
  CONSTRAINT `fk_group_has_user_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`group` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_user_user1`
    FOREIGN KEY (`user_id` )
    REFERENCES `ambrosia`.`user` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`eatingday`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`eatingday` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`eatingday` (
  `date` DATETIME NOT NULL ,
  PRIMARY KEY (`date`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`group_has_recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`group_has_recipe` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`group_has_recipe` (
  `group_id` INT NOT NULL ,
  `recipe_id` INT NOT NULL ,
  `eatingday_date` DATETIME NOT NULL ,
  PRIMARY KEY (`group_id`, `recipe_id`, `eatingday_date`) ,
  INDEX `fk_group_has_recipe_recipe1` (`recipe_id` ASC) ,
  INDEX `fk_group_has_recipe_group1` (`group_id` ASC) ,
  INDEX `fk_group_has_recipe_eatingday1` (`eatingday_date` ASC) ,
  CONSTRAINT `fk_group_has_recipe_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`group` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_recipe_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_recipe_eatingday1`
    FOREIGN KEY (`eatingday_date` )
    REFERENCES `ambrosia`.`eatingday` (`date` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
