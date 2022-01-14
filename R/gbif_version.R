#' Get the latest gbif version string
#' 
#' Can also return latest locally downloaded version, or list all versions
#' @param local Search only local versions? logical, default `FALSE`.
#' @param dir local directory ([gbif_dir()])
#' @param bucket Which remote bucket (region) should be checked
#' @param all show all versions? (logical, default `FALSE`)
#' @param ... additional arguments to [arrow::s3_bucket]
#' @export
#' @examplesIf interactive()
#' ## Latest online version available:
#' gbif_version()
#' ## Latest local version available:
#' gbif_version(local=FALSE)
#' ## All online versions:
#' gbif_version(all=TRUE)
#' 
gbif_version <- function(local = FALSE,
                         dir = gbif_dir(),
                         bucket = gbif_default_bucket(),
                         all = FALSE,
                         ...) {
  versions <- tryCatch(
    {
      if(local) {
        versions <- local_versions(dir)
      } else {
        versions <- remote_versions(bucket, ...)
      }
      versions
    },
    error = function(e) "2021-11-01",
    finally = "2021-11-01"
  )
  if(all) return(versions)
  
  latest_version(versions)
}

latest_version <- function(versions) {
  as.character(max(as.Date(versions)))
  
}

remote_versions <- function(bucket = gbif_default_bucket(), ...) {
  unset_aws_env()
  s3 <- arrow::s3_bucket(bucket, ...)
  versions <- basename(s3$ls("occurrence"))
}

local_versions <- function(path = gbif_dir()) {
  path <- file.path(path, "occurrence")
  list.dirs(path, full.names = FALSE, recursive = FALSE)
}


gbif_default_bucket <- function() {
  "gbif-open-data-us-east-1"
}
