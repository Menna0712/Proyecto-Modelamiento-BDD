CREATE DATABASE IF NOT EXISTS usm_postulaciones;
USE usm_postulaciones;

-- =========================================
-- CREACIÓN DE CATÁLOGOS
-- =========================================

CREATE TABLE region (
    id_region INT PRIMARY KEY,
    nombre_region VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE sede (
    id_sede INT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tamano_empresa (
    id_tamano INT PRIMARY KEY,
    des_empresa VARCHAR(50) NOT NULL -- Microempresa, Mediana, Grande
) ENGINE=InnoDB;

CREATE TABLE tipo_iniciativa (
    id_tipo_iniciativa INT PRIMARY KEY,
    des_iniciativa VARCHAR(50) NOT NULL -- Nueva, Existente
) ENGINE=InnoDB;

CREATE TABLE tipo_integrante (
    id_tipo_integrante INT PRIMARY KEY,
    des_integrante VARCHAR(50) NOT NULL -- Profesor, Estudiante
) ENGINE=InnoDB;

CREATE TABLE estado_postulacion (
    id_estado INT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL -- En Revisión, Aprobada, Rechazada, Cerrada
) ENGINE=InnoDB;


-- =========================================
-- CREACIÓN DE ENTIDADES 
-- =========================================

CREATE TABLE empresa (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    rut_empresa VARCHAR(15) UNIQUE NOT NULL,
    nombre_empresa VARCHAR(100) NOT NULL,
    id_tamano INT NOT NULL,
    nombre_representante VARCHAR(100) NOT NULL,
    mail_representante VARCHAR(100) NOT NULL,
    telefono_representante VARCHAR(20) NOT NULL,
    convenio_marco BOOLEAN NOT NULL, -- True (1) para Sí, False (0) para No
    FOREIGN KEY (id_tamano) REFERENCES tamano_empresa(id_tamano)
) ENGINE=InnoDB;

CREATE TABLE postulacion (
    id_postulacion INT AUTO_INCREMENT PRIMARY KEY,
    fecha_postulacion DATE NOT NULL,
    id_sede INT NOT NULL,
    id_region_ejecucion INT NOT NULL,
    id_region_impacto INT NOT NULL,
    jefe_carrera VARCHAR(100) NOT NULL,
    coordinador_proyectos VARCHAR(100) NOT NULL,
    rut_empresa VARCHAR(15) NOT NULL,
    id_tipo_iniciativa INT NOT NULL,
    nombre_iniciativa VARCHAR(150) NOT NULL,
    objetivo VARCHAR(255) NOT NULL,
    descripcion_solucion VARCHAR(255) NOT NULL,
    resultados_esperados VARCHAR(255) NOT NULL,
    id_estado INT NOT NULL,
    presupuesto_total INT NOT NULL,
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede),
    FOREIGN KEY (id_region_ejecucion) REFERENCES region(id_region),
    FOREIGN KEY (id_region_impacto) REFERENCES region(id_region),
    FOREIGN KEY (rut_empresa) REFERENCES empresa(rut_empresa),
    FOREIGN KEY (id_tipo_iniciativa) REFERENCES tipo_iniciativa(id_tipo_iniciativa),
    FOREIGN KEY (id_estado) REFERENCES estado_postulacion(id_estado)
) ENGINE=InnoDB;

CREATE TABLE equipo_de_trabajo (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    id_postulacion INT NOT NULL,
    FOREIGN KEY (id_postulacion) REFERENCES postulacion(id_postulacion)
) ENGINE=InnoDB;

CREATE TABLE integrante (
    id_integrante INT AUTO_INCREMENT PRIMARY KEY,
    id_equipo INT NOT NULL,
    rut_integrante VARCHAR(15) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    departamento_area VARCHAR(100) NOT NULL,
    id_sede INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20), 
    id_tipo_integrante INT NOT NULL,
    FOREIGN KEY (id_sede) REFERENCES sede(id_sede),
    FOREIGN KEY (id_tipo_integrante) REFERENCES tipo_integrante(id_tipo_integrante),
    FOREIGN KEY (id_equipo) REFERENCES equipo_de_trabajo(id_equipo) 
) ENGINE=InnoDB;

