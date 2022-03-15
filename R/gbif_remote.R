

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
#' @param bucket GBIF bucket name (including region). A default can also be set using
#' the option `gbif_default_bucket`, see [options].
#' @param to_duckdb Return a remote duckdb connection or arrow connection?
#' @param safe logical, default TRUE.  Should we exclude columns `mediatype` and `issue`?
#' varchar datatype on these columns substantially slows downs queries.
#' @param unset_aws Unset AWS credentials?  GBIF is provided in a public bucket,
#' so credentials are not needed, but having a AWS_ACCESS_KEY_ID or other AWS
#' environmental variables set can cause the connection to fail.  By default,
#' this will unset any set environmental variables for the duration of the R session.
#' This behavior can also be turned off globally by setting the option
#' `gbif_unset_aws` to FALSE (e.g. to use an alternative network endpoint)
#' @param endpoint_override optional parameter to [arrow::s3_bucket()]
#' @param ... additional parameters passed to the [arrow::s3_bucket()]
#' @return a remote tibble `tbl_sql` class object (by default), or a arrow 
#' Dataset query if `to_duckdb` is FALSE.  In either case, users should call
#'  `[dplyr::collect]` on the final result to force evaluation and bring the
#'   resulting data into 
#' memory in R.
#' @details 
#' A summary of this GBIF data, along with column meanings can be found at 
#' <https://github.com/gbif/occurrence/blob/master/aws-public-data.md>
#' @examplesIf interactive()
#' 
#' gbif <- gbif_remote()
#' gbif()
#' 
#' @export
#' @importFrom dplyr select
gbif_remote <-
    function(version = gbif_version(),
             bucket = gbif_default_bucket(),
             to_duckdb = FALSE,
             safe = TRUE,
             unset_aws = getOption("gbif_unset_aws", TRUE),
             endpoint_override = Sys.getenv("AWS_S3_ENDPOINT"),
             ...) {
        if (!requireNamespace("arrow", quietly = TRUE)) {
            stop("please install arrow first")
        }

        if (unset_aws) {
          unset_aws_env()
        }
        server <-
         arrow::s3_bucket(bucket, endpoint_override = endpoint_override, ...)
        prefix <- 
          paste0("/occurrence/",
                 version,
                 "/occurrence.parquet/")
        path <- server$path(prefix)
        gbif <- arrow::open_dataset(path)

        ## Consider leaving this to the user to call.
        if (to_duckdb) {
            gbif <- arrow::to_duckdb(gbif)
        }
        
        if (safe) {
          gbif <- dplyr::select(gbif, -dplyr::any_of(c("mediatype", "issue")))
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

