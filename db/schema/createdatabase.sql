SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `ambrosia` ;
CREATE SCHEMA IF NOT EXISTS `ambrosia` DEFAULT CHARACTER SET latin1 ;
USE `ambrosia` ;

-- -----------------------------------------------------
-- Table `ambrosia`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`users` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(64) NOT NULL ,
  `firstname` VARCHAR(45) NOT NULL ,
  `lastname` VARCHAR(45) NOT NULL ,
  `admin` TINYINT NOT NULL DEFAULT false ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`eatingdays`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`eatingdays` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`eatingdays` (
  `id` INT NOT NULL ,
  `date` DATETIME NOT NULL ,
  `user_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_eatingday_user1` (`user_id` ASC) ,
  CONSTRAINT `fk_eatingday_user1`
    FOREIGN KEY (`user_id` )
    REFERENCES `ambrosia`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`groups` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`groups` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`ingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`ingredients` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`ingredients` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `group_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_ingredient_group1` (`group_id` ASC) ,
  CONSTRAINT `fk_ingredient_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipes` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `creationdate` DATETIME NULL DEFAULT NULL ,
  `modificationdate` DATETIME NULL DEFAULT NULL ,
  `group_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_recipe_group1` (`group_id` ASC) ,
  CONSTRAINT `fk_recipe_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipesrecipes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipesrecipes` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipesrecipes` (
  `recipeId` INT(11) NOT NULL ,
  `recipesId` INT(11) NOT NULL ,
  PRIMARY KEY (`recipeId`, `recipesId`) ,
  INDEX `fk_recipe_has_recipe_recipe2` (`recipesId` ASC) ,
  INDEX `fk_recipe_has_recipe_recipe1` (`recipeId` ASC) ,
  CONSTRAINT `fk_recipe_has_recipe_recipe1`
    FOREIGN KEY (`recipeId` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_recipe_recipe2`
    FOREIGN KEY (`recipesId` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`tags` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`tags` (
  `id` INT(11) NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  `group_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_tag_group1` (`group_id` ASC) ,
  CONSTRAINT `fk_tag_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipestags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipestags` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipestags` (
  `recipe_id` INT(11) NOT NULL ,
  `tag_id` INT(11) NOT NULL ,
  PRIMARY KEY (`recipe_id`, `tag_id`) ,
  INDEX `fk_recipe_has_tag_tag1` (`tag_id` ASC) ,
  INDEX `fk_recipe_has_tag_recipe1` (`recipe_id` ASC) ,
  CONSTRAINT `fk_recipe_has_tag_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_tag_tag1`
    FOREIGN KEY (`tag_id` )
    REFERENCES `ambrosia`.`tags` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`reviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`reviews` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`reviews` (
  `id` INT(11) NOT NULL ,
  `grade` INT(11) NOT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `user_id` INT(11) NOT NULL ,
  `recipe_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_review_user1` (`user_id` ASC) ,
  INDEX `fk_review_recipe1` (`recipe_id` ASC) ,
  CONSTRAINT `fk_review_user1`
    FOREIGN KEY (`user_id` )
    REFERENCES `ambrosia`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_recipe1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`units`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`units` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`units` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL DEFAULT NULL ,
  `group_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_unit_group1` (`group_id` ASC) ,
  CONSTRAINT `fk_unit_group1`
    FOREIGN KEY (`group_id` )
    REFERENCES `ambrosia`.`groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`recipesingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`recipesingredients` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`recipesingredients` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `amount` DECIMAL NULL ,
  `recipes_id` INT(11) NOT NULL ,
  `ingredients_id` INT(11) NOT NULL ,
  `units_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`, `recipes_id`, `ingredients_id`, `units_id`) ,
  INDEX `fk_recipesingredients_recipes1` (`recipes_id` ASC) ,
  INDEX `fk_recipesingredients_ingredients1` (`ingredients_id` ASC) ,
  INDEX `fk_recipesingredients_units1` (`units_id` ASC) ,
  CONSTRAINT `fk_recipesingredients_recipes1`
    FOREIGN KEY (`recipes_id` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipesingredients_ingredients1`
    FOREIGN KEY (`ingredients_id` )
    REFERENCES `ambrosia`.`ingredients` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipesingredients_units1`
    FOREIGN KEY (`units_id` )
    REFERENCES `ambrosia`.`units` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ambrosia`.`eatingdayrecipes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`eatingdayrecipes` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`eatingdayrecipes` (
  `eatingdays_id` INT NOT NULL ,
  `recipe_id` INT(11) NOT NULL ,
  PRIMARY KEY (`eatingdays_id`, `recipe_id`) ,
  INDEX `fk_eatingdays_has_recipes_recipes1` (`recipe_id` ASC) ,
  INDEX `fk_eatingdays_has_recipes_eatingdays1` (`eatingdays_id` ASC) ,
  CONSTRAINT `fk_eatingdays_has_recipes_eatingdays1`
    FOREIGN KEY (`eatingdays_id` )
    REFERENCES `ambrosia`.`eatingdays` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_eatingdays_has_recipes_recipes1`
    FOREIGN KEY (`recipe_id` )
    REFERENCES `ambrosia`.`recipes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`eatingdayingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`eatingdayingredients` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`eatingdayingredients` (
  `eatingday_id` INT NOT NULL ,
  `ingredient_id` INT(11) NOT NULL ,
  PRIMARY KEY (`eatingday_id`, `ingredient_id`) ,
  INDEX `fk_eatingdays_has_ingredients_ingredients1` (`ingredient_id` ASC) ,
  INDEX `fk_eatingdays_has_ingredients_eatingdays1` (`eatingday_id` ASC) ,
  CONSTRAINT `fk_eatingdays_has_ingredients_eatingdays1`
    FOREIGN KEY (`eatingday_id` )
    REFERENCES `ambrosia`.`eatingdays` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_eatingdays_has_ingredients_ingredients1`
    FOREIGN KEY (`ingredient_id` )
    REFERENCES `ambrosia`.`ingredients` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ambrosia`.`users_has_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ambrosia`.`users_has_groups` ;

CREATE  TABLE IF NOT EXISTS `ambrosia`.`users_has_groups` (
  `users_id` INT(11) NOT NULL ,
  `groups_id` INT(11) NOT NULL ,
  PRIMARY KEY (`users_id`, `groups_id`) ,
  INDEX `fk_users_has_groups_groups1` (`groups_id` ASC) ,
  INDEX `fk_users_has_groups_users1` (`users_id` ASC) ,
  CONSTRAINT `fk_users_has_groups_users1`
    FOREIGN KEY (`users_id` )
    REFERENCES `ambrosia`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_groups_groups1`
    FOREIGN KEY (`groups_id` )
    REFERENCES `ambrosia`.`groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
