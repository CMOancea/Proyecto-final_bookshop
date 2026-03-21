USE bookproject_db;
-- General KPIs
SELECT 
    COUNT(*) AS total_libros_unicos,
    ROUND(AVG(precio_unitario), 2) AS precio_medio_catalogo,
    (SELECT COUNT(*) FROM fact_ratings) AS total_valoraciones_registradas
FROM dim_libros;

-- Top 10 Most Read Books

SELECT 
    l.titulo, 
    l.autor, 
    SUM(r_counts.num_ratings) AS total_valoraciones, -- Sumamos los ratings de todas las ediciones
    ROUND(AVG(l.precio_unitario), 2) AS precio_promedio_ediciones,
    ROUND(AVG(r_counts.avg_score), 2) AS puntuacion_media
FROM (
    -- Subconsulta para calcular métricas por ISBN primero
    SELECT 
        isbn, 
        COUNT(*) AS num_ratings, 
        AVG(puntuacion) AS avg_score
    FROM fact_ratings
    GROUP BY isbn
) AS r_counts
JOIN dim_libros l ON r_counts.isbn = l.isbn
GROUP BY l.titulo, l.autor
ORDER BY total_valoraciones DESC
LIMIT 10;

-- Popularity by Category
SELECT 
    l.categoria, 
    COUNT(r.puntuacion) AS total_ventas_ratings,
    ROUND(AVG(l.precio_unitario), 2) AS precio_medio_categoria
FROM fact_ratings r
JOIN dim_libros l ON r.isbn = l.isbn
WHERE l.categoria IS NOT NULL
GROUP BY l.categoria
ORDER BY total_ventas_ratings DESC
LIMIT 10;

-- TITLE: Top Countries by User Activity
SELECT 
    pais, 
    COUNT(*) AS total_usuarios,
    ROUND(AVG(edad), 1) AS edad_media
FROM dim_usuarios
GROUP BY pais
ORDER BY total_usuarios DESC
LIMIT 10;

-- Identify Books with Missing Authors
SELECT titulo, isbn, total_valoraciones
FROM (
    SELECT l.titulo, l.isbn, COUNT(r.puntuacion) as total_valoraciones, l.autor
    FROM dim_libros l
    JOIN fact_ratings r ON l.isbn = r.isbn
    GROUP BY l.isbn, l.titulo, l.autor
) AS resumen
WHERE autor IS NULL 
   OR autor = '' 
   OR autor = 'unknown'
ORDER BY total_valoraciones DESC;

-- 1. DESACTIVAR MODO SEGURO
SET SQL_SAFE_UPDATES = 0;

