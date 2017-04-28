# check if query is NULL or white space
is_blank <-
    function(query)
{
    if(is.null(query) || grepl("^\\s*$", query)) # white space
        return(TRUE)

    FALSE
}
