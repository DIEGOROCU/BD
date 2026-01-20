/abolish
/multiline on

-- ACERTIJO 7: Gráfica de función seno mediante Taylor
-- Objetivo: Visualizar la función seno calculada con serie de Taylor

/*
sumaMini obtiene el dominio de nuestra funcion
Puedes tocar el + 0.1 para "contraer" la grafica, pero si aumentas el limite a mas de 6.0 DES no consigue calcular la serie de Taylor por ser demasiado grande
TerminosReales calcula la serie de Taylor
Con el limite C=17.0 se calcula con suficiente precision, pero si se disminuye aunque sea un poco, los numeros desde el 4.0 no estaran calculados con precision
representacion a�ade los espacios necesarios segun el valor de la serie de taylor
La proporcion de espacios/cifra esta al limite, si se intenta aumentar para mas precision DES no carga el programa
Es mejor dejar las cotas arbitrarias as�, para que todo compile
*/
create view funcionTaylor as
with sumaMini(N) AS (
  select 0.0
  union
  select N + 0.1
  from sumaMini
  where N < 6.0
)
with terminosReales(P,                   F,   U,   T,   S,   C, N, ORIG) AS (
  select       (select N from sumaMini), 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0
  union
  select (P** ( (C+2.0)/(C) )), (F*(C+1.0))*(C+2.0), U*(-1.0), P*U/F, S + T, C +2.0, N + 1, P**(1/(2*N-1))
  from terminosReales
  where C <= 15.0
)
select * from terminosReales
WHERE C = 17.0;

create view representacionTaylor as
WITH representacion(PAR, SERIE, NUME) AS (
  SELECT '' AS PAR, ((f.S + 1) * 100) / 5 AS SERIE, f.ORIG AS NUME
  FROM funcionTaylor f
  WHERE f.C = 17.0    
  UNION ALL
  SELECT PAR || ' ', SERIE - 1.0, NUME
  FROM representacion
  WHERE SERIE >= 0.0
)
SELECT * FROM representacion where SERIE < 0.0;

select all PAR, ROUND(NUME,2) from representacionTaylor ORDER BY NUME ASC;

--select * from funcionTaylor;
