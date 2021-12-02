## Developer NOTE: consider switchng to arrow::S3FileSystem-based method.
## doesn't support sync out-of-box, but lighter dependency since arrow is already in use.


#' Download GBIF data using aws.s3 sync
#'
#' Sync a local directory with selected release of the AWS copy of GBIF
#' @param version 'prefix' string (folder) from the 
#' https://registry.opendata.aws/gbif/ which should be synced.
#' @param dir path to local directory where parquet files should be stored
#' @details
#' Sync parquet files from GBIF public data catalogue,
#' https://registry.opendata.aws/gbif/
#'
#' Note that data can also be found on the Microsoft Cloud,
#' https://planetarycomputer.microsoft.com/dataset/gbif
#'
#' Also, some users may prefer to download this data using an alternative
#' interface or work on a cloud-host machine where data is already available.
#' @export
#'
#' @examplesIf interactive()
#' gbif_download()
#'
gbif_download <-
  function(version = "2021-11-01", dir = gbif_dir()) {
  ## Fixme detect version, maybe w/o AWS dependency
  if (!requireNamespace("aws.s3", quietly = TRUE)) {
    stop("the aws.s3 package is required for automatic download", call. = FALSE)
  }
  ## Public access fails if user has a secret key configured
  Sys.unsetenv("AWS_SECRET_ACCESS_KEY")
  aws.s3::s3sync(dir,
                 base_url = "s3.amazonaws.com",
                 bucket = "gbif-open-data-ap-southeast-2",
                 prefix = paste0("occurrence/", version),
                 region = "ap-southeast-2")
}
