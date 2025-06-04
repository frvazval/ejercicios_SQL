use tienda;

select * from clientes;

insert into clientes (nombre_cliente, apellido_cliente) VALUE
("Pinocho", "Sin apellido");

-- Crear una función a la cual le indicamos el id_pais
-- y nos devolvera la cantidad de clientes de ese pais

delimiter $$


delimiter ;