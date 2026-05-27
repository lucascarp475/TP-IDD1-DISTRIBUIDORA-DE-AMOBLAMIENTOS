

create database tpgrupal
go
use tpgrupal
go

DROP TABLE entrega
DROP TABLE encuesta
DROP TABLE documentacion
DROP TABLE detalle_proyecto
DROP TABLE proyecto
DROP TABLE Interaccion
DROP TABLE producto
DROP TABLE asesor
DROP TABLE cliente

CREATE TABLE cliente(
	Id_cliente INT IDENTITY(1,1) PRIMARY KEY,
	NombreC VARCHAR(50),
	ApellidoC VARCHAR(50),
	EmailC VARCHAR(50),
	TelefonoC VARCHAR (20),
	DireccionC VARCHAR(50),
	Medio_de_contacto VARCHAR(50) CHECK (Medio_de_contacto IN('WhatsApp','Telefono','Email'))
);

CREATE TABLE asesor(
	Id_asesor INT IDENTITY(11,1)PRIMARY KEY,
	NombreA VARCHAR(50),
	ApellidoA VARCHAR(50),
	EmailA VARCHAR(50),
	TelefonoA VARCHAR (20)
);

CREATE TABLE proyecto(
	Id_proyecto INT IDENTITY(10,10)PRIMARY KEY,
	Id_cliente INT,
	Id_asesor INT,
	Fecha_de_inicio DATE,
	Estado VARCHAR(50) CHECK(Estado IN('Finalizado','Pendiente','En proceso')),
	Monto DECIMAL(12,2),
	Descuento DECIMAL(12,2),
	Fecha_de_entrega DATE,
	FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
	FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor)
);

CREATE TABLE Interaccion(
	Id_interaccion INT IDENTITY(101,1)PRIMARY KEY,
	Id_cliente INT,
	Id_asesor INT,
	Fecha_Interaccion DATE,
	Medio VARCHAR(50),
	Comentarios VARCHAR(50),
	Estado_de_venta VARCHAR(50) CHECK(Estado_de_venta IN('Interesado','En negociacion','Pendiente','Cerrada')),
	FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
	FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor)
);

CREATE TABLE entrega(
	Id_entrega int identity (1,1) primary key,
	Id_proyecto INT,
	fecha_programada date,
	fecha_real date,
	direccion_entrega varchar (50),
	estado varchar (50),
	constraint chk_estado check (estado in ('Pendiente','Completada','Cancelada')),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);
ALTER TABLE Entrega
ADD CONSTRAINT CHK_Entrega_Fechas
CHECK (Fecha_real IS NULL OR Fecha_real >= Fecha_programada);


CREATE TABLE encuesta(
	Id_encuesta INT IDENTITY(1,1)PRIMARY KEY,
	Id_proyecto INT,
	Fecha_encuesta DATE,
	Puntuacion INT,
	Comentarios VARCHAR(50),
	Volveria_a_comprar VARCHAR(2) CHECK(Volveria_a_comprar IN('SI','NO')),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto),
	CONSTRAINT CHK_Encuesta_Puntuacion CHECK (Puntuacion BETWEEN 1 AND 10)
);

CREATE TABLE documentacion(
	Id_documento INT IDENTITY(11,1)PRIMARY KEY,
	Id_proyecto INT,
	Tipo VARCHAR(50),
	Nombre_archivo VARCHAR(50),
	Ruta VARCHAR(50),
	Fecha_de_carga DATE,
	FOREIGN KEY (id_proyecto) REFERENCES proyecto(Id_proyecto)
);

CREATE TABLE producto(
	Id_producto INT IDENTITY(1001,1) PRIMARY KEY,
	NombreP VARCHAR(50),
	Categoria VARCHAR(50),
	Marca VARCHAR(50),
	Descripcion VARCHAR(50),
	Precio_unitario decimal (12,2)
);

CREATE TABLE detalle_proyecto(
	Id_proyecto INT,
	Id_producto INT,
	Cantidad INT,
	Observaciones_tecnicas VARCHAR(50),
	CONSTRAINT PK_Detalle_Proyecto PRIMARY KEY (Id_proyecto, Id_producto),
	FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto), 
	FOREIGN KEY (Id_producto) REFERENCES producto(Id_producto),
	CONSTRAINT CHK_Detalle_Cantidad CHECK (Cantidad > 0)
);

--------INSERTADO DE DATOS----
INSERT INTO cliente
(Nombre, Apellido, Email, Telefono, Direccion, Medio_de_contacto)
VALUES
('Martina','Gomez','martina.gomez@gmail.com',1123456789,'Av Santa Fe 2450','Instagram'),
('Ricardo','Perez','ricardo.perez@gmail.com',1134567890,'Cabildo 1550','Showroom'),
('Lucia','Fernandez','lucia.fernandez@gmail.com',1145678901,'Libertador 3300','Referido'),
('Andres','Lopez','andres.lopez@gmail.com',1156789012,'Maipu 890','Facebook'),
('Sofia','Martinez','sofia.martinez@gmail.com',1167890123,'Parana 1200','Mail');

