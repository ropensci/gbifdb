#' Get the latest gbif version string
#' 
#' Can also return latest locally downloaded version, or list all versions
#' @param local Search only local versions? logical, default `FALSE`.
#' @param dir local directory ([gbif_dir()])
#' @param bucket Which remote bucket (region) should be checked
#' @param all show all versions? (logical, default `FALSE`)
#' @param ... additional arguments to [arrow::s3_bucket]
#' @export
#' @details A default version can be set using option `gbif_default_version`
#' @return latest available gbif version, string
#' @examples
#' ## Latest local version available:
#' gbif_version(local=TRUE)
#' ## default version
#' options(gbif_default_version="2021-01-01")
#' gbif_version()
#' @examplesIf interactive()
#' ## Latest online version available:
#' gbif_version()
#' ## All online versions:
#' gbif_version(all=TRUE)
#' 
gbif_version <- function(local = FALSE,
                         dir = gbif_dir(),
                         bucket = gbif_default_bucket(),
                         all = FALSE,
                         ...) {
  version <- getOption("gbif_default_version", NA)
  if (!is.na(version)) { 
    return(version)
  }
  versions <- tryCatch(
    {
      if(local) {
        versions <- local_versions(dir)
      } else {
        versions <- guess_latest() #remote_versions(bucket, ...)
      }
      versions
    },
    error = function(e) guess_latest(),
    finally = guess_latest()
  )
  if(all) return(versions)
  
  
  latest_version(versions)
}

guess_latest <- function() {
  paste0(format(Sys.Date(), "%Y-%m"), "-01")
}

latest_version <- function(versions) {
  suppressWarnings(
  as.character(max(as.Date(versions)))
  )
}




remote_versions <- function(bucket = gbif_default_bucket(), 
                            endpoint_override = Sys.getenv("AWS_S3_ENDPOINT"),
                            ...) {
  
  requireNamespace("arrow", quietly = TRUE)
  if (getOption("gbif_unset_aws", TRUE)) unset_aws_env()
  s3 <- arrow::s3_bucket(bucket, endpoint_override=endpoint_override, ...)
  versions <- basename(s3$ls("occurrence"))
}

local_versions <- function(path = gbif_dir()) {
  path <- file.path(path, "occurrence")
  list.dirs(path, full.names = FALSE, recursive = FALSE)
}


gbif_default_bucket <- function() {
  getOption("gbif_default_bucket", "gbif-open-data-us-east-1")
  
}
