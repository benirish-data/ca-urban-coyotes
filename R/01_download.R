# 01_download.R
# Download all California coyote (Canis latrans) occurrence records from
# GBIF via an async download. Saves the raw data and the GBIF DOI for
# citation.

library(rgbif)
library(dplyr)


# --- 1. Resolve the coyote taxon key ------------------------------------

# GBIF identifies taxa by integer key
coyote <- name_backbone(name = "Canis latrans")
coyote_key <- coyote$usageKey
cat("Coyote taxon key:", coyote_key, "\n")


# --- 2. Trigger the download --------------------------------------------

# Restricted to coyote, California, US, and georeferenced records;
# lat/long is required for mapping.
dl <- occ_download(
  pred("taxonKey", coyote_key),
  pred("stateProvince", "California"),
  pred("country", "US"),
  pred("hasCoordinate", TRUE),
  format = "SIMPLE_CSV"
)


# --- 3. Retrieve the download -------------------------------------------

occ_download_wait(dl)
dl_info <- occ_download_get(dl, path = "data/raw", overwrite = TRUE)
occ     <- occ_download_import(dl_info)


# --- 4. Save raw data and citation --------------------------------------

saveRDS(occ, "data/raw/coyote_ca_raw.rds")
saveRDS(occ_download_meta(dl), "data/raw/gbif_citation.rds")


# --- 5. Check ----------------------------------------------------

cat("Records:", nrow(occ), "\n")
cat("Columns:", ncol(occ), "\n")
cat("DOI:    ", occ_download_meta(dl)$doi, "\n")

