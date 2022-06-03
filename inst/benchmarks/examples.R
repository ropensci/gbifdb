options(gbif_unset_aws=FALSE, 
        gbif_default_bucket="gbif",
        gbif_default_version="2021-11-01")
Sys.setenv("GBIF_HOME"="/home/shared-data/gbif",
           AWS_S3_ENDPOINT = "minio.carlboettiger.info")
library(terra)
library(viridisLite)
library(dplyr)
library(gbifdb)

db <- gbif_local()
df <- db |> mutate(latitude = round(decimallatitude),
                   longitude = round(decimallongitude)) |> 
  count(longitude, latitude, year) |> 
  collect() |> 
  mutate(n = log(n),
         year = as.character(year))

fs::dir_create("tmp")
df |> 
  filter(year > 1800, !is.na(year)) |> 
  group_by(year) |> 
  group_walk(function(x,y) {
    r <- rast(x, crs="epsg:4326") |> extend(extent)
    names(r) <- as.character(y$year)
    png(paste0("tmp/", y$year, ".png"),width = 807, height = 309, bg="transparent")
    plot(r, col= viridis(1e3),legend=FALSE, 
         colNA="black", axes=FALSE, main=y$year)
    dev.off()
  })

files <- fs::dir_ls("tmp", glob = "*.png")
gifski::gifski(files, "gbif.gif", width = 807, height = 309, loop = FALSE, delay = 0.1)




# ick loads as 2 "bands", n & year
r <- rast(df, crs="epsg:4326")
extent <- ext(r)

## load as 221 "bands", one per yr
rs <- df |> 
  filter(year > 1800, !is.na(year)) |> 
  group_by(year) |> 
  group_map(function(x,y) {
    r <- rast(x, crs="epsg:4326") |> extend(extent)
    names(r) <- as.character(y$year)
    r
  })
x <- rast(rs)
terra::animate(x, pause=.05, col= viridis(1e3),
                legend=FALSE, maxcell=6e6, colNA="black", axes=FALSE)





# really some coordinate-cleaning is probably required
df <- db |> 
  select(species, decimallatitude, decimallongitude) |>
  distinct() |>
  mutate(latitude = round(decimallatitude),
                   longitude = round(decimallongitude)) |> 
  count(longitude, latitude) |> 
  collect() |> 
  mutate(p = percent_rank(n))

r <- rast(df, crs="epsg:4326")
r |>  plot("p", col= viridis(1e3), 
           legend=FALSE, maxcell=6e6, 
           colNA="black", axes=FALSE)


