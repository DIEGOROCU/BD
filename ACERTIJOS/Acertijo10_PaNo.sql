/abolish
/duplicates off
/multiline on

-- ACERTIJO 10 - PARIDAD SIN COUNT: Determinar paridad sin usar COUNT()
-- Objetivo: Diferenciar si hay cantidad par o impar de elementos sin usar función COUNT

-- Base relation
/SET bound 5

CREATE TABLE r(x INT);
INSERT INTO r WITH n(x) AS SELECT 1 UNION SELECT x+1 FROM n WHERE x<$bound$ SELECT * FROM n;

create view pares_nones as
with recu (N, M) as (
	select (select * from r), 1.0
  	union
  	select N, M + 1.0 from recu
  	except select top 1 N, M from recu order by M desc
  	from recu
  	where M < 3.0
)
select * from recu;

select * from pares_nones;