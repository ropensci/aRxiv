
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
#' @param force If TRUE, force search request even if it seems extreme
#'
#' @import httr
#' @export
#'
#' @return Parse XML result as a list
#'
#' @examples
#' \dontshow{old_delay <- getOption("aRxiv_delay")
#'           options(aRxiv_delay=1)}
#' # search for author Broman and category stat.AP (applied statistics)
#' z <- arxiv_search(query = "au:Broman AND cat:stat.AP", start=0, end=10)
#' z$totalResults
#' sapply(z[names(z)=="entry"], function(a) a$title)
#'
#' # search for a set of documents by arxiv identifiers
#' z <- arxiv_search(id_list = "1403.3048,1402.2633,1309.1192")
#' # DOI if available
#' sapply(z[names(z)=="entry"], function(a) a$doi)
#'
#' # search for a range of dates (in this case, one day)
#' z <- arxiv_search("lastUpdatedDate:[199701010000 TO 199701012359]")
#' \dontshow{options(aRxiv_delay=old_delay)}
arxiv_search <-
function(query = NULL, id_list=NULL, start = 0, end = 10,
         sort_by=c("relevance", "lastUpdatedDate", "submittedDate"),
         ascending=TRUE, batchsize=500, force=FALSE)
{
    query_url <- "http://export.arxiv.org/api/query"

    sort_by <- match.arg(sort_by)
    sort_order <- ifelse(ascending, "ascending", "descending")

    if(is.null(start)) start <- 0
    if(is.null(end)) end <- arxiv_count(query, list)-1

    stopifnot(start >= 0)
    stopifnot(end >= 0)
    stopifnot(batchsize >= 1)

    # if force=FALSE, check that we aren't asking for too much
    if(!force) {
        too_many_res <- is_too_many(query, id_list, start, end)
        if(too_many_res)
            stop("Expecting ", too_many_res, " results; refine your search")
        if(too_many_res > batchsize && batchsize > 1000)
            stop("Expecting ", too_many_res, " and batchsize is ", batchsize, " which looks too large.\n",
                 "Refine your search or reduce batchsize.")
    }

    if(end-start+1 > batchsize) { # use batches
        nbatch <- ceiling((end-start+1)/batchsize)
        results <- NULL

        starts <- seq(start, end, by=batchsize)

        for(i in seq(along=starts)) {

            # where to end this batch?
            thisend <- starts[i]+batchsize-1
            if(thisend > end) thisend <- end


            these_results <- arxiv_search(query=query, id_list=id_list,
                                          start=starts[i], end=thisend,
                                          sort_by=sort_by, ascending=ascending,
                                          batchsize=batchsize, force=force)
            message("retrieved batch ", i)

            # if no more results? then return
            if(count_entries(these_results) == 0)
                return(results)

            results <- c(results, these_results)
        }

        return(results)
    }

    # do search
    delay_if_necessary()
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

    # return the entries
    get_entries(listresult)
}
