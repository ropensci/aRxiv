

# pull out error message, or return NULL
arxiv_error_message <-
function(listresult)
{
    entries <- get_entries(listresult)
    if(length(entries)==1) {
        entry <- entries[[1]]

        # single entry with Error as title and "arXiv api core" as author?
        if(all(c("title", "author", "summary") %in% names(entry)) &&
           entry$title == "Error" &&
           "name" %in% names(entry$author) && entry$author$name == "arXiv api core") {

            return(entry$summary)

        }

    }

    # ok; return NULL
    NULL
}
