
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
#' @export
#' @keywords
#' @seealso
#' @return
#' @alias
#' @examples \dontrun{
#'
#'}
arxiv_search  <- function(terms = NA, start = NA, end = NA, ...) {
	# Throwing down a dummy function to generate a skeleton.
	invisible()
}