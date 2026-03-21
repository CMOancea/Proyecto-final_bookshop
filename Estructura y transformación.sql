-- =================================================================
-- PROYECTO LIBRERÍA: SCRIPT UNIFICADO DE ESTRUCTURA Y TRANSFORMACIÓN
-- =================================================================

USE bookproject_db;

-- 1. PREPARACIÓN DE TABLAS RAW (Limpieza de columnas)
-- -----------------------------------------------------------------
ALTER TABLE Table_Goodreads CHANGE COLUMN `  num_pages` num_pages INT;
ALTER TABLE Table_Goodreads CHANGE COLUMN `bookID` book_id_gr INT;


-- 2. CREACIÓN DE DIMENSIÓN DE USUARIOS (Dim_Users)
-- -----------------------------------------------------------------
DROP TABLE IF EXISTS Dim_Users;

CREATE TABLE Dim_Users AS
SELECT DISTINCT 
    user_id, 
    age, 
    city, 
    state, 
    country
FROM Table_Recommendations
WHERE user_id IS NOT NULL;

ALTER TABLE Dim_Users MODIFY COLUMN user_id INT;
ALTER TABLE Dim_Users ADD PRIMARY KEY (user_id);


-- 3. CREACIÓN DE DIMENSIÓN DE LIBROS (Dim_Books)
-- -----------------------------------------------------------------
DROP TABLE IF EXISTS Dim_Books;

CREATE TABLE Dim_Books AS
SELECT 
    DISTINCT
    a.title,
    a.authors,
    a.publisher,
    a.categories,
    a.price,
    g.isbn13,
    g.language_code,
    g.num_pages,
    g.average_rating AS goodreads_rating
FROM Table_Amazon a
LEFT JOIN Table_Goodreads g ON a.title = g.title;

-- Generación de Clave Primaria Subrogada
ALTER TABLE Dim_Books ADD COLUMN book_key INT AUTO_INCREMENT PRIMARY KEY FIRST;


-- 4. CREACIÓN DE TABLA DE HECHOS (Fact_Ratings)
-- -----------------------------------------------------------------
DROP TABLE IF EXISTS Fact_Ratings;

CREATE TABLE Fact_Ratings AS
SELECT 
    r.user_id,
    b.book_key,
    r.book_rating AS rating,
    r.isbn AS original_isbn
FROM Table_Recommendations r
JOIN Dim_Books b ON r.book_title = b.title;

-- Optimización de rendimiento
ALTER TABLE Fact_Ratings ADD INDEX (user_id);
ALTER TABLE Fact_Ratings ADD INDEX (book_key);


-- 5. CREACIÓN DE VISTA MAESTRA PARA ANÁLISIS (Capa de Negocio)
-- -----------------------------------------------------------------
CREATE OR REPLACE VIEW view_market_expansion_full AS
SELECT 
    f.rating AS user_rating,
    u.user_id,
    u.age,
    u.country,
    u.city,
    b.book_key,
    b.title,
    b.authors,
    b.publisher,
    b.price,
    b.categories,
    b.num_pages,
    -- Ingeniería de características: Precio por página
    CASE WHEN b.num_pages > 0 THEN ROUND(b.price / b.num_pages, 4) ELSE 0 END AS price_per_page
FROM Fact_Ratings f
INNER JOIN Dim_Users u ON f.user_id = u.user_id
INNER JOIN Dim_Books b ON f.book_key = b.book_key;

-- 6. AUDITORÍA FINAL DE VOLUMEN
-- -----------------------------------------------------------------
SELECT 'Dim_Users' AS Tabla, COUNT(*) AS Total FROM Dim_Users
UNION
SELECT 'Dim_Books', COUNT(*) FROM Dim_Books
UNION
SELECT 'Fact_Ratings', COUNT(*) FROM Fact_Ratings
UNION
SELECT 'Vista_Maestra_Final', COUNT(*) FROM view_market_expansion_full;