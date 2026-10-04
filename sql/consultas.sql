-- 1. Listado general de postulaciones.
-- Mostrar: Postulacion N°, fecha, tipo de iniciativa, sede, region de ejecucion, region de impacto, empresa y presupuesto total.
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    p.fecha_postulacion AS 'Fecha', -- Se muestra la fecha de postulación
    ti.des_iniciativa AS 'Tipo Iniciativa', -- Se muestra la descripción del tipo de iniciativa
    s.nombre_sede AS 'Sede', -- Se muestra el nombre de la sede
    re.nombre_region AS 'Región Ejecución', -- Se muestra el nombre de la región de ejecución
    ri.nombre_region AS 'Región Impacto', -- Se muestra el nombre de la región de impacto
    e.nombre_empresa AS 'Empresa', -- Se muestra el nombre de la empresa
    p.presupuesto_total AS 'Presupuesto Total' -- Se muestra el presupuesto total
-- Se selecciona la tabla de postulaciones como base y sacamos la información de los catalogos con JOIN
FROM postulacion p 
JOIN tipo_iniciativa ti ON p.id_tipo_iniciativa = ti.id_tipo_iniciativa   
JOIN sede s ON p.id_sede = s.id_sede 
JOIN region re ON p.id_region_ejecucion = re.id_region 
JOIN region ri ON p.id_region_impacto = ri.id_region
JOIN empresa e ON p.rut_empresa = e.rut_empresa;


-- 2. Postulaciones por region.
-- Listar postulaciones donde la region de ejecucion sea “Region de Valparaiso” (o la que se indique), mostrando empresa, sede y presupuesto.
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    e.nombre_empresa AS 'Empresa', -- Se muestra el nombre de la empresa
    s.nombre_sede AS 'Sede', -- Se muestra el nombre de la sede
    p.presupuesto_total AS 'Presupuesto' -- Se muestra el presupuesto total
-- Se selecciona la tabla de postulaciones como base y sacamos la información de los catalogos con JOIN, filtrando por región de ejecución
FROM postulacion p
JOIN empresa e ON p.rut_empresa = e.rut_empresa
JOIN sede s ON p.id_sede = s.id_sede
JOIN region r ON p.id_region_ejecucion = r.id_region
WHERE r.nombre_region = 'Región de Valparaíso';


-- 3. Conteo por tipo de iniciativa.
-- Contar cuantas postulaciones son Nuevas y cuantas Existentes.
SELECT 
    ti.des_iniciativa AS 'Tipo de Iniciativa', -- Se muestra la descripción del tipo de iniciativa
    COUNT(p.id_postulacion) AS 'Cantidad' -- Se cuenta el número de postulaciones para cada tipo de iniciativa
-- Se selecciona la tabla de postulaciones como base y sacamos la información del tipo de iniciativa con JOIN, agrupando por tipo de iniciativa
FROM postulacion p
JOIN tipo_iniciativa ti ON p.id_tipo_iniciativa = ti.id_tipo_iniciativa
GROUP BY ti.des_iniciativa;


-- 4. Equipo de trabajo de una postulacion para la postulacion N°1.
-- Dado el Codigo (uso interno) o la Postulacion N°, listar integrantes con: rut, nombre, tipo (Profesor / Estudiante), sede, email y rol.
SELECT 
    i.rut_integrante AS 'RUT', -- Se muestra el RUT del integrante
    i.nombre AS 'Nombre', -- Se muestra el nombre del integrante
    ti.des_integrante AS 'Tipo Integrante', -- Se muestra la descripción del tipo de integrante (Profesor/Estudiante)
    s.nombre_sede AS 'Sede', -- Se muestra el nombre de la sede del integrante
    i.email AS 'Email', -- Se muestra el email del integrante
    i.departamento_area AS 'Departamento/Área' -- Se muestra el departamento o área del integrante
-- Se selecciona la tabla de integrantes como base y sacamos la información de los catalogos
FROM integrante i
JOIN equipo_de_trabajo eq ON i.id_equipo = eq.id_equipo
JOIN postulacion p ON eq.id_postulacion = p.id_postulacion
JOIN tipo_integrante ti ON i.id_tipo_integrante = ti.id_tipo_integrante
JOIN sede s ON i.id_sede = s.id_sede
WHERE p.id_postulacion = 1; -- Aquí se puede cambiar el número de postulación para listar el equipo de trabajo de la postulación deseada


-- 5. Empresas con postulaciones y convenio.
-- Listar empresas indicando: tamaño, convenio (Si/No) y cantidad de postulaciones asociadas, ordenado de mayor a menor.
SELECT 
    e.nombre_empresa AS 'Empresa', -- Se muestra el nombre de la empresa
    te.des_empresa AS 'Tamaño', -- Se muestra la descripción del tamaño de la empresa
    CASE WHEN e.convenio_marco = 1 THEN 'Sí' ELSE 'No' END AS 'Convenio Marco', -- Se muestra si la empresa tiene convenio marco o no
    COUNT(p.id_postulacion) AS 'Cantidad Postulaciones' -- Se cuenta el número de postulaciones asociadas a cada empresa
-- Se selecciona la tabla de empresas como base y sacamos la información del tamaño de empresa con JOIN
-- Contamos las postulaciones asociadas con LEFT JOIN para incluir empresas sin postulaciones, agrupando por empresa y ordenando de mayor a menor cantidad de postulaciones
FROM empresa e
JOIN tamano_empresa te ON e.id_tamano = te.id_tamano
LEFT JOIN postulacion p ON e.rut_empresa = p.rut_empresa
GROUP BY e.id_empresa 
ORDER BY COUNT(p.id_postulacion) DESC; -- Se ordena de mayor a menor cantidad de postulaciones


