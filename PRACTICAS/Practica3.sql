/abolish
/multiline on
-- PRÁCTICA 3: Consultas complejas con agregación y análisis de datos
-- Objetivo: Usar GROUP BY, SUM, agregaciones y análisis de distribución
-- Practica 3: Diego Rodr�guez y Alejandro Martinez

create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into programadores values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','J�piter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plut�n 3',NULL);

create table distribuci�n(c�digoPr string, dniEmp string, horas int, primary key (c�digoPr, dniEmp));
insert into distribuci�n values('P1','1',10);
insert into distribuci�n values('P1','2',40);
insert into distribuci�n values('P1','4',5);
insert into distribuci�n values('P2','4',10);
insert into distribuci�n values('P3','1',10);
insert into distribuci�n values('P3','3',40);
insert into distribuci�n values('P3','4',5);
insert into distribuci�n values('P3','5',30);
insert into distribuci�n values('P4','4',20);
insert into distribuci�n values('P4','5',10);

create table proyectos(c�digo string primary key, descripci�n string, dniDir string);
insert into proyectos values('P1','N�mina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producci�n','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');


create view vista1 as
select dni from programadores union select dni from analistas;

create view vista2 as
select dni from programadores intersect select dni from analistas;

create view vista3 as
select * from vista1 except (select dniEmp from distribuci�n union select dniDir from proyectos);

create view dnitel as
select dni,tel�fono from programadores union distinct select dni,tel�fono from analistas;

-- Proyectos con columna llamada dni
create view aux4_1 as
select c�digoPr as c�digo, dniEmp as dni_
from distribuci�n
UNION
select c�digo, dniDir as dni_
from proyectos;

-- Proyectos dirigidos por analistas
create view aux4_2 as
select distinct c�digo
from aux4_1 JOIN analistas ON dni_ = dni;

-- Vista4: Proyectos sin empleados asignados (dirigidos por analistas)
create view vista4 as
select c�digo
from aux4_1
except
select c�digo
from aux4_2;

-- Vista5: Empleados que son SOLO analistas y que dirigen algún proyecto
create view vista5 as
(select dni from analistas
except
select dni from programadores)
intersect
(select dniDir as dni from proyectos);

-- Vista6: Descripción del proyecto, nombre del empleado y horas dedicadas
create view vista6 as
select descripci�n, nombre, horas
from programadores, distribuci�n, proyectos
where (dni = dniEmp) and (c�digoPr = c�digo);

-- Vista7: Teléfonos duplicados (comentada por rendimiento)
--create view vista7 as
--select teléfono from dnitel
--except all
--select distinct teléfono from dnitel;

-- Vista8: Empleados que son AMBOS programadores y analistas (con natural join)
create view vista8 as
select dni
from programadores natural join analistas;

-- Vista9: Horas totales por empleado
create view vista9 as
select dni, sum(horas) as horas
from (select dni from programadores union select dni from analistas)
join distribuci�n on dni = dniEmp
group by dni;

-- Vista10: Unión de todos los proyectos (trabajadores + directores)
create view vista10 as
(select dni, nombre, c�digoPr as proyecto
from (select * from programadores union select * from analistas)
join distribuci�n on dni = dniEmp)
union
(select dni, nombre, c�digo as proyecto
from (select * from programadores union select * from analistas)
join proyectos on dni = dniDir)
;

-- Vista11: Empleados sin teléfono
create view vista11 as
select dni,nombre from programadores where tel�fono is null union
select dni,nombre from analistas where tel�fono is null;

-- Contamos las horas y proyectos de cada trabajador
create view vista12_totalE as
select dni, sum(horas) as horas, count(*) as cantidadP
from (select dni from programadores union select dni from analistas)
join distribuci�n on dni = dniEmp
group by dni;

-- Calculamos el promedio de horas/trabajador de cada proyecto
create view vista12_promedio as
select c�digoPr, (sum(horas) / count(*)) as p
from distribuci�n
group by c�digoPr;

-- Comparamos las horas/proyectos de los empleados con la media de los proyectos
create view vista12 as
select *
from vista12_totalE
where
(horas / cantidadP)
<
(select avg(p) from vista12_promedio);

-- Vista13: Empleados que trabajan en todos los proyectos donde trabaja Evaristo (división)
create view vista13 as
select dniEmp from
(select códigoPr,dniEmp from distribución)
division
(select códigoPr from distribución where dniEmp=
select dni from (select * from programadores union select * from analistas) where nombre='Evaristo');

-- Vista14: Empleados que trabajan en los mismos proyectos que Evaristo
create view vista14_1 as
select dni as d, códigoPr as p
from distribución, (select dni from programadores union select dni from analistas)
where dniEmp = (select dni from analistas where nombre = 'Evaristo');

create view vista14_2 as
select dni as d, códigoPr as p
from (select dni from programadores union select dni from analistas) join distribución on dni = dniEmp;

create view vista14_3 as
select d as dni from
(select * from vista14_1 except select * from vista14_2);

create view vista14 as
select * from
((select dni from programadores union select dni from analistas) except select * from vista14_3);

-- Vista15: Proyectos de Evaristo con aumento de 20% en horas para otros empleados
create view vista15_1 as
(select códigoPr as código from distribución where dniEmp=
select dni from (select * from programadores union select * from analistas) where nombre='Evaristo');

create view vista15_2 as
select * from
(select códigoPr as código, dniEmp
from distribución
union
select código, dniDir as dniEmp
from proyectos);

create view vista15_3 as
select distinct dniEmp from
(select * from vista15_1 natural join select * from vista15_2);

create view vista15_4 as
select * from
(select dni from programadores union select dni from analistas) except (select * from vista15_3);

create view vista15 as
select códigoPr,dniEmp,horas*1.2 from distribución
where dniEmp in (select dni as dniEmp from vista15_4)
group by códigoPr, dniEmp, horas;

-- Vista16: Empleados que trabajan en proyectos de directores que reportan a Evaristo
create view vista16_1 as
(select código from proyectos where dniDir=
select dni from (select * from programadores union select * from analistas) where nombre='Evaristo');

create view vista16_2 as
select dniEmp from
((select códigoPr as código,dniEmp from distribución) natural join (select código from vista16_1));

create view vista16_3 as
(select código from proyectos where dniDir in (select * from vista16_2));

create view vista16_4 as
select dniEmp from
((select códigoPr as código,dniEmp from distribución) natural join (select código from vista16_3))
union
select * from vista16_2;

create view vista16 as
select nombre from
(select * from programadores union select * from analistas) where dni in (select * from vista16_4) and nombre<>'Evaristo';

-- Mostrar resultados
select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;

-- Empleados con más de 20 horas totales
WITH total_horas (dniEmp, total) AS (
SELECT dniEmp, SUM(horas) AS total
FROM distribución
GROUP BY dniEmp
)
SELECT dniEmp, total
FROM total_horas
WHERE total > 20;
