# Datos publicados

Este directorio contiene únicamente datos analíticos agregados o climáticos derivados necesarios para reproducir las figuras. No contiene microdatos individuales, hogares, credenciales ni archivos de extracción de IPUMS.

## Inventario

| Archivo | Filas | Unidad | Años | Uso principal |
|---|---:|---|---|---|
| `derived/municipal_rainfall_z_1981_2026.csv` | 13.662 | ADM2–año | 1981–2026 | Figuras 1, 4 y A2 |
| `derived/annual_exposure_1981_2026.csv` | 46 | año | 1981–2026 | Figura 2 |
| `derived/drought_bands_2015_2026.csv` | 10 | año–banda | 2015, 2026 | Tabla A1 |
| `derived/department_rainfall_z_1981_2026.csv` | 828 | departamento–año | 1981–2026 | Figura 3 y Tabla A3 |
| `derived/department_historical_comparison.csv` | 18 | departamento | 2015, 2026 y referencia | Figura 3 |
| `derived/cdf_curves_2015_2026.csv` | 14.209 | punto de curva | 2015, 2026 y referencia | Figura 4 |
| `derived/distribution_density_inputs.csv` | 19.412 | ADM2–año o GEO2–año | 1981–2026 | Insumos agregados de las vistas alternativas de Figura 4 |
| `derived/distribution_density_curves.csv` | 2.526 | punto de curva | 2015, 2026 y referencia agrupada | Densidades alternativas de Figura 4 |
| `derived/geo2_exposure_2015_2026.csv` | 250 | GEO2–año | 2015, 2026 | Figuras 2 y 4 |
| `derived/geo2_priority_2026.csv` | 125 | GEO2 | 2026 con población fija de 2013 | Figura A1 |
| `derived/department_priority_2026.csv` | 18 | departamento | 2026 con población fija de 2013 | Figura 5 |
| `derived/maize_price_figure_a3.csv` | 12 | mes | enero–diciembre | Figura A3: trayectorias focales y resumen histórico |
| `derived/maize_price_normalized_monthly.csv` | 321 | mes–año | 2000–2026 | Observaciones, normalización y banderas de selección de A3 |
| `derived/maize_price_reference_selection.csv` | 27 | año | 2000–2026 | Auditoría de elegibilidad de años de referencia de A3 |
| `derived/maize_prices_2015_2026.csv` | 16 | mes–año | enero–agosto de 2015 y 2026 | Archivo focal anterior, conservado para trazabilidad |
| `derived/oxfam_department_summary_2026.csv` | 4 | departamento de Honduras | 2026 | Tabla A2 y contexto de Figura 4 |

El diccionario variable por variable está en [data-dictionary.csv](data-dictionary.csv). Todos los CSV usan UTF-8, punto decimal, ausencia vacía y códigos geográficos como texto.

## Geografía

`geography/` contiene límites ADM0, ADM2, departamentales y GEO2 en GeoJSON, además de Shapefiles para Stata. Los códigos `adm2_id` y `geo2_code` enlazan con los CSV. ADM2 y GEO2 son niveles distintos y no deben intercambiarse.

Los límites provienen de geoBoundaries CGAZ, se filtraron a Honduras y se simplificaron topológicamente a 0,0005 grados. Licencia: CC BY 4.0. Atribución: geoBoundaries, William & Mary geoLab. La simplificación es una modificación para publicación.

## Fuentes y restricciones

CHIRPS es de dominio público. Los conteos agrícolas son resultados agregados derivados del Censo de Honduras de 2013 mediante IPUMS International. IPUMS prohíbe redistribuir los microdatos, por lo que este repositorio publica solo estadísticas agregadas autorizadas como resultados de investigación. Quien desee reproducir el procesamiento desde personas individuales debe solicitar su propio acceso a IPUMS.

Los datos Oxfam son agregados descriptivos de una muestra intencional y no nacionalmente representativa. El archivo de precios recibido no identifica al proveedor institucional original; esta limitación se mantiene explícita.
