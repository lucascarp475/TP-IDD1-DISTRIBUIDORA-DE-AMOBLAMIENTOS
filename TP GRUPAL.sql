

create database tpgrupal
go
use tpgrupal
go

DROP TABLE IF EXISTS entrega;
DROP TABLE IF EXISTS encuesta;
DROP TABLE IF EXISTS documentacion;
DROP TABLE IF EXISTS detalle_proyecto;
DROP TABLE IF EXISTS entrega;
DROP TABLE IF EXISTS proyecto;
DROP TABLE IF EXISTS Interaccion;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS asesor;
DROP TABLE IF EXISTS cliente;

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
DROP PROCEDURE IF EXISTS AgregarCliente;
GO

CREATE PROCEDURE AgregarCliente
	@Nombre VARCHAR(50),
	@Apellido VARCHAR(50),
	@Email VARCHAR(50),
	@Telefono INT,
	@Direccion VARCHAR(50),
	@Medio_de_contacto VARCHAR(50)
AS
BEGIN
	INSERT INTO	cliente(NombreC,ApellidoC,EmailC,TelefonoC,DireccionC,Medio_de_contacto)
	VALUES(@Nombre,@Apellido,@Email,@Telefono,@Direccion,@Medio_de_contacto)

END;

EXEC AgregarCliente
'Juan',
'Perez',
'juan@gmail.com',
11223344,
'Av Rivadavia 123',
'WhatsApp';

EXEC AgregarCliente
'Maria',
'Lopez',
'marialopez@gmail.com',
1133445566,
'San Martin 456',
'WhatsApp';

EXEC AgregarCliente
'Carlos',
'Gomez',
'carlosgomez@hotmail.com',
1144556677,
'Belgrano 789',
'Telefono';

EXEC AgregarCliente
'Lucia',
'Fernandez',
'luciaf@gmail.com',
1155667788,
'Cabildo 321',
'WhatsApp';

EXEC AgregarCliente
'Martin',
'Diaz',
'martind@hotmail.com',
1166778899,
'Mitre 654',
'Email';

SELECT*FROM cliente

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
DROP PROCEDURE IF EXISTS AgregarProyecto;
GO

CREATE PROCEDURE AgregarProyecto
	@Id_cliente INT,
	@Id_asesor INT,
	@Fecha_de_inicio DATE,
	@Estado VARCHAR(50),
	@Monto DECIMAL(12,2),
	@Descuento DECIMAL(12,2),
	@Fecha_de_entrega DATE
AS
BEGIN
	INSERT INTO	proyecto(Id_cliente,Id_asesor,Fecha_de_inicio,Estado,Monto,Descuento,Fecha_de_entrega)
	VALUES(@Id_cliente,@Id_asesor,@Fecha_de_inicio,@Estado,@Monto,@Descuento,@Fecha_de_entrega)
END;

EXEC AgregarProyecto 1,11,'2026-01-10','Finalizado',1800000,10,'2026-02-15';

EXEC AgregarProyecto 2,12,'2026-01-18','En proceso',2400000,5,'2026-03-20';

EXEC AgregarProyecto 3,13,'2026-02-01','Pendiente',980000,0,'2026-04-01';

EXEC AgregarProyecto 4,14,'2026-02-12','Finalizado',1470000,15,'2026-03-05';

EXEC AgregarProyecto 5,15,'2026-03-01','En proceso',1950000,8,'2026-04-15';


SELECT*FROM proyecto


-- =========================
-- INTERACCIONES
-- =========================
DROP PROCEDURE IF EXISTS AgregarInteraccion;
GO

CREATE PROCEDURE AgregarInteraccion
	@Id_cliente INT,
	@Id_asesor INT,
	@Fecha_Interaccion DATE,
	@Medio VARCHAR(50),
	@Comentarios VARCHAR(50),
	@Estado_de_venta VARCHAR(50)
AS
BEGIN
	INSERT INTO	Interaccion(Id_cliente,Id_asesor,Fecha_Interaccion,Medio,Comentarios,Estado_de_venta)
	VALUES(@Id_cliente,@Id_asesor,@Fecha_Interaccion,@Medio,@Comentarios,@Estado_de_venta)

END;

EXEC AgregarInteraccion 1,11,'2026-01-05','WhatsApp','Consulta inicial','Interesado';

EXEC AgregarInteraccion 2,12,'2026-01-08','Email','Envio presupuesto','En negociacion';

EXEC AgregarInteraccion 3,13,'2026-01-15','Telefono','Consulta cocina','Interesado';

EXEC AgregarInteraccion 4,14,'2026-01-28','WhatsApp','Solicita descuento','Pendiente';

EXEC AgregarInteraccion 5,15,'2026-02-05','Presencial','Firma contrato','Cerrada';

SELECT*FROM Interaccion

-- =========================
-- ENTREGAS
-- =========================
DROP PROCEDURE IF EXISTS AgregarEntrega;
GO

CREATE PROCEDURE AgregarEntrega
	@Id_proyecto INT,
	@fecha_programada DATE,
	@fecha_real DATE,
	@direccion_entrega VARCHAR(50),
	@estado VARCHAR(50)
AS
BEGIN
	INSERT INTO	entrega(Id_proyecto,fecha_programada,fecha_real,direccion_entrega,estado)
	VALUES(@Id_proyecto,@fecha_programada,@fecha_real,@direccion_entrega,@estado)