-- =========================
-- ASESORES

CREATE sp_RegistrarAsesor
(
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Email VARCHAR(50),
    @Telefono VARCHAR(20)
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO asesor
        (Nombre, Apellido, Email, Telefono)
        VALUES
        (@Nombre, @Apellido, @Email, @Telefono);

        COMMIT TRANSACTION;

        PRINT 'Asesor registrado correctamente';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error al registrar asesor';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- =========================
-- PROYECTOS
-- =========================
INSERT INTO proyecto VALUES
(1,11,'2026-01-10','Finalizado',1800000,10,'2026-02-15'),
(1,12,'2026-01-18','En proceso',2400000,5,'2026-03-20'),
(3,13,'2026-02-01','Pendiente',980000,0,'2026-04-01'),
(4,14,'2026-02-12','Finalizado',1470000,15,'2026-03-05'),
(5,15,'2026-03-01','En proceso',1950000,8,'2026-04-15'),
(6,16,'2026-03-05','Finalizado',2200000,12,'2026-04-10'),
(7,17,'2026-03-11','Pendiente',850000,0,'2026-05-01'),
(8,18,'2026-03-20','En proceso',3100000,7,'2026-05-25'),
(9,19,'2026-04-02','Finalizado',2750000,10,'2026-05-15'),
(10,20,'2026-04-08','En proceso',1650000,5,'2026-06-01');


-- =========================
-- INTERACCIONES
-- =========================
INSERT INTO Interaccion VALUES
(1,11,'2026-01-05','WhatsApp','Consulta inicial','Interesado'),
(2,12,'2026-01-08','Email','Envio presupuesto','En negociacion'),
(3,13,'2026-01-15','Telefono','Consulta cocina','Interesado'),
(4,14,'2026-01-28','WhatsApp','Solicita descuento','Pendiente'),
(5,15,'2026-02-05','Presencial','Firma contrato','Cerrada'),
(6,16,'2026-02-20','Email','Consulta tecnica','Interesado'),
(7,17,'2026-03-02','Telefono','Confirma compra','Cerrada'),
(8,18,'2026-03-10','WhatsApp','Solicita visita','Interesado'),
(9,19,'2026-03-18','Email','Aprueba diseño','En negociacion'),
(10,20,'2026-03-29','Presencial','Entrega señal','Cerrada');


-- =========================
-- ENTREGAS
-- =========================
INSERT INTO entrega
(Id_proyecto, fecha_programada, fecha_real, direccion, estado)
VALUES
(1,'2025-07-15',NULL,'Av Santa Fe 2450','Pendiente'),
(2,'2025-08-01',NULL,'Cabildo 1550','Pendiente'),
(3,'2025-08-10',NULL,'Libertador 3300','Pendiente'),
(4,'2025-07-30','2025-07-30','Maipu 890','Completada'),
(5,'2025-08-20','2025-08-21','Parana 1200','Completada');


-- =========================
-- ENCUESTAS
-- =========================
INSERT INTO encuesta VALUES
(10,'2026-02-20',9,'Muy conforme','SI'),
(20,'2026-03-25',7,'Buena atencion','SI'),
(30,'2026-04-05',6,'Demora en entrega','NO'),
(40,'2026-03-10',10,'Excelente servicio','SI'),
(50,'2026-04-20',8,'Buen resultado','SI'),
(60,'2026-04-15',9,'Muy recomendable','SI'),
(70,'2026-05-05',5,'Falta comunicacion','NO'),
(80,'2026-05-30',8,'Muy buen diseño','SI'),
(90,'2026-05-18',10,'Todo perfecto','SI'),
(100,'2026-06-05',7,'Buen trabajo','SI');


-- =========================
-- DOCUMENTACION
-- =========================
INSERT INTO documentacion VALUES
(10,'Contrato','contrato1.pdf','/docs/contratos','2026-01-09'),
(20,'Plano','plano2.pdf','/docs/planos','2026-01-18'),
(30,'Render','render3.jpg','/docs/renders','2026-02-01'),
(40,'Factura','factura4.pdf','/docs/facturas','2026-02-15'),
(50,'Presupuesto','presupuesto5.pdf','/docs/presupuestos','2026-03-01'),
(60,'Contrato','contrato6.pdf','/docs/contratos','2026-03-06'),
(70,'Plano','plano7.pdf','/docs/planos','2026-03-12'),
(80,'Render','render8.jpg','/docs/renders','2026-03-22'),
(90,'Factura','factura9.pdf','/docs/facturas','2026-04-05'),
(100,'Presupuesto','presupuesto10.pdf','/docs/presupuestos','2026-04-10');

select * from producto;
-- =========================
-- PRODUCTO
-- =========================

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


-- =========================
-- DETALLE_PROYECTO
-- =========================
INSERT INTO detalle_proyecto VALUES
(10,1001,1,'Bajo mesada principal'),
(20,1002,1,'Alacena superior'),
(30,1003,1,'Isla moderna'),
(40,1004,1,'Anafe instalado'),
(50,1005,1,'Vestidor completo'),
(60,1006,2,'Placares corredizos'),
(70,1007,1,'Horno digital'),
(80,1008,1,'Campana acero inoxidable'),
(90,1009,2,'Placard juvenil'),
(100,1010,1,'Lavavajillas premium');


SELECT*FROM cliente
SELECT*FROM asesor
SELECT*FROM proyecto
SELECT*FROM Interaccion
SELECT*FROM entrega
SELECT*FROM encuesta
SELECT*FROM documentacion
SELECT*FROM producto
SELECT*FROM detalle_proyecto

----FUNCION_CALCULAR----


CREATE FUNCTION fn_CalcularMontoFinal
(
    @Monto DECIMAL(12,2),
    @Descuento DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    DECLARE @Resultado DECIMAL(12,2)

    SET @Resultado =
        @Monto - (@Monto * @Descuento / 100)

    RETURN @Resultado

END
GO

-- PROCEDURE CON TRY/CATCH
---------------------------------------------------

CREATE PROCEDURE sp_RegistrarProyecto
(
    @Id_cliente INT,
    @Id_asesor INT,
    @Monto DECIMAL(12,2),
    @Descuento DECIMAL(12,2),
    @Fecha_entrega DATE
)
AS
BEGIN

BEGIN TRY

    BEGIN TRANSACTION

    INSERT INTO proyecto
    (
        Id_cliente,
        Id_asesor,
        Fecha_de_inicio,
        Estado,
        Monto,
        Descuento,
        Fecha_de_entrega
    )
    VALUES
    (
        @Id_cliente,
        @Id_asesor,
        GETDATE(),
        'Pendiente',
        @Monto,
        @Descuento,
        @Fecha_entrega
    )

    COMMIT TRANSACTION

    PRINT 'Proyecto registrado correctamente'

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    PRINT 'Error al registrar proyecto'

    PRINT ERROR_MESSAGE()

END CATCH

END
GO

---------------------------------------------------
-- PRUEBA DEL PROCEDURE
---------------------------------------------------

EXEC sp_RegistrarProyecto
1,1,2500000,10,'2026-07-20'

---------------------------------------------------
-- PRUEBA DE LA FUNCTION
---------------------------------------------------

SELECT
Id_proyecto,
Monto,
Descuento,
dbo.fn_CalcularMontoFinal(Monto,Descuento) AS Monto_Final
FROM proyecto;
---===========================================
---  CONSULTAS Y SUB CONSULTAS DE CLIENTE
---===========================================

---TELEFONO, GMAIL Y WHATSAPP---
DROP TABLE telefonos;

SELECT*
INTO telefonos
FROM cliente
WHERE Medio_de_contacto='Telefono';

DROP TABLE WhatsApp;

SELECT*
INTO WhatsApp
FROM cliente
WHERE Medio_de_contacto='WhatsApp';

DROP TABLE Email;

SELECT*
INTO Email
FROM cliente
WHERE Medio_de_contacto='Email';

SELECT*FROM telefonos
SELECT*FROM WhatsApp
SELECT*FROM Email

----ID MAS ALTO Y MAS BAJO----

SELECT Nombre, Apellido
FROM cliente
WHERE Id_cliente=(
	SELECT Max(Id_cliente)
	FROM cliente);

SELECT Nombre, Apellido
FROM cliente
WHERE Id_cliente=(
	SELECT Min(Id_cliente)
	FROM cliente);

----ORDEN ALFABETICO----
DROP TABLE orden;

SELECT Nombre,Apellido,Telefono
INTO orden
FROM cliente;

SELECT*
FROM orden
ORDER BY Nombre ASC;

----DIRECCION EN ORACIONES-----

SELECT CONCAT_WS(' ',Nombre,Apellido,'vive en',Direccion) AS Direccion
FROM cliente;

----==========================----
----VISTAS DE TIPO DE PRODUCTO----
----==========================----

----Bebidas---
CREATE VIEW Bebidas AS
SELECT Categoria,Marca
FROM producto
WHERE Categoria='Bebida'

SELECT*FROM Bebidas

----Golosinas---
DROP VIEW Golosinas;

CREATE VIEW Golosinas AS
SELECT Categoria, Marca
FROM producto
WHERE Categoria='Golosina'

SELECT*FROM Golosinas

---=============================----
---ORDEN DE CLIENTE POR ABCDARIO----
---=============================----