-- 2. ACTUALIZACIÓN MASIVA DE AUTORES
UPDATE dim_libros SET autor = 'J.R.R. Tolkien' WHERE titulo LIKE '%lord of the rings%';
UPDATE dim_libros SET autor = 'Jack London' WHERE titulo LIKE '%call of the wild%';
UPDATE dim_libros SET autor = 'John Steinbeck' WHERE titulo LIKE '%east of eden%';
UPDATE dim_libros SET autor = 'Terry Goodkind' WHERE titulo LIKE '%wizards first rule%';
UPDATE dim_libros SET autor = 'S.E. Hinton' WHERE titulo LIKE '%the outsiders%';
UPDATE dim_libros SET autor = 'Herman Melville' WHERE titulo LIKE '%mobydick%';
UPDATE dim_libros SET autor = 'Charles Dickens' WHERE titulo LIKE '%great expectations%';
UPDATE dim_libros SET autor = 'Charles Frazier' WHERE titulo LIKE '%cold mountain%';
UPDATE dim_libros SET autor = 'Philip Pullman' WHERE titulo LIKE '%golden compass%';
UPDATE dim_libros SET autor = 'Agatha Christie' WHERE titulo LIKE '%and then there were none%';
UPDATE dim_libros SET autor = 'Mark Twain' WHERE titulo LIKE '%huckleberry finn%';
UPDATE dim_libros SET autor = 'Emma McLaughlin & Nicola Kraus' WHERE titulo LIKE '%nanny diaries%';
UPDATE dim_libros SET autor = 'George S. Clason' WHERE titulo LIKE '%richest man in babylon%';
UPDATE dim_libros SET autor = 'James Patterson' WHERE titulo LIKE '%when the wind blows%';
UPDATE dim_libros SET autor = 'Shirley Jackson' WHERE titulo LIKE '%haunting of hill house%';
UPDATE dim_libros SET autor = 'Stasi Eldredge' WHERE titulo LIKE '%captivating%';
UPDATE dim_libros SET autor = 'John Grisham' WHERE titulo LIKE '%a painted house%';
UPDATE dim_libros SET autor = 'Lee Child' WHERE titulo LIKE '%killing floor%';
UPDATE dim_libros SET autor = 'Edwin Abbott' WHERE titulo LIKE '%flatland%';
UPDATE dim_libros SET autor = 'Jeffrey Eugenides' WHERE titulo LIKE '%middlesex%';
UPDATE dim_libros SET autor = 'Emily Brontë' WHERE titulo LIKE '%wuthering heights%';
UPDATE dim_libros SET autor = 'Anita Shreve' WHERE titulo LIKE '%pilots wife%';
UPDATE dim_libros SET autor = 'Ernest Hemingway' WHERE titulo LIKE '%farewell to arms%';
UPDATE dim_libros SET autor = 'Susanna Clarke' WHERE titulo LIKE '%jonathan strange%';
UPDATE dim_libros SET autor = 'Carol Ann Hiatt' WHERE titulo LIKE '%medical reference books%';
UPDATE dim_libros SET autor = 'Robert Frost' WHERE titulo LIKE '%stopping by woods%';
UPDATE dim_libros SET autor = 'E. Nesbit' WHERE titulo LIKE '%railway children%';
UPDATE dim_libros SET autor = 'Anita Silvey' WHERE titulo LIKE '%where is elmos blanket%';
UPDATE dim_libros SET autor = 'Lorraine Heath' WHERE titulo LIKE '%londons perfect scoundrel%';
UPDATE dim_libros SET autor = 'Charles Williams' WHERE titulo LIKE '%war in heaven%';
UPDATE dim_libros SET autor = 'Alfred Lord Tennyson' WHERE titulo LIKE '%idylls of the king%';
UPDATE dim_libros SET autor = 'T.C. Boyle' WHERE titulo LIKE '%riven rock%';
UPDATE dim_libros SET autor = 'Patricia Highsmith' WHERE titulo LIKE '%liars diary%';
UPDATE dim_libros SET autor = 'Agatha Christie' WHERE titulo LIKE '%murder at the vicarage%';
UPDATE dim_libros SET autor = 'Kathryn Stockett' WHERE titulo LIKE '%blue bottle club%';
UPDATE dim_libros SET autor = 'Dietrich Dörner' WHERE titulo LIKE '%logic of failure%';
UPDATE dim_libros SET autor = 'Yasunari Kawabata' WHERE titulo LIKE '%snow country%';
UPDATE dim_libros SET autor = 'Kira Halloran' WHERE titulo LIKE '%guerrilla tactics%';
UPDATE dim_libros SET autor = 'Timothy Brook' WHERE titulo LIKE '%mr china%';
UPDATE dim_libros SET autor = 'Roberto Goizueta' WHERE titulo LIKE '%from day one%';
UPDATE dim_libros SET autor = 'Rafael Sabatini' WHERE titulo LIKE '%scaramouche%';
UPDATE dim_libros SET autor = 'Rabbi Anita Diamant' WHERE titulo LIKE '%choosing a jewish life%';
UPDATE dim_libros SET autor = 'Douglas E. Richards' WHERE titulo LIKE '%prometheus project%';
UPDATE dim_libros SET autor = 'Judith Krantz' WHERE titulo LIKE '%for matrimonial purposes%';
UPDATE dim_libros SET autor = 'Arthur C. Clarke' WHERE titulo LIKE '%sunstorm%';
UPDATE dim_libros SET autor = 'Walter van Tilburg Clark' WHERE titulo LIKE '%oxbow incident%';
UPDATE dim_libros SET autor = 'Tess Gerritsen' WHERE titulo LIKE '%blood orchid%';
UPDATE dim_libros SET autor = 'Debbie Macomber' WHERE titulo LIKE '%marry me maddie%';

