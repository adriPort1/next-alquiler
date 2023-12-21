-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-12-2023 a las 13:52:34
-- Versión del servidor: 10.1.40-MariaDB
-- Versión de PHP: 7.3.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `alquilerportatiles`
--
CREATE DATABASE IF NOT EXISTS `alquilerportatiles` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `alquilerportatiles`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumnos`
--
-- Creación: 20-12-2023 a las 09:24:01
--

DROP TABLE IF EXISTS `alumnos`;
CREATE TABLE IF NOT EXISTS `alumnos` (
  `DNI` varchar(9) NOT NULL,
  `Nombre` text CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Apellidos` text CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Curso` text NOT NULL COMMENT 'grado o curso que realizan',
  `Año` int(11) NOT NULL COMMENT 'si estan en primero 1, si estan en segundo 2 y si estan en cusos de corta duracion 0',
  `DniTutor` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`DNI`),
  UNIQUE KEY `ukDniTutorAlumno` (`DniTutor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `alumnos`:
--

--
-- Disparadores `alumnos`
--
DROP TRIGGER IF EXISTS `alumnosAD`;
DELIMITER $$
CREATE TRIGGER `alumnosAD` AFTER DELETE ON `alumnos` FOR EACH ROW DELETE FROM ordenadores WHERE DniProfesor= OLD.DNI
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `alumnosAI`;
DELIMITER $$
CREATE TRIGGER `alumnosAI` AFTER INSERT ON `alumnos` FOR EACH ROW UPDATE ordenadores o JOIN alumnos a ON o.DniAlumno = a.DNI 
SET o.DniProfesor = a.DniTutor
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `alumnosAU`;
DELIMITER $$
CREATE TRIGGER `alumnosAU` AFTER UPDATE ON `alumnos` FOR EACH ROW UPDATE ordenadores o
 JOIN alumnos a ON DniProfesor=DniTutor
 	SET o.DniProfesor=a.DniTutor WHERE o.DniAlumno=a.DNI
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenadores`
--
-- Creación: 19-12-2023 a las 09:23:44
--

DROP TABLE IF EXISTS `ordenadores`;
CREATE TABLE IF NOT EXISTS `ordenadores` (
  `numero` int(11) NOT NULL COMMENT 'numero correspondiente al ordenador',
  `marca` text NOT NULL COMMENT 'marca del ordenador',
  `modelo` varchar(20) DEFAULT NULL COMMENT 'modelo del ordenador si se sabe',
  `asignado` tinyint(1) NOT NULL COMMENT 'si esta asignado a algun alumno o no',
  `observaciones` text COMMENT 'comentarios en caso de que ocurran incidencias con los ordenadores',
  `DniAlumno` varchar(9) NOT NULL COMMENT 'dni alumno para la clave ajena',
  `DniProfesor` varchar(9) NOT NULL COMMENT 'dni profesor para la clave ajena, esta no es unica porque un profesor puede alquilar a varios alumnos',
  PRIMARY KEY (`numero`),
  UNIQUE KEY `ukAlumnoAlquiler` (`DniAlumno`) USING BTREE,
  KEY `fkOrdenadoresTutor` (`DniProfesor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `ordenadores`:
--   `DniAlumno`
--       `alumnos` -> `DNI`
--   `DniProfesor`
--       `tutores` -> `DNI`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutores`
--
-- Creación: 19-12-2023 a las 09:10:42
--

DROP TABLE IF EXISTS `tutores`;
CREATE TABLE IF NOT EXISTS `tutores` (
  `DNI` varchar(9) NOT NULL,
  `Nombre` text CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Apellidos` text CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Curso` text CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL COMMENT 'grado o curso que tutela',
  `Año` int(1) NOT NULL COMMENT 'si tutela un grado en primero, 1, si tutela un grado en segundo 2, y si tutela un curso de corta duracion 0',
  PRIMARY KEY (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- RELACIONES PARA LA TABLA `tutores`:
--

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ordenadores`
--
ALTER TABLE `ordenadores`
  ADD CONSTRAINT `fkOrdenadoresAlumno` FOREIGN KEY (`DniAlumno`) REFERENCES `alumnos` (`DNI`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fkOrdenadoresTutor` FOREIGN KEY (`DniProfesor`) REFERENCES `tutores` (`DNI`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
