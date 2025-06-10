-- EVALUACION PRACTICA

-- ALUMNO : Francisco Vázquez Valera
-- FECHA : 10/06/2025

/*
Los ejercicios se organizan en tres bloques, segun su dificultad.
Hay por tanto tres niveles de puntuacion: 0.25, 0.50 y 1.00 puntos.
La resolucion de cada ejercicio se valora siguiendo este criterio:

* Ejercicio perfectamente resuelto o con algun error no relevante: 100%.
* Ejercicio bien planteado pero no resuelto, con algun error importante 
* o varios errores leves, pero que no afecten a la comprension global del tema: 50%.
* Ejercicio no resuelto o con errores graves, que muestren falta de comprension
del tema : 0%.

Por tanto:

* un ejercicio bien resuelto del bloque 2 valdra : 0.50 x 100% = 0.50 puntos
* un ejercicio con algun error importante del bloque 3 valdra : 1.00 x 50% = 0.50 puntos

NOTA IMPORTANTE #1: No debes 'hardcodear' los ids, es decir, introducirlos a mano después de mirar las tablas. 
Si los necesitas, han de ser el resultado de alguna consulta.

NOTA IMPORTANTE #2 : Debe entregarse solo este fichero sin la base de datos y sin comprimir,
de este modo :  UF_1845_AP_TuNombre_TuAPellido.sql

*/



/*
EJERCICIO #1 : 0.25 puntos
Muestra solo las actrices (personas de profesión "actuación" de género "mujer").
Recuerda: sin hardcodear los ids.
Ha de aparecer apellido, nombre, fecha_nacimiento
Ordenadas por apellido y nombre, descendente 
*/
SELECT p.apellido, p.nombre, p.fecha_nacimiento FROM genero g 
NATURAL JOIN personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE pr.profesion = "actuacion" AND g.genero = "mujer"
ORDER BY p.apellido, p.nombre DESC;

/*
EJERCICIO #2 : 0.25 puntos
Muestra solo los personajes nacidos en el siglo XIX (piensa entre qué años).
Debe aparecer en la cabecera de la columna: nombre y apellido juntos como 'personajes nacidos en el siglo XIX'
ordenados por profesión y nombre ascendente.
*/
SELECT CONCAT_WS(" ", p.nombre, p.apellido) AS "personajes nacidos en el siglo XIX" FROM personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE p.fecha_nacimiento BETWEEN "1800" AND "1899"
ORDER BY pr.profesion, p.nombre ASC;

/*
EJERCICIO #3 : 0.25 puntos
Muestro solo la información del personaje dedicado a la música con la 
fecha de nacimiento más reciente. Todos los datos, excepto el id.
*/
SELECT p.nombre, p.apellido, pr.profesion, g.genero, p.oscars, p.fecha_nacimiento FROM genero g  
NATURAL JOIN personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE pr.profesion = "musica" AND p.fecha_nacimiento = (SELECT MAX(fecha_nacimiento) FROM personas);

/*
EJERCICIO #4 : 0.25 puntos
Personas dedicadas a la interpretación (de cualquier género) que únicamente han ganado un Óscar.
Ha de aparecer el nombre y el apellido combinados como 'actores que solo han ganado un oscar' y 
el género (hombre, mujer, ...).
Ordenados por apellido en forma ascendente.
*/
SELECT CONCAT_WS(" ", p.nombre, p.apellido) AS "actores que solo han ganado un oscar", g.genero FROM genero g 
NATURAL JOIN personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE pr.profesion = "actuacion" AND p.oscars = 1
ORDER BY p.apellido ASC;

/*
EJERCICIO #5 : 0.25 puntos
Muestra cuántos personajes no han ganado nunca un Óscar. 
Debe aparecer solo la cantidad de personajes.
*/
SELECT COUNT(*) AS "personajes que nunca han ganado un oscar" FROM personas
WHERE oscars = 0;

/*
EJERCICIO #6 : 0.25 puntos
Borra de la lista el personaje:  "Arthur Rubinstein"
*/
DELETE FROM personas
WHERE nombre = "Arthur" AND apellido = "Rubinstein";

/*
EJERCICIO #7: 0.25 puntos
El año de nacimiento de "John Williams" está mal, ya que debe ser 1932. Debes cambiarlo.
*/
UPDATE personas SET fecha_nacimiento = "1932"
WHERE nombre = "John" AND apellido = "Williams";

/*
EJERCICIO #8 : 0.25 puntos
Muestra que director que no ha ganado ningún Óscar es el que tiene la fecha de nacimiento más antigua.
Debe aparecer el nombre completo del director y su profesión, nada más.
*/
SELECT p.nombre, p.apellido, pr.profesion FROM personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE p.oscars = 0 AND pr.profesion = "direccion"
ORDER BY p.fecha_nacimiento ASC
LIMIT 1;

