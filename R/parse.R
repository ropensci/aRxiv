
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

# clean up a record
#   - multiple author -> single strings of authors & institutions
#   - multiple links -> link_abstract, link_pdf, link_doi
#   - category -> single string
clean_record <-
function(record)
{



}


# pull out a certain element (by its name) of each list in a list of lists
#    if that element doesn't appear, use ""
get_key <-
function(list_of_lists, key)
{
    vapply(list_of_lists, function(a) ifelse(key %in% names(a), a[[key]], ""), "")
}

# take author info and reture a string with names and another with
# institutions
clean_authors <-
function(record, separator="|")
{
    authors <- pull_by_key(record, "author")

    # pull out names and paste into one string
    names <- get_key(authors, "name")
    names <- paste(names, collapse=separator)

    # pull out institutions
    affiliations <- get_key(authors, "affiliation")
    affiliations <- paste(affiliations, collapse=separator)

    list(names=names, affiliations=affiliations)
}

# pull out all "link" fields from a record and converts to list with
# (link_abstrat, link_pdf, link_abstract)
clean_links <-
function(record, separator="|")
{
    links <- pull_by_key(record, "link")
    if(length(links)==0)
        return(link_abstract=NULL, link_pdf=NULL, link_doi=NULL)

    rel <- get_key(links, "rel")
    title <- get_key(links, "title")
    links <- get_key(links, "href")

    # abstract: rel=alternate
    wh <- (rel=="alternate")
    if(any(wh)) abstract <- paste(links[wh], collapse=separator)
    else abstract <- NULL

    # pdf: rel=related and title=pdf
    wh <- (rel=="related" & title=="pdf")
    if(any(wh)) pdf <- paste(links[wh], collapse=separator)
    else pdf <- NULL

    # doi: rel=related and title=doi
    wh <- (rel=="related" & title=="doi")
    if(any(wh)) doi <- paste(links[wh], collapse=separator)
    else doi <- NULL

    list(link_abstract=abstract, link_pdf=pdf, link_doi=doi)
}


# pull out categories and paste together
clean_categories <-
function(record, separator="|")
{
    categories <- pull_by_key(record, "category")
    terms <- get_key(categories, "term")
    paste(terms, collapse=separator)
}
