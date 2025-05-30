create database almacen;
use almacen;

create table piezas (
id_pieza int auto_increment not null primary key,
nombre_pieza varchar(100)
);


create table suministra (
id_pieza int,
id_proveedor int,
precio int
);


create table proveedores (
id_proveedor int not null auto_increment primary key,
nombre_proveedor varchar(100)
);

insert into piezas (nombre_pieza) values
("Tornillo M14"), ("Broca 20mm"), ("Tornillo rosca chapa"), ("tester");

insert into proveedores (nombre_proveedor) values
("SQL"), ("HTML"), ("Windsurf"), ("Stucom");

insert into suministra values
(1,3, 5), (3,1, 10), (1,4, 2), (2,3, 6), (4,3, 4), (4,4, 8);

-- 1 Obtener los nombres de todas las piezas.
select nombre_pieza from piezas;

-- 2 Obtener todos los datos de todos los proveedores.
select * from proveedores;

-- 3 Obtener el precio medio al que se nos suministran las piezas.
select avg(precio) from suministra;

-- 4 Obtener los nombres de los proveedores que suministran la pieza 1.
select p.nombre_proveedor from proveedores p
natural join suministra s 
where s.id_pieza = 1;

-- 5 Obtener los nombres de las piezas suministradas por el proveedor cuyo código es 1.
select p.nombre_pieza from piezas p
natural join suministra s 
where s.id_proveedor = 1;

-- 6 Obtener los nombres de los proveedores que suministran la piezas más caras, indicando el
-- nombre de la pieza y el precio al que la suministran.
select pr.nombre_proveedor from proveedores pr
natural join suministra su
where su.precio = (select max(precio) precio from suministra); 

-- 7 Hacer constar en la base de datos que la empresa ”Skellington Supplies” (código TNBC)
-- va a empezar a suministrarnos tuercas (código 1) a 7 dólares cada tuerca.
insert into proveedores (nombre_proveedor) values
("Skellington Supplies");

insert into piezas (nombre_pieza) values
("Tuerca");

insert into suministra values (5,5,7);

-- 8 Aumentar los precios en una unidad.
update suministra set precio = precio + 1;

-- 9 Hacer constar en la base de datos que la empresa ”Susan Calvin Corp.”(RBT) no va a suministrarnos
-- ninguna pieza (aunque la empresa en s´ı va a seguir constando en nuestra
-- base de datos).
insert into proveedores (nombre_proveedor) values ("Susan Calvin Corp");

insert into suministra values (null, 6, null);

-- 10 10. Hacer constar en la base de datos que la empresa ”Susan Calvin Corp.”(RBT) ya no va a
-- suministrarnos clavos (código 4)
delete from suministra
where id_proveedor = 6 and id_pieza = 4;

