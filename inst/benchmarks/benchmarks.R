library(arrow)
library(dplyr)
library(gbifdb)
library(bench)

Sys.setenv("GBIFDB_HOME"="/home/shared-data/gbif")

Sys.unsetenv("AWS_DEFAULT_REGION")
Sys.unsetenv("AWS_S3_ENDPOINT")
Sys.unsetenv("AWS_ACCESS_KEY_ID")
Sys.unsetenv("AWS_SECRET_ACCESS_KEY")
Sys.setenv("AWS_EC2_METADATA_DISABLED"="TRUE")

gbif_snapshot <- "s3://gbif-open-data-us-east-1/occurrence/2021-11-01/occurrence.parquet"
df <- arrow::open_dataset(gbif_snapshot)

bench::bench_time({
  test <- df %>% 
    filter(
      countrycode == "BW",
      kingdom == "Fungi"
    ) %>%
    collect()
})

## nearly the same but drops varchar columns
gbif <- gbif_remote(version="2021-11-01")
bench::bench_time({
  test <- gbif %>% 
    filter(
      countrycode == "BW",
      kingdom == "Fungi"
    ) %>%
    collect()
  
})


# NVMe drive
gbif <- gbif_remote(bucket = "gbif", version="2021-11-01", endpoint_override = "https://minio.carlboettiger.info")

bench::bench_time({
  test <- gbif %>% 
    filter(
      countrycode == "BW",
      kingdom == "Fungi"
    ) %>%
    collect()
  
})


# Spinning disk
gbif <- gbif_remote(bucket = "gbif", version="2021-11-01", endpoint_override = "https://minio.thelio.carlboettiger.info")

bench::bench_time({
  test <- gbif %>% 
    filter(
      countrycode == "BW",
      kingdom == "Fungi"
    ) %>%
    collect()
  
})



gbif <- gbif_local(version="2021-11-01")
bench_time({
  pinsapo <- gbif %>% 
    filter(species == "Abies pinsapo",
           countrycode == "ES",
           year > 2010) %>%
    collect()
})


bench_time({
pinsapo <- gbif %>% 
  filter(species == "Abies pinsapo",
         countrycode == "ES",
         year > 2010) %>%
  select(gbifid)
  ids <- pinsapo
  pinsapo <- inner_join(gbif, ids, copy=TRUE) %>% collect()

})


