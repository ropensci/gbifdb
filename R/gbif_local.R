
#' Local connection to a downloaded GBIF Parquet database
#' 
#' @importFrom dplyr tbl any_of
#' @param dir location of downloaded GBIF parquet files
#' @param tblname name for the database table
#' @param backend choose duckdb or arrow. 
#' @param safe logical. Should we exclude columns `mediatype`
#'  and `issue`? (default `TRUE`).  
#' varchar datatype on these columns substantially slows downs queries.
#' @return a remote tibble `tbl_sql` class object
#' @details 
#' A summary of this GBIF data, along with column meanings can be found at 
#' <https://github.com/gbif/occurrence/blob/master/aws-public-data.md>
#' @export
#' @examplesIf interactive()
#' 
#' gbif <- gbif_local(gbif_example_data())
#'
gbif_local <- function(dir = gbif_parquet_dir(version = gbif_version(local=TRUE)),
                       tblname="gbif",
                       backend = c("arrow", "duckdb"),
                       safe = TRUE){
  
  backend <- match.arg(backend)
  gbif <- switch(backend,
         duckdb = duckdb_local(dir),
         arrow = arrow::open_dataset(dir)
         )
  if (safe) {
    gbif <- dplyr::select(gbif, -dplyr::any_of(c("mediatype", "issue")))
  }
  gbif
}

duckdb_local <- function(dir) {
  requireNamespace("duckdbfs")
  
  con <- duckdbfs::cached_connection()
  has <- DBI::dbListTables(con)
  if("gbif" %in% has) {
    return(dplyr::tbl(con, "gbif"))
  }
  load_spatial(con)
  duckdbfs::open_dataset(paste0(dir, "/*"),
                         tblname = "gbif",
                         conn = con)
}


load_spatial <- function(conn = duckdbfs::cached_connection()) {
  status <- DBI::dbExecute(conn, "INSTALL 'spatial';")
  status <- DBI::dbExecute(conn, "LOAD 'spatial';")
  invisible(status)
}




