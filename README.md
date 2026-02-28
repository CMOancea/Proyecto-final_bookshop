# Proyecto_final_bookshop

Un análisis de Global de Amazon, Goodreads & Book-Crossing. Este proyecto representa un caso de estudio integral de Data Analytics centrado en el mercado editorial global. El objetivo principal es transformar datos brutos y desestructurados de múltiples fuentes en un tablero de control estratégico que facilite la toma de decisiones comerciales, optimizando la inversión en publicidad y stock.

# Objetivos de Negocio
A través de este análisis, buscamos dar respuesta a tres pilares fundamentales:Análisis de Mercado: ¿Qué géneros de libros dominan las ventas y generan mayor volumen económico?Segmentación de Audiencia: ¿Cuál es el perfil de edad del consumidor para cada categoría literaria?Geolocalización: ¿Qué países representan los mercados más potentes en términos de consumo y volumen de ventas?
# Stack Tecnológico
  - Lenguaje: Python (Pandas, Numpy, Re) para la ingeniería de datos.
  - Gestión de Datos: SQL para la consulta y estructuración del modelo relacional.
  - Visualización: Power BI para la creación del Dashboard interactivo.
  - Fuente de Datos: Librerías de Kaggle (Amazon Reviews, Goodreads Books y Book-Crossing Dataset).
# El Pipeline del Proyecto
1. Recopilación y Gestión de Datos
      Uso de la librería kagglehub para la ingesta automatizada de 6 archivos core, sumando más de 3.6 millones de registro.
2. Limpieza de Datos (Data Cleaning)
      Estandarización Agresiva: Procesamiento de texto mediante RegEx para unificar títulos, autores y categorías (minúsculas, eliminación de caracteres especiales).
      Tratamiento de Nulos: Imputación inteligente de precios basada en la media por categoría y autor.
      Normalización de Escalas: Conversión de ratings de diferentes fuentes a una escala única de $1$ a $5$ estrellas.
3. Ingeniería de Características (Feature Engineering)
      Segmentación Demográfica: Limpieza y agrupación de edades y ubicaciones de usuarios para análisis de comportamiento.
     Categorización: Agrupación de micro-géneros en categorías macro para mejorar la legibilidad del tablero.
     ISBN Validation: Limpieza y formateo de identificadores para asegurar la integridad referencial.
4. Modelado de Datos (Star Schema)
   Para optimizar el rendimiento en SQL y Power BI, el proyecto migra de archivos planos a un Modelo en Estrella:
   Dim_Books: Catálogo maestro (Título, Autor, Precio, Categoría, ISBN).
   Dim_Users: Perfil sociodemográfico (ID, Edad, Ubicación).
   Fact_Ratings: Tabla de hechos con millones de interacciones y reseñas.
5. Análisis Estadístico y EDA
   Evaluación de correlaciones entre el precio del libro y la valoración del usuario, así como la distribución de frecuencias de ventas por país.
6. Visualización y Dashboard
   Creación de un panel de control interactivo que permite filtrar por país, edad y género, visualizando KPIs en tiempo real.
# Estructura del Repositorio
    /data: Acceso a las rutas de los datasets originales.
    
    limpieza y EDA./notebooks: Jupyter Notebooks con el código de 
    
    /scripts: Funciones de limpieza automatizadas.
    
    /dashboard: Archivo .pbix/ .twb con el tablero final.
