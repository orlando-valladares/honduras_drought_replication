# Metodología y alcance

## Ventana climática y estandarización

El análisis suma la precipitación CHIRPS v3 de mayo a agosto, correspondiente a Primera. Para cada geografía y año calcula:

```text
z_loo = (lluvia_año − media_de_los_otros_años) / DE_de_los_otros_años
```

La referencia abarca 1981–2026 y excluye siempre el año evaluado. El umbral principal de sequía extrema es `z < −2`. Las medias por área se calcularon antes de preparar este paquete; los CSV públicos contienen los valores resultantes y permiten reconstruir todas las figuras.

## Geografías y denominadores

- **ADM2**: 297 unidades municipales observadas. Lago de Yojoa se muestra sin dato en el material cartográfico original y no entra en los denominadores.
- **GEO2**: 125 grupos de residencia del extracto IPUMS con correspondencia CHIRPS completa. Los conteos permanecen en GEO2; no se reparten artificialmente entre municipios.
- **Departamento**: agregaciones de los municipios o GEO2 correspondientes, según la variable.

La exposición agrícola usa personas clasificadas en `INDGEN=010` —agricultura, ganadería, silvicultura y pesca— y una distribución espacial fija del Censo de 2013. Los 125 grupos comparables contienen 1.077.033 personas agrícolas ponderadas. Esta medida no es un conteo de personas actualmente empleadas en agricultura en 2026 y no reconstruye cambios posteriores en la composición laboral.

## Índice de priorización

El índice departamental y GEO2 es:

```text
R = 100 × D^0,50 × N^0,25 × S^0,25
```

`D`, `N` y `S` son percentiles de rango medio dentro de Honduras para intensidad de sequía, número de personas agrícolas y participación agrícola. Es una herramienta descriptiva de comparación interna; no mide resultados finales de seguridad alimentaria ni sustituye información sobre pobreza, activos, calidad de tierra o capacidad de respuesta.

FEWS NET aporta contexto independiente sobre inseguridad alimentaria y no entra en el cálculo de `R`.

## Precios del maíz

La figura A3 utiliza las 16 observaciones mensuales disponibles entre enero y agosto de 2015 y de 2026. Para cada año:

```text
índice = 100 × precio_mensual / precio_de_enero
```

Se verificaron cuatro observaciones de control: L7.758,85 en enero de 2015; L9.810,95 en julio de 2015; L11.910,44 en enero de 2026; y L17.445,15 en agosto de 2026. No hay interpolación. La comparación es nominal: no ajusta por inflación y no compara precios reales entre años. El archivo fuente recibido no identifica al proveedor institucional original.

## Oxfam

Los archivos públicos contienen únicamente resultados departamentales agregados. La evaluación priorizó comunidades vulnerables y no es representativa a escala nacional. La asociación entre sequía extrema y pérdidas reportadas no identifica un efecto causal ni garantiza un porcentaje de pérdidas para una localidad específica.

## Dos niveles de reproducción

1. **Figuras desde datos publicados.** `code/00_reproduce_all.do` regenera los gráficos analíticos con Stata 18+ usando los CSV y Shapefiles del repositorio.
2. **Procesamiento completo desde fuentes originales.** Requiere datos CHIRPS de gran tamaño y una licencia individual de IPUMS International. Los microdatos no están incluidos y no pueden redistribuirse. Los gráficos de este repositorio, los CSV agregados y los resultados descriptivos sí pueden auditarse sin esos microdatos.

Las versiones archivadas en `figures/` son las que aparecen en los PDFs definitivos. Los mapas regenerados en Stata usan geometrías topológicamente simplificadas a 0,0005 grados para mantener ligero el repositorio, por lo que pueden presentar diferencias subpíxel de costa o borde sin alterar identificadores ni resultados.

## Fuentes, licencias y atribución

- **CHIRPS v3**: Climate Hazards Center, UC Santa Barbara. Datos de precipitación en dominio público.
- **Censo de Honduras 2013 / IPUMS International**: se publican solo resultados agregados. Los microdatos están sujetos a licencia y no se redistribuyen.
- **geoBoundaries CGAZ**: límites administrativos bajo CC BY 4.0; los archivos incluidos fueron filtrados a Honduras y simplificados para publicación. © geoBoundaries, William & Mary geoLab.
- **FEWS NET**: imagen contextual citada a FEWS NET. Su aviso indica que la información e imágenes del sitio pueden copiarse y distribuirse salvo que estén identificadas como protegidas, solicitando atribución.
- **Oxfam en América Latina y el Caribe**: resultados agregados de la evaluación rápida citada en el informe; muestra intencional.
- **Precios mayoristas de maíz blanco**: archivo nacional suministrado al proyecto; proveedor institucional original no identificado en el archivo recibido.

Las referencias bibliográficas completas constan en el informe y el apéndice.
