/abolish

-- ACERTIJO 3: Análisis de viajes en el tiempo (Back to the Future)
-- Objetivo: Determinar en qué fechas existían viajeros temporales (Martys)

-- Tabla de fechas
CREATE TABLE fechas (
  id INTEGER PRIMARY KEY,
  fecha DATE
);

INSERT INTO fechas (id, fecha) VALUES (1, DATE '1955-11-05');
INSERT INTO fechas (id, fecha) VALUES (2, DATE '1955-11-12');
INSERT INTO fechas (id, fecha) VALUES (3, DATE '1985-10-26');
INSERT INTO fechas (id, fecha) VALUES (4, DATE '2015-10-21');

-- Tabla de intervalos
CREATE TABLE intervalos (
  id INTEGER PRIMARY KEY,
  desde DATE,
  hasta DATE
);

INSERT INTO intervalos (id, desde, hasta) VALUES (1, DATE '1885-09-02', DATE '1885-09-07');
INSERT INTO intervalos (id, desde, hasta) VALUES (2, DATE '1955-11-05', DATE '1955-11-12');
INSERT INTO intervalos (id, desde, hasta) VALUES (3, DATE '1955-11-12', DATE '1955-11-20');
INSERT INTO intervalos (id, desde, hasta) VALUES (4, DATE '1968-06-12', DATE '1985-10-26');
INSERT INTO intervalos (id, desde, hasta) VALUES (5, DATE '1985-10-26', DATE '1985-10-26');
INSERT INTO intervalos (id, desde, hasta) VALUES (6, DATE '1985-10-26', DATE '1985-10-26');
INSERT INTO intervalos (id, desde, hasta) VALUES (7, DATE '1985-10-27', DATE '9999-12-12');
INSERT INTO intervalos (id, desde, hasta) VALUES (8, DATE '2015-10-21', DATE '2015-10-21');

-- Tabla de viajes
CREATE TABLE viajes (
  id INTEGER PRIMARY KEY,
  desde DATE,
  hasta DATE
);

INSERT INTO viajes (id, desde, hasta) VALUES (1, DATE '1985-10-26', DATE '1955-11-05');
INSERT INTO viajes (id, desde, hasta) VALUES (2, DATE '1955-11-12', DATE '1985-10-26');
INSERT INTO viajes (id, desde, hasta) VALUES (3, DATE '1985-10-26', DATE '2015-10-21');
INSERT INTO viajes (id, desde, hasta) VALUES (4, DATE '2015-10-21', DATE '1985-10-26');
INSERT INTO viajes (id, desde, hasta) VALUES (5, DATE '1985-10-26', DATE '1955-11-12');
INSERT INTO viajes (id, desde, hasta) VALUES (6, DATE '1955-11-20', DATE '1885-09-02');
INSERT INTO viajes (id, desde, hasta) VALUES (7, DATE '1885-09-07', DATE '1985-10-27');

-- Consultas de verificaci�n
SELECT * FROM fechas;
SELECT * FROM intervalos;
SELECT * FROM viajes;

-- Obtenemos una copia de la tabla viajes cambiando los nombres para evitar problemas derepeticion de nombres
create view viajes_aux as 
select id as id_aux, desde as desde_aux, hasta as hasta_aux
from viajes;

-- Renombramos el id de fechas para evitar problemas de repeticion de nombres
create view fechas_rename as 
select id as id_fecha, fecha
from fechas;

-- La idea del ejercicio es la siguiente:
-- Obtenemos una tabla con cada par de viajes posible, multiplicados ademas por cada fecha posible
-- Despues, para ver cuantos Martys habia en cada fecha debemos comprobar que se cumpa una de las 3 siguientes posibilidades (de ahi los or):
-- 1: El par de viajes (normal-aux) representa dos viajes seguidos y ordenados v1-v2 (con v2 el siguiente viaje de v1), y por tanto habia un Marty en la fecha f si f esta entre el final de v1 y el inicio de v2.
-- 2: Contamos si la fecha f esta entre el nacimiento de Marty y su primer viaje, y por tanto habia un Marty ahi.
-- 3: Analogamente a 2, revisamos si habia un Marty entre el final de su ultimo viaje y su muerte en el a�o 9999

create view producto as
select *
from viajes, viajes_aux, fechas_rename
where 
( 
	(id + 1 = id_aux) and (hasta <= fecha and  fecha <= desde_aux) 
) or
( 
	(id = 1) and (id_aux = 1) and (DATE '1968-06-12' <= fecha and fecha <= desde) 
) or
( 
	(id = SELECT COUNT(id) FROM viajes) and (id_aux = SELECT COUNT(id) FROM viajes) 
  and
	(hasta <= fecha and fecha <= DATE '9999-12-31')
)
;

-- NOTA: No comprendo la notacion de la respuesta pedida, por lo que la devuelvo de la forma que creo conveniente

-- Agrupamos la cantidad de Martys segun las id de cada fecha

create view res as
select id_fecha, count(*) as Martys
from producto
group by id_fecha
order by id_fecha;

-- Mostramos el resultado

select * from res;