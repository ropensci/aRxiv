
# This is the template for the search API methods for arXiv
# User manual: http://arxiv.org/help/api/user-manual
# A simple search: http://arxiv.org/help/api/user-manual
# A boolean search: http://export.arxiv.org/api/query?search_query=all:electron+AND+all:proton

#'The main search function for aRxiv
#'
#'Allows for progammatic searching of the arXiv pre-print repository.
#' @param query  Search pattern; submit multiple terms as a concactenated string.
#' @param id_list List of arXiv doc IDs, as comma-delimited string
#' @param  start An offset for the start of search
#' @param  end Where to end search results
#' @param sort_by How to sort the results
#' @param ascending If TRUE, sort in increasing order; else decreasing
#' @import httr
#' @export
#' @return Parse XML result as a list
#' @examples
#' z <- arxiv_search(query = "au:Broman AND cat:stat.AP", start=0, end=10)
#' z$totalResults
#' titles <- sapply(z[names(z)=="entry"], function(a) a$title)
arxiv_search <-
function(query = NULL, id_list=NULL, start = NULL, end = NULL,
         sort_by=c("relevance", "lastUpdatedDate", "submittedDate"),
         ascending=TRUE)
{
    query_url <- "http://export.arxiv.org/api/query"

    sort_by <- match.arg(sort_by)
    sort_order <- ifelse(ascending, "ascending", "descending")

    search_result <- POST(query_url,
                          body=list(search_query=query, id_list=id_list,
                                    start=start, max_results=end-start+1,
                                    sort_by=sort_by, sort_order=sort_order))

    stop_for_status(search_result)

    result2list(search_result)
}
