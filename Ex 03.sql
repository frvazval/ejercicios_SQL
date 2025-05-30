CREATE DATABASE peliculas;
use peliculas;

CREATE TABLE salas (
id_sala int not null auto_increment primary key,
id_pelicula int not null,
nombre_sala varchar(100) not null
);

create table peliculas (
id_pelicula int not null auto_increment primary key,
titulo_pelicula varchar(100) not null,
calificacion_edad int
);

insert into peliculas (titulo_pelicula, calificacion_edad)
values ("Batman", 12), ("Bambi", 18), ("Tiburon", 6), ("El Conclave", 12);
 
 
 insert into salas (id_pelicula, nombre_sala)
 values (1,"Stucom"), (3,"SQL"), (4,"Vaticano");
 
 -- 1 Mostrar el nombre de todas las películas.
 SELECT titulo_pelicula FROM peliculas;
 
 -- 2 Mostrar las dis8ntas calificaciones de edad que existen.
 select distinct calificacion_edad from peliculas;
 
 -- 3 Mostrar todas las películas que no han sido calificadas.
 insert into peliculas (titulo_pelicula, calificacion_edad)
 values ("Shreck", null), ("Scream", null);

select titulo_pelicula from peliculas
where calificacion_edad is null;

-- 4 Mostrar todas las salas que no proyectan ninguna película.

alter table salas modify id_pelicula int;

insert into salas (id_pelicula, nombre_sala)
values (null,"HTML"), (null,"PHP");

select nombre_sala from salas
where id_pelicula is null;

-- 5 Mostrar la información de todas las salas y, si se proyecta alguna película en la sala, mostrar
-- también la información de la película.
select nombre_sala, titulo_pelicula from salas s
left join peliculas p
on s.id_pelicula = p.id_pelicula;

-- 5b Mostrar el nombre de todas las salas y si se proyecta alguna pelicula
-- mostrar tambien el titulo de la pelicula.
select s.nombre_sala, ifnull(p.titulo_pelicula, "No hay pelicula todavia")
from salas s
left join peliculas p
on s.id_pelicula = p.id_pelicula;


-- 6 Mostrar la información de todas las películas y, si se proyecta en alguna sala, mostrar también la
-- información de la sala.
select * from peliculas p
left join salas s
on p.id_pelicula = s.id_pelicula;

-- 7 Mostrar los nombres de las películas que no se proyectan en ninguna sala.
select titulo_pelicula from peliculas p
left join salas s
on p.id_pelicula = s.id_pelicula
where id_sala is null;

-- 8 Añadir una nueva pelıcula ‘Uno, Dos, Tres’, para mayores de 7 años.
-- Y después hacer que se proyecte al menos en 4 salas.
insert into peliculas (titulo_pelicula, calificacion_edad)
values ("Uno, Dos, Tres", 7);

set @id_123 = (select id_pelicula from peliculas where titulo_pelicula = "uno, Dos, Tres");
select @id_123;

insert into salas (nombre_sala, id_pelicula)
values ("Girona", @id_123), ("Javascript", @id_123), ("Python", @id_123), ("Barcelona", @id_123);

-- Titulo de la pelicula y el numero de veces que esta proyectada
select titulo_pelicula, count(s.id_pelicula) as cantidad,
	case
		when count(s.id_pelicula) > 3 then "Pelicula muy popular"
        when count(s.id_pelicula) > 0 then "Bastante conocida"
        else "No la ha visto nadie"
	end as popularidad
from salas s
right join peliculas p
on p.id_pelicula = s.id_pelicula
group by titulo_pelicula
order by cantidad desc;

-- 9 Hacer constar que todas las películas no calificadas han sido calificadas ‘no recomendables para
-- menores de 13 años’.
update peliculas set calificacion_edad = 13
where calificacion_edad is null;

-- 10 Eliminar todas las salas que proyectan películas recomendadas para todos los públicos.
delete from salas where id_pelicula in
(select id_pelicula from peliculas where calificacion_edad < 12);


