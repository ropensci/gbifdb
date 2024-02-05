Sys.setenv("GBIF_HOME"=tempdir())


test_that("gbif_example_data()", {

  path <- gbif_example_data()
  expect_true(dir.exists(path))

})


test_that("gbif_local()", {
  
  skip_if_not_installed("arrow")
  path <- gbif_example_data()
  gbif <- gbif_local(path, backend = "arrow")
  df <- head(gbif) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
  
})

test_that("gbif_dir()", {

  dir <- gbif_dir()
  expect_true(TRUE)
})

test_that("gbif_remote()", {
  
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("arrow")

  info <- arrow::arrow_info()
  has_s3 <- info$capabilities[["s3"]]
  skip_if_not(has_s3)

  conn <- gbif_remote(backend="arrow")
  expect_true(inherits(conn, "arrow_dplyr_query"))

  df <- head(conn) |> dplyr::collect()
  expect_true(inherits(df, "tbl"))
})

