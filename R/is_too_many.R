# check if a search will return too many results
is_too_many <-
function(query=NULL, id_list=NULL, start=0, limit=10)
{
    # look for delay amount in options; otherwise set to default
    toomany <- getOption("aRxiv_toomany")
    if(is.null(toomany)) toomany <- 15000

    # this is to avoid having to call arxiv_count twice
    expected_number <- NA

    if(is.null(start))
        start <- 0
    if(is.null(limit))
        limit <- expected_number <- arxiv_count(query, id_list)

    stopifnot(start >= 0)
    stopifnot(limit >= 0)

    if(limit > toomany) {
        if(is.na(expected_number)) # haven't yet called arxiv_count
            expected_number <- arxiv_count(query, id_list)
        message("Total records matching query: ", expected_number)

        if(expected_number > toomany)
            return(expected_number)
    }

    0 # return 0 if it's not too many
}
