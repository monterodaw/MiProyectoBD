CREATE DATABASE `mydb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CONTRATO` (
  `id_contrato` int NOT NULL,
  `tipo_contrato` varchar(45) DEFAULT NULL,
  `id_presidente` int NOT NULL,
  `fecha_inicio_contrato` varchar(50) DEFAULT NULL,
  `fecha_fin_contrato` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_contrato`),
  KEY `fk_CONTRATO_PRESIDENTE1_idx` (`id_presidente`),
  CONSTRAINT `fk_CONTRATO_PRESIDENTE1` FOREIGN KEY (`id_presidente`) REFERENCES `PRESIDENTE` (`id_presidente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `ENTRENADOR` (
  `id_entrenador` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `nacionalidad` varchar(45) DEFAULT NULL,
  `CONTRATO_id_contrato` int NOT NULL,
  `id_contrato` int DEFAULT NULL,
  PRIMARY KEY (`id_entrenador`,`CONTRATO_id_contrato`),
  KEY `fk_ENTRENADOR_CONTRATO1_idx` (`CONTRATO_id_contrato`),
  CONSTRAINT `fk_ENTRENADOR_CONTRATO1` FOREIGN KEY (`CONTRATO_id_contrato`) REFERENCES `CONTRATO` (`id_contrato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `EQUIPO` (
  `id_equipo` int NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `ciudad` varchar(45) DEFAULT NULL,
  `grupo` varchar(2) DEFAULT NULL,
  `PRESIDENTE_id_presidente` int NOT NULL,
  `ENTRENADOR_id_entrenador` int NOT NULL,
  `ENTRENADOR_CONTRATO_id_contrato` int NOT NULL,
  `capitan_principal` int DEFAULT NULL,
  `JUGADOR_CONTRATO_id_contrato` int DEFAULT NULL,
  `ESTADIO_id_estadio` int NOT NULL,
  PRIMARY KEY (`id_equipo`),
  KEY `fk_EQUIPO_PRESIDENTE1_idx` (`PRESIDENTE_id_presidente`),
  KEY `fk_EQUIPO_ENTRENADOR1_idx` (`ENTRENADOR_id_entrenador`,`ENTRENADOR_CONTRATO_id_contrato`),
  KEY `fk_EQUIPO_JUGADOR1_idx` (`capitan_principal`,`JUGADOR_CONTRATO_id_contrato`),
  KEY `fk_EQUIPO_ESTADIO1_idx` (`ESTADIO_id_estadio`),
  CONSTRAINT `fk_EQUIPO_ENTRENADOR1` FOREIGN KEY (`ENTRENADOR_id_entrenador`, `ENTRENADOR_CONTRATO_id_contrato`) REFERENCES `ENTRENADOR` (`id_entrenador`, `CONTRATO_id_contrato`),
  CONSTRAINT `fk_EQUIPO_ESTADIO1` FOREIGN KEY (`ESTADIO_id_estadio`) REFERENCES `ESTADIO` (`id_estadio`),
  CONSTRAINT `fk_EQUIPO_JUGADOR1` FOREIGN KEY (`capitan_principal`, `JUGADOR_CONTRATO_id_contrato`) REFERENCES `JUGADOR` (`id_jugador`, `CONTRATO_id_contrato`),
  CONSTRAINT `fk_EQUIPO_PRESIDENTE1` FOREIGN KEY (`PRESIDENTE_id_presidente`) REFERENCES `PRESIDENTE` (`id_presidente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `ESTADIO` (
  `id_estadio` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_estadio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `JORNADA` (
  `numero_jornada` int NOT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  PRIMARY KEY (`numero_jornada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `JUGADOR` (
  `id_jugador` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `posicion` varchar(45) DEFAULT NULL,
  `nacionalidad` varchar(45) DEFAULT NULL,
  `capitan` varchar(45) DEFAULT NULL,
  `CONTRATO_id_contrato` int NOT NULL,
  `EQUIPO_id_equipo` int NOT NULL,
  PRIMARY KEY (`id_jugador`,`CONTRATO_id_contrato`),
  KEY `fk_JUGADOR_CONTRATO1_idx` (`CONTRATO_id_contrato`),
  KEY `fk_JUGADOR_EQUIPO1_idx` (`EQUIPO_id_equipo`),
  CONSTRAINT `fk_JUGADOR_CONTRATO1` FOREIGN KEY (`CONTRATO_id_contrato`) REFERENCES `CONTRATO` (`id_contrato`),
  CONSTRAINT `fk_JUGADOR_EQUIPO1` FOREIGN KEY (`EQUIPO_id_equipo`) REFERENCES `EQUIPO` (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `PARTIDO` (
  `id_partido` int NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `resultado` varchar(45) DEFAULT NULL,
  `EQUIPO_id_local` int NOT NULL,
  `EQUIPO_id_visitante` int NOT NULL,
  `ESTADIO_id_estadio` int NOT NULL,
  `JORNADA_numero_jornada` int DEFAULT NULL,
  PRIMARY KEY (`id_partido`),
  KEY `fk_PARTIDO_EQUIPO_idx` (`EQUIPO_id_local`),
  KEY `fk_PARTIDO_EQUIPO1_idx` (`EQUIPO_id_visitante`),
  KEY `fk_PARTIDO_ESTADIO1_idx` (`ESTADIO_id_estadio`),
  KEY `fk_PARTIDO_JORNADA1_idx` (`JORNADA_numero_jornada`),
  CONSTRAINT `fk_PARTIDO_EQUIPO` FOREIGN KEY (`EQUIPO_id_local`) REFERENCES `EQUIPO` (`id_equipo`),
  CONSTRAINT `fk_PARTIDO_EQUIPO1` FOREIGN KEY (`EQUIPO_id_visitante`) REFERENCES `EQUIPO` (`id_equipo`),
  CONSTRAINT `fk_PARTIDO_ESTADIO1` FOREIGN KEY (`ESTADIO_id_estadio`) REFERENCES `ESTADIO` (`id_estadio`),
  CONSTRAINT `fk_PARTIDO_JORNADA1` FOREIGN KEY (`JORNADA_numero_jornada`) REFERENCES `JORNADA` (`numero_jornada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `PRESIDENTE` (
  `id_presidente` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `correo` varchar(45) DEFAULT NULL,
  `club` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_presidente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
