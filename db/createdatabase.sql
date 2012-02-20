SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `ambrosia` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `ambrosia` ;

-- -----------------------------------------------------
-- Table `ambrosia`.`recipe`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipe` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`ingredient`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ambrosia`.`ingredient` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`unit`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ambrosia`.`unit` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipe_has_ingredient`
-- -----------------------------------------------------
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
-- Table `ambrosia`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ambrosia`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(32) NOT NULL ,
  `firstname` VARCHAR(45) NOT NULL ,
  `lastname` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`user_has_recipe`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ambrosia`.`user_has_recipe` (
  `user_id` INT NOT NULL ,
  `recipe_id` INT NOT NULL ,
  `lasteaten` DATETIME NULL ,
  PRIMARY KEY (`user_id`, `recipe_id`) ,
  INDEX `fk_user_has_recipe_recipe1` (`recipe_id` ASC) ,
  INDEX `fk_user_has_recipe_user1` (`user_id` ASC) ,
  CONSTRAINT `fk_user_has_recipe_user1`
    FOREIGN KEY (`user_id` )
    REFERENCES `ambrosia`.`user` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_recipe_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipe` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