END;

EXEC AgregarEntrega 10,'2026-05-12','2026-05-15','Riobamba 510','Pendiente';

EXEC AgregarEntrega 20,'2026-05-02','2026-05-04','Rivadavia 3100','Pendiente';

EXEC AgregarEntrega 30,'2026-04-16','2026-04-19','Callao 300','Completada';

EXEC AgregarEntrega 40,'2026-06-24','2026-06-29','Corrientes 1200','Cancelada';

EXEC AgregarEntrega 50,'2026-05-06','2026-05-09','Belgrano 201','Completada';

SELECT*FROM entrega


-- =========================
-- ENCUESTAS
-- =========================
DROP PROCEDURE IF EXISTS AgregarEncuesta;
GO

CREATE PROCEDURE AgregarEncuesta
	@Id_proyecto INT,
	@Fecha_encuesta DATE,
	@Puntuacion INT,
	@Comentarios VARCHAR(50),
	@Volveria_a_comprar VARCHAR(2)
AS
BEGIN
	INSERT INTO	encuesta(Id_proyecto,Fecha_encuesta,Puntuacion,Comentarios,Volveria_a_comprar)
	VALUES(@Id_proyecto,@Fecha_encuesta,@Puntuacion,@Comentarios,@Volveria_a_comprar)

END;

EXEC AgregarEncuesta 10,'2026-02-20',9,'Muy conforme','SI';

EXEC AgregarEncuesta 20,'2026-03-25',7,'Buena atencion','SI';

EXEC AgregarEncuesta 30,'2026-04-05',6,'Demora en entrega','NO';

EXEC AgregarEncuesta 40,'2026-03-10',10,'Excelente servicio','SI';

EXEC AgregarEncuesta 50,'2026-04-20',8,'Buen resultado','SI';

SELECT*FROM encuesta


-- =========================
-- DOCUMENTACION
-- =========================
DROP PROCEDURE IF EXISTS AgregarDocumentacion;
GO

CREATE PROCEDURE AgregarDocumentacion
	@Id_proyecto INT,
	@Tipo VARCHAR(50),
	@Nombre_archivo VARCHAR(50),
	@Ruta VARCHAR(50),
	@Fecha_de_carga DATE
AS
BEGIN
	INSERT INTO	documentacion(Id_proyecto,Tipo,Nombre_archivo,Ruta,Fecha_de_carga)
	VALUES(@Id_proyecto,@Tipo,@Nombre_archivo,@Ruta,@Fecha_de_carga)

END;

EXEC AgregarDocumentacion 10,'Contrato','contrato1.pdf','/docs/contratos','2026-01-09';

EXEC AgregarDocumentacion 20,'Plano','plano2.pdf','/docs/planos','2026-01-18';

EXEC AgregarDocumentacion 30,'Render','render3.jpg','/docs/renders','2026-02-01';

EXEC AgregarDocumentacion 40,'Factura','factura4.pdf','/docs/facturas','2026-02-15';

EXEC AgregarDocumentacion 50,'Presupuesto','presupuesto5.pdf','/docs/presupuestos','2026-03-01';

SELECT*FROM documentacion
-- =========================
-- PRODUCTO
-- =========================

DROP PROCEDURE IF EXISTS AgregarProducto;
GO

CREATE PROCEDURE AgregarProducto
	@NombreP VARCHAR(50),
	@Categoria VARCHAR(50),
	@Marca VARCHAR(50),
	@Descripcion VARCHAR(50),
	@Precio_unitario decimal (12,2)
AS
BEGIN
	INSERT INTO producto(NombreP,Categoria,Marca,Descripcion,Precio_unitario)
	VALUES(@NombreP,@Categoria,@Marca,@Descripcion,@Precio_unitario)

END;

EXEC AgregarProducto 'Bajo mesada Oslo','COCINA','Johnson','Mueble bajo mesada',450000;

EXEC AgregarProducto 'Alacena Premium','COCINA','Johnson','Alacena blanca laqueada',320000;

EXEC AgregarProducto 'Isla Central Nova','COCINA','Johnson','Isla moderna de cocina',780000;

EXEC AgregarProducto 'Placard Verona','PLACARD','Reno','Placard corredizo 3 puertas',650000;

EXEC AgregarProducto 'Vestidor Milano','PLACARD','Johnson','Vestidor modular completo',980000;

SELECT*FROM producto


-- =========================
-- DETALLE_PROYECTO
-- =========================
DROP PROCEDURE IF EXISTS AgregarDetalle_producto
GO

CREATE PROCEDURE AgregarDetalle_producto
	@Id_proyecto INT,
	@Id_producto INT,
	@Cantidad INT,
	@Observaciones_tecnicas VARCHAR(50)
AS
BEGIN
	INSERT INTO detalle_proyecto(Id_proyecto,Id_producto,Cantidad,Observaciones_tecnicas)
	VALUES(@Id_proyecto,@Id_producto,@Cantidad,@Observaciones_tecnicas)

END;

EXEC AgregarDetalle_producto 10,1001,1,'Bajo mesada principal';

EXEC AgregarDetalle_producto 20,1002,1,'Alacena superior';

EXEC AgregarDetalle_producto 30,1003,1,'Isla moderna';

EXEC AgregarDetalle_producto 40,1004,1,'Anafe instalado';

EXEC AgregarDetalle_producto 50,1005,1,'Vestidor completo';

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

