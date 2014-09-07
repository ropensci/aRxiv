## R interface to arXiv

Package is in early development.

### Installation

The package is not currently available on
[CRAN](http://cran.r-project.org). To install, use
`devtools::install_github()`, as follows:

```coffee
install.packages("devtools")
library(devtools)
install_github("ropensci/aRxiv")
```

### Basic usage

The main function is `arxiv_search()`. Here's an example of its use:

```coffee
library(aRxiv)
z <- arxiv_search(query = "au:Broman AND cat:stat.AP")
str(z)
```


### Links

* [arXiv](http://arxiv.org)
* [arXiv API](http://arxiv.org/help/api/index)
* [arXiv API user manual](http://arxiv.org/help/api/user-manual)
* [Bulk data access to arXiv](http://arxiv.org/help/bulk_data)
* [Bulk data access to arXiv metadata via OAI-PMH](http://arxiv.org/help/oa/index)
* [Bulk data access to arXiv PDFs and source docs](http://arxiv.org/help/bulk_data_s3)

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
