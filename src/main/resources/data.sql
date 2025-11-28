-- Insertar usuarios de prueba
INSERT INTO usuarios (nombre, email, password, fecha_registro) VALUES
('Juan Pérez', 'juan@email.com', '$2a$10$1234567890123456789012uQD5YyJq5q5q5q5q5q5q5q5q5q5q5q5q', '2025-10-01 10:00:00'),
('María García', 'maria@email.com', '$2a$10$1234567890123456789012uQD5YyJq5q5q5q5q5q5q5q5q5q5q5q5q', '2025-10-05 15:30:00'),
('Carlos López', 'carlos@email.com', '$2a$10$1234567890123456789012uQD5YyJq5q5q5q5q5q5q5q5q5q5q5q5q', '2025-10-10 09:15:00'),
('Ana Martínez', 'ana@email.com', '$2a$10$1234567890123456789012uQD5YyJq5q5q5q5q5q5q5q5q5q5q5q5q', '2025-10-15 14:45:00'),
('Luis Torres', 'luis@email.com', '$2a$10$1234567890123456789012uQD5YyJq5q5q5q5q5q5q5q5q5q5q5q5q', '2025-10-20 11:20:00'),
('Sebastian', 'sebastian@gmail.com', '$2a$10$PkV60V7sQLM9JJqbGxBXJeUTPgrUGCWn2x9WYL/FqI0jKmQYALpMK', '2025-10-20 11:20:00');

-- Insertar paquetes turísticos
INSERT INTO paquetes (nombre, descripcion, precio, duracion_dias, fecha_inicio, fecha_fin, cupo_maximo, cupo_disponible, imagen_url) VALUES
('Tour Machu Picchu', 'Explora las ruinas incas más famosas del mundo', 599.99, 3, '2025-11-01', '2025-11-03', 20, 15, '/images/Imagen1.jpg'),
('Aventura en Amazonas', 'Descubre la selva amazónica y su biodiversidad', 799.99, 4, '2025-11-05', '2025-11-08', 15, 10, '/images/Imagen2.jpeg'),
('Playas del Norte', 'Relájate en las mejores playas del Perú', 449.99, 5, '2025-11-10', '2025-11-14', 25, 20, '/images/Imagen3.webp'),
('Líneas de Nazca', 'Vista aérea de los misteriosos geoglifos', 299.99, 2, '2025-11-15', '2025-11-16', 10, 8, '/images/Imagen4.jpg'),
('Valle del Colca', 'Observa el vuelo del Cóndor en el cañón más profundo', 399.99, 3, '2025-11-20', '2025-11-22', 18, 12, '/images/Imagen5.jpg');

-- Insertar reservas con diferentes estados
INSERT INTO reservas (nombre_cliente, paquete, personas, email, telefono, mensaje, fecha_reserva, estado) VALUES
('Juan Pérez', 'Tour Machu Picchu', 2, 'juan@email.com', '987654321', 'Esperando confirmación de vuelos', '2025-10-02 11:30:00', 'CONFIRMADA'),
('María García', 'Aventura en Amazonas', 3, 'maria@email.com', '987654322', 'Necesito información sobre el clima', '2025-10-06 14:20:00', 'PENDIENTE'),
('Carlos López', 'Playas del Norte', 4, 'carlos@email.com', '987654323', 'Solicito habitaciones contiguas', '2025-10-11 09:45:00', 'CONFIRMADA'),
('Ana Martínez', 'Líneas de Nazca', 2, 'ana@email.com', '987654324', 'Tengo restricciones alimentarias', '2025-10-16 16:15:00', 'CANCELADA'),
('Luis Torres', 'Valle del Colca', 3, 'luis@email.com', '987654325', 'Necesito transporte desde el aeropuerto', '2025-10-21 10:50:00', 'CONFIRMADA'),
('Pedro Ramírez', 'Tour Machu Picchu', 2, 'pedro@email.com', '987654326', 'Viaje de aniversario', '2025-10-22 13:40:00', 'PENDIENTE'),
('Carmen Díaz', 'Aventura en Amazonas', 5, 'carmen@email.com', '987654327', 'Grupo familiar', '2025-10-23 15:25:00', 'CONFIRMADA'),
('Roberto Silva', 'Playas del Norte', 2, 'roberto@email.com', '987654328', 'Luna de miel', '2025-10-24 11:10:00', 'CANCELADA'),
('Diana Castro', 'Valle del Colca', 4, 'diana@email.com', '987654329', 'Viaje corporativo', '2025-10-25 14:30:00', 'CONFIRMADA'),
('Miguel Ríos', 'Líneas de Nazca', 3, 'miguel@email.com', '987654330', 'Tour fotográfico', '2025-10-26 12:15:00', 'PENDIENTE');