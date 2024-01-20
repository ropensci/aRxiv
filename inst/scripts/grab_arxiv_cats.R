# grab arxiv category information, from arXiv web site

library(httr)
library(rvest)

# table of subject classifications
# this has moved to https://arxiv.org/category_taxonomy
# it's no longer a table, but rather a bunch of divs :(
#
# categories are in <h4> elements; short descriptions are in <span> within those <h4> elements
# full description in <p> within <div class="column"> that follows the <div> with the <h4>
# larger classifications are in <h2 class="accordion-head">
####
url <- "https://arxiv.org/category_taxonomy"
text <- content(GET(url), encoding="UTF-8")

ids <- html_elements(text, "div h4")[-1] # first one is not a real category
ids <- sapply(strsplit(as.character(ids), "<h4>"), "[", 2)
ids <- sapply(strsplit(as.character(ids), " <span>"), "[", 1)

short_descr <- html_elements(text, "div h4 span")
short_descr <- sub("<span>(", "", as.character(short_descr), fixed=TRUE)
short_descr <- sub(")</span>", "", as.character(short_descr), fixed=TRUE)

larger_cat <- html_elements(text, "h2.accordion-head")
larger_cat <- sapply(strsplit(as.character(larger_cat), "[<>]"), "[", 3)

larger_cat_abbr <- sapply(strsplit(ids, ".", fixed=TRUE), "[", 1)

# ugh there are two levels of categories to extract, as well as short and long descriptions


# abbreviation, larger category, smaller category, short description, full description

arxiv_cats <- tabs[[11]]
colnames(arxiv_cats) <- c("abbreviation", "description")
arxiv_cats <- arxiv_cats[-1,] # drop header row
rownames(arxiv_cats) <- 1:nrow(arxiv_cats)

## save as data sets within package
save(query_terms, file="../../data/query_terms.RData")
save(arxiv_cats, file="../../data/arxiv_cats.RData")
