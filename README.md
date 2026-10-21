# Sequía de 2026 en Honduras: intensidad histórica, exposición agrícola y focalización territorial

[Explorar las figuras](https://orlando-valladares.github.io/honduras_drought_replication/) · [Leer el informe](docs/downloads/Honduras_ES.pdf) · [Consultar los datos](data/README.md)

Este repositorio presenta un análisis descriptivo independiente de la sequía de Primera de 2026 en Honduras. Combina lluvia CHIRPS v3 para mayo–agosto con resultados agregados del Censo de Honduras de 2013 distribuido por IPUMS International, y separa deliberadamente la intensidad territorial de la exposición de la población clasificada en la rama agrícola. El informe completo conserva las cautelas sobre geografía, denominadores, representatividad y causalidad.

[Descargar el apéndice completo](docs/downloads/Honduras_Appendix_ES.pdf)

## Resultados principales

- La lluvia nacional de Primera de 2026 registra un puntaje estandarizado de **−2,25** frente a la referencia leave-one-out de 1981–2026.
- **51,9%** de las 297 unidades ADM2 observadas se encuentra bajo sequía extrema (`z < −2`).
- **474.615 de 1.077.033 personas** clasificadas en la rama agrícola dentro de 125 grupos GEO2 comparables están expuestas a sequía extrema: **44,1%**. Es una estimación basada en la distribución espacial fija del censo de 2013, no un conteo de trabajadores agrícolas observados en 2026.
- En 2015 la exposición fue **45,5% territorial** y **45,7% agrícola**. En 2026 la sequía es más extensa territorialmente, mientras la proporción agrícola expuesta es ligeramente menor.

## Contenido

- `docs/`: sitio estático para GitHub Pages y versiones definitivas del informe y el apéndice.
- `figures/`: figuras publicadas en formatos de descarga; la figura nueva de precios está en PDF, SVG y PNG.
- `data/derived/`: datos analíticos agregados y ordenados utilizados en los gráficos.
- `data/geography/`: límites de publicación derivados de geoBoundaries, en GeoJSON y Shapefile.
- `code/`: scripts Stata para regenerar gráficos a partir de los datos públicos.
- [methodology.md](methodology.md): métodos, fuentes, reproducción y límites.

## Reproducción

Se requiere Stata 18 o posterior. Desde la raíz del repositorio:

```bash
stata -b do code/00_reproduce_all.do .
```

Los resultados se escriben en `output/figures/`. El flujo fue validado con StataNow 19.5 usando únicamente archivos incluidos aquí. Los gráficos archivados en `figures/` son las versiones exactas del informe; los scripts Stata regeneran sus contenidos analíticos desde los CSV públicos. El panel de FEWS NET es evidencia contextual atribuida y no un resultado calculado.

La reproducción completa desde insumos originales requiere descargas voluminosas de CHIRPS y acceso individual autorizado a microdatos de IPUMS International. Esos insumos no se redistribuyen.

## Fuentes y uso

Las fuentes principales son CHIRPS v3, el Censo de Honduras de 2013 mediante IPUMS International, geoBoundaries, la evaluación rápida de Oxfam y material contextual de FEWS NET. Consulte [la documentación de datos](data/README.md) para atribuciones y restricciones específicas.

Análisis independiente de Orlando Valladares. Última actualización del informe: 18 de octubre de 2026.
