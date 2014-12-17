#' Check for connection to arXiv API
#'
#' Check for connection to arXiv API
#'
#' @param max_time Maximum wait time in seconds
#'
#' @export
#'
#' @return Returns TRUE if connection is established and FALSE
#' otherwise.
#'
#' @examples
#' \donttest{
#' can_arxiv_connect(2)
#' }
can_arxiv_connect <-
    function(max_time=5) # maximum wait time in seconds
{
    query_url <- "http://export.arxiv.org/api/query"

    result <- tryCatch(z <- httr::POST(query_url, body=list(search_query="all:electron", max_results=0),
                                       httr::timeout(max_time)),
                       error=function(e) paste("Failure to connect in arxiv_check"))

    # check for error in httr::POST
    if(!is.null(result) && length(result)==1 &&
       result == "Failure to connect in arxiv_check") {
        warning("Failed to connect to ", query_url, " in ", max_time, " sec")
        return(FALSE)
    }

    # check for arXiv error
    listresult <- result2list(z)
    error_message <- arxiv_error_message(listresult)
    if(!is.null(error_message)) {
        warning("arXiv error: ", error_message)
        return(FALSE)
    }

    # check for general http error
    status <- httr::http_status(z)
    if(status$category != "success") {
        httr::warn_for_status(z)
        return(FALSE)
    }

    # seems okay...return TRUE
    TRUE
}
