USE TPBDI;
GO
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

CREATE TABLE cliente(
	Id_cliente int identity (1,1) primary key,
	Nombre VARCHAR(50),
	Apellido VARCHAR(50),
	Email VARCHAR(50),
	Telefono INT,
	Direccion VARCHAR(50),
	Medio_de_contacto VARCHAR(50)
);
--- Cliente: evitar emails repetidos
ALTER TABLE Cliente
ADD CONSTRAINT UQ_Cliente_Email
UNIQUE (Email);


CREATE TABLE asesor(
	Id_asesor int identity (1,1) primary key,
	Nombre VARCHAR(50),
	Apellido VARCHAR(50),
	Email VARCHAR(50),
	Telefono INT
);

CREATE TABLE proyecto(
	Id_proyecto int identity (1,1) primary key,
	Id_cliente INT,
	Id_asesor INT,
	Fecha_de_inicio DATE,
	Estado VARCHAR(50),
	Monto INT,
	Descuento INT,
	Fecha_de_entrega DATE,
	FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
	FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor)
);

---Proyecto: controlar monto y descuento
ALTER TABLE Proyecto
ADD CONSTRAINT CHK_Proyecto_Monto
CHECK (Monto >= 0);

ALTER TABLE Proyecto
ADD CONSTRAINT CHK_Proyecto_Descuento
CHECK (Descuento >= 0);

CREATE TABLE Interaccion(
	Id_interaccion int identity (1,1) primary key,
	Id_cliente INT,
	Id_asesor INT,
	Fecha DATE,
	Medio VARCHAR(50),
	Comentarios VARCHAR(50),
	Estado_de_venta VARCHAR(50),
	FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
	FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor)
);

CREATE TABLE entrega(
	Id_entrega int identity (1,1) primary key,
	Id_proyecto INT,
	fecha_programada date,
	fecha_real date,
	direccion varchar (50),
	estado varchar (50),
	constraint chk_estado check (estado in ('Pendiente','Completada','Cancelada')),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);
---Fechas de entrega: fecha real no debería ser anterior a la programada
ALTER TABLE Entrega
ADD CONSTRAINT CHK_Entrega_Fechas
CHECK (Fecha_real IS NULL OR Fecha_real >= Fecha_programada);


CREATE TABLE encuesta(
	Id_encuesta int identity (1,1) primary key,
	Id_proyecto INT,
	Fecha DATE,
	Puntuación INT,
	Comentarios VARCHAR(50),
	Volveria_a_comprar VARCHAR(2),
	constraint chk_volver check (volveria_a_comprar in ('si','no')),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);
ALTER TABLE Encuesta
ADD CONSTRAINT CHK_Encuesta_Puntuación
CHECK (Puntuación BETWEEN 1 AND 10);

CREATE TABLE documento(
	Id_documento int identity (1,1) primary key,
	Id_proyecto INT,
	Tipo VARCHAR(50),
	Nombre_archivo VARCHAR(50),
	Ruta VARCHAR(100),
	Fecha_de_carga DATE,
	FOREIGN KEY (id_proyecto) REFERENCES proyecto(Id_proyecto)
);


CREATE TABLE detalle_proyecto(
	Id_proyecto INT,
	Id_producto INT,
	Cantidad INT,
	Observaciones_tecnicas VARCHAR(200),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto),
	FOREIGN KEY (Id_producto) REFERENCES producto(Id_producto)
);

-- 3) Evitar cantidades negativas o cero
ALTER TABLE Detalle_Proyecto
ADD CONSTRAINT CHK_DetalleProyecto_Cantidad
CHECK (Cantidad > 0);

---Agregar idproyecto y idproducto como pk de detalle_proyecto
ALTER TABLE Detalle_Proyecto
ALTER COLUMN ID_Proyecto INT NOT NULL;

ALTER TABLE Detalle_Proyecto
ALTER COLUMN ID_Producto INT NOT NULL;
ALTER TABLE Detalle_Proyecto
ADD CONSTRAINT PK_Detalle_Proyecto
PRIMARY KEY (ID_Proyecto, ID_Producto);


INSERT INTO cliente
(Nombre, Apellido, Email, Telefono, Direccion, Medio_de_contacto)
VALUES
('Martina','Gomez','martina.gomez@gmail.com',1123456789,'Av Santa Fe 2450','Instagram'),
('Ricardo','Perez','ricardo.perez@gmail.com',1134567890,'Cabildo 1550','Showroom'),
('Lucia','Fernandez','lucia.fernandez@gmail.com',1145678901,'Libertador 3300','Referido'),
('Andres','Lopez','andres.lopez@gmail.com',1156789012,'Maipu 890','Facebook'),
('Sofia','Martinez','sofia.martinez@gmail.com',1167890123,'Parana 1200','Mail');

