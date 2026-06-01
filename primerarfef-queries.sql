-- Jugadores que son capitanes de su equipo y han jugado como capitán local en algún partido y cuya duracion de contrato sea superior a un año.

select j.id_jugador ,concat(j.nombre, ' ' ,j.apellidos) as nombre 
from JUGADOR j inner join CONTRATO c on j.id_jugador = c.id_jugador  
where j.capitan_equipo is not null AND
datediff(c.fecha_fin ,c.fecha_inicio )/365 > 1
and j.id_jugador in ( 
	select p.capitanLocal 
	from PARTIDO p );

-- Jugadores y entrenadores que tienen contrato activo en la temporada actual, mostrando su nombre completo, su rol y el tipo de contrato.

SELECT CONCAT(j.nombre, ' ', j.apellidos) AS nombre_completo, 'Jugador' AS rol, c.tipo_contrato
FROM JUGADOR j INNER JOIN CONTRATO c ON j.id_jugador = c.id_jugador
WHERE  YEAR(c.fecha_fin )=2027 
UNION
SELECT CONCAT(e.nombre, ' ', e.apellidos) AS nombre_completo, 'Entrenador' AS rol, c.tipo_contrato
FROM ENTRENADOR e INNER JOIN CONTRATO c ON e.id_entrenador = c.id_entrenador
WHERE  YEAR(c.fecha_fin )=2027; 


-- Equipos que han ganado más partidos en casa que fuera.

SELECT e.nombre,
    SUM(CASE WHEN p.goles_local > p.goles_visitante THEN 1 ELSE 0 END) AS victorias_casa,
    SUM(CASE WHEN p.goles_visitante > p.goles_local THEN 1 ELSE 0 END) AS victorias_fuera
FROM EQUIPO e INNER JOIN PARTIDO p on e.nombre = p.nombre_local  
GROUP BY e.nombre
HAVING victorias_casa > victorias_fuera;


-- Estadios con el nombre del equipo que juega en ellos y el total de goles marcados en ese estadio

SELECT es.nombre AS estadio, es.direccion  , e.nombre AS equipo,
       SUM(p.goles_local + p.goles_visitante) AS total_goles
FROM ESTADIO es 
INNER  JOIN EQUIPO e ON es.nombre = e.nombre_estadio 
INNER JOIN PARTIDO p ON es.nombre = p.nombre_estadio 
GROUP BY es.nombre, es.nombre, es.direccion , e.nombre
ORDER BY total_goles DESC;



-- Jugadores que no son españoles y no comparten nacionalidad con su entrenador

SELECT CONCAT(j.nombre, ' ', j.apellidos) AS jugador,
       j.nacionalidad,
       e.nombre AS equipo,
       CONCAT(en.nombre, ' ', en.apellidos) AS entrenador,
       en.nacionalidad AS nacionalidad_entrenador
FROM JUGADOR j
INNER JOIN EQUIPO e ON j.nombre_equipo  = e.nombre 
INNER JOIN ENTRENADOR en ON e.id_entrenador = en.id_entrenador
WHERE j.nacionalidad != en.nacionalidad
AND j.nacionalidad != 'España'
ORDER BY e.nombre, j.apellidos;

-- Top 5 equipos más goleadores de ambos grupos
SELECT 
    e.nombre,
    SUM(
        CASE 
            WHEN e.nombre = p.nombre_local THEN p.goles_local
            WHEN e.nombre = p.nombre_visitante THEN p.goles_visitante
            ELSE 0
        END
    ) AS goles
FROM EQUIPO e
INNER JOIN PARTIDO p ON e.nombre = p.nombre_local OR e.nombre = p.nombre_visitante
GROUP BY e.nombre
ORDER BY goles DESC
LIMIT 5;


-- Jugadores cuyo sueldo sea mayor a la media de su equipo
SELECT 
    CONCAT(j.nombre, ' ', j.apellidos) AS nombre,
    j.nombre_equipo,
    c.sueldo
FROM JUGADOR j
INNER JOIN CONTRATO c 
    ON j.id_jugador = c.id_jugador
