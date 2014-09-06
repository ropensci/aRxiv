
# This is the template for the search API methods for arXiv
# User manual: http://arxiv.org/help/api/user-manual
# A simple search: http://arxiv.org/help/api/user-manual
# A boolean search: http://export.arxiv.org/api/query?search_query=all:electron+AND+all:proton

#' The main search function for aRxiv
#'
#' Allows for progammatic searching of the arXiv pre-print repository.
#'
#' @param query  Search pattern as a string
#' @param id_list List of arXiv doc IDs, as comma-delimited string
#' @param start An offset for the start of search
#' @param end Where to end search results
#' @param sort_by How to sort the results
#' @param ascending If TRUE, sort in increasing order; else decreasing
#' @param batchsize Maximum number of records to request at one time
#' @param delay Time between requests, in seconds
#' @param force If TRUE, force search request even if it seems extreme
#'
#' @import httr
#' @export
#'
#' @return Parse XML result as a list
#'
#' @examples
#' # search for author Broman and category stat.AP (applied statistics)
#' z <- arxiv_search(query = "au:Broman AND cat:stat.AP", start=0, end=10)
#' z$totalResults
#' sapply(z[names(z)=="entry"], function(a) a$title)
#'
#' # search for a set of documents by arxiv identifiers
#' z <- arxiv_search(id_list = "1403.3048,1402.2633,1309.1192")
#' # DOI if available
#' sapply(z[names(z)=="entry"], function(a) a$doi)
arxiv_search <-
function(query = NULL, id_list=NULL, start = NULL, end = NULL,
         sort_by=c("relevance", "lastUpdatedDate", "submittedDate"),
         ascending=TRUE, batchsize=500, delay=3, force=FALSE)
{
    query_url <- "http://export.arxiv.org/api/query"

    sort_by <- match.arg(sort_by)
    sort_order <- ifelse(ascending, "ascending", "descending")

    # if force=FALSE, check that we aren't asking for too much
    if(!force) {
        too_many_res <- is_too_many(query, id_list, start, end)
        if(too_many_res)
            stop("Expecting ", too_many_res, " results; refine your search")
        if(too_many_res > batchsize && batchsize > 1000)
            stop("Expecting ", too_many_res, " and batchsize is ", batchsize, " which looks too large.\n",
                 "Refine your search or reduce batchsize.")
    }

    # do search
    search_result <- POST(query_url,
                          body=list(search_query=query, id_list=id_list,
                                    start=start, max_results=end-start+1,
                                    sort_by=sort_by, sort_order=sort_order))

    # convert XML results to a list
    listresult <- result2list(search_result)

    # check for arXiv error
    error_message <- arxiv_error_message(listresult)
    if(!is.null(error_message)) {
        stop("arXiv error: ", error_message)
    }

    # check for general http error
    stop_for_status(search_result)

    # return list result
    listresult
}
