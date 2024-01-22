# grab query_terms, from a table in arXiv API user manual

library(httr)
library(rvest)

url <- "https://arxiv.org/help/api/user-manual.html"
tabs <- html_elements(content(GET(url), encoding="UTF-8"), "table")
tabs <- lapply(tabs, function(z) as.data.frame(html_table(z)))


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

## save as data set within package
save(query_terms, file="../../data/query_terms.RData")
