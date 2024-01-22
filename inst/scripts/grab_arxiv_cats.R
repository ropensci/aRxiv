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

# category ID
ids <- html_elements(text, "div h4")[-1] # first one is not a real category
ids <- sapply(strsplit(as.character(ids), "<h4>"), "[", 2)
ids <- sapply(strsplit(as.character(ids), " <span>"), "[", 1)

# short description
short_descr <- html_elements(text, "div h4 span")
short_descr <- sub("<span>(", "", as.character(short_descr), fixed=TRUE)
short_descr <- sub(")</span>", "", as.character(short_descr), fixed=TRUE)

# should be the same length
stopifnot(length(ids) == length(short_descr))

# highest-level fields
fields <- html_elements(text, 'h2.accordion-head')
fields <- sapply(strsplit(as.character(fields), "[<>]"), "[", 3)

# field abbreviation
fields_abbr <- sapply(strsplit(ids, ".", fixed=TRUE), "[", 1)
fields_abbr_uniq <- unique(fields_abbr)

# ugh there are two levels of categories to extract, as well as short and long descriptions
long_descr <- html_elements(text, "div.columns p")
long_descr <- sapply(strsplit(as.character(long_descr), "[<>]"), "[", 3)
long_descr <- long_descr[3:(length(long_descr)-1)] # drop first two plus last
stopifnot(length(long_descr) == length(short_descr))


# just physics is split up into sub-fields; look for these sub-fields
sub_fields_physics <- html_elements(text, 'div.physics div h3')
sub_fields_physics_abbr <- sapply(strsplit(as.character(sub_fields_physics), "[<>]"), "[", 7)
sub_fields_physics <- sapply(strsplit(as.character(sub_fields_physics), "[<>]"), "[", 3)
sub_fields_physics_abbr <- gsub("[\\(\\)]", "", sub_fields_physics_abbr)
stopifnot(length(sub_fields_physics) == length(sub_fields_physics_abbr))

# create fields and subfields objects of same length as ids
fields_uniq <- fields_abbr_uniq
fields_uniq[fields_abbr_uniq %in% sub_fields_physics_abbr] <- "Physics"
fields_uniq[!(fields_abbr_uniq %in% sub_fields_physics_abbr)] <- fields[fields != "Physics"]
fields_count <- sapply(fields_abbr_uniq, function(a) sum(fields_abbr ==a))
fields <- rep(fields_uniq, fields_count)

sub_fields_physics_count <- sapply(sub_fields_physics_abbr, function(a) sum(fields_abbr == a))
sub_fields_physics <- rep(sub_fields_physics, sub_fields_physics_count)
subfields <- fields
subfields[fields == "Physics"] <- sub_fields_physics
subfields[fields != "Physics"] <- NA

arxiv_cats <- data.frame(category=ids,
                         field=fields,
                         subfield=subfields,
                         short_description=short_descr,
                         long_description=long_descr)

rownames(arxiv_cats) <- 1:nrow(arxiv_cats)

## save as data sets within package
save(arxiv_cats, file="../../data/arxiv_cats.RData")
