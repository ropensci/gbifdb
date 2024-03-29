% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gbif_remote.R
\name{gbif_remote}
\alias{gbif_remote}
\title{gbif remote}
\usage{
gbif_remote(
  version = gbif_version(),
  bucket = gbif_default_bucket(),
  safe = TRUE,
  unset_aws = getOption("gbif_unset_aws", TRUE),
  endpoint_override = Sys.getenv("AWS_S3_ENDPOINT", "s3.amazonaws.com"),
  backend = c("arrow", "duckdb"),
  ...
)
}
\arguments{
\item{version}{GBIF snapshot date}

\item{bucket}{GBIF bucket name (including region). A default can also be set using
the option \code{gbif_default_bucket}, see \link{options}.}

\item{safe}{logical, default TRUE.  Should we exclude columns \code{mediatype} and \code{issue}?
varchar datatype on these columns substantially slows downs queries.}

\item{unset_aws}{Unset AWS credentials?  GBIF is provided in a public bucket,
so credentials are not needed, but having a AWS_ACCESS_KEY_ID or other AWS
environmental variables set can cause the connection to fail.  By default,
this will unset any set environmental variables for the duration of the R session.
This behavior can also be turned off globally by setting the option
\code{gbif_unset_aws} to FALSE (e.g. to use an alternative network endpoint)}

\item{endpoint_override}{optional parameter to \code{\link[arrow:s3_bucket]{arrow::s3_bucket()}}}

\item{backend}{duckdb or arrow}

\item{...}{additional parameters passed to the \code{\link[arrow:s3_bucket]{arrow::s3_bucket()}}}
}
\value{
a remote tibble \code{tbl_sql} class object.
}
\description{
Connect to GBIF remote directly. Can be much faster than downloading
for one-off use or when using the package from a server in the same region
as the data. See Details.
}
\details{
Query performance is dramatically improved in queries that return only
a subset of columns. Consider using explicit \code{select()} commands to return only
the columns you need.

A summary of this GBIF data, along with column meanings can be found at
\url{https://github.com/gbif/occurrence/blob/master/aws-public-data.md}
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

gbif <- gbif_remote()
gbif()
\dontshow{\}) # examplesIf}
}
