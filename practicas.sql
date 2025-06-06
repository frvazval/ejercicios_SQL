create database tienda;
use tienda;

create table productos (
id_producto int auto_increment primary key,
nombre_producto varchar(50) not null,
precio decimal(8,2) not null,
stock_actual int not null,
ventas_producto  int not null,
id_proveedor int not null
);

alter table productos modify column ventas_producto int default 0;

create table proveedores (
id_proveedor int auto_increment primary key,
nombre_proveedor varchar(50) not null
);

create table clientes (
id_cliente int auto_increment primary key,
nombre_cliente varchar(50) not null,
apellido_cliente varchar(50) not null,
id_pais int
);

alter table clientes modify column id_pais int unsigned default 1;

insert into clientes (nombre_cliente,apellido_cliente) values ("Peter", "Parker"), ("Beyocé", "Pérez");

insert into clientes (nombre_cliente,apellido_cliente, id_pais) values 
("Michael", "Jackson", 2), ("Jean-Luc", "Piccard", 3), ("Luke", "Skywalker", 2),
("Jules", "Verne", 3), ("Clark", "Kent", 2), ("Leia", "Skywalker", 2);

-- Queremos saber, que cliente son del mismo pais y que codigo de pais es
select concat_ws(" ", c1.nombre_cliente, c1.apellido_cliente) as Cliente1,
concat(c2.nombre_cliente, " ", c2.apellido_cliente) as Cliente2, c1.id_pais
from clientes c1, clientes c2
where c1.id_pais = c2.id_pais and c1.id_cliente <> c2.id_cliente
order by c1.id_pais;

create table paises (
id_pais int auto_increment primary key,
nombre_pais varchar(50)
);

create table facturas (
id_factura int auto_increment primary key,
id_cliente int not null,
id_producto int not null,
cantidad int not null,
fecha_compra datetime default current_timestamp
);

-- Procedimiento almacenado para insertar productos con sus correspondiente proveedores
drop procedure if exists insertar_productos;
delimiter $$
create procedure insertar_productos (
p_nombre_producto varchar(50), 
p_precio decimal (8,2),
p_stock int,
p_nombre_proveedor varchar(50) )
begin
	-- con declare la variable es local, con @ es global
    -- Variable para guardar el id_proveedor si existe
	declare v_id_proveedor int;
    declare v_id_producto int;
    
    select id_proveedor into v_id_proveedor
    from proveedores where nombre_proveedor = p_nombre_proveedor;
    
    if v_id_proveedor is null then
		insert into proveedores (nombre_proveedor) values (p_nombre_proveedor);        
        select id_proveedor into v_id_proveedor
		from proveedores where nombre_proveedor = p_nombre_proveedor;
    end if;    
    
    select id_producto into v_id_producto from productos where nombre_producto = p_nombre_producto;
    
    if v_id_producto is null then
		-- Si v_id_producto
		insert into productos (nombre_producto, precio, stock_actual, id_proveedor) values
        (p_nombre_producto, p_precio, p_stock, v_id_proveedor);
        select concat_ws(" ", "Producto", p_nombre_producto, "añadido a la tabla");
    else
		update productos set precio = p_precio, stock_actual = stock_actual + p_stock
        where id_producto = v_id_producto;
        select concat_ws(" ", "Producto", p_nombre_producto, "actualizado");
    end if;             
end $$
delimiter ;

call insertar_productos ("Iphone 27", 5000.75, 2, "Apple");
call insertar_productos ("Iphone 27", 6000.75, 3, "Apple");
call insertar_productos ("S35", 1000, 5, "Samsung");
call insertar_productos ("S35", 1000, 3, "Samsung");

-- Trigger para ventas de producto
drop trigger if exists tr_verificar_stock;

delimiter //
create trigger tr_verificar_stock
before insert on facturas
for each row
begin
	declare v_stock int;
    select stock_actual into v_stock from productos where id_producto = new.id_producto;
    
    if v_stock  < new.cantidad then
		signal sqlstate "45000" set message_text = "No hay suficiente stock";
	else
		update productos set stock_actual = stock_actual - new.cantidad, ventas_producto = ventas_producto + new.cantidad
        where id_producto = new.id_producto;
	end if;
end //
delimiter ;

insert into facturas (id_cliente, id_producto, cantidad) values (1, 1, 1);
insert into facturas (id_cliente, id_producto, cantidad) values (2, 2, 20);

-- Procedimiento para vender un producto, si no esta el cliente lo añadimos
-- Si el producto no lo tenemos, mostramos un mensaje de error
-- La salida final sera nombre_cliente, apellido_cliente, nombre_producto, cantidad, precio y importe
drop procedure if exists venta_producto;
delimiter $$
create procedure venta_producto (
p_nombre_cliente varchar(50), 
p_apellido_cliente varchar(50),
p_nombre_producto varchar(50),
p_cantidad int)
begin
	declare v_id_cliente int;
    declare v_id_producto int ;
    declare v_precio int;
    
    select id_cliente into v_id_cliente
    from clientes where nombre_cliente = p_nombre_cliente and apellido_cliente = p_apellido_cliente;
    
    if v_id_cliente is null then
		insert into clientes (nombre_cliente, apellido_cliente) values (p_nombre_cliente, p_apellido_cliente);   
        select id_cliente into v_id_cliente
        from clientes where nombre_cliente = p_nombre_cliente and apellido_cliente = p_apellido_cliente;
    end if;

	select id_producto into v_id_producto
    from productos where nombre_producto = p_nombre_producto;
    
    if v_id_producto is null then
		signal sqlstate "45000" set message_text = "No se puede comprar este producto porque no existe";
    else
		insert into facturas (id_cliente, id_producto, cantidad) values
        (v_id_cliente, v_id_producto, p_cantidad);
        select precio into v_precio from productos where id_producto = v_id_producto;
        select concat_ws(" ", "cliente:", p_nombre_cliente, p_apellido_cliente, "Producto:", p_nombre_producto, "Cantidad:", p_cantidad, "Precio:", v_precio, "Importe:", p_cantidad * v_precio);
    end if;	
