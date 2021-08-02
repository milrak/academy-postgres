-- Criando base de dados
create database crime;

-- Criando estrutura
create table pessoa(
	id serial not null,
	nome varchar(104) not null,
	cpf varchar(11) not null,
	telefone varchar(11) not null,
	data_nascimento date not null,
	endereco varchar(256) not null,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_pessoa primary key(id),
	constraint ak_pessoa_cpf unique (cpf)
);

create table tipo_crime (
	id serial not null,
	nome varchar(104) not null,
	tempo_minimo_prisao smallint,
	tempo_maximo_prisao smallint,
	tempo_prescricao smallint,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_tipo_crime primary key(id),
	constraint ak_tipo_crime_nome unique (nome)
);

create table arma (
	id serial not null,
	numero_serie varchar(104),
	descricao varchar(256) not null,
	tipo varchar (1) not null,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_arma primary key(id)
);

create table crime (
	id serial not null,
	id_tipo_crime integer not null,
	data timestamp not null,
	local varchar(256) not null,
	observacao text,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime primary key(id),
	constraint fk_crime_tipo_crime foreign key (id_tipo_crime) references tipo_crime(id)
);

create table crime_arma(
	id serial not null,
	id_arma integer not null,
	id_crime integer not null,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime_arma primary key(id),
	constraint ak_crime_arma unique (id_arma, id_crime),
	constraint fk_crime_arma_arma foreign key (id_arma) references arma(id),
	constraint tk_crime_arma_crime foreign key (id_crime) references crime(id)
);

create table crime_pessoa(
	id serial not null,
	id_pessoa integer not null,
	id_crime integer not null,
	tipo varchar(1) not null,
	ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime_pessoa primary key(id),
	constraint ak_pessoa_crime unique (id_pessoa, id_crime),
	constraint fk_crime_pessoa_pessoa foreign key (id_pessoa) references pessoa(id),
	constraint tk_crime_pesoa_crime foreign key (id_crime) references crime(id)
);

-- Script para gerar armas.

--Ativando extensão
create extension if not exists "uuid-ossp";


do
$$
declare
	contador integer;
	cmd_insert varchar default '';
	fogo varchar[] default array['Pistola', 'Metralhadora', 'Escopeta'];
	branca varchar[] default array['Faca', 'Facão', 'Estilete'];
	outros varchar[] default array['Corda', 'Garrafa'];
	arma integer;
begin
	for contador in 1..1000 loop
	
		cmd_insert := format('insert into arma (numero_serie, descricao, tipo) values (%s, ',
			quote_literal(uuid_generate_v4())
		);
			
		case (random()*2)::int 
			when 0 then
				arma := floor(random()*(array_length(fogo,1)-1+1))+1;
				cmd_insert := concat(cmd_insert, format(' %s, 0);', quote_literal(concat(fogo[arma], '_', contador))));
			when 1 then
				arma := floor(random()*(array_length(branca,1)-1+1))+1;
				cmd_insert := concat(cmd_insert, format(' %s, 1);', quote_literal(concat(branca[arma], '_', contador))));
			else
				arma := floor(random()*(array_length(outros,1)-1+1))+1;
				cmd_insert := concat(cmd_insert, format(' %s, 2);', quote_literal(concat(outros[arma], '_', contador))));
		end case;

		execute cmd_insert;
	end loop;
end
$$


--teste
select * from arma




