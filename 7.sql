	
insert into pessoa(nome, cpf, telefone, data_nascimento, endereco) 
 select name, cpf, tel, nasc, endereco from dblink('dbname=sale port=5432 hostaddr=127.0.0.1 user=postgres password=admin', $$
	select name, substring((random()*id)::varchar,1,11) as cpf, lpad (id::varchar, 11, '9') as tel, now() as nasc, 'Endereço-c' as endereco  from customer c 
	union
	select name, substring((random()*id)::varchar,1,11) as cpf, rpad (id::varchar, 11, '9') as tel, birth_date as nasc , 'Endereço-e' as endereco from employee e 
$$) as (name varchar, cpf varchar, tel varchar, nasc date, endereco varchar);


