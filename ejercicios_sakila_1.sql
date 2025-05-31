-- Utiliza la base de datos sakila, disponible en MySQL Workbench,
-- para resolver estos ejercicios 
USE sakila;

-- 1) Actores que tienen el primer nombre "Gary"
SELECT first_name, last_name FROM actor
WHERE first_name = "Gary";

-- 2) Actores que tiene de primer apellido "Streep"
SELECT first_name, last_name FROM actor
WHERE last_name = "Streep";

-- 3) Actores que contengan una "o" en su nombre
SELECT first_name, last_name FROM actor
WHERE first_name LIKE "%O%";

-- 4) Actores que contengan una "a" en su nombre y una "e" en su apellido
SELECT first_name, last_name FROM actor
WHERE first_name LIKE "%A%" AND last_name LIKE "%E%";

-- 5) Actores que contengan dos "o" en su nombre (en cualquier posicion) y una "a" en su apellido
SELECT first_name, last_name FROM actor
WHERE first_name LIKE "%O%O%" AND last_name LIKE "%A%";

-- 6) Actores cuya tercera letra del nombre sea "b"
SELECT first_name, last_name FROM actor
WHERE first_name LIKE "__B%";

-- 7) Ciudades que empiezan por "a"
SELECT * FROM city
WHERE city LIKE "A%";

-- 8) Ciudades que acaban por "s"
SELECT * FROM city
WHERE city LIKE "%S";

-- 9) Ciudades del country "France"
SELECT ci.city, co.country
FROM city ci
JOIN country co ON ci.country_id = co.country_id
HAVING co.country = "France";

-- 10) Ciudades con nombres compuestos (como New York)
SELECT * FROM city
WHERE city LIKE "% %";

-- 11) películas con una duración entre 80 y 100 m.
SELECT * FROM film
WHERE length BETWEEN 80 AND 100;

-- 12) películas con un rental_rate entre 1 y 3
SELECT * FROM film
WHERE rental_rate BETWEEN 1 AND 3;

-- 13) películas con un título de más de 11 letras.
SELECT * FROM film
WHERE title LIKE "____________%";

-- 14) películas con un rating de PG o G.
SELECT * FROM film
WHERE rating = "PG" OR rating = "G";
 
--  15) ¿Cuantas ciudades tiene el country ‘France’? 
SELECT COUNT(*) AS "Cantidad de ciudades en Francia"
FROM city ci
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = "France";

-- 16) Películas que no tengan un rating de NC-17
SELECT title, rating FROM film
WHERE rating <> "NC-17";

-- 17) Películas con un rating PG y duración de más de 120.
SELECT title, length, rating FROM film
WHERE rating = "PG" AND length > 120;

-- 18) ¿Cuantos actores hay?
SELECT COUNT(*) AS Num_Actores
FROM actor;

-- 19) Película con mayor duración.
SELECT title, length FROM film
WHERE length = (SELECT MAX(length) FROM film);

-- 20) ¿Cuantos clientes viven en Indonesia?
SELECT COUNT(*) AS total_clientes_en_Indonesia
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Indonesia';

-- 21) Visualiza los 10 actores que han participado en más películas
-- (de mas a menos participaciones)
-- Mostrar nombre y apellido del actor, con la cantidad de películas ordenado de forma descendente 
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY cantidad_peliculas DESC
LIMIT 10;

-- 22) Visualiza los clientes de países que empiezan por S
-- Mostrar nombre y apellido, sin repeticiones 
SELECT DISTINCT c.first_name, c.last_name, co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country LIKE 'S%';

-- 23) Visualiza el top-10 de países con más clientes
-- Nombre de los paises y cantidad de clientes ordenado de forma descente por la cantidad
SELECT co.country, COUNT(c.customer_id) AS cantidad_clientes
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY cantidad_clientes DESC
LIMIT 10;

-- 24) Saca las 10 primeras películas alfabéticamente y el número de copias que se disponen de cada una de ellas
-- Mostrar el nombre la película y la cantidad de copias
SELECT f.title AS nombre_pelicula, COUNT(i.inventory_id) AS cantidad_copias
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title ASC
LIMIT 10;

-- 25 ¿ Cuántas películas ha alquilado Deborah Walker?
-- Mostrar Nombre y apellido del cliente y la cantidad de peliculas como "películas alquiladas"
SELECT c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS `películas alquiladas`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.first_name = 'Deborah' AND c.last_name = 'Walker'
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 26 devolverá nombre y apellido del cliente y el número de peliculas alquiladas contando cuantas veces se repite en la tabla de rental
SELECT c.first_name AS nombre_cliente, c.last_name AS apellido_cliente, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY peliculas_alquiladas DESC;