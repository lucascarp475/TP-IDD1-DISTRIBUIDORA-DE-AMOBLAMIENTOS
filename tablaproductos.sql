create database TPBDI;

create table PRODUCTO (
ID_PRODUCTO int identity (1,1) primary key,
NOMBRE varchar (25),
CATEGORIA varchar (25),
MARCA varchar (25),
DESCRIPCION varchar (30),
PRECIO_UNITARIO int,
constraint chk_categoria check (CATEGORIA in ('COCINA','PLACARD','ELECTRODOMESTICOS')));


alter table PRODUCTO
alter column DESCRIPCION varchar(100);
insert into PRODUCTO
(NOMBRE,CATEGORIA,MARCA,DESCRIPCION,PRECIO_UNITARIO)
values
('Bajo mesada Oslo','COCINA','Johnson','Mueble bajo mesada',450000),
('Alacena Premium','COCINA','Johnson','Alacena blanca laqueada',320000),
('Isla Central Nova','COCINA','Johnson','Isla moderna de cocina',780000),
('Placard Verona','PLACARD','Reno','Placard corredizo 3 puertas',650000),
('Vestidor Milano','PLACARD','Johnson','Vestidor modular completo',980000),
('Placard Compact','PLACARD','Reno','Placard compacto juvenil',390000),
('Horno Empotrable','ELECTRODOMESTICOS','Samsung','Horno electrico digital',850000),
('Anafe Vitroceramico','ELECTRODOMESTICOS','Whirlpool','Anafe vitroceramico 4 hornallas',620000),
('Campana Extractora','ELECTRODOMESTICOS','TST','Campana de acero inoxidable',410000),
('Lavavajillas Smart','ELECTRODOMESTICOS','Bosch','Lavavajillas automatico',1100000);

select * from producto;