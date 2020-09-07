library(knitr)
library(tidyverse)
library(sf)
library(raster)
library(getlandsat)
library(mapview)
library(osmdata)

palo_and_area = read_csv('../geog176A-daily-exercises/uscities.csv') %>%
  filter(city == 'Palo') %>%
  st_as_sf(coords = c('lng','lat'), crs = 4326) %>%
  st_transform(5070) %>%
  st_buffer(5000) %>%
  st_bbox() %>%
  st_as_sfc()

palo_tf = st_transform(palo_and_area, 4326) %>%
  st_bbox()

mapview(palo_tf)

####step 1
land = getlandsat::lsat_scenes()
lando = land %>%
  filter(min_lat <= palo_tf$ymin,
         max_lat >= palo_tf$ymax,
         min_lon <= palo_tf$xmin,
         max_lon >= palo_tf$xmax,
         as.Date(acquisitionDate) == as.Date('2016-09-26'))


write.csv(lando, file = "data/palo-flood-scene.csv")
