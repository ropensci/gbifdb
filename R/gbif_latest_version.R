
gbif_latest_version <- function(bucket = gbif_default_bucket(), ...) {
  versions <- tryCatch(
    {
      if(file.exists(bucket)) {
        versions <- local_versions(bucket)
      } else {
        versions <- remote_versions(bucket, ...)
      }
      versions
    },
    error = function(e) "2021-11-01",
    finally = "2021-11-01"
  )
  as.character(max(as.Date(versions)))
}

remote_versions <- function(bucket, ...) {
  unset_aws_env()
  s3 <- arrow::s3_bucket(bucket)
  versions <- basename(s3$ls("occurrence"))
}

local_versions <- function(path = gbif_dir()) {
  path <- file.path(path, "occurrence/")
  list.dirs(path, full.names = FALSE, recursive = FALSE)
}


gbif_default_bucket <- function() {
  "gbif-open-data-us-east-1"
}
