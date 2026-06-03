# 02_clean.R
# Clean the raw GBIF coyote occurrence data: parse dates, select relevant
# columns, drop low-precision and undated records. Urban/non-urban
# classification is added in a later step.

library(dplyr)
library(lubridate)

occ <- readRDS("data/raw/coyote_ca_raw.rds")


# --- 1. Select relevant columns -----------------------------------------

coyote <- occ |>
  select(
    gbif_id        = gbifID,
    lat            = decimalLatitude,
    lon            = decimalLongitude,
    coord_uncert_m = coordinateUncertaintyInMeters,
    event_date     = eventDate,
    year, month, day,
    basis          = basisOfRecord,
    institution    = institutionCode,
    recorded_by    = recordedBy
  )


# --- 2. Parse the event date --------------------------------------------

# eventDate is a string in ISO format; as_date parses it and silently
# returns NA for blank entries.
coyote <- coyote |>
  mutate(event_date = as_date(ymd_hms(event_date, truncated = 3, quiet = TRUE)))


# --- 3. Filter to usable records ----------------------------------------

# Keep records with a year, valid coordinates, and coordinate uncertainty
# under 5 km (5000 m). Records with no uncertainty value are kept, since
# missing uncertainty does not imply imprecision.
coyote <- coyote |>
  filter(
    !is.na(year),
    !is.na(lat), !is.na(lon),
    is.na(coord_uncert_m) | coord_uncert_m <= 5000
  )


# --- 4. Save ------------------------------------------------------------

saveRDS(coyote, "data/processed/coyote_clean.rds")


# --- 5. Check ----------------------------------------------------

cat("Records after cleaning:", nrow(coyote), "\n")
cat("Year range:", min(coyote$year), "-", max(coyote$year), "\n")
cat("Columns:", paste(names(coyote), collapse = ", "), "\n")