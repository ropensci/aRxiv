
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
#' @param output_format Indicates whether output should be a data frame or a list.
#' @param sep String to use to separate multiple authors,
#' affiliations, DOI links, and categories, in the case that
#' \code{output_format="data.frame"}.
#'
#' @import httr
#' @export
#'
#' @return If \code{output_format="data.frame"}, the result is a data
#' frame with each row being a manuscript and columns being the
#' various fields.
#'
#' If \code{output_format="list"}, the result is a list parsed from
#' the XML output of the search, closer to the raw output from arXiv.
#'
#' The data frame format has the following columns.
#' \tabular{rll}{
#'  [,1] \tab id               \tab arXiv ID \cr
#'  [,2] \tab updated          \tab last date updated \cr
#'  [,3] \tab published        \tab date first published \cr
#'  [,4] \tab title            \tab manuscript title \cr
#'  [,5] \tab summary          \tab abstract \cr
#'  [,6] \tab authors          \tab author names \cr
#'  [,7] \tab affiliations     \tab author affiliations \cr
#'  [,8] \tab link_abstract    \tab hyperlink to abstract \cr
#'  [,9] \tab link_pdf         \tab hyperlink to pdf \cr
#' [,10] \tab link_doi         \tab hyperlink to DOI \cr
#' [,11] \tab comment          \tab authors' comment \cr
#' [,12] \tab journal_ref      \tab journal reference \cr
#' [,13] \tab primary_category \tab primary category \cr
#' [,14] \tab categories       \tab all categories \cr
#' }
#'
#' The contents are all strings; missing values are empty strings (\code{""}).
#'
#' The columns \code{authors}, \code{affiliations}, \code{link_doi},
#' and \code{categories} may have multiple entries separated by
#' \code{sep} (by default, \code{"|"}).
#'
#' The result includes an attribute \code{"search_info"} that includes
#' information about the details of the search parameters, including
#' the time at which it was completed.
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
         ascending=TRUE, batchsize=500, force=FALSE,
         output_format=c("data.frame", "list"), sep="|")
{
    query_url <- "http://export.arxiv.org/api/query"

    sort_by <- match.arg(sort_by)
    sort_order <- ifelse(ascending, "ascending", "descending")
    output_format <- match.arg(output_format)

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
                                          batchsize=batchsize, force=force,
                                          output_format="list")
            message("retrieved batch ", i)

            # if no more results? then return
            if(count_entries(these_results) == 0)
                return(results)

            results <- c(results, these_results)
        }

        if(output_format=="data.frame")
            results <- listresult2df(results, sep=sep)

        attr(results, "search_info") <-
            search_attributes(query, id_list, start, end,
                              sort_by, sort_order)

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

    # pull out just the entries
    results <- get_entries(listresult)

    # convert to data frame
    if(output_format=="data.frame")
        results <- listresult2df(results, sep=sep)

    attr(results, "search_info") <-
        search_attributes(query, id_list, start, end,
                          sort_by, sort_order)

    results
}


# an attribute to add to the result
search_attributes <-
function(query, id_list, start, end, sort_by,
         sort_order)
{
    c(query=ifelse(is.null(query), "", query),
      id_list=ifelse(is.null(id_list), "", id_list),
      start=start, end=end, sort_by=sort_by,
      sort_order=sort_order, time=paste(Sys.time(), Sys.timezone()))
}
