# arxiv_open
#
#' Open abstract for results of arXiv search
#'
#' Open, in web browser, the abstract pages for each of set of arXiv search results.
#'
#' @param search_results Data frame of search results, as returned from \code{\link{arxiv_search}}.
#' @param limit Maximum number of abstracts to open in one call.
#'
#' @details There is a delay between calls to
#' \code{\link[utils]{browseURL}}, with the amount taken from the R
#' option \code{"aRxiv_delay"} (in seconds); if missing, the default
#' is 3 sec.
#'
#' @return (Invisibly) Vector of character strings with URLs of
#' abstracts opened.
#'
#' @seealso \code{\link{arxiv_search}}
#'
#' @export
#'
#' @examples
#' \donttest{z <- arxiv_search('au:"Peter Hall" AND ti:deconvolution')
#' arxiv_open(z)}

arxiv_open <-
function(search_results, limit=20)
{
    stopifnot(limit >= 1)

    if(nrow(search_results) == 0)
        return(invisible(NULL))

    links <- search_results$link_abstract
    links <- links[links != ""]
    if(length(links) > limit) {
        warning("More abstracts (", length(links), ") than maximum to be opened (", limit, ").")
        links <- links[1:limit]
    }

    for(link in links) {
        delay_if_necessary()
        utils::browseURL(link)
    }

    invisible(links)
}
