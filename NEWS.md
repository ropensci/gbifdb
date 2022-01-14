# gbifdb 0.1.1

* Automatically detect latest release (see `gbif_version()`). Works with local and remote sources, can also report all available versions.
* add `gbif_local()` to return a remote table instead of a connection; paralleling the use of `gbif_remote()`
* `gbif_conn()` (and thus `gbif_local()` ) gain the ability to use arrow as a backend to duckdb, and this is now the default. This improves performance and avoids crashes when all columns are requested.
* default bucket set to "us-east-1" (across both `gbif_download()` and `gbif_remote()`)
* `gbif_download()` now automatically detects versions, downloads parquet files to a path that parallels the remote path (using release-specific subdirectories), and allows bucket to be configured.
* set `to_duckdb=TRUE` by default in `gbif_remote()`, creating a consistent lazy-table interface with support for windowed functions
* `gbif_conn()` (and `gbif_local()`) now automatically detect the path of most recent GBIF version in `gbif_dir()`. No more need to to manually set path for `occurrence.parquet/` subfolder.
* documentation improved. 