CREATE TABLE etapa (
    id_etapa INT AUTO_INCREMENT PRIMARY KEY,
    id_postulacion INT NOT NULL,
    nombre_etapa VARCHAR(100) NOT NULL,
    plazos_semanas INT NOT NULL,
    entregable VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_postulacion) REFERENCES postulacion(id_postulacion)
) ENGINE=InnoDB;

-- =========================================
-- POBLAMIENTO DE CATÁLOGOS
-- =========================================

-- Regiones 1-16
INSERT INTO region (id_region, nombre_region) VALUES
(1, 'Región de Tarapacá'),
(2, 'Región de Antofagasta'),
(3, 'Región de Atacama'),
(4, 'Región de Coquimbo'),
(5, 'Región de Valparaíso'),
(6, 'Región del Libertador Gral. Bernardo O''Higgins'),
(7, 'Región del Maule'),
(8, 'Región del Biobío'),
(9, 'Región de La Araucanía'),
(10, 'Región de Los Lagos'),
(11, 'Región de Aysén del Gral. Carlos Ibáñez del Campo'),
(12, 'Región de Magallanes y de la Antártica Chilena'),
(13, 'Región Metropolitana de Santiago'),
(14, 'Región de Los Ríos'),
(15, 'Región de Arica y Parinacota'),
(16, 'Región de Ñuble');

-- Sedes 1-5
INSERT INTO sede (id_sede, nombre_sede) VALUES
(1, 'Campus Casa Central Valparaíso'),
(2, 'Campus San Joaquín'),
(3, 'Campus Vitacura'),
(4, 'Sede Viña del Mar'),
(5, 'Sede Concepción');

-- Tamaño de la empresa 1-3
INSERT INTO tamano_empresa (id_tamano, des_empresa) VALUES
(1, 'Microempresa'),
(2, 'Mediana'),
(3, 'Grande');

-- Tipo de iniciativa 1-2
INSERT INTO tipo_iniciativa (id_tipo_iniciativa, des_iniciativa) VALUES
(1, 'Nueva'),
(2, 'Existente');

-- Tipo de persona 1-2
INSERT INTO tipo_integrante (id_tipo_integrante, des_integrante) VALUES
(1, 'Profesor'),
(2, 'Estudiante');

-- Estado de la postulación 1-4
INSERT INTO estado_postulacion (id_estado, descripcion) VALUES
(1, 'En Revisión'),
(2, 'Aprobada'),
(3, 'Rechazada'),
(4, 'Cerrada');

-- =========================================
-- POBLAMIENTO DE ENTIDADES 
-- =========================================

-- Empresas (Mezcla de tamaños y convenios 1=Sí, 0=No)
-- Como no somos ingeniosos usamos nuestros propios nombres y de compañeros :)
INSERT INTO empresa (rut_empresa, nombre_empresa, id_tamano, nombre_representante, mail_representante, telefono_representante, convenio_marco) VALUES
('70.111.111-1', 'TechCorp Chile', 3, 'Constanza Rios', 'crios@techcorp.cl', '+56911111111', 1),
('71.222.222-2', 'Futcorp', 2, 'José Mena', 'jmena@futcorp.cl', '+56922222222', 0),
('72.333.333-3', 'Poke Solutions', 1, 'Javier Bravo', 'jbravo@pokesolutions.cl', '+56933333333', 1),
('73.444.444-4', 'Valo-rant', 2, 'Anais Quinchao', 'aquinchao@valo.cl', '+56944444444', 0),
('74.555.555-5', 'Balatro Energy', 3, 'Joaquin Barrios', 'jbarrios@balatro.cl', '+56955555555', 1),
('75.666.666-6', 'Springfield Ltda.', 1, 'Homero Acuña', 'hacuna@springfield.cl', '+56966666666', 0);

