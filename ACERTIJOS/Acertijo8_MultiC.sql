/abolish
/multiline on
/duplicates on

-- ACERTIJO 8 - MULTICONJUNTOS: Operaciones de intersección y diferencia
-- Objetivo: Implementar intersección y diferencia de multiconjuntos (preservando duplicados)

CREATE TABLE t(x) AS
  SELECT 1 UNION ALL 
  SELECT 1 UNION ALL 
  SELECT 1 UNION ALL 
  SELECT 2 UNION ALL 
  SELECT 3 UNION ALL 
  SELECT 3;

CREATE TABLE s(x) AS
  SELECT 1 UNION ALL 
  SELECT 1 UNION ALL 
  SELECT 2 UNION ALL 
  SELECT 4;

-- Contamos cuantos valores estan en ambas listas (con sus cantidades)
create view answer_int as
with t1(x_t, cant_t) as (
  select x as x_t, count(*) as cant_t
  from t
  group by x
)
with s1(x_s, cant_s) as (
  select x as x_s, count(*) as cant_s
  from s
  group by x
)
with recursivo(xi, canti) as (
	select x_t as xi, min(cant_t, cant_s) as canti
	from t1 join s1 on t1.x_t = s1.x_s
  	union all
  	select xi, canti - 1
  	from recursivo
 	where canti > 1
)
select xi from recursivo;

select * from answer_int;

create view answer_dif as
with t1(x, cant_t) as (
  select x, count(*) as cant_t
  from t
  group by x
)
with s1(x, cant_s) as (
  select x, count(*) as cant_s
  from s
  group by x
)
with recursivo(xi, canti) as (
	select x, (cant_t - NVL(cant_s, 0)) as canti
	from t1 natural left join s1
  	union all
  	select xi, canti - 1
  	from recursivo
 	where canti > 1
)
select xi from recursivo where canti > 0;

select * from answer_dif;