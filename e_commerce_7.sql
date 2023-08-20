create database ecommerce_7;
use ecommerce_7;
-- drop database ecommerce_7;
-- criar tabela cliente

create table cliente(
idCliente int auto_increment primary key,
PNome varchar(10),
SNome char(3),
UNome varchar(20),
CPF char(11) not null,
Endereço varchar(200),
constraint unique_cpf_cliente unique (CPF));

alter table cliente auto_increment = 1;

insert into cliente (PNome, SNome, UNome, CPF, Endereço)
values ('Nolan', 'K', 'Morgan', 123467809, 'rua Klinton 29, New York - Street Flowers'),
       ('JOSH', 'O', 'Glover', 0007654321, 'rua Cloud 89, New Jersey - Fift Avenue'),
       ('Mark', 'F', 'Klot', 11178913, 'Avenue Jersey 1009, Center - Kansas City'),
       ('Justin', 'S', 'Spark', 983124546, 'Rua P 81, Center - Park 2'),
       ('Tea', 'G', 'Brigthon', 06945897, 'Street Five, Center - Texas'),
       ('Bela', 'M', 'Creed', 6540789123, 'Street One 28, Center - San Francisco');

select * from cliente;

-- criar tabela produto

create table produto(
idProduto int auto_increment primary key,
Pname varchar (50) not null,
categoria enum ('Eletronico', 'Vestimenta', 'Brinquedo', 'Alimento', 'Movéis') not null, 
avaliacao float default 0,
dimensao varchar(10));
 
 alter table produto auto_increment = 1;
 
 insert into produto (PName, categoria, avaliacao, dimensao)
values ('SmartTV', 'Eletrônico', '4', null),
       ('Smartphone', 'Eletrônico', '2', null),
       ('Panela', 'Doméstico', '7', null),
       ('Notebook', 'Eletrônico', '4', null),
       ('Jogo de talheres', 'Domésticos', '1', null);
       
select * from produto;

-- criar tabela pedido


create table pedido(
idPedido int auto_increment primary key,
id_pedido_cliente int,
Status_pedido enum ('Cancelado', 'Confirmado', 'Em Processamento') default 'Em Processamento',
Descricao_pedido varchar (255),
Frete float default 10,
constraint fk_pedido_clientes foreign key (id_pedido_cliente) references cliente(idCliente));


-- delete from pedido where id_pedido_cliente in (1, 2, 3, 4);
insert into pedido (id_pedido_cliente, Status_pedido, Descricao_pedido, Frete)
values (1, default,'Compra via aplicativo', null),
       (2, default, 'Compra via aplicativo', 50),
       (3, 'Confirmado', 'Notebook', null),
       (4, default,'Compra via Web Site', 150);
       
 select * from pedido;
 
-- criar tabela de estoque

create table estoque(
idEstoque int auto_increment primary key,
local_estoque varchar(255),
quantidade int default 0);

insert into estoque (local_estoque, quantidade) values
('Bahia' ,900),
('Minas Gerais' ,1500),
('Rio de Janeiro' ,101),
('São Paulo' ,160),
('São Paulo' ,13),
('Brasília' , 600);

select * from estoque;
-- criar tabela fornecedor

create table fornecedor(
idFornecedor int auto_increment primary key,
Razao_social varchar(255) not null,
CNPJ char(15) not null unique,
Contato varchar(11) not null);

insert into fornecedor (Razao_social, CNPJ, Contato) values
('Acme', 000456789123456, 3499985474),
('Eletric Tech', 969619649143457, 2147985484),
('Tech', 321548893934695, 31960074);
select * from fornecedor;
-- criar tabela vendedor

drop table vendedor;
create table vendedor(
idVendedor int auto_increment primary key,
nome_social varchar (255) not null,
CNPJ char(15) unique,
CPF char (9) unique,
contato char (11) not null);

insert into vendedor (nome_social, CNPJ, CPF, contato) values
('Tech Driver', 87898787456321, null, 218878287),
('Boston Tech', null, 178965432, 213214595),
('Master Tech', 45678102457896, null, 2154657884);

create table produto_vendedor(
idPvendedor int,
idPproduto int,
prod_quantidade int default 0,
primary key (idPvendedor, idPproduto),
constraint fk_produto_vendedor foreign key (idPvendedor) references vendedor (idVendedor),
constraint fk_produto_produto foreign key (idPproduto) references produto (idProduto));

insert into produto_vendedor (idPvendedor, idPproduto, prod_quantidade) values
(1, 1, 900),
(1, 2, 490),
(2, 4, 983),
(3, 3, 5),
(2, 5, 10);

create table produto_pedido(
idPOpedido int,
idPOproduto int,
po_quantidade int default 1,
po_status enum ('Disponível' ,'Sem estoque') default 'Disponível',
primary key (idPOpedido, idPOproduto),
constraint fk_produto_pedido foreign key (idPOpedido) references pedido (idPedido),
constraint fk_produto_produto_pedido foreign key (idPOproduto) references produto (idProduto));

insert into produto_pedido (idPOpedido, idPOproduto, po_quantidade, po_status)
values (1, 1, 2, null),
       (2, 1, 1, null),
       (3, 2, 1, null);  

create table localidade_estoque(
idLestoque int,
idLproduto int,
localidade varchar (255) not null,
primary key (idLestoque, idLproduto),
constraint fk_produto_estoque_pedido foreign key (idLestoque) references estoque (idEstoque),
constraint fk_produto_estoque_produto foreign key (idLproduto) references produto (idProduto));

insert into localidade_estoque (idLestoque, idLproduto, localidade) values
(1, 2, 'MG'),
(2, 5, 'DF');

create table produto_fornecedor(
idPFornecedor int,
idPFproduto int,
quantidade int not null,
primary key (idPFornecedor, idPFproduto),
constraint fk_produto_fornecedor foreign key (idPFornecedor) references fornecedor (idFornecedor),
constraint fk_produto_fornecedor_produto foreign key (idPFproduto) references produto (idProduto));

insert into produto_fornecedor(idPFornecedor, idPFproduto, quantidade) values
(1, 2, 10),
(2, 4, 10);
 
show tables;

-- inserindo informações

select count(*) from cliente;
select * from cliente;
select * from pedido;

select concat(PNome, ' ', UNome) as nome_completo, count(*) as total_pedido, CPF, Status_pedido, Frete from cliente c, pedido p where c.idCliente = p.idPedido
group by P.idPedido;

select * from estoque e ; 

select sum(quantidade) as total_estoque, max(quantidade) as max_estoque, min(quantidade) as min_estoque, round(avg(quantidade),2) as media_estoque from estoque;

select * from estoque e, localidade_estoque l where  e.idEstoque = l.idLestoque;

select * from vendedor;
select * from fornecedor;

select nome_social from vendedor v, fornecedor f where idFornecedor = idVendedor;

select * from fornecedor f
inner join  produto p on f.idFornecedor = p.idProduto;
