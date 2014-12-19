[![Travis build status](https://travis-ci.org/ropensci/aRxiv.png?branch=master)](https://travis-ci.org/ropensci/aRxiv)
[![Appveyor build status](https://ci.appveyor.com/api/projects/status/kkqyqak224a98jlh)](https://ci.appveyor.com/project/karthik/arxiv)

## R interface to arXiv

[arXiv](http://arxiv.org) is a repository of electronic preprints for
computer science, mathematics, physics, quantitative biology,
quantitative finance, and statistics. The
[aRxiv](http://github.com/ropensci/aRxiv) package is an R interface to
the [arXiv API](http://arxiv.org/help/api/index).

Note that the arXiv API _does not_ require an API key.

The [aRxiv](http://github.com/ropensci/aRxiv) package is in early development.


### Installation

You can install the package via [CRAN](http://cran.r-project.org):

```r
install.packages("aRxiv")
```

Or use `devtools::install_github()` to get the (more recent) version
at [GitHub](https://github.com/rOpenSci/aRxiv):

```r
install.packages("devtools")
library(devtools)
install_github("ropensci/aRxiv")
```

### Basic usage

The main function is `arxiv_search()`. Here's an example of its use:

```r
library(aRxiv)
z <- arxiv_search(query = 'au:"Peter Hall" AND cat:stat*', limit=50)
str(z)
```


### Tutorial

An aRxiv tutorial is available at the rOpenSci website, [here](http://ropensci.org/tutorials/arxiv_tutorial.html).

To view the tutorial from R, use:

```r
vignette("aRxiv", "aRxiv")
```


### Links

* [arXiv](http://arxiv.org)
* [arXiv API](http://arxiv.org/help/api/index)
* [arXiv API user manual](http://arxiv.org/help/api/user-manual)
* [Bulk data access to arXiv](http://arxiv.org/help/bulk_data)
* [Bulk data access to arXiv metadata via OAI-PMH](http://arxiv.org/help/oa/index)
* [Bulk data access to arXiv PDFs and source docs](http://arxiv.org/help/bulk_data_s3)


### License

Licensed under the [MIT license](http://cran.r-project.org/web/licenses/MIT). ([More information here](http://en.wikipedia.org/wiki/MIT_License).)

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles. We recommend using `fulltext` as the primary R interface to `arXiv` unless your needs are limited to this single source.

---

[![ropensci footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
