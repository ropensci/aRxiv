#' Count number of results for a given search
#'
#' Count the number of results for a given search. Useful to check
#' before attempting to pull down a very large number of records.
#'
#' @param query  Search pattern as a string
#' @param id_list List of arXiv doc IDs, as comma-delimited string
#'
#' @import httr
#' @export
#'
#' @return Number of results (integer). An attribute
#' \code{"search_info"} contains information about the search
#' parameters and the time at which it was performed.
#'
#' @examples
#' \dontshow{old_delay <- getOption("aRxiv_delay")
#'           options(aRxiv_delay=1)}
#' # count papers in category stat.AP (applied statistics)
#' arxiv_count(query = "cat:stat.AP")
#' arxiv_count(query = 'au:"Peter Hall"')
#'
#' # count papers for a range of dates
#' arxiv_count("lastUpdatedDate:[199701010000 TO 199712312359]")
#' \dontshow{options(aRxiv_delay=old_delay)}
arxiv_count <-
function(query = NULL, id_list=NULL)
{
    query_url <- "http://export.arxiv.org/api/query"

    # do search
    delay_if_necessary()
    search_result <- POST(query_url,
                          body=list(search_query=query, id_list=id_list,
                                    start=0, max_results=0))

    # convert XML results to a list
    listresult <- result2list(search_result)

    # check for arXiv error
    error_message <- arxiv_error_message(listresult)
    if(!is.null(error_message)) {
        stop("arXiv error: ", error_message)
    }

    # check for general http error
    stop_for_status(search_result)

    # return totalResults
    result <- as.integer(listresult$totalResults)

    attr(result, "search_info") <-
        search_attributes(query, id_list, NULL, NULL, NULL, NULL)

    result
}
