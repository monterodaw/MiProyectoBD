INSERT INTO mydb.CONTRATO (id_contrato, tipo_contrato, id_presidente, fecha_inicio_contrato, fecha_fin_contrato) VALUES(0, '', 0, '', '');
INSERT INTO mydb.ENTRENADOR (id_entrenador, nombre, apellidos, nacionalidad, CONTRATO_id_contrato, id_contrato) VALUES(0, '', '', '', 0, 0);
INSERT INTO mydb.EQUIPO (id_equipo, nombre, ciudad, grupo, PRESIDENTE_id_presidente, ENTRENADOR_id_entrenador, ENTRENADOR_CONTRATO_id_contrato, capitan_principal, JUGADOR_CONTRATO_id_contrato, ESTADIO_id_estadio) VALUES(0, '', '', '', 0, 0, 0, 0, 0, 0);
INSERT INTO mydb.ESTADIO (id_estadio, nombre, direccion) VALUES(0, '', '');
INSERT INTO mydb.JORNADA (numero_jornada, fecha_inicio, fecha_fin) VALUES(0, '', '');
INSERT INTO mydb.JUGADOR (id_jugador, nombre, apellidos, posicion, nacionalidad, capitan, CONTRATO_id_contrato, EQUIPO_id_equipo) VALUES(0, '', '', '', '', '', 0, 0);
INSERT INTO mydb.PARTIDO (id_partido, fecha, resultado, EQUIPO_id_local, EQUIPO_id_visitante, ESTADIO_id_estadio, JORNADA_numero_jornada) VALUES(0, '', '', 0, 0, 0, 0);
INSERT INTO mydb.PRESIDENTE (id_presidente, nombre, apellidos, correo, club) VALUES(0, '', '', '', '');
