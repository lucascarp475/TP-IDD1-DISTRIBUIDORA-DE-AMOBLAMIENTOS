-- CONSULTAS CON JOIN:

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

SELECT
    Estado,
    COUNT(*) AS Cantidad_Proyectos
FROM proyecto
GROUP BY Estado;


SELECT
    Medio_de_contacto,
    COUNT(*) AS Cantidad_Clientes
FROM cliente
GROUP BY Medio_de_contacto;


SELECT
    Id_asesor,
    COUNT(*) AS Cantidad_Proyectos
FROM proyecto
GROUP BY Id_asesor;


SELECT
    Id_asesor,
    SUM(Monto) AS Total_Vendido
FROM proyecto
GROUP BY Id_asesor;


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