-- 3. REACTIVAR MODO SEGURO
SET SQL_SAFE_UPDATES = 1;

-- 4. COMPROBACIÓN FINAL
SELECT COUNT(*) FROM dim_libros WHERE autor = 'Unknown';

-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS
UPDATE dim_libros SET autor = 'Booker T. Washington' WHERE titulo LIKE '%up from slavery%';
UPDATE dim_libros SET autor = 'Frank B. Gilbreth, Ernestine Gilbreth Carey' WHERE titulo LIKE '%cheaper by the dozen%';
UPDATE dim_libros SET autor = 'Anne Morrow Lindbergh' WHERE titulo LIKE '%gift from the sea%';
UPDATE dim_libros SET autor = 'Stephen Crane' WHERE titulo LIKE '%red badge of courage%';
UPDATE dim_libros SET autor = 'Richard Wright' WHERE titulo LIKE '%black boy%';
UPDATE dim_libros SET autor = 'Salman Rushdie' WHERE titulo LIKE '%midnights children%';
UPDATE dim_libros SET autor = 'Carlos Castaneda' WHERE titulo LIKE '%teachings of don juan%';
UPDATE dim_libros SET autor = 'Kenneth Grahame' WHERE titulo LIKE '%wind in the willows%';
UPDATE dim_libros SET autor = 'Edith Hamilton' WHERE titulo LIKE '%mythology%';
UPDATE dim_libros SET autor = 'Charles Dickens' WHERE titulo LIKE '%pickwick club%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%mythology%' OR titulo LIKE '%black boy%';
-- TITLE: Check Remaining Titles Without Author
USE bookproject_db;

SELECT 
    COUNT(*) AS total_libros_sin_autor,
    (SELECT COUNT(*) FROM dim_libros) AS total_libros_en_dim,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM dim_libros)) * 100, 2) AS porcentaje_faltante
FROM dim_libros
WHERE autor IS NULL 
   OR autor = '' 
   OR autor = 'unknown' 
   OR autor = 'n/a'
   OR autor = '[No author found]';

