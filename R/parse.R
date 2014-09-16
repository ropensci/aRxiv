
# convert XML result from arxiv_search to a list format
result2list <-
function(searchresult)
{
    doc <- XML::xmlParse(httr::content(searchresult, "text"), asText=TRUE)
    nodes <- rapply(list(doc), function(a) XML::getNodeSet(a, path="/"),
                    how="replace")
    result <- rapply(nodes, function(x) XML::xmlToList(x), how="replace")[[1]][[1]][[1]]

    result
}

# pull all elements of list with a certain name
pull_by_key <-
function(a_list, key)
{
    a_list[names(a_list)==key]
}

# get the entries as a list
get_entries <-
function(listresult)
{
   pull_by_key(listresult, "entry")
}

# just get the number of entries
count_entries <-
function(listresult)
{
    sum(names(listresult)=="entry")
}

# convert list of results (from result2list) into data.frame
#   test for this in tests/testthat/test-clean.R
listresult2df <-
function(listresult, sep="|")
{
    if(length(listresult)==0)
        return(empty_result())

    mat <- vapply(listresult, clean_record, sep=sep,
                  clean_record(listresult[[1]], sep=sep))

    # strip off a bunch of "entry" values
    colnames(mat) <- 1:ncol(mat)

    as.data.frame(t(mat), stringsAsFactors=FALSE)

}
