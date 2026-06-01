-- =============================================
-- EMPEZAR DE 0
-- =============================================

USE master
GO

DROP DATABASE tpgrupal
GO

CREATE DATABASE tpgrupal
GO

USE tpgrupal
GO

-- =============================================
-- BORRAR TRIGGERS
-- =============================================

USE tpgrupal
GO

DROP TRIGGER IF EXISTS trg_ValidarEncuesta
DROP TRIGGER IF EXISTS trg_InteraccionAlCrearProyecto  
DROP TRIGGER IF EXISTS trg_BloquearBorradoProyecto
GO

-- =============================================
-- TABLAS
-- =============================================

CREATE TABLE cliente(
    Id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Email VARCHAR(50),
    Telefono VARCHAR(20),
    Direccion VARCHAR(50),
    Medio_de_contacto VARCHAR(50) CHECK (Medio_de_contacto IN('WhatsApp','Telefono','Email'))
);

CREATE TABLE asesor(
    Id_asesor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Email VARCHAR(50),
    Telefono VARCHAR(20)
);

CREATE TABLE proyecto(
    Id_proyecto INT IDENTITY(1,1) PRIMARY KEY,
    Id_cliente INT,
    Id_asesor INT,
    Fecha_de_inicio DATE,
    Estado VARCHAR(50) CHECK(Estado IN('Finalizado','Pendiente','En proceso')),
    Monto INT,
    Descuento INT,
    Fecha_de_entrega DATE,
    FOREIGN KEY (Id_cliente) REFERENCES cliente(Id_cliente),
    FOREIGN KEY (Id_asesor) REFERENCES asesor(Id_asesor)
);

CREATE TABLE Interaccion(
    Id_interaccion INT IDENTITY(1,1) PRIMARY KEY,
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
    Id_entrega INT IDENTITY(1,1) PRIMARY KEY,
    Id_proyecto INT,
    Cantidad INT,
    Observaciones_tecnicas VARCHAR(100),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);

CREATE TABLE encuesta(
    Id_encuesta INT IDENTITY(1,1) PRIMARY KEY,
    Id_proyecto INT,
    Fecha DATE,
    Puntuacion INT,
    Comentarios VARCHAR(50),
    Volveria_a_comprar VARCHAR(2) CHECK(Volveria_a_comprar IN('SI','NO')),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);

CREATE TABLE producto(
    Id_producto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50),
    Categoria VARCHAR(50),
    Marca VARCHAR(50),
    Descripcion VARCHAR(100),
    Precio_unitario INT
);

CREATE TABLE detalle_proyecto(
    Id_proyecto INT,
    Id_producto INT,
    Cantidad INT,
    Observaciones_tecnicas VARCHAR(200),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto),
    FOREIGN KEY (Id_producto) REFERENCES producto(Id_producto)
);

-- =============================================
-- FIX TABLAS
-- =============================================

USE tpgrupal
GO

CREATE TABLE Interaccion(
    Id_interaccion INT IDENTITY(1,1) PRIMARY KEY,
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
    Id_entrega INT IDENTITY(1,1) PRIMARY KEY,
    Id_proyecto INT,
    Cantidad INT,
    Observaciones_tecnicas VARCHAR(100),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);

CREATE TABLE encuesta(
    Id_encuesta INT IDENTITY(1,1) PRIMARY KEY,
    Id_proyecto INT,
    Fecha DATE,
    Puntuacion INT,
    Comentarios VARCHAR(50),
    Volveria_a_comprar VARCHAR(2) CHECK(Volveria_a_comprar IN('SI','NO')),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto)
);

CREATE TABLE producto(
    Id_producto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50),
    Categoria VARCHAR(50),
    Marca VARCHAR(50),
    Descripcion VARCHAR(100),
    Precio_unitario INT
);

CREATE TABLE detalle_proyecto(
    Id_proyecto INT,
    Id_producto INT,
    Cantidad INT,
    Observaciones_tecnicas VARCHAR(200),
    FOREIGN KEY (Id_proyecto) REFERENCES proyecto(Id_proyecto),
    FOREIGN KEY (Id_producto) REFERENCES producto(Id_producto)
);

-- =============================================
-- TRIGGERS
-- =============================================

-- =============================================
-- TRIGGER 1
-- =============================================

USE tpgrupal
GO

DROP TRIGGER IF EXISTS trg_ValidarEncuesta
GO

CREATE TRIGGER trg_ValidarEncuesta
ON encuesta
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN proyecto p ON i.Id_proyecto = p.Id_proyecto
        WHERE p.Estado != 'Finalizado'
    )
    BEGIN
        RAISERROR('Solo se puede encuestar proyectos finalizados.', 16, 1)
        ROLLBACK
        RETURN
    END

    INSERT INTO encuesta (Id_proyecto, Fecha, Puntuacion, Comentarios, Volveria_a_comprar)
    SELECT Id_proyecto, Fecha, Puntuacion, Comentarios, Volveria_a_comprar
    FROM inserted
END
GO

-- =============================================
-- TRIGGER 2: Registrar interacción automática
-- al crear un proyecto nuevo
-- =============================================
CREATE TRIGGER trg_InteraccionAlCrearProyecto
ON proyecto
AFTER INSERT
AS
BEGIN
    INSERT INTO Interaccion (Id_cliente, Id_asesor, Fecha, Medio, Comentarios, Estado_de_venta)
    SELECT 
        i.Id_cliente,
        i.Id_asesor,
        GETDATE(),
        'Sistema',
        'Proyecto creado automaticamente',
        'Cerrada'
    FROM inserted i
END
GO

-- =============================================
-- TRIGGER 3: Bloquear borrado de proyectos
-- con entregas o encuestas asociadas
-- =============================================
CREATE TRIGGER trg_BloquearBorradoProyecto
ON proyecto
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM entrega e
        JOIN deleted d ON e.Id_proyecto = d.Id_proyecto
    )
    OR EXISTS (
        SELECT 1 FROM encuesta en
        JOIN deleted d ON en.Id_proyecto = d.Id_proyecto
    )
    BEGIN
        RAISERROR('No se puede eliminar un proyecto con entregas o encuestas registradas.', 16, 1)
        RETURN
    END

    DELETE FROM proyecto
    WHERE Id_proyecto IN (SELECT Id_proyecto FROM deleted)
END
GO

-- =============================================
-- SELECT PARA VER TABLAS
-- =============================================

USE tpgrupal
GO

SELECT name FROM sys.tables ORDER BY name

-- =============================================
-- BORRAR TRIGGERS
-- =============================================

USE tpgrupal
GO

DROP TRIGGER IF EXISTS trg_ValidarEncuesta
DROP TRIGGER IF EXISTS trg_InteraccionAlCrearProyecto  
DROP TRIGGER IF EXISTS trg_BloquearBorradoProyecto
GO