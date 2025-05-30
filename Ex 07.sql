CREATE DATABASE ejercicio_07;
USE ejercicio_07;

CREATE TABLE provincias (
cod_pro char(2) not null primary key,
nombre_provincia varchar(50)
);

insert into provincias (cod_pro, nombre_provincia) VALUES
("1", "Barcelona"), ("2", "Girona"), ("4", "Tarragona"), ("3", "Lleida");

CREATE TABLE pueblos (
cod_pue char(3) not null primary key,
nombre_pueblo varchar(50),
cod_pro char(2) not null
);

insert into pueblos (cod_pue, nombre_pueblo, cod_pro) VALUES 
("HOS", "Hospitalet", 1), ("COR", "Cornellà", 1), ("ESP", "ESPLUGUES", 1), 
("COL", "Santa Coloma", 1), ("Cun", "Cunit", 3), ("Van", "Vandellòs", 3), 
("SER", "Seròs", 4), ("TRE", "Tremp", 4), ("BAN", "Banyoles", 4), ("TOS", "Tossa", 4);

CREATE TABLE clientes (
cod_cli int not null primary key auto_increment,
nombre_cliente varchar(100) not null,
direccion_cli varchar(100) not null,
codpostal_cli char(5),
cod_pue char(3)
); 
insert into clientes (nombre_cliente, direccion_cli, codpostal_cli, cod_pue) values
("Peter Parker", "Corssega 400", "08045", "COR"), ("Robin Hood", "Del Chorizo", "08999", "COL"),
("Anibal Lecter", "C/ del vegano", "08018", "TOS"), ("Aitana Bonmati", "C/ Gamper", "40666", "TRE");

CREATE TABLE vendedores (
cod_ven int not null primary key auto_increment,
nombre_vendedor varchar(100) not null,
direccion_ven varchar(100) not null,
codpostal_ven char(5),
cod_pue char(3)
);

insert into vendedores (nombre_vendedor, direccion_ven, codpostal_ven, cod_pue) values
("Jan Laporta","C/ Gamper", "40666", "TRE"), ("Florentino","Del Chorizo", "08999", "COL");

CREATE TABLE articulos (
cod_art int not null primary key auto_increment,
descripcion_art varchar(100) not null,
precio_art decimal(8,2),
stock_art int,
stock_min int
);

insert into articulos (descripcion_art, precio_art, stock_art, stock_min) values
("Teclado", 20, 10, 5), ("Monitor Samsung", 200, 3, 0), ("Monitor LG", 300, 1, 0), ("SSD WD", 100, 5, 5);

CREATE TABLE facturas (
cod_fac int not null primary key auto_increment,
fecha_fac datetime,
cod_ven int,
cod_cli int,
iva int,
descuento_fac decimal(5,2)
);

alter table facturas modify iva decimal(5,2);
delete  from facturas;

insert into facturas (fecha_fac, cod_ven, cod_cli, iva, descuento_fac) values
("2025-05-30", 1, 2, 0.21, 5), ("2025-04-15", 1, 1, 0.21, 10), 
("2025-05-30", 1, 2, 0.21, 5), ("2025-04-12", 2, 4, 0.21, 20);

CREATE TABLE lineas_fac (
cod_lin_fac int not null primary key auto_increment,
cod_fac int,
cant_lin decimal(8,2),
cod_art int,
precio decimal(8,2),
descuento_lin decimal(5,2)
);

insert into lineas_fac (cod_fac, cant_lin, cod_art, precio, descuento_lin) values
(1, 2, 2, 250, 0.1), (2, 2, 1, 30, 0.05), (3, 3, 3, 400, 0.1), (3, 2, 1, 30, 0.05);

-- 1. Mostrar las provincias 
SELECT nombre_provincia FROM provincias;

-- 2. Nombre y código de las provincias.
select nombre_provincia, cod_pro from provincias;

-- 3. Mostrar el código de los arYculos y el doble del precio de cada articulo. 
select cod_art, (precio_art * 2) as "Doble precio" from articulos;

