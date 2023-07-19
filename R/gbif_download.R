
#' Download GBIF data using minioclient
#' 
#' Sync a local directory with selected release of the AWS copy of GBIF

#' @param version Release date (YYYY-MM-DD) which should be synced. Will
#' detect latest version by default.  
#' @param dir path to local directory where parquet files should be stored.
#'  Fine to leave at default, see [gbif_dir()].
#' @param bucket Name of the regional S3 bucket desired.  
#' Default is "gbif-open-data-us-east-1". Select a bucket closer to your
#' compute location for improved performance, e.g. European researchers may
#' prefer "gbif-open-data-eu-central-1" etc.
#' @param region bucket region (usually ignored? Just set the bucket appropriately)
#' @details
#' Sync parquet files from GBIF public data catalog,
#' https://registry.opendata.aws/gbif/. 
#' 
#' 
#' Note that data can also be found on the Microsoft Cloud,
#' https://planetarycomputer.microsoft.com/dataset/gbif
#' 
#' Also, some users may prefer to download this data using an alternative
#' interface or work on a cloud-host machine where data is already available.
#' Note, these data include all CC0 and CC-BY licensed data in GBIF that have
#'coordinates which passed automated quality checks,
#' see <https://github.com/gbif/occurrence/blob/master/aws-public-data.md>.
#' @export
#' 
#' @return logical indicating success or failure.
#' @examplesIf interactive()
#' gbif_download()
#' 
gbif_download <-
  function(version = gbif_version(),
           dir = gbif_dir(),
           bucket = gbif_default_bucket(),
           region = ""
           ){

  if (!requireNamespace("minioclient", quietly = TRUE)) {
    message("the minioclient package is required for automatic download")
    return(invisible(NULL))
  }
  parquet_dir <- gbif_parquet_dir(version, dir)
  if (!exists(parquet_dir)) {
    dir.create(parquet_dir, FALSE, TRUE)
  }
    
  ## Public access fails if user has a secret key configured
  
  if (getOption("gbif_unset_aws", TRUE)) unset_aws_env()
  minioclient::mc_alias_set("aws", base_url, "", "")
  source <- file.path("aws", bucket, "occurrence", version,
                      "occurrence.parquet", fsep="/")
  minioclient::mc_mirror(source, parquet_dir)

}
