## code to prepare `DATASET` dataset goes here

library(dplyr)
library(arrow)
dir.create("inst/extdata/occurrence.parquet")
tbl(conn, "gbif") %>%
  head(1000) %>%
  collect() %>% 
  arrow::write_parquet("inst/extdata/occurrence.parquet/gbif.parquet")