-- 6. Postulaciones con presupuesto sobre el promedio.
-- Listar las postulaciones cuyo presupuesto total supera el promedio general de todas las postulaciones. Mostrar: Postulacion N°, nombre de la empresa y presupuesto total, ordenado de mayor a menor.
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    e.nombre_empresa AS 'Empresa', -- Se muestra el nombre de la empresa
    p.presupuesto_total AS 'Presupuesto' -- Se muestra el presupuesto total
-- Se selecciona la tabla de postulaciones como base y sacamos la información de las empresas con JOIN, filtrando por presupuesto sobre el promedio
FROM postulacion p
JOIN empresa e ON p.rut_empresa = e.rut_empresa
WHERE p.presupuesto_total > (SELECT AVG(presupuesto_total) FROM postulacion)
ORDER BY p.presupuesto_total DESC; -- Se ordena de mayor a menor presupuesto


-- 7. Cantidad de integrantes por postulacion y tipo.
-- Mostrar cuantos profesores y cuantos estudiantes tiene cada postulacion, agrupando por Postulacion N° y tipo de persona.
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    ti.des_integrante AS 'Tipo Integrante', -- Se muestra la descripción del tipo de integrante (Profesor/Estudiante)
    COUNT(i.rut_integrante) AS 'Cantidad' -- Se cuenta el número de integrantes para cada tipo en cada postulación
-- Se selecciona la tabla de integrantes como base y sacamos la información de las postulaciones y tipos de integrantes con JOIN, agrupando por postulación y tipo de integrante
FROM postulacion p
JOIN equipo_de_trabajo eq ON p.id_postulacion = eq.id_postulacion
JOIN integrante i ON eq.id_equipo = i.id_equipo
JOIN tipo_integrante ti ON i.id_tipo_integrante = ti.id_tipo_integrante
GROUP BY p.id_postulacion, ti.des_integrante;


-- 8. Postulaciones que no cumplen el mınimo de equipo.
-- Identificar postulaciones que tengan menos de 3 profesores o menos de 5 estudiantes. 
-- Mostrar el numero de postulacion, la cantidad de profesores y la cantidad de estudiantes. 
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    SUM(CASE WHEN ti.des_integrante = 'Profesor' THEN 1 ELSE 0 END) AS 'Cantidad Profesores', -- Se cuenta la cantidad de profesores en cada postulación usando una expresión CASE 
    SUM(CASE WHEN ti.des_integrante = 'Estudiante' THEN 1 ELSE 0 END) AS 'Cantidad Estudiantes' -- Se cuenta la cantidad de estudiantes en cada postulación usando una expresión CASE
-- Se selecciona la tabla de postulaciones como base y sacamos la información de los integrantes
FROM postulacion p
JOIN equipo_de_trabajo eq ON p.id_postulacion = eq.id_postulacion
LEFT JOIN integrante i ON eq.id_equipo = i.id_equipo
LEFT JOIN tipo_integrante ti ON i.id_tipo_integrante = ti.id_tipo_integrante
GROUP BY p.id_postulacion
HAVING `Cantidad Profesores` < 3 OR `Cantidad Estudiantes` < 5; -- Se filtra para mostrar solo las postulaciones que tienen menos de 3 profesores o menos de 5 estudiantes


-- 9. Empresas sin postulaciones registradas.
-- Listar las empresas que estan registradas en la base de datos pero que no tienen ninguna postulacion asociada.
-- Mostrar nombre de la empresa, RUT y tamaño.
SELECT 
    e.nombre_empresa AS 'Empresa', -- Se muestra el nombre de la empresa
    e.rut_empresa AS 'RUT', -- Se muestra el RUT de la empresa
    te.des_empresa AS 'Tamaño' -- Se muestra la descripción del tamaño de la empresa
-- Se selecciona la tabla de empresas como base y sacamos la información del tamaño de empresa con JOIN
-- Usando LEFT JOIN para incluir empresas sin postulaciones y filtrando por aquellas que no tienen postulaciones asociadas
FROM empresa e
JOIN tamano_empresa te ON e.id_tamano = te.id_tamano
LEFT JOIN postulacion p ON e.rut_empresa = p.rut_empresa
WHERE p.id_postulacion IS NULL; -- Se filtra para mostrar solo las empresas que no tienen postulaciones registradas


-- 10. Postulaciones que exceden el plazo maximo.
-- Mostrar las postulaciones cuya suma de semanas en el cronograma supera las 36 semanas (9 meses). 
-- Incluir: Postulacion N°, codigo interno, total de etapas y total de semanas, ordenado de mayor a menor. 
SELECT 
    p.id_postulacion AS 'Postulación N°', -- Se muestra el ID de la postulación como número de postulación
    COUNT(et.id_etapa) AS 'Total Etapas', -- Se cuenta el número de etapas asociadas a cada postulación
    SUM(et.plazos_semanas) AS 'Total Semanas' -- Se suma el total de semanas de las etapas para cada postulación
-- Se selecciona la tabla de postulaciones como base y sacamos la información de las etapas con JOIN
-- Agrupando por postulación y filtrando por aquellas que exceden las 36 semanas, ordenando de mayor a menor total de semanas
FROM postulacion p
JOIN etapa et ON p.id_postulacion = et.id_postulacion
GROUP BY p.id_postulacion
HAVING SUM(et.plazos_semanas) > 36 -- Se filtra para mostrar solo las postulaciones cuya suma de semanas en el cronograma supera las 36 semanas
ORDER BY `Total Semanas` DESC; -- Se ordena de mayor a menor total de semanas
