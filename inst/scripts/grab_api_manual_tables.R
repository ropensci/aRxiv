# grab a couple of tables from arXiv API user manual

library(XML)
library(httr)

url <- "http://arxiv.org/help/api/user-manual"
tabs <- readHTMLTable(content(GET(url)), stringsAsFactors=FALSE)

# make the first row the colnames
header_as_colnames <-
function(tab)
{
    colnames(tab) <- tab[1,]
    tab[-1,]
}

####
# table of query prefixes
# "Table: search_query field prefixes"
####
query_prefixes <- tabs[[6]]
query_prefixes <- header_as_colnames(query_prefixes)
# drop the ID row
query_prefixes[query_prefixes[,1] != "id",]

####
# table of subject classifications
# "Table: Subject Classifications"
####
arxiv_cats <- tabs[[11]]
arxiv_cats <- header_as_colnames(arxiv_cats)

## save as data sets within package
save(query_prefixes, file="../../data/query_prefixes.RData")
save(arxiv_cats, file="../../data/arxiv_cats.RData")
