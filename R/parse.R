
#' @importFrom XML xmlToList getNodeSet xmlParse
# convert XML result from arxiv_search to a list format
result2list <-
function(searchresult)
{
    doc <- xmlParse(content(searchresult, "text"), asText=TRUE)
    nodes <- rapply(list(doc), function(a) getNodeSet(a, path="/"),
                    how="replace")
    result <- rapply(nodes, function(x) xmlToList(x), how="replace")[[1]][[1]][[1]]

    result
}

# get the entries as a list
get_entries <-
function(listresult)
{
   listresult[names(listresult)=="entry"]
}

# just get the number of entries
count_entries <-
function(listresult)
{
    sum(names(listresult)=="entry")
}
