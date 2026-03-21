-- 1. Asegurarnos de usar la base de datos correcta
USE bookproject_db;

-- 2. Borramos las tablas si existen para empezar de cero sin errores 1050
DROP TABLE IF EXISTS Table_Amazon;
DROP TABLE IF EXISTS Table_Goodreads;
DROP TABLE IF EXISTS Table_Recommendations;

-- 3. Creamos la Tabla Amazon (con columnas extra anchas para que no falle)
CREATE TABLE Table_Amazon (
    book_id VARCHAR(255),
    title VARCHAR(1000),
    price FLOAT,
    user_id VARCHAR(255),
    rating FLOAT,
    authors TEXT,
    publisher VARCHAR(500),
    published_date VARCHAR(255),
    categories TEXT,
    ratings_count FLOAT
);

-- 4. Creamos la Tabla Goodreads
CREATE TABLE Table_Goodreads (
    bookID INT,
    Title VARCHAR(1000),
    authors TEXT,
    average_rating FLOAT,
    isbn VARCHAR(50),
    isbn13 BIGINT,
    language_code VARCHAR(50),
    num_pages INT,
    ratings_count INT,
    text_reviews_count INT,
    publication_date VARCHAR(100),
    publisher VARCHAR(500)
);

-- 5. Creamos la Tabla Recommendations
CREATE TABLE Table_Recommendations (
    user_id INT,
    isbn VARCHAR(50),
    book_rating INT,
    book_title VARCHAR(1000),
    book_author VARCHAR(500),
    year_of_publication FLOAT,
    publisher VARCHAR(500),
    age INT,
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255)
);
USE bookproject_db;

-- 1. Creamos la tabla de Dimension de Usuarios limpia
CREATE TABLE Dim_Users AS
SELECT DISTINCT 
    user_id, 
    age, 
    city, 
    state, 
    country
FROM Table_Recommendations
WHERE user_id IS NOT NULL;

-- 2. Definimos el ID de usuario como Llave Primaria
-- Esto evita que haya duplicados y acelera las consultas
ALTER TABLE Dim_Users MODIFY COLUMN user_id INT;
ALTER TABLE Dim_Users ADD PRIMARY KEY (user_id);

-- 3. Verificación: ¿Cuántos usuarios únicos tenemos?
SELECT COUNT(*) AS total_usuarios_unicos FROM Dim_Users;

USE bookproject_db;
-- Quitamos los espacios de num_pages y de bookID si los tuviera
ALTER TABLE Table_Goodreads CHANGE COLUMN `  num_pages` num_pages INT;
ALTER TABLE Table_Goodreads CHANGE COLUMN `bookID` book_id_gr INT;

LEFT JOIN Table_Goodreads g ON a.title = g.title;

-- 2. Añadimos un ID único incremental para que sea nuestra Llave Primaria
ALTER TABLE Dim_Books ADD COLUMN book_key INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- 3. Verificación: ¿Cuántos libros únicos tenemos ahora?
SELECT COUNT(*) AS total_libros_catalogo FROM Dim_Books;
-- Borramos si quedó algo del intento fallido
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
    g.num_pages,  -- Ahora ya no tiene espacios
    g.average_rating AS goodreads_rating
FROM Table_Amazon a
LEFT JOIN Table_Goodreads g ON a.title = g.title;

-- Añadimos la llave primaria para que sea una tabla profesional
ALTER TABLE Dim_Books ADD COLUMN book_key INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Verificación final
SELECT * FROM Dim_Books LIMIT 10;