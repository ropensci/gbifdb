
#' A `[DBI]`-style database connection to GBIF data
#' 
#' Returns a database connection to the local GBIF parquet file.
#' @param dir the directory containing all parquet files to be read
#' @param tblname name of the table to be created in the duckdb VIEW
#' @return a `DBIconnection` object
#' @export
#' 
#' @examples
#' 
#' gbif.parquet <- gbif_example_data()
#' con <- gbif_conn(gbif.parquet)
#' 
gbif_conn <- function(dir = gbif_dir(), tblname = "gbif") {
  gbif_conn_arrow(dir, tblname)
}

# Using arrow as the backend for local data gives better performance
gbif_conn_arrow <- function(dir = gbif_dir(), 
                             tblname = "gbif") {
  arrow <- arrow::open_dataset(dir)
  conn <- DBI::dbConnect(duckdb::duckdb())
  duckdb::duckdb_register_arrow(conn, tblname, arrow)
  conn
}





## Pure duckdb -- currently crashes if all columns are selected
gbif_conn_duckdb <- function(dir = gbif_dir(), 
                             tblname = "gbif") {
  parquet <- file.path(dir, "*")
  conn <- DBI::dbConnect(duckdb::duckdb(), database)
  if (! tblname %in% DBI::dbListTables(conn)){
    query <- paste0("CREATE VIEW '", tblname,
                  "' AS SELECT * FROM parquet_scan('",
                  parquet, "');")
    DBI::dbSendQuery(conn, query)
  }
  conn
}

## CREATE TABLE with persistent storage currently crashes!
