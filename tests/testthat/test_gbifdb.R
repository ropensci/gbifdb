context("test gbifdb")

test_that("gbif_example_data()", {

  path <- gbif_example_data()
  expect_true(dir.exists(path))

})

test_that("gbif_conn()", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  conn <- gbif_conn(path)

  expect_true(dir.exists(path))
  expect_true(inherits(conn, "duckdb_connection"))

})

test_that("gbif_dir()", {

  dir <- gbif_dir()
  expect_true(TRUE)
})

test_that("gbif_remote()", {
  # skip_on_cran()
  skip_if_offline()

  info <- arrow::arrow_info()
  has_s3 <- info$capabilities[["s3"]]
  skip_if_not(has_s3)

  conn <- gbif_remote(to_duckdb = FALSE)
  expect_true(inherits(conn, "Dataset"))
})

test_that("gbif_remote(to_duckdb=TRUE)....slow!", {
  # skip_on_cran()

  info <- arrow::arrow_info()
  has_s3 <- info$capabilities[["s3"]]
  skip_if_not(has_s3)
  skip_if_offline()
  library(arrow)
  library(dplyr)
  conn <- gbif_remote(to_duckdb = TRUE)
  expect_true(inherits(conn, "tbl_dbi"))
  duckdb::dbDisconnect(conn$src$con, shutdown = TRUE)
})
