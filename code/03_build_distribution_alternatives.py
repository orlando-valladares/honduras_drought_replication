#!/usr/bin/env python3
"""Build the two pooled-distribution alternatives shown beside Figure 4."""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


FOCAL_YEARS = (2015, 2026)
COLORS = {"Referencia agrupada": "#9aa09f", "2015": "#2457c5", "2026": "#c52b2b"}


def loo(frame: pd.DataFrame, key: str) -> pd.DataFrame:
    out = frame.copy()
    grouped = out.groupby(key)["rain_may_aug_mm"]
    count = grouped.transform("count")
    total = grouped.transform("sum")
    squares = out.assign(_square=out.rain_may_aug_mm.pow(2)).groupby(key)["_square"].transform("sum")
    mean = (total - out.rain_may_aug_mm) / (count - 1)
    variance = (squares - out.rain_may_aug_mm.pow(2) - (count - 1) * mean.pow(2)) / (count - 2)
    out["z_loo"] = (out.rain_may_aug_mm - mean) / np.sqrt(variance.clip(lower=0))
    return out


def prepare_inputs(source: Path, destination: Path) -> pd.DataFrame:
    municipal = pd.read_csv(source / "brief_context_municipal_periods.csv")
    municipal = loo(municipal.loc[municipal.country_code.eq("HND")], "municipality_id")
    municipal = municipal.loc[municipal.municipality.ne("Lago de Yojoa")].copy()

    crosswalk = pd.read_csv(source / "brief_ipums_residence_group_crosswalk.csv", dtype=str)
    crosswalk = crosswalk.loc[crosswalk.country_code.eq("HND")].copy()
    crosswalk["residence_group_code"] = crosswalk.residence_group_code.str.zfill(6)
    people = pd.read_csv(
        source / "brief_ipums_residence_group_analysis.csv",
        dtype={"residence_group_code": str},
    )
    people = people.loc[
        people.country_code.eq("HND") & people.complete_chirps_group.astype(bool)
    ].drop_duplicates("residence_group_code")
    people["residence_group_code"] = people.residence_group_code.str.zfill(6)
    crosswalk = crosswalk.loc[crosswalk.residence_group_code.isin(set(people.residence_group_code))]

    group_year = municipal.merge(
        crosswalk[["municipality_id", "residence_group_code"]],
        on="municipality_id",
        how="inner",
    )
    group_year = (
        group_year.groupby(["year", "residence_group_code"], as_index=False)
        .agg(z_loo=("z_loo", "mean"))
        .merge(
            people[["residence_group_code", "agricultural_industry_people"]],
            on="residence_group_code",
            validate="many_to_one",
        )
    )

    adm2 = municipal[["year", "z_loo"]].assign(
        population="Municipios ADM2", weight=1.0
    )
    agriculture = group_year[["year", "z_loo", "agricultural_industry_people"]].rename(
        columns={"agricultural_industry_people": "weight"}
    )
    agriculture["population"] = "Trabajadores agrícolas (Censo 2013)"
    inputs = pd.concat(
        [adm2[["population", "year", "z_loo", "weight"]],
         agriculture[["population", "year", "z_loo", "weight"]]],
        ignore_index=True,
    )
    inputs["series"] = np.where(
        inputs.year.eq(2015), "2015",
        np.where(inputs.year.eq(2026), "2026", "Referencia agrupada"),
    )
    destination.parent.mkdir(parents=True, exist_ok=True)
    inputs.to_csv(destination, index=False)
    return inputs


def weighted_kde(values: np.ndarray, weights: np.ndarray, grid: np.ndarray) -> np.ndarray:
    mask = np.isfinite(values) & np.isfinite(weights) & (weights > 0)
    values, weights = values[mask], weights[mask]
    weights = weights / weights.sum()
    mean = np.sum(weights * values)
    sd = np.sqrt(np.sum(weights * (values - mean) ** 2))
    effective_n = 1.0 / np.sum(weights**2)
    bandwidth = max(0.12, 1.06 * sd * effective_n ** (-0.2))
    scaled = (grid[:, None] - values[None, :]) / bandwidth
    return np.exp(-0.5 * scaled**2).dot(weights) / (bandwidth * np.sqrt(2 * np.pi))


def build_curves(inputs: pd.DataFrame) -> pd.DataFrame:
    grid = np.linspace(-4.5, 2.5, 421)
    rows = []
    for population in inputs.population.unique():
        for series in ("Referencia agrupada", "2015", "2026"):
            selected = inputs.loc[
                inputs.population.eq(population) & inputs.series.eq(series)
            ]
            density = weighted_kde(
                selected.z_loo.to_numpy(),
                selected.weight.to_numpy(),
                grid,
            )
            rows.append(pd.DataFrame({
                "population": population,
                "series": series,
                "z_loo": grid,
                "density": density,
                "observations": len(selected),
                "total_weight": selected.weight.sum(),
            }))
    return pd.concat(rows, ignore_index=True)


def save_plot(curves: pd.DataFrame, population: str, title: str, stem: str, root: Path) -> None:
    fig, ax = plt.subplots(figsize=(6.8, 4.35))
    subset = curves.loc[curves.population.eq(population)]
    for series, width in (("Referencia agrupada", 1.4), ("2015", 2.0), ("2026", 2.0)):
        line = subset.loc[subset.series.eq(series)]
        ax.plot(line.z_loo, line.density, color=COLORS[series], lw=width, label=series)
    ax.axvline(-2, color="#333333", lw=0.9, ls=":")
    ax.set_xlim(-4.5, 2.5)
    ax.set_ylim(bottom=0)
    ax.set_xlabel("Puntaje z LOO")
    ax.set_ylabel("Densidad")
    ax.set_title(title, loc="left", fontsize=11, fontweight="semibold")
    ax.grid(color="#e8e8e8", lw=0.55)
    ax.legend(frameon=False, ncol=3, loc="upper left", fontsize=8)
    fig.subplots_adjust(left=.11, right=.98, top=.88, bottom=.14)

    targets = {
        "pdf": [root / "figures/pdf", root / "docs/downloads/figures"],
        "png": [root / "figures/png", root / "docs/figures"],
        "svg": [root / "figures/svg"],
    }
    for extension, directories in targets.items():
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            kwargs = {"dpi": 220} if extension == "png" else {}
            fig.savefig(
                directory / f"{stem}.{extension}",
                bbox_inches="tight",
                pad_inches=.05,
                facecolor="white",
                **kwargs,
            )
    plt.close(fig)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--source-derived", type=Path)
    args = parser.parse_args()
    root = args.root.resolve()
    input_csv = root / "data/derived/distribution_density_inputs.csv"
    inputs = prepare_inputs(args.source_derived, input_csv) if args.source_derived else pd.read_csv(input_csv)
    inputs.to_csv(root / "docs/data/distribution_density_inputs.csv", index=False)
    curves = build_curves(inputs)
    curves.to_csv(root / "data/derived/distribution_density_curves.csv", index=False)
    curves.to_csv(root / "docs/data/distribution_density_curves.csv", index=False)
    build_specs = [
        ("Municipios ADM2", "Distribución agrupada de municipios ADM2", "figure-4a-distribucion-adm2"),
        ("Trabajadores agrícolas (Censo 2013)", "Distribución ponderada de trabajadores agrícolas", "figure-4b-distribucion-agricultura"),
    ]
    for population, title, stem in build_specs:
        save_plot(curves, population, title, stem, root)


if __name__ == "__main__":
    main()