-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS BASED ON NEW LIST
UPDATE dim_libros SET autor = 'J.R.R. Tolkien' WHERE titulo LIKE '%lord of the rings%';
UPDATE dim_libros SET autor = 'Jack London' WHERE titulo LIKE '%call of the wild%';
UPDATE dim_libros SET autor = 'John Steinbeck' WHERE titulo LIKE '%east of eden%';
UPDATE dim_libros SET autor = 'Terry Goodkind' WHERE titulo LIKE '%wizards first rule%';
UPDATE dim_libros SET autor = 'S.E. Hinton' WHERE titulo LIKE '%the outsiders%';
UPDATE dim_libros SET autor = 'Herman Melville' WHERE titulo LIKE '%mobydick%';
UPDATE dim_libros SET autor = 'Charles Dickens' WHERE titulo LIKE '%great expectations%';
UPDATE dim_libros SET autor = 'Charles Frazier' WHERE titulo LIKE '%cold mountain%';
UPDATE dim_libros SET autor = 'Philip Pullman' WHERE titulo LIKE '%golden compass%';
UPDATE dim_libros SET autor = 'Agatha Christie' WHERE titulo LIKE '%and then there were none%';
UPDATE dim_libros SET autor = 'Mark Twain' WHERE titulo LIKE '%huckleberry finn%';
UPDATE dim_libros SET autor = 'Emma McLaughlin & Nicola Kraus' WHERE titulo LIKE '%nanny diaries%';
UPDATE dim_libros SET autor = 'George S. Clason' WHERE titulo LIKE '%richest man in babylon%';
UPDATE dim_libros SET autor = 'James Patterson' WHERE titulo LIKE '%when the wind blows%';
UPDATE dim_libros SET autor = 'Shirley Jackson' WHERE titulo LIKE '%haunting of hill house%';
UPDATE dim_libros SET autor = 'John Grisham' WHERE titulo LIKE '%a painted house%';
UPDATE dim_libros SET autor = 'Lee Child' WHERE titulo LIKE '%killing floor%';
UPDATE dim_libros SET autor = 'Edwin Abbott' WHERE titulo LIKE '%flatland%';
UPDATE dim_libros SET autor = 'Jeffrey Eugenides' WHERE titulo LIKE '%middlesex%';
UPDATE dim_libros SET autor = 'Emily Brontë' WHERE titulo LIKE '%wuthering heights%';
UPDATE dim_libros SET autor = 'Ernest Hemingway' WHERE titulo LIKE '%farewell to arms%';
UPDATE dim_libros SET autor = 'Susanna Clarke' WHERE titulo LIKE '%jonathan strange%';
UPDATE dim_libros SET autor = 'Robert Frost' WHERE titulo LIKE '%stopping by woods%';
UPDATE dim_libros SET autor = 'E. Nesbit' WHERE titulo LIKE '%railway children%';
UPDATE dim_libros SET autor = 'Tess Gerritsen' WHERE titulo LIKE '%blood orchid%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%lord of the rings%' OR titulo LIKE '%wuthering heights%';

-- 1. DESACTIVAR EL MODO SEGURO TEMPORALMENTE
SET SQL_SAFE_UPDATES = 0;

-- 2. ACTUALIZACIÓN DE AUTORES
UPDATE dim_libros SET autor = 'J.R.R. Tolkien' WHERE titulo LIKE '%the hobbit%';
UPDATE dim_libros SET autor = 'J.D. Salinger' WHERE titulo LIKE '%catcher in the rye%';
UPDATE dim_libros SET autor = 'John Steinbeck' WHERE titulo LIKE '%of mice and men%';
UPDATE dim_libros SET autor = 'Ayn Rand' WHERE titulo LIKE '%atlas shrugged%';
UPDATE dim_libros SET autor = 'Nathaniel Hawthorne' WHERE titulo LIKE '%scarlet letter%';
UPDATE dim_libros SET autor = 'George Orwell' WHERE titulo LIKE '%animal farm%';
UPDATE dim_libros SET autor = 'C.S. Lewis' WHERE titulo LIKE '%lion the witch and the wardrobe%';
UPDATE dim_libros SET autor = 'Stephen King' WHERE titulo LIKE '%it%';
UPDATE dim_libros SET autor = 'E.B. White' WHERE titulo LIKE '%charlottes web%';
UPDATE dim_libros SET autor = 'Alexandre Dumas' WHERE titulo LIKE '%count of monte cristo%';
UPDATE dim_libros SET autor = 'Louisa May Alcott' WHERE titulo LIKE '%little women%';
UPDATE dim_libros SET autor = 'Charles Dickens' WHERE titulo LIKE '%christmas carol%';
UPDATE dim_libros SET autor = 'Mary Shelley' WHERE titulo LIKE '%frankenstein%';
UPDATE dim_libros SET autor = 'Oscar Wilde' WHERE titulo LIKE '%picture of dorian gray%';
UPDATE dim_libros SET autor = 'Mario Puzo' WHERE titulo LIKE '%the godfather%';
UPDATE dim_libros SET autor = 'Ray Bradbury' WHERE titulo LIKE '%illustrated man%';
UPDATE dim_libros SET autor = 'Stephen Hawking' WHERE titulo LIKE '%brief history of time%';
UPDATE dim_libros SET autor = 'Agatha Christie' WHERE titulo LIKE '%roger ackroyd%';

