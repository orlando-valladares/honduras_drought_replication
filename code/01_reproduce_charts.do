version 18.0
set more off

* Figura 2: exposición histórica.
import delimited using "$publication_root/data/derived/annual_exposure_1981_2026.csv", ///
    varnames(1) encoding("utf-8") clear
generate double plot_year = year
replace plot_year = 2027.25 if year == 2026
generate str8 territorial_label = string(municipal_pct, "%4.1f") + "%" ///
    if inlist(year, 2015, 2026)
generate str8 agricultural_label = string(agricultural_pct, "%4.1f") + "%" ///
    if inlist(year, 2015, 2026)
twoway ///
    (bar municipal_pct plot_year, barwidth(.32) color(navy)) ///
    (bar agricultural_pct plot_year, barwidth(.32) color(orange)) ///
    (scatter municipal_pct plot_year if inlist(year, 2015, 2026), ///
        msymbol(none) mlabel(territorial_label) mlabcolor(navy) mlabposition(11)) ///
    (scatter agricultural_pct plot_year if inlist(year, 2015, 2026), ///
        msymbol(none) mlabel(agricultural_label) mlabcolor(orange) mlabposition(1)), ///
    xlabel(1981 1985 1990 1995 2000 2005 2010 2015 2020 2025 2027.25 "2026", ///
        angle(45) labsize(small)) ///
    ylabel(0(20)100, angle(horizontal)) ytitle("Porcentaje") xtitle("") ///
    legend(order(1 "Unidades ADM2" 2 "Personas agrícolas (GEO2)") rows(2) ///
        position(11) ring(0) region(lcolor(none))) ///
    graphregion(color(white)) plotregion(color(white))
graph export "$publication_root/output/figures/figure-2-exposicion-historica.pdf", replace
graph export "$publication_root/output/figures/figure-2-exposicion-historica.svg", replace
graph export "$publication_root/output/figures/figure-2-exposicion-historica.png", width(1800) replace

* Figura 3: departamentos en su escala histórica local.
import delimited using "$publication_root/data/derived/department_historical_comparison.csv", ///
    varnames(1) encoding("utf-8") clear
sort historical_mean_mm
generate byte plot_order = _n
capture label drop department_order
forvalues i = 1/`=_N' {
    local department_name = department[`i']
    label define department_order `i' `"`department_name'"', add
}
label values plot_order department_order
generate double lower = historical_mean_mm - historical_sd_mm
generate double upper = historical_mean_mm + historical_sd_mm
twoway ///
    (rcap lower upper plot_order, horizontal lcolor(gs10) lwidth(medthick)) ///
    (scatter plot_order historical_mean_mm, msymbol(pipe) mcolor(black)) ///
    (scatter plot_order historical_median_mm, msymbol(x) mcolor(gs6)) ///
    (scatter plot_order rain_2015_mm, msymbol(triangle) mcolor(navy)) ///
    (scatter plot_order rain_2026_mm, msymbol(circle) mcolor(maroon)), ///
    ylabel(1(1)18, valuelabel angle(horizontal) labsize(vsmall)) ///
    xlabel(, labsize(small) grid) xtitle("Lluvia mayo–agosto (mm)") ytitle("") ///
    legend(order(2 "Media histórica" 3 "Mediana histórica" 4 "2015" 5 "2026") ///
        cols(2) region(lcolor(none))) graphregion(color(white)) plotregion(color(white))
graph export "$publication_root/output/figures/figure-3-comparacion-departamental.pdf", replace
graph export "$publication_root/output/figures/figure-3-comparacion-departamental.svg", replace
graph export "$publication_root/output/figures/figure-3-comparacion-departamental.png", width(1800) replace

* Figura 4: distribuciones acumuladas.
import delimited using "$publication_root/data/derived/cdf_curves_2015_2026.csv", ///
    varnames(1) encoding("utf-8") clear
twoway ///
    (line cumulative_share z_loo if curve_id == "adm2_reference_1981_2025", ///
        sort lcolor(gs10) lwidth(thin)) ///
    (line cumulative_share z_loo if curve_id == "adm2_2015", ///
        sort lcolor(navy) lwidth(medthick)) ///
    (line cumulative_share z_loo if curve_id == "geo2_agricultural_2015", ///
        sort lcolor(navy) lpattern(dash) lwidth(medium)) ///
    (line cumulative_share z_loo if curve_id == "adm2_2026", ///
        sort lcolor(maroon) lwidth(medthick)) ///
    (line cumulative_share z_loo if curve_id == "geo2_agricultural_2026", ///
        sort lcolor(maroon) lpattern(dash) lwidth(medium)), ///
    xline(-2, lcolor(gs5) lpattern(dot)) xscale(range(-4 2.5)) ///
    yscale(range(0 1)) ylabel(0(.2)1, angle(horizontal)) ///
    xtitle("Puntaje z LOO") ytitle("Proporción acumulada") ///
    legend(order(1 "Referencia municipio–año" 2 "Municipios 2015" ///
        3 "Agricultura 2015" 4 "Municipios 2026" 5 "Agricultura 2026") ///
        cols(1) position(11) ring(0) region(lcolor(none)) size(vsmall)) ///
    graphregion(color(white)) plotregion(color(white))
graph export "$publication_root/output/figures/figure-4-distribuciones-acumuladas.pdf", replace
graph export "$publication_root/output/figures/figure-4-distribuciones-acumuladas.svg", replace
graph export "$publication_root/output/figures/figure-4-distribuciones-acumuladas.png", width(1800) replace

* Figura A3: precios nominales, enero de cada año = 100.
import delimited using "$publication_root/data/derived/maize_prices_2015_2026.csv", ///
    varnames(1) encoding("utf-8") clear
assert abs(price_hnl_per_tonne - 7758.85) < .001 if year == 2015 & month == 1
assert abs(price_hnl_per_tonne - 9810.95) < .001 if year == 2015 & month == 7
assert abs(price_hnl_per_tonne - 11910.44) < .001 if year == 2026 & month == 1
assert abs(price_hnl_per_tonne - 17445.15) < .001 if year == 2026 & month == 8
twoway ///
    (connected price_index_january_100 month if year == 2015, sort ///
        lcolor(navy) mcolor(navy) msymbol(circle) lwidth(medthick)) ///
    (connected price_index_january_100 month if year == 2026, sort ///
        lcolor(orange) mcolor(orange) msymbol(diamond) lwidth(medthick)), ///
    xlabel(1 "Ene" 2 "Feb" 3 "Mar" 4 "Abr" 5 "May" 6 "Jun" 7 "Jul" 8 "Ago") ///
    ylabel(100(10)150, angle(horizontal)) yscale(range(98 154)) ///
    ytitle("Índice de precio nominal (enero = 100)") xtitle("") ///
    text(128.8 7 "+26,4% en julio", color(navy)) ///
    text(149.2 8 "+46,5% en agosto", color(orange) placement(nw)) ///
    legend(order(1 "2015" 2 "2026") rows(1) position(11) ring(0) ///
        region(lcolor(none))) graphregion(color(white)) plotregion(color(white))
graph export "$publication_root/output/figures/appendix-a3-precios-maiz.pdf", replace
graph export "$publication_root/output/figures/appendix-a3-precios-maiz.svg", replace
graph export "$publication_root/output/figures/appendix-a3-precios-maiz.png", width(1800) replace
