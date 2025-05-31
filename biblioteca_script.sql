/* Crea la base de datos si no existe */
CREATE DATABASE If NOT EXISTS biblioteca;
/* Borra la base de datos si existe */
-- DROP DATABASE IF EXISTS biblioteca;
USE biblioteca;
/* Crea la tabla si no existe */
CREATE TABLE IF NOT EXISTS libros (
id_libro int AUTO_INCREMENT NOT NULL PRIMARY KEY,
titulo_libro varchar(100) NOT NULL,
id_autor int NOT NULL,
editorial varchar(50) not null,
ejemplares_stock smallint 
);

INSERT INTO autores 
VALUES (1, "Jules", "Verne");

INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Isaac", "Asimov"), ("Stanislaw", "Lem");

INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Stephen", "King"); 

SELECT * FROM autores;
-- Obtener los nombres de los autores que empiecen por s
SELECT nombre_autor, apellido_autor
FROM autores
WHERE nombre_autor LIKE "S%";

-- Obtener los autores cyo nombre contiene 5 letras
SELECT nombre_autor, apellido_autor
FROM autores
WHERE nombre_autor LIKE "_____";

-- Contar cuantos autores hay
SELECT COUNT(*) AS "Cantidad de autores" FROM autores;


INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Pepe", "Vargas Llosa"); 

UPDATE autores SET nombre_autor = "Mario"
WHERE apellido_autor = "Vargas Llosa";

DELETE FROM autores WHERE apellido_autor = "Vargas Llosa";

-- Muestra los datos ordenados por apellido
SELECT apellido_autor, nombre_autor
FROM autores
ORDER BY apellido_autor;

-- Muestra los datos ordenados por apellido, pero limita a un resultado
SELECT apellido_autor, nombre_autor
FROM autores
ORDER BY apellido_autor
LIMIT 1;

-- Muestra los datos ordenados por apellido, concatenando 
SELECT CONCAT(apellido_autor,",", nombre_autor) AS autor
FROM autores
ORDER BY apellido_autor;

-- Muestra los datos ordenados por apellido, concatenando , separando por coma y con el apellido en mayusculas
SELECT CONCAT_WS(", ",UPPER(apellido_autor), nombre_autor) AS autor
FROM autores
ORDER BY apellido_autor;

DESCRIBE libros;

DESCRIBE autores_libros;

-- Borrar un campo de una tabla
ALTER TABLE libros
DROP COLUMN id_autor;

INSERT INTO libros (titulo_libro, editorial, ejemplares_stock)
VALUES ("La vuelta al mundo en 80 días", "Taurus", 5),
("De la tierra a la luna", "taurus", 3),
("Yo robot", "gredos", 3),
("Solaris", "Alfauara", 5);

INSERT INTO autores_libros (id_autor, id_libro) VALUES
(1, 1), (1, 2), (2, 3), (3, 4);

CREATE TABLE IF NOT EXISTS editoriales (
id_editorial int AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_editorial varchar(50) NOT NULL,
id_poblacion int NOT NULL
);

CREATE TABLE IF NOT EXISTS poblaciones (
id_poblacion int AUTO_INCREMENT NOT NULL PRIMARY KEY,
poblacion varchar(25)
);

-- Borrar un campo de una tabla
ALTER TABLE editoriales
DROP COLUMN id_poblacion;

-- Obtener solo las editoriales distintas de la tabla libros
SELECT DISTINCT editorial FROM libros;

-- Inserta las editoriales en la tabla editoriales
INSERT INTO editoriales(nombre_editorial)
SELECT DISTINCT editorial FROM libros;

-- Añadir la columna id_editorial a la tabla libros
ALTER TABLE libros
ADD COLUMN id_editorial int NOT NULL;

-- Inserto las editoriales en libros
UPDATE libros AS l, editoriales e
SET l.id_editorial = e.id_editorial
WHERE l.editorial = e.nombre_editorial;

-- Elimino la columna editorial
ALTER TABLE libros
DROP COLUMN editorial;

INSERT INTO poblaciones(poblacion) VALUES ("Barcelona"), ("Madrid"), ("Cornellà"), ("Paris");

ALTER TABLE editoriales
ADD COLUMN id_poblacion int NOT NULL;

SELECT SUM(ejemplares_stock) AS Stock_Total FROM libros;

-- Sistema simple, pero no recomendado
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l, editoriales e
WHERE l.id_editorial = e.id_editorial;

-- Sistema con un JOIN (Recomendado)
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
JOIN editoriales e
ON l.id_editorial = e.id_editorial;