-- 3. VOLVER A ACTIVAR EL MODO SEGURO (POR SEGURIDAD)
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICAR CAMBIOS
SELECT titulo, autor FROM dim_libros WHERE autor != 'Unknown' LIMIT 10;

SELECT 
    COUNT(*) AS total_libros_sin_autor,
    (SELECT COUNT(*) FROM dim_libros) AS total_libros_en_dim,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM dim_libros)) * 100, 2) AS porcentaje_faltante
FROM dim_libros
WHERE autor IS NULL 
   OR autor = '' 
   OR autor = 'unknown' 
   OR autor = 'n/a'
   OR autor = '[No author found]';
-- TITLE: Identifying High-Impact Missing Authors
USE bookproject_db;

SELECT 
    l.titulo, 
    COUNT(r.puntuacion) AS total_valoraciones
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
WHERE l.autor = 'Unknown' OR l.autor IS NULL
GROUP BY l.titulo
ORDER BY total_valoraciones DESC
LIMIT 20;

-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS BASED ON PROVIDED LIST
UPDATE dim_libros SET autor = 'Jules Verne' WHERE titulo LIKE '%journey to the centre of the earth%';
UPDATE dim_libros SET autor = 'John D. Fitzgerald' WHERE titulo LIKE '%great brain%';
UPDATE dim_libros SET autor = 'Tom Clancy' WHERE titulo LIKE '%hunt for red october%';
UPDATE dim_libros SET autor = 'Nicholas Monsarrat' WHERE titulo LIKE '%cruel sea%';
UPDATE dim_libros SET autor = 'Mary Stewart' WHERE titulo LIKE '%crystal cave%';
UPDATE dim_libros SET autor = 'Lewis Carroll' WHERE titulo LIKE '%alices adventures in wonderland%';
UPDATE dim_libros SET autor = 'James M. Cain' WHERE titulo LIKE '%postman always rings twice%';
UPDATE dim_libros SET autor = 'Ben Hogan' WHERE titulo LIKE '%fundamentals of golf%';
UPDATE dim_libros SET autor = 'Albert Camus' WHERE titulo LIKE '%the plague%';
UPDATE dim_libros SET autor = 'Okakura Kakuzō' WHERE titulo LIKE '%book of tea%';
UPDATE dim_libros SET autor = 'Carl Jung, et al.' WHERE titulo LIKE '%man and his symbols%';
UPDATE dim_libros SET autor = 'Agatha Christie' WHERE titulo LIKE '%abc murders%';
UPDATE dim_libros SET autor = 'Sue Grafton' WHERE titulo LIKE '%s is for silence%';
UPDATE dim_libros SET autor = 'J.R.R. Tolkien' WHERE titulo LIKE '%fellowship of the rings%';
UPDATE dim_libros SET autor = 'Pat Conroy' WHERE titulo LIKE '%water is wide%';
UPDATE dim_libros SET autor = 'Frederick Douglass' WHERE titulo LIKE '%frederick douglass%';
UPDATE dim_libros SET autor = 'David Sedaris' WHERE titulo LIKE '%naked%';
UPDATE dim_libros SET autor = 'Barbara Robinson' WHERE titulo LIKE '%best christmas pageant%';
UPDATE dim_libros SET autor = 'Phyllis Reynolds Naylor' WHERE titulo LIKE '%shiloh%';
UPDATE dim_libros SET autor = 'Geoffrey Chaucer' WHERE titulo LIKE '%canterbury tales%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%centre of the earth%' OR titulo LIKE '%canterbury tales%';


