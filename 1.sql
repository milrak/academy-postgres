-- Alterando o nome da tabela sale
alter table sale rename to sale_bk;

drop table sale;


-- Ciando nova tabela com range
CREATE TABLE sale (
	id serial NOT NULL,
	id_customer int4 NOT NULL,
	id_branch int4 NOT NULL,
	id_employee int4 NOT NULL,
	"date" timestamp(6) NOT NULL,
	created_at timestamp NOT NULL DEFAULT now(),
	modified_at timestamp NOT NULL DEFAULT now(),
	active bool NOT NULL DEFAULT true
) partition by range(date);

-- Devolvendo as foreign keys da tabela 
ALTER TABLE public.sale ADD CONSTRAINT fk_sale_branch FOREIGN KEY (id_branch) REFERENCES public.branch(id);
ALTER TABLE public.sale ADD CONSTRAINT fk_sale_customer FOREIGN KEY (id_customer) REFERENCES public.customer(id);
ALTER TABLE public.sale ADD CONSTRAINT fk_sale_employee FOREIGN KEY (id_employee) REFERENCES public.employee(id);


-- Limite inferiro de "date" em sale_bk
select min(date) from sale_bk s  -- 1970-01-03 06:34:24

-- Limite superior de "date" em sale_bk
select max(date) from sale_bk s  -- 2021-01-13 14:20:19

-- Criando tabelas de ranger
do
$$
declare
	ano integer;
	cmd_create varchar default '';
begin
	for ano in 1970..2021 loop
		cmd_create := format('create table sale_%s partition of sale for values from (%s) to (%s);',
			ano,
			quote_literal(concat(ano,'-01-01 00:00:00')),
			quote_literal(concat(ano, '-12-31 23:59:59.999999')));
			execute cmd_create;
	end loop;
end	
$$
-- Passando informações de sale_bk para sale
do
$$
declare 
	consulta record;
begin 
	for consulta in select * from sale_bk loop
		INSERT INTO sale
			(id, id_customer, id_branch, id_employee, "date", created_at, modified_at, active)
			VALUES(consulta.id, consulta.id_customer, consulta.id_branch, consulta.id_employee,
				consulta.date, consulta.created_at, consulta.modified_at, consulta.active);
	end loop;
end
$$

-- Resultado
select * from sale;