-- 4. Mostrar el código de la factura, número de línea e importe de cada línea (sin considerar impuestos
select cod_lin_fac, cod_fac, precio from lineas_fac;

-- 5. Mostrar los dis8ntos 8pos de IVA aplicados en las facturas.
select distinct(iva) from facturas;

-- 6. Mostrar el código y nombre de aquellas provincias cuyo código es menor a HH. 
select cod_pro, nombre_provincia from provincias
where cod_pro < "HH";

-- 7. Mostrar los distintos tipos de descuento de aplicados por los vendedores que cuyos códigos no 
-- superan el valor 50.


-- 8. Mostrar el código y descripción de aquellos arYculos cuyo stock es igual o supera los 2 unidades. 
select cod_art, descripcion_art from articulos
where stock_art > 2;

-- 9. Mostrar el código y fechas de las facturas con IVA 21 y que pertenecen al cliente de código 2.
select cod_fac, fecha_fac from facturas
where iva = 0.21 and cod_cli = 2;

-- 10. Mostrar el código y fechas de las facturas con IVA 21 o con descuento 10 y que pertenecen al 
-- cliente de código 1.
select cod_fac, fecha_fac from facturas
where (iva =.21 or descuento_fac = 10) and cod_cli = 1; 

-- 11. Mostrar el código de la factura y el número de línea de las facturas cuyas líneas superan 100 Bs sin 
-- considerar descuentos ni impuestos. 
select cod_fac, cod_lin_fac from lineas_fac
where cant_lin * precio > 100;

-- 12. Importe medio por factura, sin considerar descuentos ni impuestos. El importe de una factura se 
-- calcula sumando el producto de la can8dad por el precio de sus líneas. 
select avg(cant_lin * precio) as media from lineas_fac
group by cod_fac;

-- 13. Stock medio, máximo, y mínimo de los arYculos que contienen la letra O en la segunda posición 
-- de su descripción y cuyo stock mínimo es superior a la mitad de su stock actual.
 select descripcion_art, avg(stock_art) as media, max(stock_art) as maximo, min(stock_art) as minimo from articulos
 where descripcion_art like "_o%" and stock_min > (stock_art / 2)
 group by descripcion_art; 
 
-- 14. Número de facturas para cada año. Junto con el año debe aparecer el número de facturas de ese 
-- año. 
select year(fecha_fac) as año, count(*) as num_facturas
from facturas
group by año;

-- 15. Número de facturas de cada cliente, pero sólo se deben mostrar aquellos clientes que tienen menos 
-- de 2 facturas. 
select cod_cli, count(*) as cantidad_facturas from facturas
group by cod_cli
having cantidad_facturas < 2;

-- 16. Cantidades totales vendidas para cada articulo cuya descripción empieza por “M”. La cantidad total 
-- vendida de un articulo se calcula sumando las cantidades de todas sus líneas de factura.
select a.cod_art, a.descripcion_art, sum(l.cant_lin)
from articulos a 
natural join lineas_fac l 
where a.descripcion_art like "M%"
group by l.cod_art;

-- 17. Código de aquellos articulos de los que se ha facturado más de 400 euros.
select cod_art
from lineas_fac
group by cod_art
having sum(cant_lin * precio) > 400;





/*  
18. Número de facturas de cada uno de los clientes cuyo código está entre 241 y 250, con cada IVA 
dis8nto que se les ha aplicado. En cada línea del resultado se debe mostrar un código de cliente, 
un IVA y el número de facturas de ese cliente con ese IVA. 
19. Vendedores y clientes cuyo nombre coincide (vendedores que a su vez han comprado algo a la 
empresa) 
 
20. Creación de una vista que muestre únicamente los códigos postales de los clientes que inicien con 
el número 12. 
21. Mostrar el código y el nombre de los clientes de Castellón (posee código 12) que han realizado 
facturas con vendedores de más de dos provincias dis8ntas. El resultado debe quedar ordenado 
ascendentemente respecto del nombre del cliente.
*/