-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS
UPDATE dim_libros SET autor = 'Thor Heyerdahl' WHERE titulo LIKE '%kontiki%';
UPDATE dim_libros SET autor = 'Dan Brown' WHERE titulo LIKE '%deception point%';
UPDATE dim_libros SET autor = 'Viktor E. Frankl' WHERE titulo LIKE '%mans search for meaning%';
UPDATE dim_libros SET autor = 'John Knowles' WHERE titulo LIKE '%separate peace%';
UPDATE dim_libros SET autor = 'Madeleine L''Engle' WHERE titulo LIKE '%ring of endless light%';
UPDATE dim_libros SET autor = 'Robert Louis Stevenson' WHERE titulo LIKE '%dr jekyll and mr hyde%';
UPDATE dim_libros SET autor = 'G.K. Chesterton' WHERE titulo LIKE '%everlasting man%';
UPDATE dim_libros SET autor = 'Neil Gaiman' WHERE titulo LIKE '%neverwhere%';
UPDATE dim_libros SET autor = 'Isabel Allende' WHERE titulo LIKE '%daughter of fortune%';
UPDATE dim_libros SET autor = 'Adam Smith' WHERE titulo LIKE '%wealth of nations%';
UPDATE dim_libros SET autor = 'Jane Green' WHERE titulo LIKE '%jemima j%';
UPDATE dim_libros SET autor = 'Pat Conroy' WHERE titulo LIKE '%hornets nest%';
UPDATE dim_libros SET autor = 'Esther Forbes' WHERE titulo LIKE '%johnny tremain%';
UPDATE dim_libros SET autor = 'Stephen King' WHERE titulo LIKE '%the summons%';
UPDATE dim_libros SET autor = 'Audie Murphy' WHERE titulo LIKE '%to hell and back%';
UPDATE dim_libros SET autor = 'James Clavell' WHERE titulo LIKE '%king rat%';
UPDATE dim_libros SET autor = 'Alan Moore, David Lloyd' WHERE titulo LIKE '%v for vendetta%';
UPDATE dim_libros SET autor = 'Howard Fast' WHERE titulo LIKE '%rabble in arms%';
UPDATE dim_libros SET autor = 'Sigmund Freud' WHERE titulo LIKE '%interpretation of dreams%';
UPDATE dim_libros SET autor = 'Victor Hugo' WHERE titulo LIKE '%les miserables%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%kontiki%' OR titulo LIKE '%les miserables%';


