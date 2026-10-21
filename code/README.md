# Reproducción en Stata

Ejecute desde la raíz del repositorio:

```bash
stata -b do code/00_reproduce_all.do .
```

El controlador crea `output/figures/` y llama:

- `01_reproduce_charts.do`: Figuras 2, 3, 4 y A3.
- `02_reproduce_maps.do`: Figura 1 y paneles analíticos 5a–5c.

Se requiere Stata 18 o posterior. El flujo usa `spshape2dta` y `grmap`; la copia validada fue StataNow 19.5. `grmap` se activa localmente si todavía no está activo. No se descarga ningún dato durante la ejecución.

Los resultados regenerados son representaciones Stata de los mismos datos publicados. Las figuras exactas usadas en el informe se conservan en `figures/`. El panel 5d es una imagen contextual de FEWS NET y no se recalcula; el compuesto completo también está archivado en PDF y PNG.

Los archivos `output/` y los logs están excluidos de Git.
