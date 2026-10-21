version 18.0
set more off

* Conversión de los límites CC BY 4.0 suministrados a formatos espaciales de Stata.
local starting_directory `"`c(pwd)'"'
foreach boundary in honduras_adm2 honduras_departments honduras_geo2 {
    foreach extension in shp dbf shx prj cpg {
        copy "$publication_root/data/geography/`boundary'.`extension'" ///
            "$publication_root/output/spatial/`boundary'.`extension'", replace
    }
}
cd "$publication_root/output/spatial"
spshape2dta honduras_adm2, replace
spshape2dta honduras_departments, replace
spshape2dta honduras_geo2, replace
cd `"`starting_directory'"'
capture grmap, activate

* Figura 1: sequía municipal de 2026.
import delimited using "$publication_root/data/derived/municipal_rainfall_z_1981_2026.csv", ///
    varnames(1) encoding("utf-8") stringcols(1) clear
keep if year == 2026
keep adm2_id z_loo
tempfile rainfall_2026
save `rainfall_2026'
use "$publication_root/output/spatial/honduras_adm2", clear
merge 1:1 adm2_id using `rainfall_2026', assert(match) nogenerate
grmap z_loo using "$publication_root/output/spatial/honduras_adm2_shp", ///
    id(_ID) clmethod(custom) clbreaks(-10 -2.5 -2 -1.5 -1 -.5 0 .5 1 1.5 10) ///
    fcolor(RdYlBu) ocolor(white ..) osize(vthin ..) ///
    legend(size(vsmall)) graphregion(color(white))
graph export "$publication_root/output/figures/figure-1-mapa-municipal.pdf", replace
graph export "$publication_root/output/figures/figure-1-mapa-municipal.png", width(1800) replace

* Paneles analíticos de la Figura 5.
import delimited using "$publication_root/data/derived/department_priority_2026.csv", ///
    varnames(1) encoding("utf-8") clear
keep department agricultural_industry_people agriculture_share_known_industry p
tempfile department_values
save `department_values'
use "$publication_root/output/spatial/honduras_departments", clear
merge 1:1 department using `department_values', assert(match) nogenerate
grmap agricultural_industry_people using ///
    "$publication_root/output/spatial/honduras_departments_shp", ///
    id(_ID) fcolor(Greens) ocolor(white ..) osize(vthin ..) ///
    title("(a) Personas en la rama agrícola", size(small)) ///
    legend(size(vsmall)) graphregion(color(white)) name(panel_a, replace)
graph export "$publication_root/output/figures/figure-5a.pdf", replace
grmap agriculture_share_known_industry using ///
    "$publication_root/output/spatial/honduras_departments_shp", ///
    id(_ID) fcolor(Blues) ocolor(white ..) osize(vthin ..) ///
    title("(b) Participación agrícola", size(small)) ///
    legend(size(vsmall)) graphregion(color(white)) name(panel_b, replace)
graph export "$publication_root/output/figures/figure-5b.pdf", replace
grmap p using "$publication_root/output/spatial/honduras_departments_shp", ///
    id(_ID) fcolor(Heat) ocolor(white ..) osize(vthin ..) ///
    title("(c) Índice combinado de prioridad", size(small)) ///
    legend(size(vsmall)) graphregion(color(white)) name(panel_c, replace)
graph export "$publication_root/output/figures/figure-5c.pdf", replace
graph combine panel_a panel_b panel_c, cols(2) graphregion(color(white))
graph export "$publication_root/output/figures/figure-5-paneles-analiticos.pdf", replace

display as text "El panel (d) es contexto FEWS NET, no un resultado calculado."
display as text "Su imagen atribuida se conserva en figures/png/figure-5d-fews-net-context.png."
