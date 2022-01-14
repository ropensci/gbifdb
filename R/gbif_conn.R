
#' A `[DBI]`-style database connection to GBIF data
#' 
#' Returns a database connection to the local GBIF parquet file.
#' @param dir the directory containing all parquet files to be read
#' @param tblname name of the table to be created in the duckdb VIEW
#' @param backend Use arrow or duckdb as backend connection? 
#' @return a `DBIconnection` object
#' @export
#' 
#' @examples
#' 
#' gbif.parquet <- gbif_example_data()
#' con <- gbif_conn(gbif.parquet)
#' 
gbif_conn <- function(dir = gbif_parquet_dir(version = 
                                               gbif_version(local=TRUE)),
                      tblname = "gbif", 
                      backend = c("arrow", "duckdb")) {
  backend <- match.arg(backend)
  switch(backend, 
         "arrow" = gbif_conn_arrow(dir, tblname),
         "duckdb" = gbif_conn_duckdb(dir, tblname)
  )
}

# Using arrow as the backend for local data gives better performance
gbif_conn_arrow <- function(dir, 
                             tblname = "gbif") {
  arrow <- arrow::open_dataset(dir)
  conn <- cachable_duckdb_conn()
  duckdb::duckdb_register_arrow(conn, tblname, arrow)
  
  
  conn
}


cachable_duckdb_conn <- function(){
  conn <- getOption("gbifdb_conn", NULL)
  if (is.null(conn)) {
    conn <- DBI::dbConnect(duckdb::duckdb())
  }
  options("gbifdb_conn" = conn)
  conn
}



## Pure duckdb -- currently crashes if all columns are selected
## Currently not used!
gbif_conn_duckdb <- function(dir, 
                             tblname = "gbif") {
  parquet <- file.path(dir, "*")
  conn <- cachable_duckdb_conn()
  if (! tblname %in% DBI::dbListTables(conn)){
    query <- paste0("CREATE VIEW '", tblname,
                  "' AS SELECT * FROM parquet_scan('",
                  parquet, "');")
    DBI::dbSendQuery(conn, query)
  }
  conn
}

## CREATE TABLE with persistent storage currently crashes!
