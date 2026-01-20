/abolish
/multiline on

-- ACERTIJO 6: Cálculo del número e (constante de Euler)
-- Objetivo: Aproximar el valor de e mediante series de Taylor

CREATE TABLE numeros (
  numero FLOAT NOT NULL,
  PRIMARY KEY (numero));

INSERT INTO numeros (numero) VALUES
(1);

-- Vista recursiva con:
  --	N = N� del termino de la serie de Taylor que toca
  --	P = Producto de todos los naturales anteriores, para usarse en 1/n!
  --	D = Termino N de la serie de Taylor
  --	SD = Serie de Taylor que se ha ido sumando hasta N
-- El codigo es autoexplicativo, cada dato se va actualizando como debe
-- Los nombres son asi ya que no me permite llamar e a las listas
-- Finalmente cogemos la serie de Taylor con 50 terminos (cuantos mas, mas preciso) y cogemos la maxima suma, ya que al ser de terminos positivos sera la suma de los 50 terminos
create view ee as
with euler(N, P, D, SD) AS (
  select 2.0, 1.0, 1.0, 1.0
  union
  select N + 1, P * N, 1 / P, SD + 1/P
  from euler)
select max(SD) as eee from (select top 50 * from euler);

select * from ee;