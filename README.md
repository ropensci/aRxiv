## R interface to arXiv

[arXiv](http://arxiv.org) is an archive of manuscripts for computer
science, mathematics, physics, quantiative biology, quantitative
finance, and statistics. The [aRxiv](http://github.com/ropensci/aRxiv)
package is an R interface to the
[arXiv API](http://arxiv.org/help/api/index).

Note that the arXiv API _does not_ require an API key.

The [aRxiv](http://github.com/ropensci/aRxiv) package is in early development.


### Installation

The package is not currently available on
[CRAN](http://cran.r-project.org). To install, use
`devtools::install_github()`, as follows:

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


### Links

* [arXiv](http://arxiv.org)
* [arXiv API](http://arxiv.org/help/api/index)
* [arXiv API user manual](http://arxiv.org/help/api/user-manual)
* [Bulk data access to arXiv](http://arxiv.org/help/bulk_data)
* [Bulk data access to arXiv metadata via OAI-PMH](http://arxiv.org/help/oa/index)
* [Bulk data access to arXiv PDFs and source docs](http://arxiv.org/help/bulk_data_s3)


### License

Licensed under the [MIT license](LICENSE). ([More information here](http://en.wikipedia.org/wiki/MIT_License).)

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
