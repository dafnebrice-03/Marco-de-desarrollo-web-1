-- ================================================================
-- SCRIPT DE CREACIÓN - BASE DE DATOS SOBRERUEDAS PARA SQL SERVER
-- Preparado para: DESKTOP-P99LE3N\SQLEXPRESS
-- Usuario: Sebastian | Contraseña: Sebastian
-- ================================================================

-- Cambiar a base de datos master para crear nueva BD
USE master;
GO

-- Verificar si existe y eliminar (OPCIONAL - comentar si no deseas perder datos)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'sobreruedas')
BEGIN
    ALTER DATABASE sobreruedas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE sobreruedas;
    PRINT '❌ Base de datos anterior eliminada';
END;
GO

-- Crear la base de datos
CREATE DATABASE sobreruedas;
GO

PRINT '✅ Base de datos "sobreruedas" creada';
GO

USE sobreruedas;
GO

-- ================================================================
-- 1. TABLA: USUARIOS
-- ================================================================
CREATE TABLE usuarios (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    fecha_registro DATETIME2 DEFAULT GETDATE(),
    activo BIT DEFAULT 1,
    INDEX idx_email (email),
    INDEX idx_activo (activo)
);

PRINT '✅ Tabla USUARIOS creada';
GO

-- ================================================================
-- 2. TABLA: DESTINOS
-- ================================================================
CREATE TABLE destinos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX),
    region NVARCHAR(100) NOT NULL,
    precio_base DECIMAL(10, 2) NOT NULL,
    imagen_url NVARCHAR(300),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    INDEX idx_region (region),
    INDEX idx_activo (activo)
);

PRINT '✅ Tabla DESTINOS creada';
GO

-- ================================================================
-- 3. TABLA: PAQUETES
-- ================================================================
CREATE TABLE paquetes (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NVARCHAR(MAX),
    destino_id BIGINT NOT NULL,
    duracion_dias INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    incluye NVARCHAR(MAX),
    imagen_url NVARCHAR(300),
    activo BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (destino_id) REFERENCES destinos(id) ON DELETE CASCADE,
    INDEX idx_destino (destino_id),
    INDEX idx_activo (activo)
);

PRINT '✅ Tabla PAQUETES creada';
GO

-- ================================================================
-- 4. TABLA: RESERVAS
-- ================================================================
CREATE TABLE reservas (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    paquete_id BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    cantidad_personas INT NOT NULL,
    precio_total DECIMAL(10, 2) NOT NULL,
    estado NVARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, CONFIRMADA, CANCELADA
    fecha_reserva DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (paquete_id) REFERENCES paquetes(id) ON DELETE CASCADE,
    INDEX idx_usuario (usuario_id),
    INDEX idx_paquete (paquete_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha_reserva (fecha_reserva)
);

PRINT '✅ Tabla RESERVAS creada';
GO

-- ================================================================
-- 5. TABLA: CONTACTOS
-- ================================================================
CREATE TABLE contactos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL,
    asunto NVARCHAR(200) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    telefono NVARCHAR(20),
    leido BIT DEFAULT 0,
    fecha_envio DATETIME2 DEFAULT GETDATE(),
    INDEX idx_email (email),
    INDEX idx_leido (leido)
);

PRINT '✅ Tabla CONTACTOS creada';
GO

-- ================================================================
-- 6. TABLA: PAGOS
-- ================================================================
CREATE TABLE pagos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    reserva_id BIGINT NOT NULL,
    cantidad DECIMAL(10, 2) NOT NULL,
    metodo_pago NVARCHAR(50), -- TARJETA, TRANSFERENCIA, EFECTIVO
    estado_pago NVARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, COMPLETADO, RECHAZADO
    referencia_transaccion NVARCHAR(100),
    fecha_pago DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
    INDEX idx_reserva (reserva_id),
    INDEX idx_estado_pago (estado_pago)
);

PRINT '✅ Tabla PAGOS creada';
GO

-- ================================================================
-- 7. TABLA: ACTIVIDADES_LOG
-- ================================================================
CREATE TABLE actividades_log (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    usuario_id BIGINT,
    tipo_actividad NVARCHAR(100), -- LOGIN, LOGOUT, RESERVA, PAGO, etc.
    descripcion NVARCHAR(MAX),
    ip_address NVARCHAR(45),
    fecha DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_usuario (usuario_id),
    INDEX idx_tipo_actividad (tipo_actividad)
);

PRINT '✅ Tabla ACTIVIDADES_LOG creada';
GO

-- ================================================================
-- 8. INSERTAR DATOS DE EJEMPLO
-- ================================================================

