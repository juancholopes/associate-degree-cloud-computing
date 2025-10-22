-- SOLUCIONES PARA ARCHIVO CDR.SQL GRANDE (>100MB)
-- ================================================

-- OPCIÓN 1: DIVIDIR EL ARCHIVO EN PARTES MÁS PEQUEÑAS
-- Usar el comando split en terminal Linux:
-- split -l 10000 cdr.sql cdr_parte_
-- Esto creará archivos de 10,000 líneas cada uno

-- OPCIÓN 2: CARGAR DATOS USANDO LOAD DATA INFILE (más eficiente)
-- Si tienes los datos en formato CSV:
LOAD DATA INFILE '/ruta/a/datos_cdr.csv'
INTO TABLE cdr.cdr
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- OPCIÓN 3: CREAR PROCEDIMIENTO PARA CARGA BATCH
DELIMITER //
CREATE PROCEDURE CargarCDRBatch()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE batch_size INT DEFAULT 1000;

    -- Deshabilitar autocommit para mejor rendimiento
    SET autocommit = 0;

    -- Tu lógica de inserción aquí en lotes
    -- COMMIT cada batch_size registros

    COMMIT;
    SET autocommit = 1;
END //
DELIMITER ;

-- OPCIÓN 4: VERIFICAR CONFIGURACIÓN DE MySQL
-- Aumentar límites temporalmente:
SET GLOBAL max_allowed_packet = 1073741824; -- 1GB
SET GLOBAL innodb_buffer_pool_size = 2147483648; -- 2GB

-- OPCIÓN 5: USAR mysqlimport (línea de comandos)
-- mysqlimport --local --fields-terminated-by=',' nombre_db /ruta/archivo.csv

-- DEBUGGING: VERIFICAR POR QUÉ LA CONSULTA ORIGINAL NO DEVUELVE DATOS
-- 1. Verificar estructura de tabla
DESCRIBE cdr.cdr;

-- 2. Verificar datos existentes
SELECT COUNT(*) FROM cdr.cdr;

-- 3. Verificar rangos de fechas disponibles
SELECT MIN(registro) as fecha_minima,
       MAX(registro) as fecha_maxima,
       COUNT(*) as total_registros
FROM cdr.cdr;

-- 4. Verificar datos específicos para 2016
SELECT COUNT(*) as registros_2016,
       COUNT(CASE WHEN LENGTH(destino) = 10 THEN 1 END) as destinos_10_digitos,
       COUNT(CASE WHEN facturar > 0 THEN 1 END) as con_facturacion
FROM cdr.cdr
WHERE YEAR(registro) = 2016;

-- 5. Probar consulta paso a paso
-- Paso 1: Solo año 2016
SELECT COUNT(*) FROM cdr.cdr WHERE YEAR(registro) = 2016;

-- Paso 2: Año 2016 + destinos de 10 dígitos
SELECT COUNT(*) FROM cdr.cdr
WHERE YEAR(registro) = 2016 AND LENGTH(destino) = 10;

-- Paso 3: Verificar valores de facturación
SELECT MIN(facturar) as min_facturar,
       MAX(facturar) as max_facturar,
       AVG(facturar) as avg_facturar
FROM cdr.cdr
WHERE YEAR(registro) = 2016 AND LENGTH(destino) = 10;