/*
EJERCICIO #9 : 0.50 puntos
Muestra sólo las personas dedicadas a la interpretación de género masculino nacidas entre 1920 y 1940
Ha de aparecer : nombre, apellido, profesión y la fecha de nacimiento como 'nacimiento'
Ordenado por la fecha de nacimiento en forma descendente.
*/
SELECT p.nombre, p.apellido, pr.profesion, p.fecha_nacimiento AS "nacimiento" FROM genero g 
NATURAL JOIN personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE pr.profesion = "actuacion" AND g.genero = "hombre" AND p.fecha_nacimiento BETWEEN "1920" AND "1940"
ORDER BY p.fecha_nacimiento ASC;

/*
EJERCICIO #10 : 0.50 puntos
Muestra los personajes que han ganado más Óscars (pero sólo esos).
Debe aparecer nombre, apellido y profesión
Ordenados por apellido descendente
*/
SELECT p.nombre, p.apellido, pr.profesion FROM personas p 
INNER JOIN profesion pr ON p.profesion = pr.id_profesion
WHERE p.oscars = (SELECT MAX(oscars) FROM personas)
ORDER BY p.apellido DESC;

/*
EJERCICIO #11 : 1.00 puntos
Crea una función llamada cantidad_personas_genero que, indicando un género, devuelva el número de personajes de cada género.
Por ejemplo, si se indica 'mujer', la función devolverá el número de mujeres.
Y la ejecutaremos así: cantidad_personas_genero('mujer');
Si se indica un genero que no existe, la función devolverá el texto "Género no encontrado".
Sería este caso: cantidad_personas_genero('alienígena');
*/
DROP FUNCTION IF EXISTS cantidad_personas_genero;
DELIMITER $$
CREATE FUNCTION cantidad_personas_genero(p_genero varchar(15))
RETURNS int
DETERMINISTIC
BEGIN
	DECLARE v_cantidad int;
    SELECT COUNT(*) INTO v_cantidad FROM genero g 
    NATURAL JOIN personas p
    WHERE g.genero = p_genero;

	IF v_cantidad = 0 THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "Género no encontrado";
	ELSE
		RETURN v_cantidad;
    END IF;
END $$
DELIMITER ;

SELECT cantidad_personas_genero("mujer");

SELECT cantidad_personas_genero("alienígena");

/*
EJERCICIO #12 : 1.00 puntos
Crea un procedimiento almacenado para añadir personajes a la base de datos.
Se llamará st_add_people 
Los parámetros serán : nombre, apellido, profesion, genero, oscars y fecha de nacimiento

Pruébalo con estos ejemplos:
st_poblar_bd('Groucho', 'Marx', 'actuacion', 'hombre', 1, 1980);
st_poblar_bd('Howard', 'Shore', 'musica', 'hombre', 1, 1946);

*/
DROP PROCEDURE IF EXISTS st_add_people;

DELIMITER $$
CREATE PROCEDURE st_add_people(
p_nombre varchar(20),
p_apellido varchar(30),
p_profesion varchar(25),
p_genero varchar(15),
p_oscars int,
p_fecha_nacimiento varchar(19)
)
BEGIN
	DECLARE v_id_profesion int;
    DECLARE v_id_genero int;
    
    SELECT id_profesion INTO v_id_profesion
    FROM profesion
    WHERE profesion = p_profesion;
    
    if v_id_profesion IS NULL THEN
		INSERT INTO profesion (profesion) VALUES (p_profesion);
        
        SELECT id_profesion INTO v_id_profesion
		FROM profesion
		WHERE profesion = p_profesion;
    END IF;
	
    SELECT id_genero INTO v_id_genero
    FROM genero
    WHERE genero = p_genero;
    
    if v_id_genero IS NULL THEN
		INSERT INTO genero (genero) VALUES (p_genero);
        
        SELECT id_genero INTO v_id_genero
		FROM genero
		WHERE genero = p_genero;
    END IF;
    
    INSERT INTO personas (nombre, apellido, profesion, id_genero, oscars, fecha_nacimiento)
    VALUES (p_nombre, p_apellido, v_id_profesion, v_id_genero, p_oscars, p_fecha_nacimiento);
    
END $$
DELIMITER ;

CALL st_add_people('Groucho', 'Marx', 'actuacion', 'hombre', 1, 1980);
CALL st_add_people('Howard', 'Shore', 'musica', 'hombre', 1, 1946);






