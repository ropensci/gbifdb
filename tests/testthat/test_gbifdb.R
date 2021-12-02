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
  conn <- gbif_remote(to_duckdb = FALSE)
  expect_true(inherits(conn, "Dataset"))
})

test_that("gbif_remote(to_duckdb=TRUE)....slow!", {
  # skip_on_cran()
  skip_if_offline()
  library(arrow)
  library(dplyr)
  conn <- gbif_remote(to_duckdb = TRUE)
  expect_true(inherits(conn, "tbl_dbi"))
  duckdb::dbDisconnect(conn$src$con, shutdown = TRUE)
})
