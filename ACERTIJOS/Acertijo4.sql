/abolish
/multiline on

-- ACERTIJO 4: Ranking de canciones
-- Objetivo: Asignar posición a cada canción según número de copias vendidas

CREATE TABLE hits (
  theme varchar(50) NOT NULL,
  copies int NOT NULL,
  PRIMARY KEY (theme, copies));

INSERT INTO hits (theme, copies) VALUES
('I Will Always Love You', 20),
('If I Didn''t Care', 19),
('In the Summertime', 31),
('It''s Now or Never', 20),
('My Heart will Go On', 25),
('Rock Around the Clock', 25),
('Silent Night', 30),
('We Are the World', 20),
('White Christmas', 50);

-- Copiamos la tabla con otros nombres
create view hits_aux as
select theme as t_aux, copies as c_aux
from hits;

-- Hacemos el producto con si misma, para la posicion contamos cuantas contamos cuantas canciones han sido mas escuchadas o cuantas van despues en orden alfabetico en caso de empate
create view prod_aux as
select all *
from hits, hits_aux
where copies < c_aux or (copies = c_aux and theme >= t_aux);

-- Contamos y ponemos la vista como se pide
create view vista1 as
select all theme, copies, count(*) as pos
from prod_aux
group by theme, copies
order by pos;

select * from vista1;