-- Poblar Postulaciones
INSERT INTO postulacion (id_postulacion, fecha_postulacion, id_sede, id_region_ejecucion, id_region_impacto, jefe_carrera, coordinador_proyectos, rut_empresa, id_tipo_iniciativa, nombre_iniciativa, objetivo, descripcion_solucion, resultados_esperados, id_estado, presupuesto_total) VALUES
(1, '2026-03-01', 1, 13, 5, 'Constanza Rios', 'José Mena', '70.111.111-1', 1, 'Sistema de Gestión de Inventarios', 'Optimizar el control de stock y reducir pérdidas', 'Implementar un software de gestión con alertas automáticas', 'Reducción del 20% en pérdidas por inventario en el primer año', 1, 50000000),
(2, '2026-03-02', 2, 8, 8, 'Javier Bravo', 'Juan Pedro', '72.333.333-3', 2, 'Plataforma de E-commerce para Pymes', 'Facilitar la venta online para pequeñas empresas', 'Desarrollar una plataforma intuitiva y accesible para pymes', 'Aumento del 30% en ventas online para las pymes usuarias en el primer año', 1, 30000000),
(3, '2026-03-03', 3, 5, 5, 'Anais Quinchao', 'Joaquin Barrios', '73.444.444-4', 1, 'Aplicación de Realidad Aumentada para Turismo', 'Mejorar la experiencia turística con RA', 'Crear una app que ofrezca tours interactivos con RA en sitios turísticos', 'Incremento del 25% en visitas a los sitios turísticos que implementen la app en el primer año', 1, 40000000),
(4, '2026-03-04', 4, 16, 16, 'Joaquin Barrios', 'Joaquin Perez', '74.555.555-5', 2, 'Sistema de Energía Renovable para Hogares', 'Promover el uso de energías limpias en hogares', 'Desarrollar un sistema de paneles solares asequible y fácil de instalar para hogares', 'Reducción del 15% en la factura de electricidad para los hogares que implementen el sistema en el primer año', 1, 60000000),
(5, '2026-03-05', 5, 10, 10, 'Tomas Mora', 'Paula Rios', '75.666.666-6', 1, 'Sistema de Gestión de Proyectos', 'Optimizar la gestión de proyectos en la universidad', 'Desarrollar una plataforma para el seguimiento y control de proyectos académicos', 'Mejora en la eficiencia del proceso de gestión de proyectos en un 25% en el primer año', 1, 45000000),
(6, '2026-03-06', 1, 13, 5, 'Constanza Rios', 'José Mena', '70.111.111-1', 2, 'Sistema de Gestión de Inventarios', 'Optimizar el control de stock y reducir pérdidas', 'Implementar un software de gestión con alertas automáticas', 'Reducción del 20% en pérdidas por inventario en el primer año', 1, 50000000),
(7, '2026-03-07', 2, 8, 8, 'Javier Bravo', 'Juan Pedro', '72.333.333-3', 1, 'Plataforma de E-commerce para Pymes', 'Facilitar la venta online para pequeñas empresas', 'Desarrollar una plataforma intuitiva y accesible para pymes', 'Aumento del 30% en ventas online para las pymes usuarias en el primer año', 1, 30000000),
(8, '2026-03-08', 3, 5, 5, 'Anais Quinchao', 'Joaquin Barrios', '73.444.444-4', 2, 'Aplicación de Realidad Aumentada para Turismo', 'Mejorar la experiencia turística con RA', 'Crear una app que ofrezca tours interactivos con RA en sitios turísticos', 'Incremento del 25% en visitas a los sitios turísticos que implementen la app en el primer año', 1, 40000000),
(9, '2026-03-09', 4, 16, 16, 'Joaquin Barrios', 'Joaquin Perez', '74.555.555-5', 1, 'Sistema de Energía Renovable para Hogares', 'Promover el uso de energías limpias en hogares', 'Desarrollar un sistema de paneles solares asequible y fácil de instalar para hogares', 'Reducción del 15% en la factura de electricidad para los hogares que implementen el sistema en el primer año', 1, 60000000),
(10, '2026-03-10', 5, 10, 10, 'Tomas Mora', 'Paula Rios', '75.666.666-6', 2, 'Sistema de Gestión de Proyectos', 'Optimizar la gestión de proyectos en la universidad', 'Desarrollar una plataforma para el seguimiento y control de proyectos académicos', 'Mejora en la eficiencia del proceso de gestión de proyectos en un 25% en el primer año', 1, 45000000);


