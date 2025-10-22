-- CONSULTAS CDR - ACTIVIDAD 3 SENA
-- =====================================

-- 1. Borrar datos de llamadas del día 12 de diciembre de 2019
DELETE FROM cdr.cdr
WHERE DATE(registro) = '2019-12-12';

-- 2. Reporte de llamadas entre extensiones del 10 de marzo de 2018 usando DATE (atendidas)
SELECT *
FROM cdr.cdr
WHERE DATE(registro) = '2018-03-10'
  AND LENGTH(origen) <= 3
  AND LENGTH(destino) <= 3
  AND estado = 'completada';

-- 3. Misma consulta anterior usando YEAR(), MONTH(), DAY()
SELECT *
FROM cdr.cdr
WHERE YEAR(registro) = 2018
  AND MONTH(registro) = 3
  AND DAY(registro) = 10
  AND LENGTH(origen) <= 3
  AND LENGTH(destino) <= 3
  AND estado = 'completada';

-- 4. Llamadas entrantes no atendidas entre mediodía del 12 enero 2017 y medianoche del 3 marzo 2017
SELECT *
FROM cdr.cdr
WHERE registro >= '2017-01-12 12:00:00'
  AND registro <= '2017-03-03 23:59:59'
  AND LENGTH(origen) > 3
  AND LENGTH(destino) <= 3
  AND estado = 'no_atendida';

-- 5. Contar llamadas que entraron el 7 de abril de 2019
SELECT COUNT(*) AS total_llamadas
FROM cdr.cdr
WHERE DATE(registro) = '2019-04-07'
  AND LENGTH(origen) > 3
  AND LENGTH(destino) <= 3;

-- 6. Llamadas no contestadas por año entre 2016 y 2019
SELECT YEAR(registro) AS año,
       COUNT(*) AS llamadas_no_contestadas
FROM cdr.cdr
WHERE YEAR(registro) BETWEEN 2016 AND 2019
  AND estado = 'no_atendida'
GROUP BY YEAR(registro)
ORDER BY año;

-- 7. Costo de llamadas por extensiones específicas durante 2019
SELECT origen AS extension,
       SUM(CEIL(duracion/60) * 85) AS costo_total,
       COUNT(*) AS total_llamadas
FROM cdr.cdr
WHERE YEAR(registro) = 2019
  AND origen IN ('111', '104', '128', '161', '151')
  AND estado = 'completada'
GROUP BY origen
ORDER BY costo_total DESC;

-- CONSULTA ORIGINAL CORREGIDA - Verificar datos para 2016
-- Primero verificar si hay datos para 2016:
SELECT COUNT(*) AS registros_2016,
       MIN(registro) AS primera_fecha,
       MAX(registro) AS ultima_fecha
FROM cdr.cdr
WHERE YEAR(registro) = 2016;

-- Si no hay datos, probar con otros años:
SELECT YEAR(registro) AS año, COUNT(*) AS registros
FROM cdr.cdr
GROUP BY YEAR(registro)
ORDER BY año;

-- Consulta original adaptada para encontrar datos:
SELECT *,
       CEIL(duracion/60) * 85 AS valor
FROM cdr.cdr
WHERE LENGTH(destino) = 10
  AND CEIL(duracion/60) * 85 > 200
  AND estado = 'completada'
ORDER BY valor DESC
LIMIT 10;