INSERT INTO destinos (nombre, descripcion, region, precio_base, imagen_url)
VALUES 
    ('Cusco - Machu Picchu', 'La ciudad perdida de los Incas', 'Cusco', 500.00, '/images/Imagen3.webp'),
    ('Huaraz - Cordillera Blanca', 'Montañas y lagunas de ensueño', 'Áncash', 400.00, '/images/Imagen38.jpg'),
    ('Arequipa - Volcanes', 'Paisajes volcánicos impresionantes', 'Arequipa', 350.00, '/images/Imagen26.jpg'),
    ('Puno - Titicaca', 'El lago navegable más alto del mundo', 'Puno', 300.00, '/images/Imagen9.jpeg');

PRINT '✅ Destinos insertados';
GO

INSERT INTO paquetes (nombre, descripcion, destino_id, duracion_dias, precio, incluye)
VALUES 
    ('Machu Picchu Express', 'Visita a la ciudadela en 3 días', 1, 3, 1200.00, 'Hotel, Guía, Transporte, Comidas'),
    ('Cordillera Blanca', 'Trekking y lagunas glaciares', 2, 5, 1800.00, 'Hotel, Guía, Todas las comidas'),
    ('Arequipa Completo', 'Ciudad, volcanes y cañón', 3, 4, 1400.00, 'Hotel, Visitas guiadas, Transporte'),
    ('Islas del Titicaca', 'Islas flotantes y comunidades locales', 4, 2, 800.00, 'Hotel, Transporte, Guía');

PRINT '✅ Paquetes insertados';
GO

-- Usuario de prueba (contraseña encriptada con bcrypt)
-- Usuario: admin@sobreruedas.com, Contraseña: Prueba123!
INSERT INTO usuarios (nombre, email, password, fecha_registro)
VALUES 
    ('Administrador Sistema', 'admin@sobreruedas.com', '$2a$10$SlVZVnVWVmhWa0hVVllWVufXlsQx4u1w0XQsZLZZqZ8G6XyZKd4NK', GETDATE());

PRINT '✅ Usuario de prueba creado (admin@sobreruedas.com / Prueba123!)';
GO

-- ================================================================
-- 9. CREAR VISTAS
-- ================================================================

CREATE VIEW vw_reservas_detalladas AS
SELECT 
    r.id,
    u.nombre as usuario_nombre,
    u.email,
    d.nombre as destino_nombre,
    pk.nombre as paquete_nombre,
    r.fecha_inicio,
    r.fecha_fin,
    r.cantidad_personas,
    r.precio_total,
    r.estado,
    r.fecha_reserva
FROM reservas r
INNER JOIN usuarios u ON r.usuario_id = u.id
INNER JOIN paquetes pk ON r.paquete_id = pk.id
INNER JOIN destinos d ON pk.destino_id = d.id;

PRINT '✅ Vista VW_RESERVAS_DETALLADAS creada';
GO

CREATE VIEW vw_resumen_ventas AS
SELECT 
    CONVERT(DATE, r.fecha_reserva) as fecha,
    COUNT(r.id) as cantidad_reservas,
    SUM(r.precio_total) as monto_total,
    COUNT(DISTINCT r.usuario_id) as usuarios_distintos
FROM reservas r
WHERE r.estado = 'CONFIRMADA'
GROUP BY CONVERT(DATE, r.fecha_reserva);

PRINT '✅ Vista VW_RESUMEN_VENTAS creada';
GO

-- ================================================================
-- 10. VERIFICACIÓN FINAL
-- ================================================================

PRINT '';
PRINT '╔════════════════════════════════════════════════════════╗';
PRINT '║ ✅ BASE DE DATOS CREADA EXITOSAMENTE                  ║';
PRINT '╚════════════════════════════════════════════════════════╝';
PRINT '';

SELECT 
    'Base de Datos: sobreruedas' as Información,
    COUNT(*) as [Total de Tablas]
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
GROUP BY TABLE_SCHEMA;

PRINT '';
PRINT '📊 Tablas creadas:';
SELECT 
    TABLE_NAME as 'Tabla',
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) as 'Columnas'
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '📝 Vistas creadas:';
SELECT TABLE_NAME as 'Vista'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '👤 Usuarios en la BD:';
SELECT id, nombre, email, activo, fecha_registro FROM usuarios;

PRINT '';
PRINT '🏖️ Destinos cargados:';
SELECT id, nombre, region, precio_base FROM destinos ORDER BY id;

PRINT '';
PRINT '📦 Paquetes disponibles:';
SELECT id, nombre, duracion_dias, precio FROM paquetes ORDER BY id;

PRINT '';
PRINT '═══════════════════════════════════════════════════════';
PRINT '✨ LISTO PARA USAR CON SPRING BOOT ✨';
PRINT '═══════════════════════════════════════════════════════';
