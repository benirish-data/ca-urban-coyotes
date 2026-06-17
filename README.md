# Urban Coyotes in California

An exploratory analysis of ~24,000 coyote (*Canis latrans*) occurrence records
from the Global Biodiversity Information Facility (GBIF), examining where and
when coyotes are observed across California and how observations differ between
urban and non-urban areas.

## The question

Coyotes occupy nearly every environment in California, from dense cities to
remote wildlands. This project asks three descriptive questions:

- Where are coyotes observed across the state?
- How has the volume of observations changed over time?
- How does the urban vs. non-urban split vary by year and by season?

A recurring theme runs through the analysis: occurrence data records where and
when *people* observe coyotes, which is not the same as where and when coyotes
actually are. The report treats this observation bias as a central limitation
rather than an afterthought.

## Key findings

- Coyote observations span the entire state, with a near-even split between
  urban (47%) and non-urban (53%) records.
- Annual observations rose sharply after the mid-2010s, driven largely by the
  growth of citizen-science platforms rather than a population boom.
- The urban share of observations roughly doubled from ~20% (2010) to ~50%
  (early 2020s), reflecting both real urban colonization and the spread of
  observation apps into cities.
- Urban and non-urban observations peak in different seasons (urban in summer,
  non-urban in winter).

## Data

GBIF occurrence download for *Canis latrans* in California, filtered to
georeferenced records with coordinate uncertainty under 5 km.

- Source: GBIF.org, DOI 10.15468/dl.dxmt6t (https://doi.org/10.15468/dl.dxmt6t)
- ~24,000 records spanning 1886-2026

## Repository structure

    R/
      01_download.R         download occurrence data from GBIF
      02_clean.R            parse dates, filter, select columns
      03_classify_urban.R   tag each record urban / non-urban via Census boundaries
    Ben_Irish_Project_3.qmd the full analysis and report
    Ben_Irish_Project_3.pdf rendered report

## Tools

R, with rgbif, sf, tigris, dplyr, ggplot2, and Quarto.

## Reproducing the analysis

The scripts in R/ run in order (01 -> 02 -> 03) to produce the cleaned,
classified dataset. The Quarto report reads that dataset to generate all
figures and tables. Rendering requires a LaTeX installation (e.g. tinytex)
for PDF output.
