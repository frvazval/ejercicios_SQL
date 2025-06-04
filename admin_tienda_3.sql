use tienda;

select * from clientes;

insert into clientes (nombre_cliente, apellido_cliente) VALUE
("Pinocho", "Sin apellido");

-- Crear una función a la cual le indicamos el id_pais
-- y nos devolvera la cantidad de clientes de ese pais

drop function if exists clientes_pais;

delimiter $$
create function clientes_pais (p_id_pais int)
returns int
deterministic 
begin
	declare v_cantidad_clientes int;
	select count(id_pais) into v_cantidad_clientes
    from clientes where id_pais = p_id_pais group by id_pais;
    return v_cantidad_clientes;
end $$
delimiter ;

