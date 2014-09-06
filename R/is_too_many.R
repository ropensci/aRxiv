# check if a search will return too many results
is_too_many <-
function(query=NULL, id_list=NULL, start=0, end=10)
{
    # look for delay amount in options; otherwise set to default
    toomany <- getOption("aRxiv_toomany")
    if(is.null(toomany)) toomany <- 15000

    expected_count <- NA

    if(is.null(start))
        start <- 0
    if(is.null(end)) {
        expected_number <- arxiv_count(query, id_list)
        end <- expected_number-1 # index of last, and index starts at 0
    }

    stopifnot(start >= 0)
    stopifnot(end >= 0)

    if(end-start+1 > toomany) {
        if(is.na(expected_number))
            expected_number <- arxiv_count(query, id_list)
        message("Total records matching query: ", expected_number)

        if(expected_number > toomany)
            return(expected_number)
    }

    0 # return 0 if it's not too many
}
