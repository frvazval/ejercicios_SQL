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

insert into clientes (nombre_cliente,apellido_cliente) values ("Peter", "Parker"), ("Beyocé", "Pérez");

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
		update productos set stock_actual = stock_actual - new.cantidad, ventas_producto = ventas_producto + new.cantidad;
	end if;
end //
delimiter ;




