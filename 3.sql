-- Crie um PIVOT TABLE para saber o total de clientes por bairro e zona;

select * from crosstab(
$$
select d.name,
z.name, 
count(c.id) filter (where z.id = d.id_zone )
from public.district d
    inner join public.customer c on d.id = c.id_district
    cross join public.zone z 
group by 1,2
order by 1,2
$$,
$$
    select name from public.zone
$$
) as (name varchar, Norte varchar, Sul varchar, Leste varchar, Oeste varchar)