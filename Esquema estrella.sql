-- TITLE: Master Book Dimension - Clean Version
USE bookproject_db;

DROP TABLE IF EXISTS dim_libros;

CREATE TABLE dim_libros AS
SELECT 
    isbn,
    MAX(titulo) AS titulo,
    MAX(autor) AS autor,
    MAX(editorial) AS editorial,
    MAX(categoria) AS categoria,
    AVG(precio) AS precio_unitario,
    MAX(anio_publicacion) AS anio_publicacion
FROM (
    -- 1. AMAZON
    SELECT 
        book_id_clean AS isbn, 
        title AS titulo, 
        author AS autor, 
        publisher AS editorial, 
        categories AS categoria, 
        price AS precio, 
        NULL AS anio_publicacion
    FROM table_amazon
    
    UNION ALL
    
    -- 2. GOODREADS
    SELECT 
        isbn, 
        title, 
        author, 
        publisher, 
        NULL AS categoria, 
        NULL AS precio, 
        publication_date AS anio_publicacion
    FROM table_goodreads
    
    UNION ALL
    
    -- 3. RECOMMENDATIONS
    SELECT 
        isbn_clean, 
        title, 
        author, 
        publisher, 
        NULL AS categoria, 
        NULL AS precio, 
        year_of_publication
    FROM table_recommendations
) AS stg_libros
WHERE isbn IS NOT NULL AND isbn != ''
GROUP BY isbn;

-- Definimos la llave primaria para optimizar Power BI
ALTER TABLE dim_libros ADD PRIMARY KEY (isbn(255));

-- User Dimension
DROP TABLE IF EXISTS dim_usuarios;

CREATE TABLE dim_usuarios AS
SELECT DISTINCT
    user_id,
    age AS edad,
    city AS ciudad,
    state AS estado,
    country AS pais
FROM table_recommendations
WHERE user_id IS NOT NULL;

ALTER TABLE dim_usuarios ADD PRIMARY KEY (user_id);

-- Ratings Fact Table
DROP TABLE IF EXISTS fact_ratings;

CREATE TABLE fact_ratings AS
SELECT 
    user_id, 
    isbn_clean AS isbn, 
    rating AS puntuacion
FROM table_recommendations
WHERE rating IS NOT NULL
UNION ALL
SELECT 
    user_id, 
    book_id_clean AS isbn, 
    rating
FROM table_amazon
WHERE rating IS NOT NULL;