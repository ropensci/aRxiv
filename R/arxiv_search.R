
# This is the template for the search API methods for arXiv
# User manual: http://arxiv.org/help/api/user-manual
# A simple search: http://arxiv.org/help/api/user-manual
# A boolean search: http://export.arxiv.org/api/query?search_query=all:electron+AND+all:proton

#'The main search function for aRxiv
#'
#'Allows for progammatic searching of the arXiv pre-print repository.
#' @param terms  Search terms. Submit multiple terms as a concactenated string.
#' @param  start An offset for the start of search
#' @param  end Where to end search results
#' @param  ... optional additional arguments
#' @importFrom XML xmlToList
#' @importFrom rjson toJSON
#' @import httr
#' @export
#' @keywords
#' @seealso
#' @return
#' @alias
#' @examples \dontrun{
#' arxiv_search(query = "electron")
#'}
arxiv_search  <- function(query = NULL, start = NA, end = NA, foptions = list()) {
	browser()
 args <- compact(as.list(c(query = query)))	
 query_url <- "http://export.arxiv.org/api/query"
 search_res <- GET(query_url, query = args, foptions)
 stop_for_status(search_res)
 search_content <- content(search_res)
 search_list <- xmlToList(search_content)
 search_json <- toJSON(search_list)
 search_json
}