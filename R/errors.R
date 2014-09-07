

# pull out error message, or return NULL
arxiv_error_message <-
function(listresult)
{
    nentries <- sum(names(listresult)=="entry")
    if(nentries == 1) { # one entry
        entry <- listresult[["entry"]]

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
