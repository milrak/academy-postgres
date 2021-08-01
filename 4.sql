-- criando coluna
alter table sale_item add column unit_price numeric;


--script para preencher o valor
do
$$
declare
	produto record;
	cmd_update varchar default '';
begin
	for produto in select * from product p where exists (select * from sale_item si where si.id_product=p.id)
	loop
	cmd_update := format ('update sale_item set unit_price=%s where id_product=%s ;', produto.sale_price, produto.id);
	execute cmd_update;
end loop;
end
$$

--trigger para preencher o campo em novas compras.
create or replace function fn_insert_unit_price_sale_item() returns trigger as
$$
begin
	new.unit_price := (select sale_price from product where id=new.id_product);
return new;
end
$$
language plpgsql;

-- vinculando gatinho
create trigger tg_insert_unit_price_sale_item
	alter insert on sale_item
	for each row
	execute function fn_insert_unit_price_sale_item();
