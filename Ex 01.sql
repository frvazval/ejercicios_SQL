CREATE DATABASE empleados;
use empleados;

create table empleados (
DNI varchar(9) NOT NULL primary key,
nombre varchar(100) not null,
apellidos varchar(255) not null,
id_departamento int not null
);

create table departamentos (
id_departamento int not null primary key auto_increment,
nombre varchar(100) not null,
presupuesto decimal(9,2) not null
);

-- Obtener los apellidos de los empleados
SELECT apellidos FROM empleados;

-- Obtener los apellidos de los empleados sin repeticiones
SELECT distinct apellidos FROM empleados;

-- Obtener todos los datos de los empleados que se apellidan "López"
SELECT * FROM empleados WHERE apellidos = "Lopez";
SELECT * FROM empleados WHERE apellidos LIKE "Lopez";
SELECT * FROM empleados WHERE apellidos IN ("Lopez");

-- Obtener todos los datos de los empleados que se apellidan "López" y "Pérez"
SELECT * FROM empleados WHERE apellidos = "Lopez" OR apellidos = "Perez";
SELECT * FROM empleados WHERE apellidos LIKE "Lopez" OR apellidos LIKE "Perez";
SELECT * FROM empleados WHERE apellidos IN ("Lopez", "Perez");

-- Obtener todos los datos de los empleados que trabajan en el dep. 14
SELECT * FROM empleados WHERE id_departamento = 14;

-- Obtener todos los datos de los empleados cuyo apellido comience por 'P'
SELECT * FROM empleados WHERE apellidos LIKE "P%";

-- Obtener el presupuesto total de todos los departamentos
SELECT SUM(presupuesto) FROM departamentos;

-- Obtener el número de empleados de cada departamento
SELECT id_departamento, COUNT(DNI) 
FROM empleados 
GROUP BY id_departamento;

-- Obtener los datos completos de los empleados y su departamento
SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
JOIN departamentos d
ON e.id_departamento = d.id_departamento;

SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
NATURAL JOIN departamentos d;

-- Obtener los nombres de los departamentos que tienen más de dos empleados
SELECT nombre
FROM departamentos
WHERE id_departamento IN (
	SELECT id_departamento FROM empleados
    GROUP BY id_departamento HAVING COUNT(DNI) > 2);
    
-- Añadir departamento de Calidad, con presupuesto de 40000€ y código 11.
-- Añadir empleado "Esther Vázquez" DNI "12345678E"
INSERT INTO departamentos(id_departamento, nombre, presupuesto)
VALUES (11, "Calidad", 40000);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento)
VALUES ("12345678E", "Esther", "Vázquez", 11);


INSERT INTO departamentos(id_departamento, nombre, presupuesto)
VALUES (10, "Ventas", 100000);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento)
VALUES ("12345678A", "Michael", "Corleone", 10), ("12345678B", "Caperucita", "Roja", 10);

-- Aplicar a todos los departamentos un recorte del 10%
UPDATE departamentos set presupuesto = presupuesto * 0.9; 

-- Reasignar a los empleados del dept 11 al dept 10
UPDATE empleados set id_departamento = 11 where nombre = "Esther";

DELETE FROM empleados WHERE id_departamento = 11;

-- Despedir (= borrar de la tabla) a todos los empleados de departamentos
-- cuyo presupuesto supera los 60000
DELETE FROM empleados WHERE id_departamento IN (
	SELECT id_departamento FROM departamentos WHERE presupuesto > 60000);


