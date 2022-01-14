context("test gbifdb")

test_that("gbif_example_data()", {

  path <- gbif_example_data()
  expect_true(dir.exists(path))

})

test_that("gbif_conn() duckdb", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  conn <- gbif_conn(path, backend="duckdb")
  
  expect_true(dir.exists(path))
  expect_true(inherits(conn, "duckdb_connection"))
  
})

test_that("gbif_conn()", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  conn <- gbif_conn(path)

  expect_true(dir.exists(path))
  expect_true(inherits(conn, "duckdb_connection"))

})

test_that("gbif_local()", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  gbif <- gbif_local(path)
  
  expect_true(inherits(gbif, "tbl"))
  expect_true(inherits(gbif, "tbl_dbi"))
  expect_true(inherits(gbif, "tbl_duckdb_connection"))
  
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
  expect_true(inherits(conn, "arrow_dplyr_query"))
  #expect_true(inherits(conn, "Dataset"))
})

test_that("gbif_remote(to_duckdb=TRUE)....slow!", {

  skip("CI strangeness")

  info <- arrow::arrow_info()
  has_s3 <- info$capabilities[["s3"]]
  skip_if_not(has_s3)

  skip_if_offline()
  skip_on_cran()
  

  library(arrow)
  library(dplyr)
  conn <- gbif_remote(to_duckdb = TRUE)
  expect_true(inherits(conn, "tbl_dbi"))
  duckdb::dbDisconnect(conn$src$con, shutdown = TRUE)
})
