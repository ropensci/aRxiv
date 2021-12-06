# aRxiv

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](
https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CRAN/GitHub 0.5.19 / 0.6](https://img.shields.io/badge/CRAN/GitHub-0.5.19%20/%200.6-blue.svg)](https://cran.r-project.org/package=aRxiv)

## R interface to arXiv

[arXiv](https://arxiv.org) is a repository of electronic preprints for
computer science, mathematics, physics, quantitative biology,
quantitative finance, and statistics. The
[aRxiv](https://github.com/ropensci/aRxiv) package is an R interface to
the [arXiv API](https://arxiv.org/help/api/index).

Note that the arXiv API _does not_ require an API key.


## Package Status and Installation

[![R-CMD-check](https://github.com/ropensci/aRxiv/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/aRxiv/actions)
[![codecov](https://codecov.io/gh/ropensci/aRxiv/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/aRxiv)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/aRxiv?color=blue)](https://github.com/r-hub/cranlogs.app)

__Installation instructions__
__Stable Version__

You can install the package via [CRAN](https://cran.r-project.org):

```r
install.packages("aRxiv")
```

__Development Version__

Or use `devtools::install_github()` to get the (more recent) version
at [GitHub](https://github.com/rOpenSci/aRxiv):

```r
install.packages("devtools")
library(devtools)
install_github("ropensci/aRxiv")
```

## Usage
### Basic usage

The main function is `arxiv_search()`. Here's an example of its use:

```r
library(aRxiv)
z <- arxiv_search(query = 'au:"Peter Hall" AND cat:stat*', limit=50)
str(z)
```


### Tutorial

An aRxiv tutorial is available at the rOpenSci website, [here](https://docs.ropensci.org/aRxiv/articles/aRxiv.html).

To view the tutorial from R, use:

```r
vignette("aRxiv", "aRxiv")
```


### Links

* [arXiv](https://arxiv.org)
* [arXiv API](https://arxiv.org/help/api/index)
* [arXiv API user manual](https://arxiv.org/help/api/user-manual)
* [Bulk data access to arXiv](https://arxiv.org/help/bulk_data)
* [Bulk data access to arXiv metadata via OAI-PMH](https://arxiv.org/help/oa/index)
* [Bulk data access to arXiv PDFs and source docs](https://arxiv.org/help/bulk_data_s3)


### License

Licensed under the [MIT license](https://cran.r-project.org/web/licenses/MIT). ([More information here](https://en.wikipedia.org/wiki/MIT_License).)

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles. We recommend using `fulltext` as the primary R interface to `arXiv` unless your needs are limited to this single source.

---

## Citation

Get citation information for `aRxiv` in R by running: `citation(package = 'aRxiv')`

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/ropensci/aRxiv/blob/master/CONDUCT.md).
By participating in this project you agree to abide by its terms.



[![ropensci footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