INSERT INTO asesor
(Nombre, Apellido, Email, Telefono)
VALUES
('Carlos','Ramirez','carlos.ramirez@gaudir.com',1122233344),
('Valeria','Sosa','valeria.sosa@gaudir.com',1133344455),
('Federico','Molina','federico.molina@gaudir.com',1144455566);

INSERT INTO proyecto
(Id_cliente, Id_asesor, Fecha_de_inicio, Estado, Monto, Descuento, Fecha_de_entrega)
VALUES
(1,1,'2025-06-01','Cotizacion',770000,0,'2025-07-15'),
(2,2,'2025-06-03','Negociacion',1430000,50000,'2025-08-01'),
(3,1,'2025-06-05','Cerrado',1750000,100000,'2025-08-10'),
(4,3,'2025-06-08','Fabricado',1470000,70000,'2025-07-30'),
(5,2,'2025-06-10','Instalado',1950000,150000,'2025-08-20');

-- DETALLE_PROYECTO
INSERT INTO detalle_proyecto
(Id_proyecto, Id_producto, Cantidad, Observaciones_tecnicas)
VALUES
(1,1,1,'Bajo mesada a medida color blanco'),
(1,2,1,'Alacena superior combinada'),

(2,4,1,'Placard corredizo para dormitorio principal'),
(2,6,1,'Placard compacto para dormitorio secundario'),

(3,5,1,'Vestidor modular completo'),
(3,7,1,'Horno empotrable incluido'),

(4,5,1,'Vestidor con estantes reforzados'),
(4,9,1,'Campana de acero inoxidable'),

(5,3,1,'Isla central con espacio de guardado'),
(5,8,1,'Anafe vitroceramico sobre mesada');
-- INTERACCIONES
INSERT INTO Interaccion
(Id_cliente, Id_asesor, Fecha, Medio, Comentarios, Estado_de_venta)
VALUES
(1,1,'2025-06-01','Instagram','Consulta por cocina','Cotizacion'),
(2,2,'2025-06-03','Showroom','Visita al local','Negociacion'),
(3,1,'2025-06-05','Referido','Interes en placard y horno','Cerrado'),
(4,3,'2025-06-08','Facebook','Consulta por vestidor','Fabricado'),
(5,2,'2025-06-10','Mail','Proyecto cocina completo','Instalado');
-- ENTREGAS
INSERT INTO entrega
(Id_proyecto, fecha_programada, fecha_real, direccion, estado)
VALUES
(1,'2025-07-15',NULL,'Av Santa Fe 2450','Pendiente'),
(2,'2025-08-01',NULL,'Cabildo 1550','Pendiente'),
(3,'2025-08-10',NULL,'Libertador 3300','Pendiente'),
(4,'2025-07-30','2025-07-30','Maipu 890','Completada'),
(5,'2025-08-20','2025-08-21','Parana 1200','Completada');

-- ENCUESTAS
INSERT INTO encuesta
(Id_proyecto, Fecha, Puntuación, Comentarios, Volveria_a_comprar)
VALUES
(4,'2025-08-02',9,'Muy buena instalacion','si'),
(5,'2025-08-23',8,'Buen servicio general','si');

-- DOCUMENTOS
INSERT INTO documento
(Id_proyecto, Tipo, Nombre_archivo, Ruta, Fecha_de_carga)
VALUES
(1,'Formulario contacto','contacto_cliente_1.pdf','/documentos/proyecto1/contacto.pdf','2025-06-01'),
(1,'Cotizacion','cotizacion_proyecto_1.pdf','/documentos/proyecto1/cotizacion.pdf','2025-06-02'),

(2,'Formulario venta','venta_proyecto_2.pdf','/documentos/proyecto2/venta.pdf','2025-06-03'),
(3,'Condiciones venta','condiciones_proyecto_3.pdf','/documentos/proyecto3/condiciones.pdf','2025-06-05'),

(4,'Orden instalacion','orden_instalacion_4.pdf','/documentos/proyecto4/orden.pdf','2025-07-28'),
(5,'Encuesta satisfaccion','encuesta_proyecto_5.pdf','/documentos/proyecto5/encuesta.pdf','2025-08-23');


SELECT * FROM cliente;
SELECT * FROM asesor;
SELECT * FROM proyecto;
SELECT * FROM Interaccion;
SELECT * FROM detalle_proyecto;
SELECT * FROM entrega;
SELECT * FROM encuesta;
SELECT * FROM documento;