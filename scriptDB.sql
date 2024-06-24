
-- -----------------------------------------------------
-- DATEBASE mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- DATEBASE sbd1p1
-- -----------------------------------------------------
DROP DATEBASE IF EXISTS `sbd1p1` ;

-- -----------------------------------------------------
-- DATEBASE sbd1p1
-- -----------------------------------------------------
CREATE DATEBASE IF NOT EXISTS `sbd1p1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `sbd1p1` ;

-- -----------------------------------------------------
-- Table `sbd1p1`.`carrera`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`carrera` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`carrera` (
  `codigo_carrera` VARCHAR(10) NOT NULL,
  `nombre_carrera` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_carrera`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`catedratico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`catedratico` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`catedratico` (
  `codigo_catedratico` VARCHAR(10) NOT NULL,
  `nombre_completo` VARCHAR(100) NULL DEFAULT NULL,
  `sueldo_mensual` INT NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_catedratico`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`curso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`curso` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`curso` (
  `codigo_curso` VARCHAR(10) NOT NULL,
  `nombre_curso` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_curso`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`edificio` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`edificio` (
  `codigo_edificio` VARCHAR(10) NOT NULL,
  `nombre_edificio` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_edificio`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`estudiante` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`estudiante` (
  `numero_carnet` VARCHAR(10) NOT NULL,
  `nombre_completo` VARCHAR(100) NULL DEFAULT NULL,
  `ingreso_familiar` INT NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`numero_carnet`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`salon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`salon` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`salon` (
  `codigo_salon` VARCHAR(10) NOT NULL,
  `codigo_edificio` VARCHAR(10) NULL DEFAULT NULL,
  `capacidad` INT NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_salon`),
  INDEX `codigo_edificio` (`codigo_edificio` ASC) VISIBLE,
  CONSTRAINT `salon_ibfk_1`
    FOREIGN KEY (`codigo_edificio`)
    REFERENCES `sbd1p1`.`edificio` (`codigo_edificio`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`seccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`seccion` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`seccion` (
  `codigo_seccion` VARCHAR(10) NOT NULL,
  `codigo_curso` VARCHAR(10) NULL DEFAULT NULL,
  `codigo_catedratico` VARCHAR(10) NULL DEFAULT NULL,
  `codigo_salon` VARCHAR(10) NULL DEFAULT NULL,
  `año` INT NULL DEFAULT NULL,
  `ciclo` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_seccion`),
  INDEX `codigo_curso` (`codigo_curso` ASC) VISIBLE,
  INDEX `codigo_catedratico` (`codigo_catedratico` ASC) VISIBLE,
  INDEX `codigo_salon` (`codigo_salon` ASC) VISIBLE,
  CONSTRAINT `seccion_ibfk_1`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `sbd1p1`.`curso` (`codigo_curso`),
  CONSTRAINT `seccion_ibfk_2`
    FOREIGN KEY (`codigo_catedratico`)
    REFERENCES `sbd1p1`.`catedratico` (`codigo_catedratico`),
  CONSTRAINT `seccion_ibfk_3`
    FOREIGN KEY (`codigo_salon`)
    REFERENCES `sbd1p1`.`salon` (`codigo_salon`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`horario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`horario` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`horario` (
  `codigo_horario` VARCHAR(10) NOT NULL,
  `codigo_seccion` VARCHAR(10) NULL DEFAULT NULL,
  `dia` VARCHAR(20) NULL DEFAULT NULL,
  `hora_inicio` TIME NULL DEFAULT NULL,
  `hora_fin` TIME NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_horario`),
  INDEX `codigo_seccion` (`codigo_seccion` ASC) VISIBLE,
  CONSTRAINT `horario_ibfk_1`
    FOREIGN KEY (`codigo_seccion`)
    REFERENCES `sbd1p1`.`seccion` (`codigo_seccion`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`plan` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`plan` (
  `codigo_plan` VARCHAR(10) NOT NULL,
  `codigo_carrera` VARCHAR(10) NULL DEFAULT NULL,
  `nombre_plan` VARCHAR(100) NULL DEFAULT NULL,
  `año_inicio` INT NULL DEFAULT NULL,
  `ciclo_inicio` VARCHAR(10) NULL DEFAULT NULL,
  `año_fin` INT NULL DEFAULT NULL,
  `ciclo_fin` VARCHAR(10) NULL DEFAULT NULL,
  `creditos_necesarios` INT NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_plan`),
  INDEX `codigo_carrera` (`codigo_carrera` ASC) VISIBLE,
  CONSTRAINT `plan_ibfk_1`
    FOREIGN KEY (`codigo_carrera`)
    REFERENCES `sbd1p1`.`carrera` (`codigo_carrera`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`inscripcion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`inscripcion` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`inscripcion` (
  `codigo_carrera` VARCHAR(10) NOT NULL,
  `numero_carnet` VARCHAR(10) NOT NULL,
  `codigo_plan` VARCHAR(10) NULL DEFAULT NULL,
  `fecha_inscripcion` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_carrera`, `numero_carnet`),
  INDEX `codigo_carrera` (`codigo_carrera` ASC, `codigo_plan` ASC) VISIBLE,
  INDEX `numero_carnet` (`numero_carnet` ASC) VISIBLE,
  CONSTRAINT `inscripcion_ibfk_1`
    FOREIGN KEY (`codigo_carrera` , `codigo_plan`)
    REFERENCES `sbd1p1`.`plan` (`codigo_carrera` , `codigo_plan`),
  CONSTRAINT `inscripcion_ibfk_2`
    FOREIGN KEY (`numero_carnet`)
    REFERENCES `sbd1p1`.`estudiante` (`numero_carnet`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`pensum`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`pensum` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`pensum` (
  `codigo_pensum` VARCHAR(10) NOT NULL,
  `codigo_carrera` VARCHAR(10) NULL DEFAULT NULL,
  `codigo_plan` VARCHAR(10) NULL DEFAULT NULL,
  `codigo_curso` VARCHAR(10) NULL DEFAULT NULL,
  `obligatoriedad` CHAR(1) NULL DEFAULT NULL,
  `creditos_obtenidos` INT NULL DEFAULT NULL,
  `nota_aprobacion` INT NULL DEFAULT NULL,
  `zona_minima` INT NULL DEFAULT NULL,
  `codigo_curso_prerrequisito` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`codigo_pensum`),
  INDEX `codigo_carrera` (`codigo_carrera` ASC, `codigo_plan` ASC) VISIBLE,
  INDEX `codigo_curso` (`codigo_curso` ASC) VISIBLE,
  CONSTRAINT `pensum_ibfk_1`
    FOREIGN KEY (`codigo_carrera` , `codigo_plan`)
    REFERENCES `sbd1p1`.`plan` (`codigo_carrera` , `codigo_plan`),
  CONSTRAINT `pensum_ibfk_2`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `sbd1p1`.`curso` (`codigo_curso`))


-- -----------------------------------------------------
-- Table `sbd1p1`.`prerrequisito`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sbd1p1`.`prerrequisito` ;

CREATE TABLE IF NOT EXISTS `sbd1p1`.`prerrequisito` (
  `codigo_curso` VARCHAR(10) NOT NULL,
  `codigo_curso_prerrequisito` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`codigo_curso`, `codigo_curso_prerrequisito`),
  INDEX `codigo_curso_prerrequisito` (`codigo_curso_prerrequisito` ASC) VISIBLE,
  CONSTRAINT `prerrequisito_ibfk_1`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `sbd1p1`.`curso` (`codigo_curso`),
  CONSTRAINT `prerrequisito_ibfk_2`
    FOREIGN KEY (`codigo_curso_prerrequisito`)
    REFERENCES `sbd1p1`.`curso` (`codigo_curso`))
