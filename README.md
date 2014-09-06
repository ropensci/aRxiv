## R interface to arXiv

Package is in early development.

### Installation

The package is not currently available on
[CRAN](http://cran.r-project.org). To install, use
`devtools::install_github()`, as follows:a

```coffee
install.packages("devtools")
library(devtools)
install_github("ropensci/aRxiv")
library(aRxiv)
```

### Basic usage

The main function is `arxiv_search()`. Here's an example of its use:

```coffee
arxiv_search(query = "au:Broman AND cat:stat.AP", start=0, end=10)
```


### Notes

* [arXiv API](http://arxiv.org/help/api/index)
* [arXiv API user manual](http://arxiv.org/help/api/user-manual)

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
