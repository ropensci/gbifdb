Dear Victoria, CRAN Maintainers,

Thanks for your careful review of our intial submission.  


> If there are references describing the methods in your package, please
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
auto-linking.
(If you want to add a title as well please put it in quotes: "Title")

Thank you. These methods have not yet been described in publication but appopriate links to the relevant documentation have now been added in as URLs.


> Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)
Missing Rd-tags:
      gbif_dir.Rd: \value
      gbif_download.Rd: \value
      gbif_example_data.Rd: \value
      gbif_version.Rd: \value

Thank you, appropriate `\value` strings are now provided for all four of these functions.

> Please ensure that your functions do not write by default or in your
examples/vignettes/tests in the user's home filespace (including the
package directory and getwd()). This is not allowed by CRAN policies.
Please omit any default path in writing functions. In your
examples/vignettes/tests you can write to tempdir().

I confirm we have already done this as advised by CRAN;
all tests write to tempdir(). Examples and vignettes will not write to the
user's home space when run as part of the R CMD check, test, etc.
