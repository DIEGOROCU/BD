/abolish
/multiline on
--/duplicates on

-- ACERTIJO 9 - NÚMEROS PRIMOS: Detección de números primos
-- Objetivo: Identificar todos los números primos hasta 20 usando recursión

create view primos as
with nums(N) as (
 select 2.0 from dual
  union
  select N+1.0 from nums
  where N < 20.0
)
with prim(N, MP, Q) as(
	select (select N from nums), (select N from nums) as MP, -1.0
  	union
  	select N, MP + N, Q**2
  	from prim
  	where MP < 20.0 and (N = MP or Q = 1.0)
)
select N as NUMI from nums
except
select distinct MP as NUMI from prim where Q = 1.0;

select * from primos;