WHERE c.sueldo > (
    SELECT AVG(c2.sueldo)
    FROM JUGADOR j2
    INNER JOIN CONTRATO c2 
        ON j2.id_jugador = c2.id_jugador
    WHERE j2.nombre_equipo = j.nombre_equipo
);


-- ENUM en tipo_contrato
ALTER TABLE CONTRATO
MODIFY COLUMN tipo_contrato ENUM('FICHAJE', 'AGENTE LIBRE', 'CESION');


-- SET en posicion
ALTER TABLE JUGADOR
MODIFY COLUMN posicion SET('PORTERO', 'DEFENSA', 'CENTROCAMPISTA', 'DELANTERO');


-- Vista 1: Equipos que han ganado más partidos en casa que fuera

CREATE VIEW vista_victorias_local AS
SELECT e.nombre,
    SUM(CASE WHEN p.goles_local > p.goles_visitante THEN 1 ELSE 0 END) AS victorias_casa,
    SUM(CASE WHEN p.goles_visitante > p.goles_local THEN 1 ELSE 0 END) AS victorias_fuera
FROM EQUIPO e INNER JOIN PARTIDO p on e.nombre = p.nombre_local  
GROUP BY e.nombre
HAVING victorias_casa > victorias_fuera;

SELECT * FROM vista_victorias_local;
-- Vista 2: Jugadores que no son españoles y no comparten nacionalidad con su entrenador

CREATE VIEW vista_jugadores_extranjeros AS
SELECT CONCAT(j.nombre, ' ', j.apellidos) AS jugador,
       j.nacionalidad,
       e.nombre AS equipo,
       CONCAT(en.nombre, ' ', en.apellidos) AS entrenador,
       en.nacionalidad AS nacionalidad_entrenador
FROM JUGADOR j
INNER JOIN EQUIPO e ON j.nombre_equipo  = e.nombre 
INNER JOIN ENTRENADOR en ON e.id_entrenador = en.id_entrenador
WHERE j.nacionalidad != en.nacionalidad
AND j.nacionalidad != 'España'
ORDER BY e.nombre, j.apellidos;

SELECT * FROM vista_jugadores_extranjeros;



-- FUNCIÓN 1: Devuelve el total de puntos de un equipo
DELIMITER //

CREATE FUNCTION total_puntos(f_equipo VARCHAR(45)) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE puntos INT DEFAULT 0;
    DECLARE existe INT DEFAULT 0;

    SELECT COUNT(*) INTO existe
    FROM EQUIPO
    WHERE nombre = f_equipo;

    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ese equipo no existe';
    END IF;

    SELECT SUM(
        CASE
            WHEN p.nombre_local = f_equipo 
                 AND p.goles_local > p.goles_visitante THEN 3

            WHEN p.nombre_visitante = f_equipo 
                 AND p.goles_visitante > p.goles_local THEN 3

            WHEN (p.nombre_local = f_equipo OR p.nombre_visitante = f_equipo)
                 AND p.goles_local = p.goles_visitante THEN 1

            ELSE 0
        END
    ) INTO puntos
    FROM PARTIDO p
    WHERE p.nombre_local = f_equipo 
       OR p.nombre_visitante = f_equipo;

    RETURN puntos;
END //

DELIMITER ;

select total_puntos('');


-- FUNCIÓN: Devuelve el porcentaje de victorias de un equipo
DELIMITER //

CREATE FUNCTION porcentaje_victorias(f_equipo VARCHAR(45))
RETURNS DECIMAL(5,2) 
DETERMINISTIC
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE ganados INT DEFAULT 0;
    DECLARE existe INT DEFAULT 0;

    
    SELECT COUNT(*) INTO existe
    FROM EQUIPO
    WHERE nombre = f_equipo;

    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ese equipo no existe';
    END IF;

    
    SELECT COUNT(*) INTO total
    FROM PARTIDO
    WHERE nombre_local = f_equipo 
       OR nombre_visitante = f_equipo;

    IF total = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ese equipo no ha jugado partidos';
    END IF;

    
    SELECT COUNT(*) INTO ganados
    FROM PARTIDO
    WHERE (nombre_local = f_equipo AND goles_local > goles_visitante)
       OR (nombre_visitante = f_equipo AND goles_visitante > goles_local);

    RETURN ROUND((ganados / total) * 100, 2);
