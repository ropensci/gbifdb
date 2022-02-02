
#' Local connection to a downloaded GBIF Parquet database
#' 
#' @importFrom dplyr tbl any_of
#' @inheritParams gbif_conn
#' @param safe logical, default TRUE.  Should we exclude columns `mediatype`` and `issue`?
#' varchar datatype on these columns substantially slows downs queries.
#' @return a remote tibble `tbl_sql` class object
#' @details 
#' A summary of this GBIF data, along with column meanings can be found at 
#' <https://github.com/gbif/occurrence/blob/master/aws-public-data.md>
#' @export
#' @examplesIf interactive()
#' 
#' 
#' gbif <- gbif_local(gbif_example_data())
#'
gbif_local <- function(dir = gbif_parquet_dir(version = gbif_version(local=TRUE)),
                       tblname="gbif",
                       backend = "arrow",
                       safe = TRUE){
  
  
  conn <- gbif_conn(dir, tblname, backend)
  gbif <- dplyr::tbl(conn, tblname)
  if (safe) {
          gbif <- dplyr::select(gbif, -dplyr::any_of(c("mediatype", "issue")))
  }
  gbif
}
