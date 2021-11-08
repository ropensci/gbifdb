## Currently aws.s3 R package does not seem able to sync, though works fine 
## via minio's `mc` or the aws cli client, etc. 
## Alternately could support downloads with direct link, but maybe 
## just fine to leave this up to the user.



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
#' @noRd
#' 
#' @examplesIf interactive()
#' gbif_download()
#' 
gbif_download <-
  function(version = "occurrence/2021-11-01",
           dir = gbif_dir()
           ){

  ## Fixme detect version, maybe w/o AWS dependency
  
  if(!requireNamespace("aws.s3", quietly = TRUE)){
    message("the aws.s3 package is required for automatic download")
    return(invisible(NULL))
  }
  ## Public access fails if user has a secret key configured
  Sys.unsetenv("AWS_SECRET_ACCESS_KEY")
  aws.s3::s3sync(dir,
                 base_url = "amazonaws.com",
                 bucket = "gbif-open-data-ap-southeast-2",
                 prefix = version,
                 region = "s3.ap-southeast-2")
}


#' Default storage location
#' 
#' Default location can be set with the env var GBIF_HOME,
#' otherwise will use the default provided by [tools::R_user_dir()]
#' 
#' @export
gbif_dir <- function(){
  Sys.getenv("GBIF_HOME",
             tools::R_user_dir("gbif"))
             
}