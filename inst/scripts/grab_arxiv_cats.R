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

# categories
cats <- sapply(strsplit(ids, ".", fixed=TRUE), "[", 1)

short_descr <- html_elements(text, "div h4 span")
short_descr <- sub("<span>(", "", as.character(short_descr), fixed=TRUE)
short_descr <- sub(")</span>", "", as.character(short_descr), fixed=TRUE)

# should be the same length
stopifnot(length(ids) == length(short_descr))

larger_cat <- html_elements(text, "h2.accordion-head")
larger_cat <- sapply(strsplit(as.character(larger_cat), "[<>]"), "[", 3)

cat_abbr <- sapply(strsplit(ids, ".", fixed=TRUE), "[", 1)
cat_abbr_uniq <- unique(larger_cat_abbr)

# ugh there are two levels of categories to extract, as well as short and long descriptions
long_descr <- html_elements(text, "div.columns p")
long_descr <- sapply(strsplit(as.character(long_descr), "[<>]"), "[", 3)
long_descr <- long_descr[3:(length(long_descr)-1)] # drop first two plus last
stopifnot(length(long_descr) == length(short_descr))

# highest-level fields
fields <- html_elements(text, 'h2.accordion-head')
fields <- sapply(strsplit(as.character(fields), "[<>]"), "[", 3)

# just physics is split up into sub-fields; look for these sub-fields
sub_fields_physics <- html_elements(text, 'div.physics div h3')
sub_fields_physics_abbr <- sapply(strsplit(as.character(sub_fields_physics), "[<>]"), "[", 7)
sub_fields_physics <- sapply(strsplit(as.character(sub_fields_physics), "[<>]"), "[", 3)
sub_fields_physics_abbr <- gsub("[\\(\\)]", "", sub_fields_physics_abbr)
stopifnot(length(sub_fields_physics) == length(sub_fields_physics_abbr))

# expand fields and sub-fields
physics_cats <- cats %in% sub_fields_physics_abbr
fields_abbr <- ()


arxiv_cats <- data.frame(abbreviation=ids,
                         field=,
                         subfield=,
                         short_description=short_descr,
                         long_description=long_descr)

colnames(arxiv_cats) <- c("abbreviation", "description")
arxiv_cats <- arxiv_cats[-1,] # drop header row
rownames(arxiv_cats) <- 1:nrow(arxiv_cats)

## save as data sets within package
save(query_terms, file="../../data/query_terms.RData")
save(arxiv_cats, file="../../data/arxiv_cats.RData")
