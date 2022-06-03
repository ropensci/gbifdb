#' Return a path to the directory containing GBIF example parquet data
#' 
#' @details example data is taken from the first 1000 rows of the
#' 2011-11-01 release of the parquet data.
#' @return path to the example occurrence data installed with the package.
#' @examples
#' gbif_example_data()
#' @export
gbif_example_data <- function() {
  system.file("extdata", 
              "occurrence.parquet",
              package = "gbifdb")
}