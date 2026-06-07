

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
	EmailC VARCHAR(50) UNIQUE,
	TelefonoC VARCHAR (20),
	DireccionC VARCHAR(50),
	Medio_de_contacto VARCHAR(50) CHECK (Medio_de_contacto IN('WhatsApp','Telefono','Email'))
);

CREATE TABLE asesor(
	Id_asesor INT IDENTITY(11,1)PRIMARY KEY,
	NombreA VARCHAR(50),
	ApellidoA VARCHAR(50),
	EmailA VARCHAR(50) UNIQUE,
	TelefonoA VARCHAR (20)
);

CREATE TABLE proyecto(
	Id_proyecto INT IDENTITY(10,10)PRIMARY KEY,
	Id_cliente INT,
	Id_asesor INT,
	Fecha_de_inicio DATE,
	Estado VARCHAR(50) CHECK(Estado IN('Finalizado','Pendiente','En proceso')),
	Monto DECIMAL(12,2),
	Descuento DECIMAL(5,2),
	Fecha_de_entrega DATE,
	FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
	FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor),
    CONSTRAINT CHK_Proyecto_Descuento CHECK (Descuento BETWEEN 0 AND 100)
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
	@Telefono varchar(20),
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
'11223344',
'Av Rivadavia 123',
'WhatsApp';

EXEC AgregarCliente
'Maria',
'Lopez',
'marialopez@gmail.com',
'1133445566',
'San Martin 456',
'WhatsApp';

EXEC AgregarCliente
'Carlos',
'Gomez',
'carlosgomez@hotmail.com',
'1144556677',
'Belgrano 789',
'Telefono';

EXEC AgregarCliente
'Lucia',
'Fernandez',
'luciaf@gmail.com',
'1155667788',
'Cabildo 321',
'WhatsApp';

EXEC AgregarCliente
'Martin',
'Diaz',
'martind@hotmail.com',
'1166778899',
'Mitre 654',
'Email';
SELECT*FROM cliente


-- =========================
-- ASESORES
DROP PROCEDURE IF EXISTS sp_RegistrarAsesor;
GO
CREATE PROCEDURE sp_RegistrarAsesor
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Email VARCHAR(50),
    @Telefono VARCHAR(20)

AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO asesor
        (NombreA, ApellidoA, EmailA, TelefonoA)
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

EXEC sp_RegistrarAsesor
    @Nombre = 'Carlos',
    @Apellido = 'Ramirez',
    @Email = 'carlos.ramirez@gaudir.com',
    @Telefono = '1122233344';

EXEC sp_RegistrarAsesor
    @Nombre = 'Valeria',
    @Apellido = 'Sosa',
    @Email = 'valeria.sosa@gaudir.com',
    @Telefono = '1133344455';

EXEC sp_RegistrarAsesor
    @Nombre = 'Federico',
    @Apellido = 'Molina',
    @Email = 'federico.molina@gaudir.com',
    @Telefono = '1144455566';


EXEC sp_RegistrarAsesor
    @Nombre = 'Luciana',
    @Apellido = 'Perez',
    @Email = 'luciana.perez@gaudir.com',
    @Telefono = '1155566677';


EXEC sp_RegistrarAsesor
    @Nombre = 'Martin',
    @Apellido = 'Gutierrez',
    @Email = 'martin.gutierrez@gaudir.com',
    @Telefono = '1166677788';


select * from asesor;
-- =========================
-- PROYECTOS
-- =========================
DROP PROCEDURE IF EXISTS sp_RegistrarProyecto;
GO