-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS BASED ON PROVIDED LIST
UPDATE dim_libros SET autor = 'Roald Dahl' WHERE titulo LIKE 'boy%' AND (autor = 'Unknown' OR autor IS NULL);
UPDATE dim_libros SET autor = 'Daphne du Maurier' WHERE titulo LIKE 'rebecca%';
UPDATE dim_libros SET autor = 'Robert Louis Stevenson' WHERE titulo LIKE '%child%garden of verses%';
UPDATE dim_libros SET autor = 'Janet Dailey' WHERE titulo LIKE '%true lies%';
UPDATE dim_libros SET autor = 'John Berendt' WHERE titulo LIKE '%midnight in the garden of good and evil%';
UPDATE dim_libros SET autor = 'Maurice Sendak' WHERE titulo LIKE '%where the wild things are%';
UPDATE dim_libros SET autor = 'T.H. White' WHERE titulo LIKE '%sword in the stone%';
UPDATE dim_libros SET autor = 'John Wyndham' WHERE titulo LIKE '%day of the triffids%';
UPDATE dim_libros SET autor = 'Ernest Hemingway' WHERE titulo LIKE '%to have and have not%';
UPDATE dim_libros SET autor = 'Virginia Woolf' WHERE titulo LIKE '%room of one%s own%';
UPDATE dim_libros SET autor = 'Rebecca West' WHERE titulo LIKE '%black lamb and grey falcon%';
UPDATE dim_libros SET autor = 'Mary Jane Clark' WHERE titulo LIKE '%crazy for you%';
UPDATE dim_libros SET autor = 'C.S. Lewis' WHERE titulo LIKE '%that hideous strength%';
UPDATE dim_libros SET autor = 'Geraldine Brooks' WHERE titulo LIKE '%knight in shining armor%';
UPDATE dim_libros SET autor = 'Jean Craighead George' WHERE titulo LIKE '%my side of the mountain%';
UPDATE dim_libros SET autor = 'Alice Walker' WHERE titulo LIKE '%color purple%';
UPDATE dim_libros SET autor = 'Neil Gaiman' WHERE titulo LIKE '%coraline%';
UPDATE dim_libros SET autor = 'Eoin Colfer' WHERE titulo LIKE '%artemis fowl%';
UPDATE dim_libros SET autor = 'Owen Wister' WHERE titulo LIKE '%the virginian%';
UPDATE dim_libros SET autor = 'Bill Bryson' WHERE titulo LIKE '%down under%';
UPDATE dim_libros SET autor = 'A.A. Milne' WHERE titulo LIKE '%when we were very young%';
UPDATE dim_libros SET autor = 'Maeve Binchy' WHERE titulo LIKE '%tara road%';
UPDATE dim_libros SET autor = 'Arthur Conan Doyle' WHERE titulo LIKE '%sherlock holmes%';
UPDATE dim_libros SET autor = 'Fyodor Dostoevsky' WHERE titulo LIKE '%crime%punishment%';
UPDATE dim_libros SET autor = 'Linda Goodman' WHERE titulo LIKE '%linda goodman%sun signs%';
UPDATE dim_libros SET autor = 'Terry Goodkind' WHERE titulo LIKE '%stone of tears%';
UPDATE dim_libros SET autor = 'Howard Pyle' WHERE titulo LIKE '%robin hood%';
UPDATE dim_libros SET autor = 'Leif Enger' WHERE titulo LIKE '%peace like a river%';
UPDATE dim_libros SET autor = 'C.V. Wedgwood' WHERE titulo LIKE '%thirty years war%';
UPDATE dim_libros SET autor = 'John Fante' WHERE titulo LIKE '%ask the dust%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%wild things%' OR titulo LIKE '%sun signs%';

