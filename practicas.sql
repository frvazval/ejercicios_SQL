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



