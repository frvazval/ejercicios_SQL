CREATE DATABASE almacenes;
use almacenes;

CREATE TABLE almacenes (
id_almacen int not null primary key auto_increment,
lugar varchar(100) not null,
capacidad int not null
);

CREATE TABLE cajas (
num_referencia varchar(5) not null primary key,
contenido varchar(100) not null, 
valor decimal(6,2) not null,
id_almacen int not null
);

INSERT INTO almacenes(lugar, capacidad) VALUES ('Barcelona', 100), ('Cornellà', 5), ('Hospitalet', 20), ('Badalona', 3);
INSERT INTO CAJAS (num_referencia, contenido, valor, id_almacen) VALUES
('TECL1', "teclados", 100, 1),('RAT1', "ratones", 200, 2),('TECL2', "teclados", 100, 4),('RAT2', "ratones", 200, 4);


-- 1
SELECT * FROM almacenes;

-- 2
SELECT * FROM cajas WHERE valor > 150;

-- 3
SELECT distinct contenido FROM cajas;

-- 4
SELECT AVG(valor) FROM cajas;

-- 5
SELECT id_almacen, AVG(valor)
FROM cajas
GROUP BY id_almacen;

-- 6
SELECT id_almacen, AVG(valor)
FROM cajas
GROUP BY id_almacen
HAVING AVG(valor) > 150;

-- 7
SELECT c.num_referencia, a.lugar
FROM almacenes a
natural join cajas c;

-- 8
SELECT id_almacen, COUNT(id_almacen)
FROM cajas
GROUP BY id_almacen;

SELECT a.id_almacen, COUNT(a.id_almacen)
FROM almacenes a
LEFT JOIN cajas c
ON a.id_almacen = c.id_almacen
GROUP BY a.id_almacen;

-- 9 Obtener los códigos de los almacenes que están saturados (los almacenes donde el número de cajas es superior a la capacidad).
SELECT a.id_almacen
FROM almacenes a
WHERE a.capacidad < (SELECT count(*) FROM cajas c WHERE a.id_almacen = c.id_almacen);

-- 10 Obtener los números de referencia de las cajas que están en Badalona
SELECT num_referencia FROM cajas 
NATURAL JOIN almacenes
WHERE lugar = "Badalona";

-- 11 Insertar un nuevo almacén en Bilbao con capacidad para 3 cajas.
INSERT INTO almacenes (lugar, capacidad)
VALUES ("Bilbao",3);

-- 12 Insertar una nueva caja, con número de referencia ‘H5RT’, con contenido ‘Papel’, valor 200, y situada en el almacén 2.
INSERT INTO cajas (num_referencia, contenido, valor, id_almacen)
VALUES ('H5RT', 'Papel', 200, 2);

-- 13 Rebajar el valor de todas las cajas un 15 %.
UPDATE cajas SET valor = valor * .85;

-- 14 Rebajar un 20 % el valor de todas las cajas cuyo valor sea superior al valor medio de todas las cajas.
SET @promedio = (SELECT AVG(valor) FROM cajas);

UPDATE cajas SET valor = valor * 0.80
WHERE valor > @promedio;

-- 15 Eliminar todas las cajas cuyo valor sea inferior a 100 Bs.
DELETE FROM cajas WHERE valor < 100;

-- 16 Vaciar el contenido de los almacenes que están saturados.

DELETE c
FROM cajas c
JOIN (
    SELECT a.id_almacen
    FROM almacenes a
    JOIN cajas cc ON a.id_almacen = cc.id_almacen
    GROUP BY a.id_almacen, a.capacidad
    HAVING a.capacidad < COUNT(cc.id_almacen)
) AS sub ON c.id_almacen = sub.id_almacen;


