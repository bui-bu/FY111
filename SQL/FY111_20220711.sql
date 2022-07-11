-- MySQL Script generated by MySQL Workbench
-- Mon Jul 11 11:26:09 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fy111
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema fy111
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fy111` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `fy111` ;

-- -----------------------------------------------------
-- Table `fy111`.`device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`device` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `icon` VARCHAR(45) NULL DEFAULT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fy111`.`login_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`login_log` (
  `Member_id` VARCHAR(256) NOT NULL,
  `Device_type` INT NOT NULL,
  `start_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Member_id`, `start_time`),
  INDEX `fk_Login_Log_Device1_idx` (`Device_type` ASC) VISIBLE,
  CONSTRAINT `fk_Login_Log_Device1`
    FOREIGN KEY (`Device_type`)
    REFERENCES `fy111`.`device` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fy111`.`Class`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`Class` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NULL,
  `name` VARCHAR(45) NOT NULL,
  `ip` CHAR(15) NULL,
  `image` VARCHAR(45) NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  `signup_enabled` TINYINT NOT NULL DEFAULT '0',
  `checkin_enabled` TINYINT NOT NULL DEFAULT '0',
  `duration` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fy111`.`class_signup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`class_signup` (
  `Member_id` VARCHAR(256) NOT NULL,
  `Class_id` INT NOT NULL,
  PRIMARY KEY (`Member_id`, `Class_id`),
  INDEX `fk_Metaverse_has_Member_Metaverse2_idx` (`Class_id` ASC) VISIBLE,
  CONSTRAINT `fk_Metaverse_has_Member_Metaverse2`
    FOREIGN KEY (`Class_id`)
    REFERENCES `fy111`.`Class` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fy111`.`class_checkin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`class_checkin` (
  `Member_id` VARCHAR(256) NOT NULL,
  `Class_id` INT NOT NULL,
  `time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Member_id`, `Class_id`),
  INDEX `fk_Metaverse_has_Member_Metaverse1_idx` (`Class_id` ASC) VISIBLE,
  CONSTRAINT `fk_Metaverse_has_Member_Metaverse1`
    FOREIGN KEY (`Class_id`)
    REFERENCES `fy111`.`Class` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `fy111`.`Class_unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`Class_unit` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Class_id` INT NOT NULL,
  `code` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `image` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_class_unit_class1`
    FOREIGN KEY (`Class_id`)
    REFERENCES `fy111`.`Class` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`class_littleunit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`class_littleunit` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Class_unit_id` INT NOT NULL,
  `code` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `image` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_class_littleunit_class_unit1`
    FOREIGN KEY (`Class_unit_id`)
    REFERENCES `fy111`.`Class_unit` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`operation_unit_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`operation_unit_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Member_id` VARCHAR(256) NULL,
  `unit_code` VARCHAR(45) NULL,
  `pass` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`operation_littleunit_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`operation_littleunit_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `operation_log_id` INT NOT NULL,
  `littleunit_code` VARCHAR(45) NULL,
  `score` INT NULL,
  `pass` TINYINT NULL,
  `start_time` DATETIME NULL,
  `end_time` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_operation_checkpoint_operation_log1`
    FOREIGN KEY (`operation_log_id`)
    REFERENCES `fy111`.`operation_unit_log` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`operation_checkpoint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`operation_checkpoint` (
  `operation_littleunit_log_id` INT NOT NULL,
  `CKPT_id` VARCHAR(45) NOT NULL,
  `PointType` INT NULL,
  INDEX `fk_operation_checkpoint_operation_littleunit_log1_idx` (`operation_littleunit_log_id` ASC) VISIBLE,
  PRIMARY KEY (`operation_littleunit_log_id`, `CKPT_id`),
  CONSTRAINT `fk_operation_checkpoint_operation_littleunit_log1`
    FOREIGN KEY (`operation_littleunit_log_id`)
    REFERENCES `fy111`.`operation_littleunit_log` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`operation_Occdisaster`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`operation_Occdisaster` (
  `operation_littleunit_log_id` INT NOT NULL,
  `OccDisaster_code` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`operation_littleunit_log_id`, `OccDisaster_code`),
  CONSTRAINT `fk_table1_operation_littleunit_log1`
    FOREIGN KEY (`operation_littleunit_log_id`)
    REFERENCES `fy111`.`operation_littleunit_log` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`Occdisaster`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`Occdisaster` (
  `Code` VARCHAR(45) NOT NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`Code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`class_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`class_log` (
  `Member_id` VARCHAR(256) NOT NULL,
  `Class_id` INT NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NULL,
  PRIMARY KEY (`Member_id`, `start_time`),
  INDEX `fk_class_log_Class1_idx` (`Class_id` ASC) VISIBLE,
  CONSTRAINT `fk_class_log_Class1`
    FOREIGN KEY (`Class_id`)
    REFERENCES `fy111`.`Class` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`Timer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`Timer` (
  `Member_id` VARCHAR(256) NOT NULL,
  `start_time` DATETIME NOT NULL,
  PRIMARY KEY (`Member_id`, `start_time`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fy111`.`Class_unit_ckpt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fy111`.`Class_unit_ckpt` (
  `Class_unit_id` INT NOT NULL,
  `CKPT_id` VARCHAR(45) NOT NULL,
  `content` TEXT NULL,
  INDEX `fk_Class_unit_ckpt_Class_unit1_idx` (`Class_unit_id` ASC) VISIBLE,
  PRIMARY KEY (`Class_unit_id`, `CKPT_id`),
  CONSTRAINT `fk_Class_unit_ckpt_Class_unit1`
    FOREIGN KEY (`Class_unit_id`)
    REFERENCES `fy111`.`Class_unit` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `fy111`.`device`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`device` (`id`, `icon`, `name`) VALUES (1, NULL, 'PC');
INSERT INTO `fy111`.`device` (`id`, `icon`, `name`) VALUES (2, NULL, 'Android');
INSERT INTO `fy111`.`device` (`id`, `icon`, `name`) VALUES (3, NULL, 'iOS');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fy111`.`Class`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`Class` (`id`, `code`, `name`, `ip`, `image`, `content`, `signup_enabled`, `checkin_enabled`, `duration`) VALUES (1, 'HA', '高空工作車作業', '', NULL, NULL, 1, 1, 120);
INSERT INTO `fy111`.`Class` (`id`, `code`, `name`, `ip`, `image`, `content`, `signup_enabled`, `checkin_enabled`, `duration`) VALUES (2, 'SF', '施工架作業', '', NULL, NULL, 1, 1, 120);
INSERT INTO `fy111`.`Class` (`id`, `code`, `name`, `ip`, `image`, `content`, `signup_enabled`, `checkin_enabled`, `duration`) VALUES (3, 'SW', '下水道工程模擬訓練', NULL, NULL, NULL, 1, 1, 75);
INSERT INTO `fy111`.`Class` (`id`, `code`, `name`, `ip`, `image`, `content`, `signup_enabled`, `checkin_enabled`, `duration`) VALUES (4, 'GC', '矽甲烷更換鋼瓶', NULL, NULL, NULL, 1, 1, 60);

COMMIT;


-- -----------------------------------------------------
-- Data for table `fy111`.`Class_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`Class_unit` (`id`, `Class_id`, `code`, `name`, `image`) VALUES (1, 1, 'HA_S', '高空工作車作業-剪刀式工作車作業情境單元', NULL);
INSERT INTO `fy111`.`Class_unit` (`id`, `Class_id`, `code`, `name`, `image`) VALUES (2, 1, 'HA_C', '高空工作車作業-車載式工作車作業情境單元', NULL);
INSERT INTO `fy111`.`Class_unit` (`id`, `Class_id`, `code`, `name`, `image`) VALUES (3, 2, 'SF_U', '施工架作業單元', NULL);
INSERT INTO `fy111`.`Class_unit` (`id`, `Class_id`, `code`, `name`, `image`) VALUES (4, 3, 'SW_U', '下水道工程單元', NULL);
INSERT INTO `fy111`.`Class_unit` (`id`, `Class_id`, `code`, `name`, `image`) VALUES (5, 4, 'GC_U', '矽甲烷更換鋼瓶單元', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `fy111`.`class_littleunit`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (1, 1, 'HA_S_00', '高空-剪刀-安全裝備穿戴', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (2, 1, 'HA_S_01', '高空-剪刀-作業前檢點', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (3, 1, 'HA_S_02', '高空-剪刀-修剪路樹作業', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (4, 2, 'HA_C_00', '高空-車載-安全裝備穿戴', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (5, 2, 'HA_C_01', '高空-車載-作業前檢點', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (6, 2, 'HA_C_02', '高空-車載-更換燈泡作業', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (7, 3, 'SF_U_00', '施工架作業-安全裝備穿戴', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (8, 3, 'SF_U_01', '施工架作業-磁磚拼貼及牆壁粉刷', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (9, 3, 'SF_U_02', '施工架作業-磚牆拆除作業', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (10, 3, 'SF_U_03', '施工架作業-壁連座阻力與拆除', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (11, 4, 'SW_U_00', '下水道-下人孔前的準備工作與安全裝備穿戴', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (12, 4, 'SW_U_01', '下水道-下水道清淤作業', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (13, 5, 'GC_U_00', '矽甲烷-鋼瓶置換', NULL);
INSERT INTO `fy111`.`class_littleunit` (`id`, `Class_unit_id`, `code`, `name`, `image`) VALUES (14, 5, 'GC_U_01', '矽甲烷-鋼瓶操作', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `fy111`.`Occdisaster`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_000', '作業中無任何疏失');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_001', '職災1');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_002', '職災2');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_003', '職災3');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_004', '職災4');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_005', '職災5');
INSERT INTO `fy111`.`Occdisaster` (`Code`, `content`) VALUES ('DD_006', '職災6');

COMMIT;


-- -----------------------------------------------------
-- Data for table `fy111`.`Class_unit_ckpt`
-- -----------------------------------------------------
START TRANSACTION;
USE `fy111`;
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_01', '檢查點1');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_02', '檢查點2');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_03', '檢查點3');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_04', '檢查點4');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_05', '檢查點5');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_11', '檢查點11');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_12', '檢查點12');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_13', '檢查點13');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_14', '檢查點14');
INSERT INTO `fy111`.`Class_unit_ckpt` (`Class_unit_id`, `CKPT_id`, `content`) VALUES (1, 'CKPT_15', '檢查點15');

COMMIT;

