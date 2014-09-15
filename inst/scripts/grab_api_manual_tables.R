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
# table of query terms
# "Table: search_query field terms"
####
query_terms <- tabs[[6]]
query_terms <- header_as_colnames(query_terms)
# drop the ID row
query_terms <- query_terms[query_terms[,1] != "id",]

# add to that table
query_terms <- rbind(query_terms,
                        c("submittedDate",
                          "Date/time of initial submission, as YYYYMMDDHHMM"),
                        c("lastUpdatedDate",
                          "Date/time of last update, as YYYYMMDDHHMM"))
dimnames(query_terms) <- list(1:nrow(query_terms), c("term", "description"))


####
# table of subject classifications
# "Table: Subject Classifications"
####
arxiv_cats <- tabs[[11]]
colnames(arxiv_cats) <- c("abbreviation", "description")
arxiv_cats <- arxiv_cats[-1,] # drop header row
rownames(arxiv_cats) <- 1:nrow(arxiv_cats)

## save as data sets within package
save(query_terms, file="../../data/query_terms.RData")
save(arxiv_cats, file="../../data/arxiv_cats.RData")
