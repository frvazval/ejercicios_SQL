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
		
    else
    
    end if;
    
    
    
    
end $$
delimiter ;

call insertar_productos ("Iphone 27", 5000.75, 2, "Apple");




