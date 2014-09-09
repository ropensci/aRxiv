# arxiv_open
#
#' Open abstract for results of arXiv search
#'
#' Open, in web browser, the abstract pages for each of set of arXiv search results.
#'
#' @param search_results Data frame of search results, as returned from \code{\link{arxiv_search}}
#'
#' @details The R option \code{"arxiv_max2open"} defines the maximum
#' number of pages to open; if missing, the default is 5.
#' \bold{Don't try to open too many at once!}
#'
#' @return (Invisibly) Vector strings with URLs of abstracts opened.
#'
#' @importFrom utils browseURL
#' @export
#'
#' @examples
#' z <- arxiv_search("au:Broman AND cat:stat.AP")
#' \donttest{arxiv_open(z)}

arxiv_open <-
function(search_results)
{
    if(nrow(search_results) == 0)
        return(invisible(NULL))

    max2open <- getOption("arxiv_max2open")
    max2open <- ifelse(is.null(max2open), 5, max2open)

    links <- search_results$link_abstract
    links <- links[links != ""]
    if(length(links) > max2open) {
        warning("More abstracts (", length(links), ") than maximum allowed to be opened (", max2open, ").")
        links <- links[1:max2open]
    }

    for(link in links) {
        cat(link, "\n")
        browseURL(link)
    }

    return(invisible(links))
}
