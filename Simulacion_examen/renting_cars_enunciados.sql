use renting_cars2;

# Quitar temporalmente la restricción de consultas y evitar error 1055
# SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

-- max(), min(), count(), sum(), avg()

-- 1. ¿Cuál es el modelo (o modelos) más caro y su precio? ¿Y los más baratos?
-- 1a. El más caro
SELECT nombre_modelo, precioDia
FROM modelos
WHERE precioDia = (SELECT MAX(precioDia) FROM modelos);

-- 1b. El más barato
SELECT nombre_modelo, precioDia
FROM modelos
WHERE precioDia = (SELECT MIN(precioDia) FROM modelos);


-- 2. ¿Quien fue el primer cliente de la empresa?
-- nombre, apellido, tipo, fecha
select c.nombre, c.apellido, m.tipo, m.nombre_modelo, a.fecha_recogida from clientes c 
inner join alquileres a 
on a.id_cliente = c.id_cliente
natural join modelos m
where a.fecha_recogida = (SELECT MIN(fecha_recogida) FROM alquileres);




-- Antes actualizamos la tabla de alquileres con la facturación correcta
select (datediff(a.fecha_entrega, a.fecha_recogida) + 1) * m.precioDia, id_alquiler 
from alquileres a
natural join modelos m;

update alquileres a natural join modelos m
set facturacion = (datediff(a.fecha_entrega, a.fecha_recogida) + 1) * m.precioDia;

-- 4. Facturación total de 2024 por clientes
-- Nota: se cobra en el momento de la devolución
select sum(facturacion) from alquileres where year(fecha_entrega) = "2024";





-- 6. ¿Cuanto ha gastado cada cliente en cada alquiler? ¿Y cuanto ha gastado en total?
# 6A. En cada alquiler
select concat_ws(" ", c.nombre, c.apellido) as cliente, a.facturacion
from clientes c 
natural join alquileres a;

# 6B. En total
select concat_ws(" ", c.nombre, c.apellido) as cliente, sum(a.facturacion) as total
from clientes c 
natural join alquileres a
group by a.id_cliente;

-- 7. Queremos que aparezcan estos mensajes:
-- -- si ha gastado más de 4000 -> "muy buen cliente"
-- -- si ha gastado más de 2000 -> "buen cliente"
-- -- si ha gastado más de 1000 -> "cliente medio"
-- -- si ha gastado igual o menos de 1000 -> "factura poco"
select concat_ws(" ", c.nombre, c.apellido) as cliente,
case
	when sum(a.facturacion) > 4000 then "muy buen cliente"
    when sum(a.facturacion) > 2000 then "buen cliente"
    when sum(a.facturacion) > 1000 then "cliente medio"
    else "factura poco"    
end as valoración
from clientes c 
natural join alquileres a
group by a.id_cliente;

-- 8. Mostrar nombre de cliente, y el importe total gastado
-- Ordenado por importe de más a menos



-- 9. Mostrar nombre de cliente, dias de alquiler, marca, modelo, importe gastado, nombre del concesionario
-- Ordenado por importe de más a menos


-- 10. Tenemos un nuevo cliente, con estos datos:
--  Steve Ballmer, dni y carnet 666666666, email steve@ballmer.com, teléfono 666666666, vive en Roma, password 1234
-- Hay que obtener el id del pais mediante un select, no ponerlo directamente


-- 11. ¿Qué clientes no han alquilado nunca un vehículo?
select c.nombre
from clientes c 
left join alquileres a on c.id_cliente = a.id_cliente
where a.id_cliente is null;

-- 12. Crea un SP (llamado cars_no_rent) para mostrar los modelos que no se han alquilado nunca.

-- 13. Crea una función (llamada count_city) que, dado el nombre de una población 
-- nos devuelva el número de clientes que viven en esa población.

-- 14. Crea un SP (llamado miising_information) que devuelva el nombre y apellidos de 
-- los clientes que no tienen todos los datos completos (dni, email, teléfono, población, password).
-- Solo con que falte uno de estos datos ya deben aparecer en la lista