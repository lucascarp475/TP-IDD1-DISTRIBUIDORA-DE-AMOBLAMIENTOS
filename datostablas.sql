-- EJEMPLOS DE DATOS PARA INSERTAR EN LAS TABLAS.

-- =========================
-- CLIENTES
-- =========================
INSERT INTO cliente VALUES
(1,'Juan','Perez','juanperez@gmail.com',1122334455,'Av. Rivadavia 1234','WhatsApp'),
(2,'Maria','Lopez','marialopez@gmail.com',1133445566,'San Martin 456','Email'),
(3,'Carlos','Gomez','carlosgomez@gmail.com',1144556677,'Belgrano 789','Telefono'),
(4,'Lucia','Fernandez','luciaf@gmail.com',1155667788,'Cabildo 321','WhatsApp'),
(5,'Martin','Diaz','martind@gmail.com',1166778899,'Mitre 654','Email'),
(6,'Ana','Torres','anatorres@gmail.com',1177889900,'Corrientes 100','Telefono'),
(7,'Pedro','Ruiz','pedror@gmail.com',1188990011,'Lavalle 555','WhatsApp'),
(8,'Sabrina','Mendez','smendez@gmail.com',1199001122,'Callao 890','Email'),
(9,'Federico','Castro','fcastro@gmail.com',1111222233,'Santa Fe 742','Telefono'),
(10,'Julieta','Silva','julietas@gmail.com',1122446688,'Pueyrredon 999','WhatsApp');


-- =========================
-- ASESORES
-- =========================
INSERT INTO asesor VALUES
(1,'Sofia','Ramirez','sramirez@empresa.com',1177000001),
(2,'Diego','Martinez','dmartinez@empresa.com',1177000002),
(3,'Valentina','Suarez','vsuarez@empresa.com',1177000003),
(4,'Nicolas','Herrera','nherrera@empresa.com',1177000004),
(5,'Camila','Romero','cromero@empresa.com',1177000005),
(6,'Lucas','Vega','lvega@empresa.com',1177000006),
(7,'Martina','Rojas','mrojas@empresa.com',1177000007),
(8,'Tomas','Navarro','tnavarro@empresa.com',1177000008),
(9,'Florencia','Acosta','facosta@empresa.com',1177000009),
(10,'Ivan','Medina','imedina@empresa.com',1177000010);


-- =========================
-- PROYECTOS
-- =========================
INSERT INTO proyecto VALUES
(1,1,1,'2026-01-10','Finalizado',1800000,10,'2026-02-15'),
(2,2,2,'2026-01-18','En proceso',2400000,5,'2026-03-20'),
(3,3,1,'2026-02-01','Pendiente',980000,0,'2026-04-01'),
(4,4,3,'2026-02-12','Finalizado',1470000,15,'2026-03-05'),
(5,5,2,'2026-03-01','En proceso',1950000,8,'2026-04-15'),
(6,6,4,'2026-03-05','Finalizado',2200000,12,'2026-04-10'),
(7,7,5,'2026-03-11','Pendiente',850000,0,'2026-05-01'),
(8,8,6,'2026-03-20','En proceso',3100000,7,'2026-05-25'),
(9,9,7,'2026-04-02','Finalizado',2750000,10,'2026-05-15'),
(10,10,8,'2026-04-08','En proceso',1650000,5,'2026-06-01');


-- =========================
-- INTERACCIONES
-- =========================
INSERT INTO Interacción VALUES
(1,1,1,'2026-01-05','WhatsApp','Consulta inicial','Interesado'),
(2,1,1,'2026-01-08','Email','Envio presupuesto','En negociacion'),
(3,2,2,'2026-01-15','Telefono','Consulta cocina','Interesado'),
(4,3,1,'2026-01-28','WhatsApp','Solicita descuento','Pendiente'),
(5,4,3,'2026-02-05','Presencial','Firma contrato','Cerrada'),
(6,5,2,'2026-02-20','Email','Consulta tecnica','Interesado'),
(7,6,4,'2026-03-02','Telefono','Confirma compra','Cerrada'),
(8,7,5,'2026-03-10','WhatsApp','Solicita visita','Interesado'),
(9,8,6,'2026-03-18','Email','Aprueba diseño','En negociacion'),
(10,9,7,'2026-03-29','Presencial','Entrega señal','Cerrada');


-- =========================
-- ENTREGAS
-- =========================
INSERT INTO entrega VALUES
(1,1,3,'Entrega completa'),
(2,2,2,'Falta instalacion'),
(3,3,1,'Pendiente aprobacion'),
(4,4,4,'Sin observaciones'),
(5,5,2,'Demora por proveedor'),
(6,6,3,'Entrega parcial'),
(7,7,1,'Pendiente'),
(8,8,5,'Instalacion programada'),
(9,9,4,'Entrega correcta'),
(10,10,2,'Requiere ajuste');


-- =========================
-- ENCUESTAS
-- =========================
INSERT INTO encuesta VALUES
(1,1,'2026-02-20',9,'Muy conforme','SI'),
(2,2,'2026-03-25',7,'Buena atencion','SI'),
(3,3,'2026-04-05',6,'Demora en entrega','NO'),
(4,4,'2026-03-10',10,'Excelente servicio','SI'),
(5,5,'2026-04-20',8,'Buen resultado','SI'),
(6,6,'2026-04-15',9,'Muy recomendable','SI'),
(7,7,'2026-05-05',5,'Falta comunicacion','NO'),
(8,8,'2026-05-30',8,'Muy buen diseño','SI'),
(9,9,'2026-05-18',10,'Todo perfecto','SI'),
(10,10,'2026-06-05',7,'Buen trabajo','SI');


-- =========================
-- DOCUMENTACION
-- =========================
INSERT INTO documentación VALUES
(1,1,'Contrato','contrato1.pdf','/docs/contratos','2026-01-09'),
(2,2,'Plano','plano2.pdf','/docs/planos','2026-01-18'),
(3,3,'Render','render3.jpg','/docs/renders','2026-02-01'),
(4,4,'Factura','factura4.pdf','/docs/facturas','2026-02-15'),
(5,5,'Presupuesto','presupuesto5.pdf','/docs/presupuestos','2026-03-01'),
(6,6,'Contrato','contrato6.pdf','/docs/contratos','2026-03-06'),
(7,7,'Plano','plano7.pdf','/docs/planos','2026-03-12'),
(8,8,'Render','render8.jpg','/docs/renders','2026-03-22'),
(9,9,'Factura','factura9.pdf','/docs/facturas','2026-04-05'),
(10,10,'Presupuesto','presupuesto10.pdf','/docs/presupuestos','2026-04-10');


-- =========================
-- DETALLE_PROYECTO
-- =========================
INSERT INTO detalle_proyecto VALUES
(1,1,1,'Bajo mesada principal'),
(1,2,1,'Alacena superior'),
(2,3,1,'Isla moderna'),
(2,8,1,'Anafe instalado'),
(3,5,1,'Vestidor completo'),
(4,4,2,'Placares corredizos'),
(5,7,1,'Horno digital'),
(6,9,1,'Campana acero inoxidable'),
(7,6,2,'Placard juvenil'),
(8,10,1,'Lavavajillas premium'),
(9,1,1,'Bajo mesada compacto'),
(10,3,1,'Isla central blanca');
