context("test gbifdb")

test_that("gbif_example_data()", {
  
  path <- gbif_example_data()
  expect_true(dir.exists(path))
  
})

test_that("gbif_conn()", {
  
  path <- gbif_example_data()
  conn <- gbif_conn(path)
  
  expect_true(dir.exists(path))
  expect_true(inherits(conn, "duckdb_connection"))
  
})
