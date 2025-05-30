create database hospitales;
use hospitales;
CREATE TABLE temple1 ( nuempl CHAR(6) NOT
NULL, nombre CHAR(12) NOT NULL,
inicial CHAR(1) NOT NULL, apellido
CHAR(15) NOT NULL, dept CHAR(3)
NOT NULL, tlfn CHAR(4), feching
DATE NOT NULL, codtra SMALLINT
NOT NULL, niveduc SMALLINT NOT
NULL, sexo CHAR(1) NOT NULL,
fechnac DATE NOT NULL, salario
DECIMAL(9,2) NOT NULL );

CREATE TABLE tdepar2 ( numdep CHAR(3)
NOT NULL, nomdep CHAR(36)
NOT NULL, numdirec CHAR(6)
NOT NULL);

-- 1 Obtener una lista de todas las empleadas de los departamentos que empiecen por D o por E. La
-- lista anterior debe contener información sobre el número de personal, nombre, apellido y
-- número de teléfono.
SELECT 
    t.nuempl AS NumeroPersonal,
    t.nombre AS Nombre,
    t.apellido AS Apellido,
    t.tlfn AS Telefono
FROM 
    temple1 t
JOIN 
    tdepar2 d ON t.dept = d.numdep
WHERE 
    t.sexo = 'F'
    AND (d.nomdep LIKE 'D%' OR d.nomdep LIKE 'E%');
    
-- 2 Obtener un listado de todos los empleados (nombre y apellido) que ganan más de 2000 Bs al mes
-- y que entraron en la compañía después del 1 de Enero de 1975. También se quiere la información
-- correspondiente a su código de trabajo y al número de personal de sus directores.
SELECT 
    e.nombre,
    e.apellido,
    e.codtra,
    d.nuempl AS NumeroPersonalDirector
FROM 
    temple1 e
LEFT JOIN 
    temple1 d ON e.codtra = d.nuempl
WHERE 
    e.salario > 2000
    AND e.feching > '1975-01-01';
    
-- 3 Obtener una lista con el apellido, número de departamento y salario mensual de los empleados
-- de los departamentos ‘A00’, ‘B01’, ‘C01’ y ‘D01’. La salida se quiere en orden descendente de
-- salario dentro de cada departamento.
SELECT 
    apellido,
    dept AS NumeroDepartamento,
    salario
FROM 
    temple1
WHERE 
    dept IN ('A00', 'B01', 'C01', 'D01')
ORDER BY 
    dept ASC,
    salario DESC;
    
-- 4 Se pide una lista que recupere el salario medio de cada departamento junto con el número de
-- empleados que 8ene. El resultado no debe incluir empleados que tengan un código de trabajo
-- mayor que 54, ni departamentos con menos de tres empleados. Se quiere ordenada por número
-- de departamento.
SELECT 
    dept AS NumeroDepartamento,
    AVG(salario) AS SalarioMedio,
    COUNT(*) AS NumeroEmpleados
FROM 
    temple1
WHERE 
    codtra <= 54
GROUP BY 
    dept
HAVING 
    COUNT(*) >= 3
ORDER BY 
    dept;
   
-- 5 Seleccionar todos los empleados de los departamentos ‘D11’ y ‘E11’ cuyo primer apellido empiece
-- por S.
SELECT *
FROM temple1
WHERE 
    dept IN ('D11', 'E11')
    AND apellido LIKE 'S%';
    
-- 6 Obtener el nombre, apellido y fecha de ingreso de los directores de departamento ordenados por
-- número de personal.
SELECT 
    t.nombre,
    t.apellido,
    t.feching
FROM 
    temple1 t
JOIN 
    tdepar2 d ON t.nuempl = d.numdirec
ORDER BY 
    t.nuempl;
    
-- 7 Obtener un listado de las mujeres de los departamentos que empiecen por D y por E cuyo nivel
-- ación sea superior a la media; en este caso también ordenados por número de personal.
SELECT 
    t.*
FROM 
    temple1 t
JOIN 
    tdepar2 d ON t.dept = d.numdep
WHERE 
    t.sexo = 'F'
    AND (d.nomdep LIKE 'D%' OR d.nomdep LIKE 'E%')
    AND t.niveduc > (
        SELECT AVG(niveduc) FROM temple1
    )
ORDER BY 
    t.nuempl;
    
-- 8 Seleccionar todos los empleados cuyo nombre sea igual al de algunas personas del departamento
-- D21 y cuyo código de trabajo sea diferente de todos los del E21 (la lista debe contener el número
-- de personal, nombre, apellido, departamento y código de trabajo).
SELECT 
    e.nuempl,
    e.nombre,
    e.apellido,
    e.dept,
    e.codtra
FROM 
    temple1 e
WHERE 
    e.nombre IN (
        SELECT nombre FROM temple1 WHERE dept = 'D21'
    )
    AND e.codtra NOT IN (
        SELECT codtra FROM temple1 WHERE dept = 'E21'
    );

-- 9 Listar los empleados que no sean directores (la información que debe aparecer es el número de
-- personal, apellido y departamento).
SELECT 
    nuempl,
    apellido,
    dept
FROM 
    temple1
WHERE 
    nuempl NOT IN (SELECT numdirec FROM tdepar2);
    
-- 10 Seleccionar parejas de empleados (de sexo opuesto) que hayan nacido el mismo día (con
-- información acerca de apellido y fecha de nacimiento).
SELECT 
    e1.apellido AS Apellido1,
    e1.fechnac AS FechaNacimiento,
    e2.apellido AS Apellido2
FROM 
    temple1 e1
JOIN 
    temple1 e2 ON e1.fechnac = e2.fechnac
               AND e1.sexo <> e2.sexo
               AND e1.nuempl < e2.nuempl;

-- 11 Obtener un listado de todos los empleados que pertenecen al mismo departamento que Tomás
-- Soler.
SELECT 
    nuempl,
    nombre,
    apellido,
    dept
FROM 
    temple1
WHERE 
    dept = (
        SELECT dept 
        FROM temple1 
        WHERE nombre = 'Tomás' AND apellido = 'Soler'
        LIMIT 1
    );

    


