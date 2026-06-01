CREATE DATABASE `1RA RFEF` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CONTRATO` (
  `id_contrato` int NOT NULL,
  `tipo_contrato` enum('FICHAJE','AGENTE LIBRE','CESION') DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `sueldo` decimal(10,2) DEFAULT NULL,
  `id_jugador` int DEFAULT NULL,
  `id_entrenador` int DEFAULT NULL,
  PRIMARY KEY (`id_contrato`),
  KEY `fk_CONTRATO_JUGADOR1_idx` (`id_jugador`),
  KEY `fk_CONTRATO_ENTRENADOR1_idx` (`id_entrenador`),
  CONSTRAINT `fk_CONTRATO_ENTRENADOR1` FOREIGN KEY (`id_entrenador`) REFERENCES `ENTRENADOR` (`id_entrenador`),
  CONSTRAINT `fk_CONTRATO_JUGADOR1` FOREIGN KEY (`id_jugador`) REFERENCES `JUGADOR` (`id_jugador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ENTRENADOR` (
  `id_entrenador` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `nacionalidad` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_entrenador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `EQUIPO` (
  `nombre` varchar(45) NOT NULL,
  `ciudad` varchar(45) DEFAULT NULL,
  `grupo` varchar(2) DEFAULT NULL,
  `id_presidente` int NOT NULL,
  `nombre_estadio` varchar(45) NOT NULL,
  `id_entrenador` int NOT NULL,
  PRIMARY KEY (`nombre`),
  KEY `fk_EQUIPO_PRESIDENTE1_idx` (`id_presidente`),
  KEY `fk_EQUIPO_ESTADIO1_idx` (`nombre_estadio`),
  KEY `fk_EQUIPO_ENTRENADOR1_idx` (`id_entrenador`),
  CONSTRAINT `fk_EQUIPO_ENTRENADOR1` FOREIGN KEY (`id_entrenador`) REFERENCES `ENTRENADOR` (`id_entrenador`),
  CONSTRAINT `fk_EQUIPO_ESTADIO1` FOREIGN KEY (`nombre_estadio`) REFERENCES `ESTADIO` (`nombre`),
  CONSTRAINT `fk_EQUIPO_PRESIDENTE1` FOREIGN KEY (`id_presidente`) REFERENCES `PRESIDENTE` (`id_presidente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ESTADIO` (
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `JORNADA` (
  `numero_jornada` int NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`numero_jornada`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `JUGADOR` (
  `id_jugador` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `posicion` set('PORTERO','DEFENSA','CENTROCAMPISTA','DELANTERO') DEFAULT NULL,
  `nacionalidad` varchar(45) DEFAULT NULL,
  `nombre_equipo` varchar(45) NOT NULL,
  `capitan_equipo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_jugador`),
  KEY `fk_JUGADOR_EQUIPO1_idx` (`nombre_equipo`),
  KEY `fk_JUGADOR_EQUIPO2_idx` (`capitan_equipo`),
  CONSTRAINT `fk_JUGADOR_EQUIPO1` FOREIGN KEY (`nombre_equipo`) REFERENCES `EQUIPO` (`nombre`),
  CONSTRAINT `fk_JUGADOR_EQUIPO2` FOREIGN KEY (`capitan_equipo`) REFERENCES `EQUIPO` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PARTIDO` (
  `id_partido` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `goles_local` int DEFAULT NULL,
  `goles_visitante` int DEFAULT NULL,
  `nombre_local` varchar(45) NOT NULL,
  `nombre_visitante` varchar(45) NOT NULL,
  `nombre_estadio` varchar(45) NOT NULL,
  `numero_jornada` int NOT NULL,
  `capitanLocal` int NOT NULL,
  `capitanVisitante` int NOT NULL,
  PRIMARY KEY (`id_partido`),
  KEY `fk_PARTIDO_EQUIPO_idx` (`nombre_local`),
  KEY `fk_PARTIDO_EQUIPO1_idx` (`nombre_visitante`),
  KEY `fk_PARTIDO_ESTADIO1_idx` (`nombre_estadio`),
  KEY `fk_PARTIDO_JORNADA1_idx` (`numero_jornada`),
  KEY `fk_PARTIDO_JUGADOR1_idx` (`capitanLocal`),
  KEY `fk_PARTIDO_JUGADOR2_idx` (`capitanVisitante`),
  CONSTRAINT `fk_PARTIDO_EQUIPO` FOREIGN KEY (`nombre_local`) REFERENCES `EQUIPO` (`nombre`),
  CONSTRAINT `fk_PARTIDO_EQUIPO1` FOREIGN KEY (`nombre_visitante`) REFERENCES `EQUIPO` (`nombre`),
  CONSTRAINT `fk_PARTIDO_ESTADIO1` FOREIGN KEY (`nombre_estadio`) REFERENCES `ESTADIO` (`nombre`),
  CONSTRAINT `fk_PARTIDO_JORNADA1` FOREIGN KEY (`numero_jornada`) REFERENCES `JORNADA` (`numero_jornada`),
  CONSTRAINT `fk_PARTIDO_JUGADOR1` FOREIGN KEY (`capitanLocal`) REFERENCES `JUGADOR` (`id_jugador`),
  CONSTRAINT `fk_PARTIDO_JUGADOR2` FOREIGN KEY (`capitanVisitante`) REFERENCES `JUGADOR` (`id_jugador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PRESIDENTE` (
  `id_presidente` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `correo` varchar(45) DEFAULT NULL,
  `club` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_presidente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;