# Projet: Analyse des pharmacies en Tunisie

Ce projet Quarto presente une analyse descriptive des pharmacies en Tunisie, par delegation et gouvernorat. Il inclut une page d'analyse complete et une presentation en slides.

## Contenu

- `qmd/pharmacies_analysis.qmd` : analyse principale (statistiques, classements, comparaisons).
- `QuartoSlides/presentation.qmd` : presentation synthese (revealjs).
- `index.qmd` : page d'accueil du site.
- `qmd/data/pharmacies.csv` : donnees source.
- `_quarto.yml` : configuration du site Quarto.

## Prerequis

- Quarto installe
- R installe
- Packages R: `tidyverse` (installe automatiquement si absent)

## Rendu local

Rendre l'analyse:

```bash
quarto render qmd/pharmacies_analysis.qmd
```

Previsualiser la presentation:

```bash
quarto preview QuartoSlides/presentation.qmd --no-browser --no-watch-inputs
```

## Notes

- Les donnees sont lues depuis `qmd/data/pharmacies.csv`.
- Les chemins de lecture sont adaptes pour fonctionner depuis `qmd/` ou `QuartoSlides/`.
