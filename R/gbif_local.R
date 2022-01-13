
#' Local connection to a downloaded GBIF Parquet database
#' 
#' @return a remote tibble `tbl_sql` class object
#' @export
#' @examplesIf interactive()
#' gbif <- gbif_local(gbif_example_data())
#' @importFrom dplyr tbl
#' @inheritParams gbif_conn
gbif_local <- function(dir = gbif_parquet_dir(), tblname="gbif"){
  conn <- gbif_conn(dir, tblname)
  dplyr::tbl(conn, tblname)
}