create database directores_empleados;
use directores_empleados;

create table directores (
dni varchar(9) not null primary key,
nomapels varchar(255),
dnijefe varchar(9),
id_despacho int
);

create table despachos (
id_despacho int not null auto_increment primary key,
capacidad int
);

insert into directores values
("38888480P", "Peter Parker", "45588448L", 1), ("38554480O", "Bruce Wayne", "56788448L", 2), ("88888660P", "Clark Kent", "40088048L", 3), ("38888555M", "Selina Keyn", "45500048C", 2);

insert into directores values
("65678110P", "Mario Bros", "88888660P", 3), ("67778810P", "Mario Bros", "38554480O",4);

insert into directores values
("67895432N", "Lara Croft", null, 2);

insert into despachos (capacidad) values
(4), (2), (6), (10);

-- 1 Mostrar el DNI, nombre y apellidos de todos los directores.
select dni, nomapels from directores;

-- 2 Mostrar los datos de los directores que no tienen jefes.
select * from directores
where dnijefe is null;

-- 3 Mostrar el nombre y apellidos de cada director, junto con la capacidad del despacho en el que se
-- encuentra.
select nomapels, capacidad from directores
natural join despachos;

-- 4 Mostrar el número de directores que hay en cada despacho.
select count(*) as num_directores, id_despacho from directores
group by id_despacho;

-- 5 Mostrar los datos de los directores cuyos jefes no tienen jefes.
select * from directores
where dnijefe is null;

-- 6 Mostrar los nombres y apellidos de los directores junto con los de su jefe.
SELECT 
    d1.nomapels AS nombre_director,
    d2.nomapels AS nombre_jefe
FROM 
    directores d1
LEFT JOIN 
    directores d2 ON d1.dnijefe = d2.dni;

-- 7 Mostrar el número de despachos que están sobre utilizados.
SELECT d.id_despacho
FROM despachos d
WHERE d.capacidad < (SELECT count(*) FROM directores di WHERE d.id_despacho = di.id_despacho);

-- 8 Añadir un nuevo director llamado Paco Pérez, DNI 28301700, sin jefe, y situado en el despacho 124.
insert into directores values
("28301700K", "Paco Pérez", null, 124);

-- 9 Asignar a todos los empleados de apellido Pérez un nuevo jefe con DNI 74568521.
update directores set dnijefe = "7456521G"
where nomapels like "%Pérez";

-- 10 Despedir a todos los directores, excepto a los que no 8enen jefe.
delete from directores where dnijefe is not null; 