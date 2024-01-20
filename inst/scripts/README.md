## R scripts to grab data tables

- [`grab_query_terms`](https://github.com/ropensci/aRxiv/tree/master/inst/scripts/grab_query_terms.R)
grabs search terms (`query_terms`) from the [API user manual](https://arxiv.org/help/api/user-manual.html)

- [`grab_arxiv_cats.R`](http://github.com/ropensci/aRxiv/tree/master/inst/scripts/grab_arxiv_cats.R)
grabs the subject classifications (`arxiv_cats`) from <https://arxiv.org/category_taxonomy>

```r
library(aRxiv)
data(query_terms)
data(arxiv_cats)
```
