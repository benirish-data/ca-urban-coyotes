# 03_classify_urban.R
# Label each coyote observation as urban or non-urban by testing whether
# its coordinates fall within a US Census urban-area polygon.

library(dplyr)
library(sf)
library(tigris)

options(tigris_use_cache = TRUE)

coyote <- readRDS("data/processed/coyote_clean.rds")


# --- 1. Convert observations to spatial points --------------------------

# st_as_sf builds a spatial object from the lat/lon columns. crs = 4326
# is the standard GPS coordinate system (WGS84).
coyote_sf <- st_as_sf(
  coyote,
  coords = c("lon", "lat"),
  crs = 4326,
  remove = FALSE
)


# --- 2. Download Census urban-area boundaries ---------------------------

# Census urban areas are national; filter to those intersecting California
# after loading. The polygons arrive in CRS 4269; transform to 4326 to
# match the points.
urban <- urban_areas(year = 2020) |>
  st_transform(4326)


# --- 3. Spatial join: which points fall inside an urban area ------------

# st_within returns, for each point, the index of any urban polygon that
# contains it. Points in no polygon get NA.
within_urban <- st_within(coyote_sf, urban)
is_urban <- lengths(within_urban) > 0

coyote_sf$urban <- ifelse(is_urban, "Urban", "Non-urban")


# --- 4. Drop geometry, save a plain data frame --------------------------

coyote_out <- coyote_sf |>
  st_drop_geometry()

saveRDS(coyote_out, "data/processed/coyote_classified.rds")


# --- 5. Sanity check ----------------------------------------------------

cat("Records:", nrow(coyote_out), "\n")
print(table(coyote_out$urban))
cat("Urban proportion:",
    round(mean(coyote_out$urban == "Urban"), 3), "\n")