INSERT INTO equipo_de_trabajo (id_equipo, id_postulacion) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Poblar Integrantes
-- Nuevamente, nombres de compañeros y profesores porq no se me ocurre nada más :D
INSERT INTO integrante (rut_integrante, id_equipo, nombre, departamento_area, id_sede, email, telefono, id_tipo_integrante) VALUES
('15.111.111-1', 1, ' Mauricio Figueroa', 'Informática', 1, 'mauricio.figueroa@usm.cl', '+56977777771', 1),
('15.222.222-2', 2, ' Sergio Veliz', 'Matemática', 2, 'sergio.veliz@usm.cl', '+56977777772', 1),
('15.333.333-3', 3, ' Hector Duarte', 'Física', 1, 'hector.duarte@usm.cl', '+56977777773', 1),
('15.444.444-4', 4, ' Gaston Droguett', 'Informática', 4, 'gaston.droguett@usm.cl', '+56977777774', 1),
('21.111.111-1', 5, ' Jose Astudillo', 'Informática', 1, 'jose.astudillo@usm.cl', '+56988888881', 1),
('21.222.222-2', 6, ' Rogrigo Rodriguez', 'Mecánica', 2, 'rodrigo.rodriguez@usm.cl', '+56988888882', 1),
('21.333.333-3', 7, ' Carla Soto', 'Telemática', 3, 'carla.soto@usm.cl', '+56988888883', 1),
('21.444.444-4', 8, ' Rodolfo Palma', 'Informática', 1, 'rodolfo.palma@usm.cl', '+56988888884', 1),
('21.555.555-5', 9, ' Paula Rios', 'Diseño', 4, 'paula.rios@usm.cl', '+56988888885', 1),
('21.666.666-6', 10, ' Tomas Mora', 'Arquitectura', 5, 'tomas.mora@usm.cl', '+56933276077', 1),
('15.777.111-1', 1, ' Andrea Pizarro', 'Informática', 1, 'andrea.pizarro@usm.cl', '+56970000011', 1),
('15.777.222-2', 1, ' Claudio Mella', 'Matemática', 2, 'claudio.mella@usm.cl', '+56970000012', 1),
('15.777.333-3', 1, ' Daniela Araya', 'Física', 3, 'daniela.araya@usm.cl', '+56970000013', 2),
('15.777.444-4', 1, ' Eduardo Salinas', 'Química', 4, 'eduardo.salinas@usm.cl', '+56970010054', 2),
('15.777.555-5', 1, ' Francisca Leiva', 'Informática', 5, 'francisca.leiva@usm.cl', '+56970000015', 2),
('15.777.666-6', 1, ' Gabriel Fuentes', 'Electrónica', 1, 'gabriel.fuentes@usm.cl', '+56970000016', 2),
('15.777.777-7', 1, ' Hugo Cisternas', 'Mecánica', 2, 'hugo.cisternas@usm.cl', '+56970000017', 2),
('15.777.888-8', 2, ' Isidora Peña', 'Telemática', 3, 'isidora.pena@usm.cl', '+56970000018', 1),
('15.777.999-9', 2, ' Javier Rojas', 'Arquitectura', 4, 'javier.rojas@usm.cl', '+56970000019', 1),
('15.888.111-1', 2, ' Karina Contreras', 'Diseño', 5, 'karina.contreras@usm.cl', '+56970000020', 2),
('15.888.222-2', 2, ' Luis Villarroel', 'Informática', 1, 'luis.villarroel@usm.cl', '+56970000021', 2),
('15.888.333-3', 2, ' Macarena Tapia', 'Matemática', 2, 'macarena.tapia@usm.cl', '+56970000022', 2),
('15.888.444-4', 2, ' Nicolás Farías', 'Física', 3, 'nicolas.farias@usm.cl', '+56970000023', 2),
('15.888.555-5', 2, ' Olivia Escobar', 'Química', 4, 'olivia.escobar@usm.cl', '+56970000024', 2),
('15.888.666-6', 3, ' Pablo Sepúlveda', 'Electrónica', 5, 'pablo.sepulveda@usm.cl', '+56970000025', 1),
('15.888.777-7', 3, ' Renata Godoy', 'Mecánica', 1, 'renata.godoy@usm.cl', '+56970000026', 1),
('15.888.888-8', 3, ' Sebastián Loyola', 'Telemática', 2, 'sebastian.loyola@usm.cl', '+56970000027', 2),
('15.888.999-9', 3, ' Valentina Saavedra', 'Arquitectura', 3, 'valentina.saavedra@usm.cl', '+56970000028', 2),
('15.999.111-1', 3, ' Walter Herrera', 'Diseño', 4, 'walter.herrera@usm.cl', '+56970000029', 2),
('15.999.222-2', 3, ' Ximena Carrasco', 'Informática', 5, 'ximena.carrasco@usm.cl', '+56970000030', 2),
('22.777.111-1', 3, ' Álvaro Muñoz', 'Informática', 1, 'alvaro.munoz@usm.cl', '+56971000031', 2),
('22.777.222-2', 4, ' Benjamín Silva', 'Mecánica', 2, 'benjamin.silva@usm.cl', '+56971000032', 1),
('22.777.333-3', 4, ' Camila Torres', 'Telemática', 3, 'camila.torres@usm.cl', '+56971000033', 1),
('22.777.444-4', 4, ' Diego Navarro', 'Informática', 4, 'diego.navarro@usm.cl', '+56971000034', 2),
('22.777.555-5', 4, ' Emilia Vergara', 'Diseño', 5, 'emilia.vergara@usm.cl', '+56971000035', 2),
('22.777.666-6', 4, ' Felipe Espindola', 'Biotecnología', 1, 'felipe.espindola@usm.cl', '+56971000036', 2),
('22.777.777-7', 4, ' Gabriela Castro', 'Química', 2, 'gabriela.castro@usm.cl', '+56971000037', 2),
('22.777.888-8', 4, ' Héctor Molina', 'Electrónica', 3, 'hector.molina@usm.cl', '+56971000038', 2),
('22.777.999-9', 5, ' Ignacia Reyes', 'Matemática', 4, 'ignacia.reyes@usm.cl', '+56971000039', 1),
('22.888.111-1', 5, ' Joaquín Bustos', 'Informática', 5, 'joaquin.bustos@usm.cl', '+56971000040', 1),
('22.888.222-2', 5, ' Karla Morales', 'Mecánica', 1, 'karla.morales@usm.cl', '+56971000041', 2),
('22.888.333-3', 5, ' Luciano Vega', 'Telemática', 2, 'luciano.vega@usm.cl', '+56971000042', 2),
('22.888.444-4', 5, ' Martina Soto', 'Informática', 3, 'martina.soto@usm.cl', '+56971000043', 2),
('22.888.555-5', 5, ' Nicolás Delgado', 'Diseño', 4, 'nicolas.delgado@usm.cl', '+56971000044', 2),
('22.888.666-6', 5, ' Olivia Ramírez', 'Arquitectura', 5, 'olivia.ramirez@usm.cl', '+56971000045', 2),
('22.888.777-7', 6, ' Pedro Gallardo', 'Química', 1, 'pedro.gallardo@usm.cl', '+56971000046', 2),
('22.888.888-8', 6, ' Rafaela Cortés', 'Electrónica', 2, 'rafaela.cortes@usm.cl', '+56971000047', 1),
('22.888.999-9', 6, ' Simón Paredes', 'Matemática', 3, 'simon.paredes@usm.cl', '+56971000048', 1),
('22.999.111-1', 6, ' Trinidad Fuenzalida', 'Informática', 4, 'trinidad.fuenzalida@usm.cl', '+56971000049', 2),
('22.999.222-2', 6, ' Vicente Zamora', 'Mecánica', 5, 'vicente.zamora@usm.cl', '+56971000050', 2),
('22.999.333-3', 6, ' Antonia Ibarra', 'Telemática', 1, 'antonia.ibarra@usm.cl', '+56971000051', 2),
('22.999.444-4', 6, ' Bruno Valdés', 'Informática', 2, 'bruno.valdes@usm.cl', '+56971000052', 2),
('22.999.555-5', 7, ' Catalina Arriagada', 'Diseño', 3, 'catalina.arriagada@usm.cl', '+56971000053', 1),
('22.999.666-6', 7, ' Damián Sanhueza', 'Arquitectura', 4, 'damian.sanhueza@usm.cl', '+56971000054', 1),
('22.999.777-7', 7, ' Elena Cáceres', 'Química', 5, 'elena.caceres@usm.cl', '+56971000055', 2),
('22.999.888-8', 7, ' Franco Donoso', 'Electrónica', 1, 'franco.donoso@usm.cl', '+56971000056', 2),
('22.999.999-9', 7, ' Gabriela Lagos', 'Matemática', 2, 'gabriela.lagos@usm.cl', '+56971000057', 2),
('23.111.111-1', 7, ' Héctor Bravo', 'Informática', 3, 'hector.bravo@usm.cl', '+56971000058', 2),
('23.111.222-2', 7, ' Victor Rios', 'Informatica', 5, 'victor.rios@usm.cl','+56971000059', 2),
('23.111.333-3', 8, ' Claudia Mena', 'Informatica', 1, 'claudia.mena@usm.cl','+56971000060', 2),
('23.111.444-4', 8, ' Jose Perez', 'Informatica', 2, 'jose.perez@usm.cl','+56971000061', 2),
('23.111.555-5', 8, ' Julieta Rios', 'Informatica', 2, 'julieta.rios@usm.cl','+56971000062', 1),
('23.111.666-6', 8, ' victor Rojas', 'Informatica', 5, 'victor.rojas@usm.cl','+56971000063', 1),
('23.111.777-7', 8, ' Juan Lagos', 'Informatica', 2, 'juan.lagos@usm.cl','+56971000064', 2),
('23.111.888-8', 8, ' Franciso Suazo', 'Informatica', 2, 'franciso.suazo@usm.cl','+56971000065', 2),
('23.111.999-9', 8, ' Macarena Ortiz', 'Informatica', 2, 'macarena.ortiz@usm.cl','+56971000066', 2),
('23.111.233-3', 9, ' Sofia Lopez', 'Informatica', 4, 'sofia.lopez@usm.cl','+56971000067', 2),
('23.111.322-2', 9, ' Renato Mena', 'Informatica', 5, 'renato.mena@usm.cl','+56971000068', 2),
('23.111.433-2', 9, ' Felipe Gonzales', 'Informatica', 1, 'felipe.gonzales@usm.cl','+56971000069', 2),
('23.111.523-2', 9, ' Rodrigo Lagos', 'Informatica', 4, 'rodrigo.lagos@usm.cl','+56971000070', 1),
('23.111.523-1', 9, ' Julian Ortiz', 'Informatica', 5, 'julian.ortiz@usm.cl','+56971000071', 1),
('23.111.523-3', 9, ' Juanito Ortiz', 'Informatica', 2, 'juanito.ortiz@usm.cl','+56971000072', 2),
('23.111.523-4', 9, ' Juan Rodriguez', 'Informatica', 5, 'juan.rodriguez@usm.cl','+56971000073', 2),
('23.111.523-5', 10, ' Sanriago Perez', 'Informatica', 2, 'sanriago.perezs@usm.cl','+56971000074', 2),
('23.111.523-6', 10, ' Julian Rios', 'Informatica', 4, 'julian.pios@usm.cl','+56971000075', 2),
('23.111.523-7', 10, ' Francisco Rodriguez', 'Informatica', 3, ' francisco.rodriguez@usm.cl','+56971000076', 2),
('23.111.523-8', 10, ' Magdalena Perez', 'Informatica', 1, 'magdalena.perez@usm.cl','+56971000077', 2),
('23.111.523-9', 10, ' Magdalena Olivares', 'Informatica', 4, 'magdalena.olivares@usm.cl','+56971000078', 1),
('23.111.524-1', 10, ' Nestor Perez', 'Informatica', 2, 'nestor.perez@usm.cl','+56971000079', 1);


-- Poblar Etapas
INSERT INTO etapa (id_postulacion, nombre_etapa, plazos_semanas, entregable) VALUES
(1, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(1, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(1, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(2, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(2, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(2, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(3, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(3, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(3, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(4, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(4, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(4, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(5, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(5, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(5, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(6, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(6, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(6, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(7, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(7, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(7, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(8, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(8, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(8, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(9, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(9, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(9, 'Evaluación Final', 4, 'Informe de resultados y presentación final'),
(10, 'Revisión Inicial', 2, 'Informe de revisión inicial'),
(10, 'Desarrollo del Proyecto', 12, 'Prototipo funcional'),
(10, 'Evaluación Final', 18, 'Informe de resultados y presentación final');