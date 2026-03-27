# Proyecto_final_bookshop

Un análisis de Global de Amazon, Goodreads & Book-Crossing. Este proyecto representa un caso de estudio integral de Data Analytics centrado en el mercado editorial global. El objetivo principal es transformar datos brutos y desestructurados de múltiples fuentes en un tablero de control estratégico que facilite la toma de decisiones comerciales, optimizando la inversión en publicidad y stock.

# Modelo de Inteligencia Comercial: Optimización de Inventario y Estrategia de Ventas

Este proyecto desarrolla un ecosistema de **Business Intelligence (BI)** y **Data Engineering** para una librería en fase de expansión. El objetivo es transformar datos masivos de consumo en decisiones estratégicas que minimicen el riesgo de stock y maximicen el ticket medio de venta.

##  Recursos del Proyecto
* **Presentación :** [Ver Google Slides](https://docs.google.com/presentation/d/1eeFIxeGN6d-NAhE0s4PX1EhfesNQmhR7aYx7UgI_lkA/edit?usp=sharing)
* **Dashboard Interactivo:** `Dashboard.pbix` (Power BI incluido en el repositorio)

---

##  Stack Tecnológico
* **Lenguajes:** SQL (MySQL/MariaDB), Python (Pandas, SQLalchemy).
* **IA & NLP:** Clasificación masiva de géneros mediante LLM (Large Language Models) para enriquecimiento de metadatos.
* **BI:** Power BI Desktop (Modelado en estrella y segmentación avanzada con DAX).
* **Entorno:** Jupyter Notebooks (`main.ipynb`).

---

## Arquitectura de Datos y ETL
El proyecto integra tres fuentes de datos masivas para obtener una visión **360°** del mercado:

| Dataset | Registros | Aportación Estratégica |
| :--- | :--- | :--- |
| **Amazon Books** | ~3.6M | Precios, Categorías y Ratings de mercado. |
| **Goodreads** | ~11K | Metadatos técnicos (Nº páginas, Idioma, Calidad). |
| **Book-Crossing** | ~927K | Perfil demográfico (Edad, Ubicación) y Transacciones. |

### Enriquecimiento de Datos con IA (Categorización)
Para resolver la falta de géneros estandarizados, se diseñó un flujo de **Data Quality**:
* **Manual Labeling:** `unique_titles_book_id.csv` (Base de referencia).
* **IA Backfilling:** Procesamiento de títulos pendientes mediante modelos de lenguaje (`unique_titles_book_id_backfill.csv`).
* **Consolidación:** Integración de resultados desde `classification_results.csv` para optimizar la precisión de las categorías.

---

## Modelado de Datos (Star Schema)
Se implementó un **Modelo en Estrella** para garantizar la escalabilidad y el rendimiento del dashboard:

* **Tablas de Hechos:** `fact_ratings` (Puntuaciones y transacciones unificadas).
* **Dimensiones:** * `dim_libros`: ISBN, Título, Autor, Categoría (IA-Enriched), Precio.
    * `dim_usuarios`: ID, Edad (Segmentada por DAX), Ubicación Geográfica.

---

## Insights Clave (Business Intelligence)
* **Dominio de Ficción:** 31% del volumen total. Actúa como motor de tráfico principal.
* **Ticket Medio:** € 25. Oportunidad detectada para estrategias de venta cruzada.
* **Geolocalización:** UK (7.73) y USA (7.64) presentan los mayores índices de satisfacción (*Product-Market Fit*).
* **Volatilidad de Rating (3.03):** Se aplica un filtrado por "Rating Real" para optimizar la rotación de inventario.

---

## Estructura del Repositorio
* **`/SQL`**: Scripts de ingeniería de datos (`Esquema estrella.sql`, `Estructura y transformación.sql`).
* **`/Notebooks`**: Proceso de limpieza y backfill de categorías (`main.ipynb`).
* **`/Data`**: Datasets maestros y resultados de clasificación IA.
* **`/PowerBI`**: Visualización interactiva (`Dashboard.pbix`).

---

##  Cómo ejecutar el proyecto
1.  **Infraestructura:** Ejecutar `Estructura y transformación.sql` para preparar el esquema.
2.  **Procesamiento:** Ejecutar `main.ipynb` para procesar los datos y aplicar el backfill de categorías.
3.  **Modelado:** Ejecutar `Esquema estrella.sql` para generar las dimensiones optimizadas.
4.  **Análisis:** Abrir `Dashboard.pbix` y actualizar el origen de datos local.

---

> **Nota de Impacto:** Este modelo permite una reducción estimada del 15% en stock de baja rotación al alinear las compras de inventario con los ratings reales y las tendencias demográficas detectadas.