end $$
delimiter ;
call venta_producto ("Robin", "Hood", "Iphone 27", 2);

-- Hacer un select que muestre el total de todas las facturas del año 2024
select sum(f.cantidad * p.precio) as "Importe total" from facturas f
natural join productos p
where year(f.fecha_compra) = 2024; 

-- Funcion para que muestre los totales de compra de un año en concreto
drop function if exists facturacion_anual;
delimiter $$
create function facturacion_anual (p_year_fact year)
returns varchar(255)
deterministic 
begin
	declare v_total decimal(10,2);    
    
	select sum(f.cantidad * p.precio) into v_total from facturas f
	natural join productos p
	where year(f.fecha_compra) = p_year_fact;
    
    if v_total is null then
		return concat_ws(" ", "El año", p_year_fact, "no tiene facturación");
	else
		return concat_ws(" ", "total Facturacion del año", p_year_fact, "=", v_total, "€");
    end if;
        
end $$
delimiter ;

select facturacion_anual(2025);

drop procedure if exists insertar_productos_2;
delimiter $$
create procedure insertar_productos_2 (
in p_nombre_producto varchar(50), 
in p_precio decimal (8,2),
in p_stock int,
in p_nombre_proveedor varchar(50),
out p_stock_actualizado int)
begin
	-- con declare la variable es local, con @ es global
    -- Variable para guardar el id_proveedor si existe
	declare v_id_proveedor int;
    declare v_id_producto int;
    
    select id_proveedor into v_id_proveedor
    from proveedores where nombre_proveedor = p_nombre_proveedor;
    
    if v_id_proveedor is null then
		insert into proveedores (nombre_proveedor) values (p_nombre_proveedor);        
        select id_proveedor into v_id_proveedor
		from proveedores where nombre_proveedor = p_nombre_proveedor;
    end if;    
    
    select id_producto into v_id_producto from productos where nombre_producto = p_nombre_producto;
    
    if v_id_producto is null then
		-- Si v_id_producto
		insert into productos (nombre_producto, precio, stock_actual, id_proveedor) values
        (p_nombre_producto, p_precio, p_stock, v_id_proveedor);
        select concat_ws(" ", "Producto", p_nombre_producto, "añadido a la tabla");
    else
		update productos set precio = p_precio, stock_actual = stock_actual + p_stock
        where id_producto = v_id_producto;
        select concat_ws(" ", "Producto", p_nombre_producto, "actualizado");
    end if;   
    set p_stock_actualizado = (select stock_actual from productos where id_producto = v_id_producto);
end $$
delimiter ;

-- Variable global
set @stock_producto_actualizado = 0;

call insertar_productos_2("MacBook", 2000, 5, "Apple", @stock_producto_actualizado);
call insertar_productos_2("Teclado", 50, 2, "Logitech", @stock_producto_actualizado);
call insertar_productos_2("Mouse", 20, 4, "Logitech", @stock_producto_actualizado);

-- Mostrar el valor que tiene ahora la variable global
select @stock_producto_actualizado;

-- Necesitamos la información completa de la base de datos:
-- Los clientes, que han comprado, cual es es stock de ese producto,
-- la fecha de la factura y quien era el proveedor
-- Pero no hay que poner los ids

select c.nombre_cliente, c.apellido_cliente, pr.nombre_producto, pr.stock_actual, f.fecha_compra, p.nombre_proveedor from clientes c 
left join facturas f
on c.id_cliente = f.id_cliente
left join productos pr
on f.id_producto = pr.id_producto
left join proveedores p 
on pr.id_proveedor = p.id_proveedor 
order by f.fecha_compra;

-- Crear una vista con el select anterior
drop view if exists datos_totales;

create view datos_totales as 
select c.nombre_cliente, c.apellido_cliente, pr.nombre_producto, pr.stock_actual, f.fecha_compra, p.nombre_proveedor from clientes c 
left join facturas f
on c.id_cliente = f.id_cliente
left join productos pr
on f.id_producto = pr.id_producto
left join proveedores p 
on pr.id_proveedor = p.id_proveedor 
order by f.fecha_compra;


select * from datos_totales;
select nombre_cliente from datos_totales;

-- Ver los usuarios actuales
select * from mysql.user;

-- Crear usuario para la base de datos tienda
create user "admin_tienda"@localhost identified by "1234";
create user "admin_tienda"@"%" identified by "1234";

-- Conceder permisos en la base de datos tienda para hacer select en cualquier tabla
grant select on tienda.* to "admin_tienda"@localhost;
grant insert, update, delete on tienda.* to "admin_tienda"@localhost;
grant all privileges on tienda.* to "admin_tienda"@localhost;
grant all privileges on tienda.* to "admin_tienda"@"%";
grant create routine, execute on tienda.* to "admin_tienda"@localhost  with grant option;

grant all privileges on tienda.* to "admin_tienda"@localhost with grant option;
-- Ver permisos de un usuario
show grants for "admin_tienda"@localhost;

show grants for "root"@localhost;


