USE bookproject_db;

-- ############################################################################
-- TITLE: Comprehensive Bookstore Business Intelligence Audit
-- PROJECT: Inventory Optimization & Pricing Strategy
-- ############################################################################

-- ----------------------------------------------------------------------------
-- 1. VOLUME ANALYSIS: Most Read Books, Top Sellers & Prices
-- ----------------------------------------------------------------------------
-- Objective: Identify high-rotation products and their price points.
-- In this dataset, "Most Read" and "Top Sold" are derived from rating volume.

SELECT 
    l.titulo, 
    l.autor, 
    l.precio, 
    COUNT(r.isbn) AS total_lecturas,
    ROUND(AVG(r.puntuacion), 2) AS rating_medio
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
GROUP BY l.isbn, l.titulo, l.autor, l.precio
ORDER BY total_lecturas DESC
LIMIT 20;


-- ----------------------------------------------------------------------------
-- 2. DEMOGRAPHIC IMPACT: Most Active Countries and Age Groups
-- ----------------------------------------------------------------------------
-- Objective: Understand "Who" and "Where" to target promotional packs.

-- Countries with most readings
SELECT 
    u.pais, 
    COUNT(r.puntuacion) AS volumen_lecturas,
    ROUND(AVG(l.precio), 2) AS ticket_medio_pais
FROM dim_usuarios u
JOIN fact_ratings r ON u.user_id = r.user_id
JOIN dim_libros l ON r.isbn = l.isbn
GROUP BY u.pais
ORDER BY volumen_lecturas DESC
LIMIT 10;

-- Age groups activity
SELECT 
    CASE 
        WHEN edad < 18 THEN '1. Kids/Teens (<18)'
        WHEN edad BETWEEN 18 AND 35 THEN '2. Young Adults (18-35)'
        WHEN edad BETWEEN 36 AND 55 THEN '3. Adults (36-55)'
        ELSE '4. Seniors (>55)'
    END AS grupo_edad,
    COUNT(*) AS total_lecturas
FROM dim_usuarios u
JOIN fact_ratings r ON u.user_id = r.user_id
GROUP BY grupo_edad
ORDER BY grupo_edad;


-- ----------------------------------------------------------------------------
-- 3. CATEGORY & PRICE PERFORMANCE: Most Read Genres and Avg Pricing
-- ----------------------------------------------------------------------------
-- Objective: Determine which of our 24 categories drive the most traffic 
-- and their average market price.

SELECT 
    categoria, 
    COUNT(*) AS volumen_lecturas,
    ROUND(AVG(precio), 2) AS precio_medio_categoria
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
WHERE categoria != 'Other'
GROUP BY categoria
ORDER BY volumen_lecturas DESC;


-- ----------------------------------------------------------------------------
-- 4. QUALITY VS. PRICE: Best and Worst Rated Books
-- ----------------------------------------------------------------------------
-- Objective: Identify which price points correlate with high/low satisfaction.
-- We only consider books with > 10 ratings to avoid statistical bias.

(SELECT 
    'Best Rated' AS tipo_rendimiento,
    titulo, 
    precio, 
    ROUND(AVG(puntuacion), 2) AS rating
 FROM dim_libros l
 JOIN fact_ratings r ON l.isbn = r.isbn
 WHERE puntuacion > 0
 GROUP BY l.isbn, l.titulo, l.precio
 HAVING COUNT(r.puntuacion) > 10
 ORDER BY rating DESC
 LIMIT 10)

UNION ALL

(SELECT 
    'Worst Rated' AS tipo_rendimiento,
    titulo, 
    precio, 
    ROUND(AVG(puntuacion), 2) AS rating
 FROM dim_libros l
 JOIN fact_ratings r ON l.isbn = r.isbn
 WHERE puntuacion > 0
 GROUP BY l.isbn, l.titulo, l.precio
 HAVING COUNT(r.puntuacion) > 10
 ORDER BY rating ASC
 LIMIT 10);
-- ############################################################################
-- TITLE: Comprehensive Business Intelligence Audit - Book Project 2026
-- ############################################################################

USE bookproject_db;

-- 1. TOP 10 LIBROS Y AUTORES MÁS LEÍDOS (Volumen de Mercado)
-- ----------------------------------------------------------------------------
-- Muestra qué títulos y escritores dominan el inventario por número de ratings.
SELECT 'TOP 10 LIBROS' AS reporte;
SELECT l.titulo, l.autor, COUNT(r.isbn) AS total_lecturas
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
GROUP BY l.titulo, l.autor
ORDER BY total_lecturas DESC
LIMIT 10;

SELECT 'TOP 10 AUTORES' AS reporte;
SELECT l.autor, COUNT(r.isbn) AS total_lecturas
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
GROUP BY l.autor
ORDER BY total_lecturas DESC
LIMIT 10;


-- 2. ANÁLISIS POR GÉNERO: PRECIO VS PUNTUACIÓN
-- ----------------------------------------------------------------------------
-- Identifica los géneros más caros, los más baratos y su satisfacción media.
SELECT 
    categoria, 
    ROUND(AVG(precio), 2) AS precio_promedio,
    ROUND(AVG(puntuacion), 2) AS puntuacion_media,
    COUNT(r.isbn) AS volumen_lecturas
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
GROUP BY categoria
ORDER BY precio_promedio DESC;


-- 3. PAÍSES CON % DE GÉNERO (Cuota de Mercado Local)
-- ----------------------------------------------------------------------------
-- Calcula qué peso porcentual tiene cada género dentro de cada país.
-- Útil para saber qué "vender" en cada región.
SELECT 
    u.pais, 
    l.categoria, 
    COUNT(r.isbn) AS lecturas_por_genero,
    ROUND(COUNT(r.isbn) * 100.0 / SUM(COUNT(r.isbn)) OVER(PARTITION BY u.pais), 2) AS porcentaje_en_pais
FROM dim_usuarios u
JOIN fact_ratings r ON u.user_id = r.user_id
JOIN dim_libros l ON r.isbn = l.isbn
WHERE u.pais IS NOT NULL 
  AND l.categoria != 'Other'
GROUP BY u.pais, l.categoria
ORDER BY u.pais, porcentaje_en_pais DESC;


-- 4. RESUMEN DE PORCENTAJES TOTALES (Global Market Share)
-- ----------------------------------------------------------------------------
-- ¿Qué géneros representan el mayor trozo del pastel a nivel mundial?
SELECT 
    categoria, 
    COUNT(r.isbn) AS total_lecturas,
    ROUND(COUNT(r.isbn) * 100.0 / (SELECT COUNT(*) FROM fact_ratings), 2) AS porcentaje_global
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
GROUP BY categoria
ORDER BY porcentaje_global DESC;