END //

DELIMITER ;

select porcentaje_victorias('Atlético Madrileño');

DELIMITER //
CREATE PROCEDURE jugadores_sueldo_mayor_media(IN p_nombre_equipo VARCHAR(45))
BEGIN
    DECLARE existe INT DEFAULT 0;

    
    SELECT COUNT(*) INTO existe
    FROM EQUIPO
    WHERE nombre = p_nombre_equipo;

    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ese equipo no existe';
    END IF;

    
    SELECT 
        CONCAT(j.nombre, ' ', j.apellidos) AS nombre,
        j.nombre_equipo,
        c.sueldo
    FROM JUGADOR j
    INNER JOIN CONTRATO c ON j.id_jugador = c.id_jugador
    WHERE j.nombre_equipo = p_nombre_equipo
      AND c.sueldo > (
          SELECT AVG(c2.sueldo)
          FROM JUGADOR j2
          INNER JOIN CONTRATO c2 ON j2.id_jugador = c2.id_jugador
          WHERE j2.nombre_equipo = p_nombre_equipo
      )
    ORDER BY c.sueldo DESC;
END //

DELIMITER ;

CALL jugadores_sueldo_mayor_media('Real Madrid Castilla');
-- PROCEDIMIENTO 2:
DELIMITER //
CREATE PROCEDURE clasificacion_por_grupo(IN p_grupo VARCHAR(2))
BEGIN
    SET p_grupo = UPPER(p_grupo);

    IF p_grupo = 'A' OR p_grupo = 'B' THEN

        SELECT 
            e.nombre,
            e.grupo,
            total_puntos(e.nombre) AS puntos
        FROM EQUIPO e
        WHERE e.grupo = p_grupo
        ORDER BY puntos DESC;

    ELSE

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'el grupo debe ser A o B';

    END IF;
END //
DELIMITER ;

CALL clasificacion_por_grupo('f');
CALL clasificacion_por_grupo('b');
-- PROCEDIMIENTO: Muestra los jugadores de un equipo cuyo contrato va a vencer pronto

DELIMITER //
CREATE PROCEDURE contratos_proximos_vencer(IN p_equipo VARCHAR(45))
BEGIN
    DECLARE existe INT DEFAULT 0;

    SELECT COUNT(*) INTO existe
    FROM EQUIPO
    WHERE nombre = p_equipo;

    IF existe > 0 THEN

        SELECT 
            CONCAT(j.nombre, ' ', j.apellidos) AS jugador,
            j.posicion,
            j.nombre_equipo,
            c.tipo_contrato,
            c.fecha_fin,
            DATEDIFF(c.fecha_fin, CURDATE()) AS dias_restantes
        FROM JUGADOR j
        INNER JOIN CONTRATO c 
            ON j.id_jugador = c.id_jugador
        WHERE j.nombre_equipo = p_equipo
          AND c.fecha_fin >= CURDATE()
          AND c.fecha_fin <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
        ORDER BY dias_restantes ASC;

    ELSE

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ese equipo no existe';

    END IF;
END //

DELIMITER ;

CALL contratos_proximos_vencer('CD Lugo');
-- TRIGGER 1: Evita que se inserten jugadores con un id_jugador duplicado
DELIMITER //

CREATE TRIGGER trigger_capitania_transferencia
BEFORE UPDATE ON JUGADOR
FOR EACH ROW
BEGIN
    IF NEW.nombre_equipo != OLD.nombre_equipo THEN
        SET NEW.capitan_equipo = NULL;
    END IF;
END //

DELIMITER ;

-- TRIGGER 1: Si un jugador es transferido a otro equipo, 
-- elimina automáticamente su rol de capitán en el equipo anterior
delimiter //
CREATE TRIGGER trigger_no_duplicar_jugador
BEFORE INSERT ON JUGADOR
FOR EACH ROW
BEGIN
   IF EXISTS (SELECT 1 FROM JUGADOR WHERE id_jugador = NEW.id_jugador) THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Error: El jugador ya existe, no se permiten duplicados.';
   END IF;
END //
delimiter ;