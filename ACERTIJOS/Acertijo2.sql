/abolish
/type_casting on

create table patrones(id_patron string primary key, nombre string, titulo string, edad integer);
insert into patrones(id_patron, nombre, titulo, edad) values('1','Jacinto','CY',45);
insert into patrones(id_patron, nombre, titulo, edad) values('2','Herminia','PY',35);
insert into patrones(id_patron, nombre, titulo, edad) values('3','Calixto','PER',22);
insert into patrones(id_patron, nombre, titulo, edad) values('4','Teodora','PER',29);
insert into patrones(id_patron, nombre, titulo, edad) values('5','Vicente','PNB',29);

create table barcos(id_barco string primary key, nombre_barco string, color string);
insert into barcos(id_barco, nombre_barco, color) values('1','Albatros','blanco');
insert into barcos(id_barco, nombre_barco, color) values('2','Bravo','blanco');
insert into barcos(id_barco, nombre_barco, color) values('3','Coral','rojo');
insert into barcos(id_barco, nombre_barco, color) values('4','Dorada','blanco');
insert into barcos(id_barco, nombre_barco, color) values('5','Exodus','azul');

create table reservas(id_patron string references patrones, id_barco string references barcos, fecha date, primary key (id_patron, id_barco, fecha));
insert into reservas(id_patron, id_barco, fecha) values('1','1','2014-06-01');
insert into reservas(id_patron, id_barco, fecha) values('1','2','2014-06-07');
insert into reservas(id_patron, id_barco, fecha) values('1','4','2014-08-12');
insert into reservas(id_patron, id_barco, fecha) values('2','4','2014-07-20');
insert into reservas(id_patron, id_barco, fecha) values('3','1','2014-08-05');
insert into reservas(id_patron, id_barco, fecha) values('3','3','2014-09-16');
insert into reservas(id_patron, id_barco, fecha) values('3','1','2014-06-11');
insert into reservas(id_patron, id_barco, fecha) values('3','5','2014-07-13');
insert into reservas(id_patron, id_barco, fecha) values('4','4','2014-08-22');
insert into reservas(id_patron, id_barco, fecha) values('4','5','2014-09-03');

-- Vista1: Barcos más reservados
-- Agregamos una columna de cantidad para contar reservas por barco

-- Añadimos una columna con 1, para representar la cantidad, para que se pueda luego sumar
aux0 := project id_patron, id_barco, fecha, 1 as c(reservas);
--Sumamos las cantidades segun la id del barco
aux1 := group_by id_barco id_barco, sum (c) true (aux0);
--Renombramos para poder hacer el producto de latabla con si misma
aux2 := (rename aux (idb, c) (aux1)) product (rename auxi (idb_e, c_e) (aux1));
--Cogemos los barcos que han sido reservados menos que algun otro, para despues
aux3 := select (c < c_e) (aux2);
--Cogemos la lista de todas las id
aux4 := (project idb (aux2));
--Cogemos la lista de las id de los barcos que han sido reservados menos que algun otro
aux5 := (project idb (aux3));
--Hacemos la diferencia, ya que los mas reservados no han sido reservados menos que ningun otro
aux6 := aux4 difference aux5;
--Hacemos el producto para escoger los barcos mas reservados, y proyectamos sus nombres
vista1 := project nombre_barco(select (id_barco = idb) (barcos product aux6));

select true (vista1);
