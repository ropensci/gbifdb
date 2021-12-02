

#' gbif remote
#'
#' Connect to GBIF remote directly. Can be much faster than downloading
#' for one-off use or when using the package from a server in the same region
#' as the data.
#'
#' @param version GBIF snapshot date
#' @param bucket GBIF bucket name (including region)
#' @param to_duckdb Return a remote duckdb connection or arrow connection?
#'   Note that leaving as FALSE may be faster but is limited to the dplyr-style
#'   operations supported by [arrow] alone.
#' @param ... additional parameters passed to the s3_bucket() (e.g. for remote
#'  access to independently hosted buckets)
#' @examplesIf interactive()
#' @export
#'
gbif_remote <-
    function(version = "2021-11-01",
             bucket = "gbif-open-data-af-south-1",
             to_duckdb = FALSE,
             ...) {
        if (!requireNamespace("arrow", quietly = TRUE)) {
            stop("please install arrow first")
        }
        info <- arrow::arrow_info()
        if (!info$capabilities[["s3"]]) {
            stop("arrow was not installed with S3 support.")
        }


        server <-
         arrow::s3_bucket(bucket, ...)
        prefix <- 
          paste0("/occurrence/",
                 version,
                 "/occurrence.parquet/")
        path <- server$path(prefix)
        df <- arrow::open_dataset(path)
        if (to_duckdb) {
            if (!requireNamespace("dplyr", quietly = TRUE)) {
                stop("please install dplyr first")
            }
            df <- arrow::to_duckdb(df)
        }
        df
    }