-- 1. DISABLE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- 2. UPDATE AUTHORS BASED ON PROVIDED LIST
UPDATE dim_libros SET autor = 'David McCullough' WHERE titulo LIKE '%truman%';
UPDATE dim_libros SET autor = 'Nicholas Sparks' WHERE titulo LIKE '%bend in the road%';
UPDATE dim_libros SET autor = 'Ursula K. Le Guin' WHERE titulo LIKE '%wizard of earthsea%';
UPDATE dim_libros SET autor = 'Lynne Wilcox' WHERE titulo LIKE '%maui revealed%';
UPDATE dim_libros SET autor = 'Mary Manz Simon' WHERE titulo LIKE '%daily strength for daily needs%';
UPDATE dim_libros SET autor = 'Philip Roth' WHERE titulo LIKE '%plot against america%';
UPDATE dim_libros SET autor = 'Daniel Defoe' WHERE titulo LIKE '%robinson crusoe%';
UPDATE dim_libros SET autor = 'John Steinbeck' WHERE titulo LIKE '%in dubious battle%';
UPDATE dim_libros SET autor = 'Julie Garwood' WHERE titulo LIKE 'the wedding%' AND (autor = 'Unknown' OR autor IS NULL);
UPDATE dim_libros SET autor = 'Jacob Riis' WHERE titulo LIKE '%how the other half lives%';
UPDATE dim_libros SET autor = 'James Surowiecki' WHERE titulo LIKE '%wisdom of crowds%';
UPDATE dim_libros SET autor = 'Paul de Kruif' WHERE titulo LIKE '%microbe hunters%';
UPDATE dim_libros SET autor = 'Thomas Hardy' WHERE titulo LIKE '%tess of the d%ubervilles%';
UPDATE dim_libros SET autor = 'Tim LaHaye, Jerry B. Jenkins' WHERE titulo LIKE '%soul harvest%';
UPDATE dim_libros SET autor = 'Eliyahu M. Goldratt' WHERE titulo LIKE 'the goal%ongoing improvement%';
UPDATE dim_libros SET autor = 'Natalie Babbitt' WHERE titulo LIKE '%search for delicious%';
UPDATE dim_libros SET autor = 'Frédéric Bastiat' WHERE titulo LIKE 'the law' OR titulo LIKE 'the law %';
UPDATE dim_libros SET autor = 'Jules Verne' WHERE titulo LIKE '%twenty thousand leagues under the sea%';
UPDATE dim_libros SET autor = 'Michael J. Fox' WHERE titulo LIKE '%lucky man%';
UPDATE dim_libros SET autor = 'Georgette Heyer' WHERE titulo LIKE '%infamous army%';
UPDATE dim_libros SET autor = 'C.S. Forester' WHERE titulo LIKE '%hornblower and the atropos%';
UPDATE dim_libros SET autor = 'Elizabeth Young' WHERE titulo LIKE '%asking for trouble%';
UPDATE dim_libros SET autor = 'David Malouf' WHERE titulo LIKE 'ransom%' AND (autor = 'Unknown' OR autor IS NULL);
UPDATE dim_libros SET autor = 'Harold Keith' WHERE titulo LIKE '%rifles for watie%';
UPDATE dim_libros SET autor = 'Maya Angelou' WHERE titulo LIKE '%i know why the caged bird sings%';
UPDATE dim_libros SET autor = 'Bill Martin Jr., John Archambault' WHERE titulo LIKE '%chicka chicka boom boom%';
UPDATE dim_libros SET autor = 'Dorothy L. Sayers' WHERE titulo LIKE '%have his carcase%';

-- 3. RE-ENABLE SAFE MODE
SET SQL_SAFE_UPDATES = 1;

-- 4. FINAL VERIFICATION
SELECT titulo, autor FROM dim_libros 
WHERE titulo LIKE '%robinson crusoe%' OR titulo LIKE '%wisdom of crowds%';

SELECT 
    l.titulo, 
    COUNT(r.puntuacion) AS total_valoraciones
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
WHERE l.autor = 'Unknown' OR l.autor IS NULL
GROUP BY l.titulo
ORDER BY total_valoraciones DESC
LIMIT 30;

-- TITLE: Final Audit of Missing Authors
USE bookproject_db;

SELECT 
    'Total General' AS Metrica,
    COUNT(*) AS Cantidad,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM dim_libros)) * 100, 2) AS Porcentaje
FROM dim_libros
WHERE autor IN ('Unknown', 'Otros/No Identificado') OR autor IS NULL

UNION ALL

-- Libros con más de 100 valoraciones que aún no tienen autor
SELECT 
    'Libros Relevantes (>100 ratings) sin autor',
    COUNT(*),
    NULL
FROM (
    SELECT l.isbn
    FROM dim_libros l
    JOIN fact_ratings r ON l.isbn = r.isbn
    WHERE l.autor IN ('Unknown', 'Otros/No Identificado') OR l.autor IS NULL
    GROUP BY l.isbn
    HAVING COUNT(r.puntuacion) > 100
) AS relevantes;

-- TITLE: Detailed List of the 315 Relevant Missing Authors
USE bookproject_db;

SELECT 
    l.titulo, 
    COUNT(r.puntuacion) AS total_valoraciones,
    l.isbn
FROM dim_libros l
JOIN fact_ratings r ON l.isbn = r.isbn
WHERE l.autor IN ('Unknown', 'Otros/No Identificado') OR l.autor IS NULL
GROUP BY l.isbn, l.titulo
HAVING total_valoraciones > 100
ORDER BY total_valoraciones DESC;