-- Se puede hacer también asi porque se llaman igual id_editorial
SELECT l.titulo_libro, e.nombre_editorial
FROM libros l
NATURAL JOIN editoriales e;

-- De que poblacion son las editoriales
SELECT p.poblacion, e.nombre_editorial
FROM editoriales e
NATURAL JOIN poblaciones p;

-- Nombre del autor, titulo del libro, editorial, poblacion
SELECT a.nombre_autor, l.titulo_libro, e.nombre_editorial, p.poblacion
FROM autores a
NATURAL JOIN autores_libros
NATURAL JOIN libros l
NATURAL JOIN editoriales e
NATURAL JOIN poblaciones p;

SELECT a.nombre_autor, l.titulo_libro, e.nombre_editorial, p.poblacion
FROM autores a
JOIN autores_libros al
ON a.id_autor = al.id_autor
JOIN libros l 
ON l.id_libro = al.id_libro
JOIN editoriales e
ON e.id_editorial = l.id_editorial
JOIN poblaciones p 
ON p.id_poblacion = e.id_poblacion;

-- Nombre del autor que no tenga libros
SELECT a.nombre_autor, l.titulo_libro
FROM autores a 
LEFT JOIN autores_libros al
ON a.id_autor = al.id_autor
LEFT JOIN libros l 
ON l.id_libro = al.id_libro
WHERE l.titulo_libro IS NULL;

-- Poblaciones que no tienen editorial
SELECT p.poblacion
FROM poblaciones p 
LEFT JOIN editoriales e
ON p.id_poblacion = e.id_poblacion
WHERE e.nombre_editorial IS NULL;

CREATE TABLE usuarios (
id_usuario int NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_usuario varchar(20) NOT NULL,
apellido_usuario varchar(50) NOT NULL,
fecha_nacimiento date,
carnet_biblio int UNIQUE NOT NULL,
fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000 AS carnet;

INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
("Steve", "Jobs", "1955-02-24", FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000),
("Letizia", "Ortiz", "1968-06-30", FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000),
("Peter", "Parker", "2000-03-11", FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000),
("Clark", "Kent", "1989-09-11", FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000),
("Lois", "Lane", "1989-10-06", FLOOR(rand()*(99999999 - 10000000 + 1)) + 10000000);

CREATE TABLE prestamos (
id_prestamo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_usuario int NOT NULL,
id_libro int NOT NULL,
fecha_prestamo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_devolucion TIMESTAMP
);

INSERT INTO prestamos (id_usuario, id_libro) VALUES
(1,1), (1,2), (1,3), (2,1), (2,2), (3,1);



INSERT INTO prestamos (id_usuario, id_libro) VALUES
(4,4);

-- Obtener los préstamos de los libros prestados
SELECT l.titulo_libro, COUNT(p.id_libro) AS prestamos
FROM libros l 
NATURAL JOIN prestamos p 
GROUP BY p.id_libro;

-- Obtener los préstamos de los libros que solo esten prestados 1 vez
SELECT l.titulo_libro, COUNT(p.id_libro) AS prestamos
FROM libros l 
NATURAL JOIN prestamos p 
GROUP BY p.id_libro
HAVING prestamos = 1;


-- Obtener los préstamos de los libros que solo esten prestados 1 vez, sin que aparezca la columna del numero de prestamos
SELECT l.titulo_libro
FROM libros l 
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = 1;

-- Obtener los libros con menor cantidad de prestamos
SELECT l.titulo_libro
FROM libros l 
NATURAL JOIN prestamos p 
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (SELECT COUNT(p.id_libro) AS minima_cantidad
	FROM prestamos p 
	GROUP BY p.id_libro
	ORDER BY minima_cantidad ASC
	LIMIT 1);
    
    -- Crear las CONSTRAINT de claves foraneas
    ALTER TABLE editoriales
    ADD CONSTRAINT fk_poblaciones
    FOREIGN KEY (id_poblacion)
    REFERENCES poblaciones (id_poblacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
    -- Añadir columna a tabla autores
    ALTER TABLE autores
    ADD COLUMN id_epoca int NOT NULL;
    
    -- Crear tabla epoca
    CREATE TABLE epocas (
    id_epoca int PRIMARY KEY AUTO_INCREMENT,
    epoca varchar(20) NOT NULL    
    );
    
    -- Añado una epoca
    INSERT INTO epocas (epoca) VALUES ("Barroco");
    
    -- Añadir clave foranea en tabla autores
    ALTER TABLE autores
    ADD CONSTRAINT fk_epoca
    FOREIGN KEY (id_epoca)
    REFERENCES epocas(id_epoca)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
    