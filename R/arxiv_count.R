#' Count number of results for a given search
#'
#' Count the number of results for a given search. Useful to check
#' before attempting to pull down a very large number of records.
#'
#' @param query Search pattern as a string; a vector of such strings is
#' also allowed, in which case the elements are combined with \code{AND}.
#' @param id_list arXiv doc IDs, as comma-delimited string or a vector
#' of such strings
#'
#' @export
#'
#' @return Number of results (integer). An attribute
#' \code{"search_info"} contains information about the search
#' parameters and the time at which it was performed.
#'
#' @seealso \code{\link{arxiv_search}}, \code{\link{query_terms}},
#' \code{\link{arxiv_cats}}
#'
#' @examples
#' \dontshow{old_delay <- getOption("aRxiv_delay")
#'           options(aRxiv_delay=1)}
#' \donttest{
#' # count papers in category stat.AP (applied statistics)
#' arxiv_count(query = "cat:stat.AP")
#'
#' # count papers by Peter Hall in any stat category
#' arxiv_count(query = 'au:"Peter Hall" AND cat:stat*')
#'
#' # count papers for a range of dates
#' #    here, everything in 2013
#' arxiv_count("submittedDate:[2013 TO 2014]")
#' }
#' \dontshow{options(aRxiv_delay=old_delay)}
arxiv_count <-
function(query=NULL, id_list=NULL)
{
    query_url <- "http://export.arxiv.org/api/query"

    query <- paste_query(query)
    id_list <- paste_id_list(id_list)

    delay_if_necessary()
    # do search
    # (extra messy to avoid possible problems when testing on CRAN
    #    timeout_action defined in timeout.R)
    body <- list(search_query=query, id_list=id_list,
                 start=0, max_gresults=0)
    body <- drop_nulls(body)
    search_result <- try(httr::POST(query_url,
                                    body=body,
                                    httr::timeout(get_arxiv_timeout())))
    if(class(search_result) == "try-error") {
        timeout_action()
        return(invisible(NULL))
    }

    set_arxiv_time() # set time for last call to arXiv

    # convert XML results to a list
    listresult <- result2list(search_result)

    # check for arXiv error
    error_message <- arxiv_error_message(listresult)
    if(!is.null(error_message)) {
        stop("arXiv error: ", error_message)
    }

    # check for general http error
    httr::stop_for_status(search_result)

    # return totalResults
    result <- as.integer(listresult$totalResults)

    attr(result, "search_info") <-
        search_attributes(query, id_list, NULL, NULL, NULL, NULL)

    # assign class to avoid printing attributes
    class(result) <- c("arxiv_count", "integer")
    result
}

# to avoid printing attributes
#' @export
print.arxiv_count <-
function(x, ...)
{
    print(as.vector(x), ...)
}

# omit search_info attribute
#    also, if arxiv_count, unclass
omit_attr <-
function(x)
{
    attr(x, "search_info") <- NULL
    attr(x, "total_results") <- NULL

    if("arxiv_count" %in% class(x))
        x <- unclass(x)

    x
}
