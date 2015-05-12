# paste queries together with AND
paste_query <-
function(query)
{
    if(is.null(query) || length(query)==1) return(query)
    paste(query, collapse=" AND ")
}

# paste together id_list
paste_id_list <-
function(id_list)
{
    if(is.null(id_list) || length(id_list)==1) return(id_list)
    paste(id_list, collapse=",")
}

# drop NULL values from a list
drop_nulls <-
function(list)
{
    list[!vapply(list, is.null, TRUE)]
}
