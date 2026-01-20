-- PRÁCTICA 2: Operaciones avanzadas con joins naturales y divisiones
-- Objetivo: Usar natural joins, divisiones y consultas complejas con agregación

-- Pr�ctica 2:
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
-- Vista1: Empleados que son SOLO analistas (diferencia con programadores)vista1 := project dni (programadores njoin analistas);

aux2_0 := rename aux (dni,horas) (group_by dni dni,sum(horas) true ((programadores union analistas) nljoin (rename aux (c�digopr,dni,horas) (distribuci�n))));
aux2_1 := project dni, 0 (select (horas is null) (aux2_0));
aux2_2 := select (horas is not null) (aux2_0);
vista2 := aux2_2 union aux2_1;
-- Vista3: Empleados con sus proyectos asignados (tanto como trabajadores como directores)aux3_0 := programadores union analistas;
aux3_1 := rename dist (c�digo, dni) (project c�digopr,dniemp (distribuci�n)) union rename proy (c�digo,dni) (project c�digo, dnidir (proyectos));
aux3_2 := project dni,nombre,c�digo (aux3_0 njoin aux3_1);
vista3 := aux3_2 union rename rest (dni,nombre,c�digo) (project dni,nombre,NULL (project dni,nombre (aux3_0) difference project dni,nombre (aux3_2)));
-- Vista4: Empleados sin teléfono registradovista4 := project dni,nombre (select (tel�fono is null) (aux3_0));

aux5_0 := project c�digo (select nombre='Evaristo' (aux3_2));
vista5 := rename list(dni,c�digopr,horas) (project dni,c�digo,horas*1.2 (aux3_2 difference (aux3_2 njoin aux5_0) njoin rename dist(c�digo, dni, horas) (distribuci�n)));

vista6 := project dni (select nombre <> 'Evaristo' (aux3_2 division aux5_0));

aux7_0 := project c�digo (select nombre='Evaristo' (aux3_2));
aux7_1 := project dni (select nombre <> 'Evaristo' (aux3_2));
aux7_2 := aux7_1 product aux7_0;
aux7_3 := rename temp (dni,c�digo) (aux7_2);
aux7_4 := project dni,c�digo (select nombre <> 'Evaristo' (aux3_2));
aux7_5 := aux7_3 difference aux7_4;
vista7 := aux7_1 difference project dni (aux7_5);

-- Codigo de los proyectos dirigidos por Evaristo
aux8_0 := project c�digo (select dnidir = dni (proyectos product (project dni (select nombre = 'Evaristo' (aux3_2)))));
-- Trabajadores de los proyectos dirigidos por Evaristo (sin contar a Evaristo)
aux8_1 := (project dni (select cod = c�digo ((rename aux (cod) (aux8_0)) product aux3_2))) difference (project dni (select nombre = 'Evaristo' (aux3_2))) ;
-- Proyectos que dirigen los trabajadores de Evaristo
aux8_2 := project c�digo (select dnidir = dni (proyectos product (aux8_1)));
-- Empleados de los trabajadores de Evaristo
aux8_3 := (project dni (select cod = c�digo ((rename aux (cod) (aux8_2)) product aux3_2))) difference (project dni (select nombre = 'Evaristo' (aux3_2))) ;
-- Unimos empleados de Evaristo y los subempleados
vista8 := aux8_1 union aux8_3;

select true (vista1);
select true (vista2);
select true (vista3);
select true (vista4);
select true (vista5);
select true (vista6);
select true (vista7);
select true (vista8);