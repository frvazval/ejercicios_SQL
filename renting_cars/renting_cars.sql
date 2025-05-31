/* Crea la base de datos si no existe */
CREATE DATABASE If NOT EXISTS renting_cars;

-- abro la base de datos
USE renting_cars;

-- Creo las tablas
CREATE TABLE IF NOT EXISTS clientes (
id_cliente int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL,
apellido varchar(100) NOT NULL,
email varchar(50)
);

CREATE TABLE IF NOT EXISTS ventas (
id_venta int AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_cliente int NOT NULL
);

CREATE TABLE IF NOT EXISTS ventas_productos (
id_vp int AUTO_INCREMENT NOT NULL PRIMARY KEY,
id_venta int NOT NULL,
id_producto int NOT NULL,
cantidad int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS productos (
id_producto int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL,
marca varchar(50) NOT NULL,
precio decimal (7,2) NOT NULL DEFAULT 0.0,
stock int NOT NULL DEFAULT 0,
id_proveedor int NOT NULL
);

CREATE TABLE IF NOT EXISTS proveedores (
id_proveedor int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL
);

-- Creo las claves foraneas
ALTER TABLE ventas
    ADD CONSTRAINT fk_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES clientes(id_cliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE ventas_productos
    ADD CONSTRAINT fk_venta
    FOREIGN KEY (id_venta)
    REFERENCES ventas(id_venta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
   ALTER TABLE ventas_productos
    ADD CONSTRAINT fk_producto
    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
    ALTER TABLE productos
    ADD CONSTRAINT fk_proveedor
    FOREIGN KEY (id_proveedor)
    REFERENCES proveedores(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;