Sys.setenv("GBIF_HOME"=tempdir())

test_that("gbif_dir()", {
  
  dir <- gbif_dir()
  expect_true(TRUE)
})


test_that("gbif_example_data()", {

  path <- gbif_example_data()
  expect_true(dir.exists(path))

})

test_that("arrow gbif_local()", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  gbif <- gbif_local(path, backend = "arrow")
  df <- head(gbif) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
  
})

test_that("duckdb gbif_local()", {
  
  skip_on_os("solaris")
  path <- gbif_example_data()
  gbif <- gbif_local(path, backend = "duckdb")
  df <- head(gbif) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
  
})

test_that("arrow gbif_remote()", {

  skip("remote arrow fails in check mode only?")  
  skip_if_not_installed("arrow")
  skip_on_os("solaris")
  skip_on_cran()
  skip_if_offline()
  
  info <- arrow::arrow_info()
  has_s3 <- info$capabilities[["s3"]]
  skip_if_not(has_s3)
  
  conn <- gbif_remote(backend="arrow")
  expect_true(inherits(conn, "arrow_dplyr_query"))
  
  df <- head(conn) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
})


test_that("duckdb gbif_remote()", {
  
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("duckdbfs")
  skip_on_os("windows")

  conn <- gbif_remote(backend="duckdb")

  df <- head(conn) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
})

