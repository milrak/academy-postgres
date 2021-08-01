-- criando coluna
alter table sale add column total_price numeric;

-- consulta que trás o total da compra, por compra.
select s.id, sum(si.quantity*si.unit_price) from sale s 
inner join sale_item si on s.id =si.id_sale
group by 1


--script para preencher o valor
do
$$
declare 
	venda record;
	cmd_update varchar default '';
begin
	for venda in 
	select s.id, sum(si.quantity*si.unit_price) as valor_total from sale s 
		inner join sale_item si on s.id =si.id_sale
	group by 1
	loop
	cmd_update := format ('update sale set total_price=%s where id=%s ;', venda.valor_total, venda.id);
	execute cmd_update;
end loop;
end
$$

--trigger para preencher o campo de valor total da compra.
create or replace function fn_insert_total_price_sale() returns trigger as 
$$
begin
	update sale set total_price=(select sum(quantity*unit_price) from sale_item where id_sale=new.id_sale ) where id=new.id_sale;
return new;
end
$$
language plpgsql;


-- vinculando gatinho
create trigger tg_insert_total_price_sale
	after insert or update or delete on sale_item 
	for each row
	execute function fn_insert_total_price_sale();


	
