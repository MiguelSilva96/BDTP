-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema IberoTrem
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema IberoTrem
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `IberoTrem` DEFAULT CHARACTER SET utf8 ;
USE `IberoTrem` ;

-- -----------------------------------------------------
-- Table `IberoTrem`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Cliente` (
  `CC` VARCHAR(15) NOT NULL,
  `Data_de_Nascimento` DATE NOT NULL,
  `Nome` VARCHAR(64) NOT NULL,
  `Telefone` VARCHAR(15) NULL,
  `Email` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`CC`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IberoTrem`.`Estação`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Estação` (
  `Id_estação` INT NOT NULL,
  `Nome` VARCHAR(32) NOT NULL,
  `Cidade` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`Id_estação`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IberoTrem`.`Comboio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Comboio` (
  `Id_comboio` INT NOT NULL,
  `Nr_lugares` INT NOT NULL,
  PRIMARY KEY (`Id_comboio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IberoTrem`.`Viagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Viagem` (
  `Id_viagem` INT NOT NULL,
  `Hora_partida` TIME NOT NULL,
  `Hora_chegada` TIME NOT NULL,
  `Preço` FLOAT NOT NULL,
  `Id_estação_origem` INT NOT NULL,
  `Id_comboio` INT NOT NULL,
  `Id_estação_destino` INT NOT NULL,
  PRIMARY KEY (`Id_viagem`),
  INDEX `Id_estação_idx` (`Id_estação_origem` ASC),
  INDEX `fk_Viagem_1_idx` (`Id_comboio` ASC),
  INDEX `fk_Viagem_Estação1_idx` (`Id_estação_destino` ASC),
  CONSTRAINT `Id_estação`
    FOREIGN KEY (`Id_estação_origem`)
    REFERENCES `IberoTrem`.`Estação` (`Id_estação`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Viagem_1`
    FOREIGN KEY (`Id_comboio`)
    REFERENCES `IberoTrem`.`Comboio` (`Id_comboio`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Viagem_Estação1`
    FOREIGN KEY (`Id_estação_destino`)
    REFERENCES `IberoTrem`.`Estação` (`Id_estação`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IberoTrem`.`Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Reserva` (
  `Id_reserva` INT NOT NULL,
  `Lugar` INT NOT NULL,
  `Data` DATE NOT NULL,
  `CC` VARCHAR(15) NOT NULL,
  `Id_viagem` INT NOT NULL,
  PRIMARY KEY (`Id_reserva`),
  INDEX `CC INT_idx` (`CC` ASC),
  INDEX `Id_viagem_idx` (`Id_viagem` ASC),
  CONSTRAINT `CC `
    FOREIGN KEY (`CC`)
    REFERENCES `IberoTrem`.`Cliente` (`CC`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `Id_viagem`
    FOREIGN KEY (`Id_viagem`)
    REFERENCES `IberoTrem`.`Viagem` (`Id_viagem`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `IberoTrem`.`Lugares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `IberoTrem`.`Lugares` (
  `Lugar` INT NOT NULL,
  `Comboio` INT NOT NULL,
  PRIMARY KEY (`Lugar`, `Comboio`),
  INDEX `fk_Lugares_Comboio1_idx` (`Comboio` ASC),
  CONSTRAINT `fk_Lugares_Comboio1`
    FOREIGN KEY (`Comboio`)
    REFERENCES `IberoTrem`.`Comboio` (`Id_comboio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
