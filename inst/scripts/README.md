## Script for [aRxiv](http://github.com/ropensci/aRxiv) package

[`grab_api_manual_tables.R`](http://github.com/ropensci/aRxiv/tree/master/inst/scripts/grab_api_manual_tables.R)
&ndash; R script to grab tables from the
[arXiv API user guide](http://arxiv.org/help/api/index).

- search terms (`query_prefixes`)
- subject classifications (`arxiv_cats`)

The script creates datasets for the package that contain the body of the tables.

To access the resulting datasets, do the following:

```r
library(aRxiv)
data(query_prefixes)
data(arxiv_cats)
```
