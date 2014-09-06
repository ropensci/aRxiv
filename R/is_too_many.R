# check if a search will return too many results
is_too_many <-
function(query=NULL, id_list=NULL, start=NULL, end=NULL)
{
    toomany <- 15000 # I'll call this too many

    if(is.null(start) || is.null(end) || (end-start+1) > toomany) {
        expected_number <- arxiv_count(query, id_list)
        message("Total records matching query: ", expected_number)

        if(expected_number > toomany)
            return(expected_number)
    }

    0 # return 0 if it's not too many
}
