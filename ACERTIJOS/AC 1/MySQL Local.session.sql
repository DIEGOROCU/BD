-- Práctica 2:
-- Diego Rodríguez y Alejandro Martínez
-- Para procesar este archivo (se puede especificar también la ruta): /process datos.ra
-- Antes debéis crear las relaciones (tablas).
-- Falta la última tupla de cada tabla y debéis escribir vosotros la instrucción de inserción en cada caso
/abolish
/multiline on
/duplicates off

create table programadores(dni string primary key, nombre string, dirección string, teléfono string);

insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, dirección string, teléfono string);

insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3', NULL);


create table distribución(códigopr string, dniemp string, horas int, primary key (códigopr,dniemp));

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

create table proyectos(código string primary key, descripción string, dnidir string);

insert into proyectos(código, descripción, dnidir) values('P1','Nómina','4');
insert into proyectos(código, descripción, dnidir) values('P2','Contabilidad','4');
insert into proyectos(código, descripción, dnidir) values('P3','Producción','5');
insert into proyectos(código, descripción, dnidir) values('P4','Clientes','5');
insert into proyectos(código, descripción, dnidir) values('P5','Ventas','6');

vista1 := project dni (programadores njoin analistas);
vista2 := rename (dniemp as dni) (distribución);

select true (vista1);
--select true (vista2);
--select true (vista3);
--select true (vista4);
--select true (vista5);
--select true (vista6);
--select true (vista7);
--select true (vista8);