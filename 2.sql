--Crie um PIVOT TABLE para saber o total vendido por grupo de produto por mês referente a um determinado ano;


select * from crosstab(
$$
select pg.name,
ano.mes,
coalesce (sum(si.quantity) filter (where to_char(s.date, 'mm')::integer = ano.mes), 0) as total
from product_group pg
	inner join product p on p.id_product_group=pg.id
	inner join sale_item si on p.id=si.id_product
	inner join sale s on si.id_sale =s.id 
	cross join (select * from generate_series(1,12) mes) ano
where 
	date_part('year', s.date)= 2019
group by 1, 2
order by 1, 2
$$,
$$
	select * from generate_series(1,12) order by 1
$$) as (name varchar,
		JAN numeric,
		FEV numeric,
		MAR numeric,
		ABR numeric,
		MAI numeric,
		JUN numeric,
		JUL numeric,
		AGO numeric,
		SET_ numeric,
		OUT_ numeric,
		NOV numeric,
		DEZ numeric)