CREATE PROCEDURE sp_RegistrarProyecto
(
    @Id_cliente INT,
    @Id_asesor INT,
    @Monto DECIMAL(12,2),
    @Descuento DECIMAL(5,2),
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


EXEC sp_RegistrarProyecto
    @Id_cliente = 1,
    @Id_asesor = 11,
    @Monto = 770000,
    @Descuento = 0,
    @Fecha_entrega = '2026-07-15';

EXEC sp_RegistrarProyecto
    @Id_cliente = 2,
    @Id_asesor = 12,
    @Monto = 1430000,
    @Descuento = 5,
    @Fecha_entrega = '2026-08-01';

EXEC sp_RegistrarProyecto
    @Id_cliente = 3,
    @Id_asesor = 11,
    @Monto = 1750000,
    @Descuento = 10,
    @Fecha_entrega = '2026-08-10';

EXEC sp_RegistrarProyecto
    @Id_cliente = 4,
    @Id_asesor = 13,
    @Monto = 1470000,
    @Descuento = 7,
    @Fecha_entrega = '2026-07-30';

EXEC sp_RegistrarProyecto
    @Id_cliente = 5,
    @Id_asesor = 12,
    @Monto = 1950000,
    @Descuento = 15,
    @Fecha_entrega = '2026-08-20';
SELECT*FROM proyecto

UPDATE proyecto -----para cambiar el estado del proyecto cuando se haya hecho la entrega
SET Estado = 'Finalizado'
WHERE Id_proyecto IN (40,50);



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

EXEC AgregarInteraccion 5,15,'2026-02-05','Presencial','Venta concretada','Cerrada';


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

EXEC AgregarEntrega
    10,
    '2026-07-10',
    NULL,
    'Av Rivadavia 123',
    'Pendiente';

EXEC AgregarEntrega
    20,
    '2026-07-25',
    NULL,
    'San Martin 456',
    'Pendiente';

EXEC AgregarEntrega
    30,
    '2026-08-05',
    NULL,
    'Belgrano 789',
    'Pendiente';

EXEC AgregarEntrega
    40,
    '2026-07-28',
    '2026-07-30',
    'Cabildo 321',
    'Completada';

EXEC AgregarEntrega
    50,
    '2026-08-18',
    '2026-08-20',
    'Mitre 654',
    'Completada';



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

EXEC AgregarEncuesta
    40,
    '2026-08-02',
    9,
    'Muy conforme con la instalacion',
    'SI';

EXEC AgregarEncuesta
    50,
    '2026-08-25',
    10,
    'Excelente atencion y calidad',
    'SI';

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
DROP FUNCTION IF EXISTS fn_CalcularMontoFinal
GO

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


---------------------------------------------------
-- PRUEBA DEL PROCEDURE
---------------------------------------------------

EXEC sp_RegistrarProyecto
1,1,2500000,10,'2026-07-20'

select * from proyecto;
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

SELECT
    c.NombreC,
    c.ApellidoC,
    p.Id_proyecto,
    p.Estado,
    a.NombreA AS Nombre_Asesor,
    a.ApellidoA AS Apellido_Asesor
FROM cliente AS c
JOIN proyecto AS p
    ON c.Id_cliente = p.Id_cliente
JOIN asesor AS a
    ON p.Id_asesor = a.Id_asesor;


SELECT
    p.Id_proyecto,
    p.Estado,
    e.fecha_programada,
    e.fecha_real,
    e.estado AS Estado_Entrega
FROM proyecto AS p
JOIN entrega AS e
    ON p.Id_proyecto = e.Id_proyecto;


SELECT
    p.Id_proyecto,
    en.Puntuacion,
    en.Comentarios,
    en.Fecha_encuesta
FROM proyecto AS p
JOIN encuesta AS en
    ON p.Id_proyecto = en.Id_proyecto;


SELECT
    c.NombreC,
    c.ApellidoC,
    i.Fecha_Interaccion,
    i.Medio,
    i.Comentarios
FROM cliente AS c
JOIN Interaccion AS i
    ON c.Id_cliente = i.Id_cliente;


SELECT
    p.Id_proyecto,
    d.Tipo,
    d.Nombre_archivo,
    d.Fecha_de_carga
FROM proyecto AS p
JOIN documentacion AS d
    ON p.Id_proyecto = d.Id_proyecto;


SELECT
    p.Id_proyecto,
    pr.NombreP,
    dp.Cantidad,
    dp.Observaciones_tecnicas
FROM proyecto AS p
JOIN detalle_proyecto AS dp
    ON p.Id_proyecto = dp.Id_proyecto
JOIN producto AS pr
    ON dp.Id_producto = pr.Id_producto;


-- CONSULTAS CON GROUP BY:
-- Cantidad de proyectos agrupados por estado
SELECT
    Estado,
    COUNT(*) AS Cantidad_Proyectos
FROM proyecto
GROUP BY Estado;

-- Cantidad de clientes según su medio de contacto preferido

SELECT
    Medio_de_contacto,
    COUNT(*) AS Cantidad_Clientes
FROM cliente
GROUP BY Medio_de_contacto;

-- Cantidad de proyectos asignados a cada asesor

SELECT
    Id_asesor,
    COUNT(*) AS Cantidad_Proyectos
FROM proyecto
GROUP BY Id_asesor;
-- Monto total vendido por cada asesor
SELECT
    Id_asesor,
    SUM(Monto) AS Total_Vendido
FROM proyecto
GROUP BY Id_asesor;

-- Cantidad de documentos registrados por tipo
SELECT
    Tipo,
    COUNT(*) AS Cantidad_Documentos
FROM documentacion
GROUP BY Tipo;



-- CONSULTAS CON HAVING:

SELECT
    Id_asesor,
    COUNT(*) AS Cantidad_Proyectos
FROM proyecto
GROUP BY Id_asesor
HAVING COUNT(*) > 2;


SELECT
    Estado,
    COUNT(*) AS Cantidad
FROM proyecto
GROUP BY Estado
HAVING COUNT(*) > 1;


SELECT
    Id_asesor,
    SUM(Monto) AS Total_Vendido
FROM proyecto
GROUP BY Id_asesor
HAVING SUM(Monto) > 2000000;


SELECT
    Tipo,
    COUNT(*) AS Cantidad
FROM documentacion
GROUP BY Tipo
HAVING COUNT(*) > 1;


SELECT
    Medio_de_contacto,
    COUNT(*) AS Cantidad
FROM cliente
GROUP BY Medio_de_contacto
HAVING COUNT(*) > 1;



-- SUBCONSULTA ESCALAR:

SELECT *
FROM proyecto
WHERE Monto >
(
    SELECT AVG(Monto)
    FROM proyecto
);



-- SUBCONSULTA CON IN:

SELECT *
FROM cliente
WHERE Id_cliente IN
(
    SELECT Id_cliente
    FROM proyecto
);



-- SUBCONSULTA CON EXISTS:

SELECT *
FROM cliente AS c
WHERE EXISTS
(
    SELECT 1
    FROM Interaccion AS i
    WHERE i.Id_cliente = c.Id_cliente
);



-- SUBCONSULTA CORRELACIONADA:

SELECT *
FROM proyecto AS p1
WHERE Monto >
(
    SELECT AVG(Monto)
    FROM proyecto AS p2
    WHERE p1.Id_asesor = p2.Id_asesor
);


SELECT
    p.Id_proyecto,
    c.NombreC,
    a.NombreA,
    p.Estado,
    p.Monto,
    p.Descuento,
    dbo.fn_CalcularMontoFinal(p.Monto, p.Descuento) AS Monto_Final
FROM proyecto p
JOIN cliente c
    ON p.Id_cliente = c.Id_cliente
JOIN asesor a
    ON p.Id_asesor = a.Id_asesor;


------------VISTAS----
--- VISTA 1: Proyectos con cliente y asesor----

CREATE VIEW vw_Proyectos_Detalle AS
SELECT
    p.Id_proyecto,
    c.NombreC + ' ' + c.ApellidoC AS Cliente,
    a.NombreA + ' ' + a.ApellidoA AS Asesor,
    p.Fecha_de_inicio,
    p.Estado,
    p.Monto,
    p.Descuento,
    dbo.fn_CalcularMontoFinal(p.Monto, p.Descuento) AS Monto_Final,
    p.Fecha_de_entrega
FROM proyecto p
JOIN cliente c ON p.Id_cliente = c.Id_cliente
JOIN asesor a ON p.Id_asesor = a.Id_asesor;
GO
-- VISTA 2: Entregas con datos del proyecto y cliente
CREATE VIEW vw_Entregas_Proyecto AS
SELECT
    e.Id_entrega,
    p.Id_proyecto,
    c.NombreC + ' ' + c.ApellidoC AS Cliente,
    e.fecha_programada,
    e.fecha_real,
    e.direccion_entrega,
    e.estado AS Estado_Entrega,
    p.Estado AS Estado_Proyecto
FROM entrega e
JOIN proyecto p ON e.Id_proyecto = p.Id_proyecto
JOIN cliente c ON p.Id_cliente = c.Id_cliente;
GO

-- VISTA 3: Encuestas de satisfacción
CREATE VIEW vw_Satisfaccion_Clientes AS
SELECT
    en.Id_encuesta,
    p.Id_proyecto,
    c.NombreC + ' ' + c.ApellidoC AS Cliente,
    en.Fecha_encuesta,
    en.Puntuacion,
    en.Comentarios,
    en.Volveria_a_comprar
FROM encuesta en
JOIN proyecto p ON en.Id_proyecto = p.Id_proyecto
JOIN cliente c ON p.Id_cliente = c.Id_cliente;
GO


-- VISTA 4: Detalle de productos por proyecto
CREATE VIEW vw_Detalle_Productos_Proyecto AS
SELECT
    p.Id_proyecto,
    c.NombreC + ' ' + c.ApellidoC AS Cliente,
    pr.NombreP AS Producto,
    pr.Categoria,
    pr.Marca,
    dp.Cantidad,
    pr.Precio_unitario,
    dp.Observaciones_tecnicas
FROM detalle_proyecto dp
JOIN proyecto p ON dp.Id_proyecto = p.Id_proyecto
JOIN cliente c ON p.Id_cliente = c.Id_cliente
JOIN producto pr ON dp.Id_producto = pr.Id_producto;
GO


-- VISTA 5: Resumen de ventas por asesor
CREATE VIEW vw_Ventas_Por_Asesor AS
SELECT
    a.Id_asesor,
    a.NombreA + ' ' + a.ApellidoA AS Asesor,
    COUNT(p.Id_proyecto) AS Cantidad_Proyectos,
    SUM(p.Monto) AS Total_Bruto,
    SUM(dbo.fn_CalcularMontoFinal(p.Monto, p.Descuento)) AS Total_Final
FROM asesor a
JOIN proyecto p ON a.Id_asesor = p.Id_asesor
GROUP BY a.Id_asesor, a.NombreA, a.ApellidoA;
GO

SELECT * FROM vw_Proyectos_Detalle;
SELECT * FROM vw_Entregas_Proyecto;
SELECT * FROM vw_Satisfaccion_Clientes;
SELECT * FROM vw_Detalle_Productos_Proyecto;
SELECT * FROM vw_Ventas_Por_Asesor;



----INSERCION COMPLEJA 
CREATE PROCEDURE sp_RegistrarProyectoCompleto
    @Id_cliente INT,
    @Id_asesor INT,
    @Monto DECIMAL(12,2),
    @Descuento DECIMAL(12,2),
    @Fecha_entrega DATE,
    @Medio VARCHAR(50),
    @Comentario VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO proyecto
        (Id_cliente, Id_asesor, Fecha_de_inicio, Estado, Monto, Descuento, Fecha_de_entrega)
        VALUES
        (@Id_cliente, @Id_asesor, GETDATE(), 'Pendiente', @Monto, @Descuento, @Fecha_entrega);

        INSERT INTO Interaccion
        (Id_cliente, Id_asesor, Fecha_Interaccion, Medio, Comentarios, Estado_de_venta)
        VALUES
        (@Id_cliente, @Id_asesor, GETDATE(), @Medio, @Comentario, 'Pendiente');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


EXEC sp_RegistrarProyectoCompleto
    @Id_cliente = 1,
    @Id_asesor = 11,
    @Monto = 1250000,
    @Descuento = 10,
    @Fecha_entrega = '2026-09-10',
    @Medio = 'WhatsApp',
    @Comentario = 'Nuevo proyecto cocina integral';

EXEC sp_RegistrarProyectoCompleto
    @Id_cliente = 2,
    @Id_asesor = 12,
    @Monto = 980000,
    @Descuento = 5,
    @Fecha_entrega = '2026-09-18',
    @Medio = 'Email',
    @Comentario = 'Cliente solicita presupuesto';

EXEC sp_RegistrarProyectoCompleto
    @Id_cliente = 3,
    @Id_asesor = 13,
    @Monto = 1650000,
    @Descuento = 15,
    @Fecha_entrega = '2026-10-05',
    @Medio = 'Telefono',
    @Comentario = 'Consulta por placard y vestidor';


    SELECT * FROM proyecto;
SELECT * FROM Interaccion;

---- Consulta parametrizada de entregas

CREATE PROCEDURE sp_EntregasPorEstado
    @Estado VARCHAR(50)
AS
BEGIN
    SELECT
        e.Id_entrega,
        e.Id_proyecto,
        e.fecha_programada,
        e.fecha_real,
        e.direccion_entrega,
        e.estado
    FROM entrega e
    WHERE e.estado = @Estado;
END;
GO

EXEC sp_EntregasPorEstado 'Pendiente';
EXEC sp_EntregasPorEstado 'Completada';