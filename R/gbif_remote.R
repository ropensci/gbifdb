

#' gbif remote
#'
#' Connect to GBIF remote directly. Can be much faster than downloading
#' for one-off use or when using the package from a server in the same region
#' as the data. See Details.
#'
#' @details Query performance is dramatically improved in queries that return only
#' a subset of columns. Consider using explicit `select()` commands to return only
#' the columns you need.
#' @param version GBIF snapshot date
#' @param bucket GBIF bucket name (including region)
#' @param to_duckdb Return a remote duckdb connection or arrow connection?
#'   Note that leaving as FALSE may be faster but is limited to the dplyr-style
#'   operations supported by [arrow] alone.
#' @param safe logical, default TRUE.  Should we exclude columns `mediatype`` and `issue`?
#' varchar datatype on these columns substantially slows downs queries.
#' @param ... additional parameters passed to the s3_bucket() (e.g. for remote
#'  access to independently hosted buckets)
#' @examplesIf interactive()
#' 
#' gbif <- gbif_remote()
#' gbif()
#' 
#' @export
#' @importFrom dplyr select
gbif_remote <-
    function(version = gbif_latest_version(),
             bucket = gbif_default_bucket(),
             to_duckdb = FALSE,
             safe = TRUE,
             ...) {
        if (!requireNamespace("arrow", quietly = TRUE)) {
            stop("please install arrow first")
        }

        unset_aws_env()
        server <-
         arrow::s3_bucket(bucket, ...)
        prefix <- 
          paste0("/occurrence/",
                 version,
                 "/occurrence.parquet/")
        path <- server$path(prefix)
        gbif <- arrow::open_dataset(path)

        if (safe) {
          gbif <- dplyr::select(gbif, -dplyr::any_of(c("mediatype", "issue")))
        }
        ## Consider leaving this to the user to call.
        if (to_duckdb) {
            gbif <- arrow::to_duckdb(gbif)
        }

        gbif
    }


unset_aws_env <- function(){
    
    ## Consider re-setting these afterwards.
    ## What about ~/.aws ?
    ## Maybe set these to empty strings instead of unsetting?
    
    ## Would be nice if we could simply override the detection of these
    Sys.unsetenv("AWS_DEFAULT_REGION")
    Sys.unsetenv("AWS_S3_ENDPOINT")
    Sys.unsetenv("AWS_ACCESS_KEY_ID")
    Sys.unsetenv("AWS_SECRET_ACCESS_KEY")
}

