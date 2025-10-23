/abolish
/multiline on

-- Practica 3: Diego Rodríguez y Alejandro Martinez

create table programadores(dni string primary key, nombre string, dirección string, teléfono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, dirección string, teléfono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3',NULL);

create table distribución(códigoPr string, dniEmp string, horas int, primary key (códigoPr, dniEmp));
insert into distribución values('P1','1',10);
insert into distribución values('P1','2',40);
insert into distribución values('P1','4',5);
insert into distribución values('P2','4',10);
insert into distribución values('P3','1',10);
insert into distribución values('P3','3',40);
insert into distribución values('P3','4',5);
insert into distribución values('P3','5',30);
insert into distribución values('P4','4',20);
insert into distribución values('P4','5',10);

create table proyectos(código string primary key, descripción string, dniDir string);
insert into proyectos values('P1','Nómina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producción','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

/*
create view vista1 as
select dni from programadores union select dni from analistas;

create view vista2 as
select dni from programadores intersect select dni from analistas;

create view vista3 as
select * from vista1 except (select dniEmp from distribución union select dniDir from proyectos);

create view dnitel as
select dni,teléfono from programadores union distinct select dni,teléfono from analistas;

-- Proyectos con columna llamada dni
create view aux4_1 as
select códigoPr as código, dniEmp as dni_
from distribución
UNION
select código, dniDir as dni_
from proyectos;

create view aux4_2 as
select distinct código
from aux4_1 JOIN analistas ON dni_ = dni;

create view vista4 as
select código
from aux4_1
except
select código
from aux4_2;

create view vista5 as
(select dni from analistas
except
select dni from programadores)
intersect
(select dniDir as dni from proyectos);

create view vista6 as
select descripción, nombre, horas
from programadores, distribución, proyectos
where (dni = dniEmp) and (códigoPr = código);

-- Dejar comentada esta vista, hace que tarde mucho en compilar
--create view vista7 as
--select teléfono from dnitel
--except all
--select distinct teléfono from dnitel;

create view vista8 as
select dni
from programadores natural join analistas;

-- Sumamos las horas de cada trabajador
create view vista9 as
select dni, sum(horas) as horas
from (select dni from programadores union select dni from analistas)
join distribución on dni = dniEmp
group by dni;

-- Unimos el join de todos los empleados con los proyectos (tanto como trabajadores como siendo directires, uniendo ambos casos)
create view vista10 as
(select dni, nombre, códigoPr as proyecto
from (select * from programadores union select * from analistas)
join distribución on dni = dniEmp)
union
(select dni, nombre, código as proyecto
from (select * from programadores union select * from analistas)
join proyectos on dni = dniDir)
;

-- Unimos los telefono is null de cada tipo de trabajadores
create view vista11 as
select dni,nombre from programadores where teléfono is null union
select dni,nombre from analistas where teléfono is null;

-- Contamos las horas y proyectos de cada trabajador
create view vista12_totalE as
select dni, sum(horas) as horas, count(*) as cantidadP
from (select dni from programadores union select dni from analistas)
join distribución on dni = dniEmp
group by dni;

-- Calculamos el promedio de horas/trabajador de cada proyecto
create view vista12_promedio as
select códigoPr, (sum(horas) / count(*)) as p
from distribución
group by códigoPr;

-- Comparamos las horas/proyectos de los empleados con la media de los proyectos
create view vista12 as
select *
from vista12_totalE
where
(horas / cantidadP)
<
(select avg(p) from vista12_promedio);

create view vista13 as
select dniEmp from
(select códigoPr,dniEmp from distribución)
division
(select códigoPr from distribución where dniEmp=
select dni from (select * from programadores union select * from analistas) where nombre='Evaristo');

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

;*/

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
/*
select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
 select * from vista14;
select * from vista15;*/
select * from vista16