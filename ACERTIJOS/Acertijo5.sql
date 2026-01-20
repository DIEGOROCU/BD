/abolish
/multiline on

-- ACERTIJO 5: Raíz cuadrada de números enteros
-- Objetivo: Calcular la raíz cuadrada entera y el residuo sin usar funciones nativas

CREATE TABLE numeros (
  numero INT NOT NULL,
  PRIMARY KEY (numero));

INSERT INTO numeros (numero) VALUES
(4),
(10),
(15),
(25),
(40),
(49),
(50),
(30),
(1),
(0),
(-1),
(-5);

-- Vista recursiva con:
  --	C = Cantidad de impares ya sumados
  --	N = Numero impar que toca sumar
  --	S = Suma de todos los impares hasta N (incluido)
-- Empezamos con el impar -1 para poder compar el 0 con las sumas, y asi empezamos con 0 impares y una suma total de 0
create view aux1 as
with naturales(C, N, S) AS (
  select 0, -1, 0
  union
  select C + 1, N + 2, S + N + 2 
  from naturales)
select * from naturales;

-- Emparejamos cada numero con su raiz de la siguiente forma:
  -- 	1. El numero debe ser mayor o igual (caso raiz exacta) que la suma S
  -- 	2. El numero debe ser menor que la siguiente suma S (obtenida sumando S+2C+1)
  -- 	3. El residuo es la diferencia entre S y el numero
-- Para ver hasta que suma cogemos, calculamos tantas sumas como el maximo numero que haya, ya que seguro que si hay max(numero) sumas, la mayor de las mismas pasara a max(numero) y asi podremos agrupar a todos con sus sumas menores y la primera mayor (inlcuimos un greatest para evitar casos extra�os con numeros muy bajos)
create view vista1_1 as
select numero, C as raiz, (numero - S) as residuo
from numeros, 
(select top (GREATEST((select top 1 numero from (select * from numeros order by numero desc)), 3)) * from aux1)
where (numero >= S) and (S + 2*C + 1 > numero);

-- Unimos las raices, con los numeros negativos y sus respectivos null como raiz (no puedo poner NAN) y 0 como residuo
create view vista1 as
select *
from vista1_1 union
(select numero, Null as raiz, 0 as residuo from numeros where numero < 0);

select * from vista1;