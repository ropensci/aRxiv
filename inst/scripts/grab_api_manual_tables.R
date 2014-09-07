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
# table of result elements
# "Table: Atom elements"
####
result_elements <- tabs[[10]]
result_elements <- header_as_colnames(result_elements)

# split into two
feedindex <- which(result_elements[,1]=="feed elements")
entryindex <- which(result_elements[,1]=="entry elements")
result_elements <- list(feed=result_elements[(feedindex+1):(entryindex-1),],
                        entry=result_elements[-(1:entryindex),])

####
# table of subject classifications
# "Table: Subject Classifications"
####
arxiv_cats <- tabs[[11]]
arxiv_cats <- header_as_colnames(arxiv_cats)

## save as data sets within package
save(query_prefixes, file="../../data/query_prefixes.RData")
save(result_elements, file="../../data/result_elements.RData")
save(arxiv_cats, file="../../data/arxiv_cats.RData")
