check_arrow_installed <- function(){
  if (!requireNamespace("arrow", quietly = TRUE)) {
    msg <- paste(
      "The 'arrow' package is required but is not available. Install it with:",
      'install.packages("arrow", repos = c("https://p3m.dev/cran/2024-02-02", getOption("repos")))',
      sep = "\n"
    )
    stop(msg, call. = FALSE)
  }
}

select_backend <- function(choice){
  backends <- c("arrow", "duckdb")
  if (identical(choice, backends)) {
    # User did not specify, this is the default case
    if (requireNamespace("arrow", quietly = TRUE)) {
      # arrow is the default option
      return("arrow")
    } else {
      # Sadly, it's not available, so warn and use duckdb
      msg <- paste(
        "The 'arrow' is not available. Using 'duckdb' instead. To use arrow, install it with:",
        'install.packages("arrow", repos = c("https://p3m.dev/cran/2024-02-02", getOption("repos")))',
        sep = "\n"
      )
      warning(msg, call. = FALSE)
      return("duckdb")
    }
  } else if (identical(choice, "arrow")) {
    # User has explicitly chosen arrow, so error if arrow isn't available
    check_arrow_installed()
    return("arrow")
  } else {
    # Usual match.args handling
    return(match.arg(choice, backends))
  }
}