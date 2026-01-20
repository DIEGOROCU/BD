-- PRÁCTICA 1: Operaciones básicas con empleados y proyectos
-- Objetivo: Realizar consultas combinadas sobre programadores, analistas, distribución y proyectos

-- Pr�ctica 1:
-- Diego Rodr�guez y Alejandro Mart�nez
-- Para procesar este archivo (se puede especificar tambi�n la ruta): /process datos.ra
-- Antes deb�is crear las relaciones (tablas).
-- Falta la �ltima tupla de cada tabla y deb�is escribir vosotros la instrucci�n de inserci�n en cada caso
/abolish
/multiline on
/duplicates off

create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);

insert into programadores values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);

insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','J�piter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plut�n 3', NULL);


create table distribuci�n(c�digopr string, dniemp string, horas int, primary key (c�digopr,dniemp));

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

create table proyectos(c�digo string primary key, descripci�n string, dnidir string);

insert into proyectos(c�digo, descripci�n, dnidir) values('P1','N�mina','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P2','Contabilidad','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P3','Producci�n','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P4','Clientes','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P5','Ventas','6');

-- Vista1: Todos los empleados (programadores + analistas)
vista1 := project dni (programadores union analistas);

-- Vista 3: Empleados sin proyectos asignados (ni como trabajadores ni como directores)
vista3 := vista1 difference (project dniemp (distribuci�n) union project dnidir (proyectos));

-- Vista4: Proyectos sin empleados asignados (dirigidos por analistas)
vista4 := project código (proyectos) difference (project código (proyectos) intersect project códigopr (select dniemp=dni (distribución product analistas)));

-- Vista 6: Descripción del proyecto, nombre del empleado y horas dedicadas
vista6 := project descripción,nombre,horas (select (código = códigopr) (proyectos product (project dni,nombre,horas,códigopr (select (dni=dniemp) (programadores product distribución)))));

-- Vista7: Teléfonos de empleados distintos que comparten 
vista7 := project tel�fono (select (dni!=dni_aux AND tel�fono_aux=tel�fono) ((rename aux1 (dni_aux,nombre_aux,direcci�n_aux,tel�fono_aux) (programadores union analistas)) product (programadores union analistas)));

select true (vista1);
select true (vista2);
select true (vista3);
select true (vista4);
select true (vista5);
select true (vista6);
select true (vista7);
