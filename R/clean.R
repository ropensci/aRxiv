
# clean up a record
#   - multiple author -> single strings of authors & institutions
#   - multiple links -> link_abstract, link_pdf, link_doi
#   - category -> single string
clean_record <-
function(record, sep="|")
{
    id <- clean_id(record)
    authors <- clean_authors(record, sep=sep)
    links <- clean_links(record, sep=sep)
    categories <- clean_categories(record, sep=sep)

    c(id=id,
      submitted=clean_datetime(get_key(record, "published")),
      updated=clean_datetime(get_key(record, "updated")),
      title=get_key(record, "title"),
      abstract=get_key(record, "summary"),
      authors=authors$names,
      affiliations=authors$affiliations,
      link_abstract=links$link_abstract,
      link_pdf=links$link_pdf,
      link_doi=links$link_doi,
      comment=get_key(record, "comment"),
      journal_ref=get_key(record, "journal_ref"),
      doi=get_key(record, "doi"),
      primary_category=get_key(record$primary_category, "term"),
      categories=categories)
}

empty_result <-
function()
{
   data.frame(id=character(0),
              submitted=character(0),
              updated=character(0),
              title=character(0),
              abstract=character(0),
              authors=character(0),
              affiliations=character(0),
              link_abstract=character(0),
              link_pdf=character(0),
              link_doi=character(0),
              comment=character(0),
              journal_ref=character(0),
              doi=character(0),
              primary_category=character(0),
              categories=character(0),
              stringsAsFactors=FALSE)
}


# pull out a certain element (by its name) of each list in a list of lists
#    if that element doesn't appear, use ""
# the purpose of this is to avoid NULLs and get "" instead
get_key_ll <-
function(list_of_lists, key)
{
    vapply(list_of_lists, function(a) ifelse(key %in% names(a), a[[key]], ""), "")
}

# pull out a certain element (by its name)
#    if that element doesn't appear, use ""
# the purpose of this is to avoid NULLs and get "" instead
get_key <-
function(a_list, key)
{
    ifelse(key %in% names(a_list), a_list[[key]], "")
}

# id comes back as an URL; strip off the initial "http://arxiv.org/abs/"
clean_id <-
function(record)
{
    if(is.null(record$id)) return("")
    sub("^http://arxiv.org/abs/", "", record$id)
}

# date/time comes back as
clean_datetime <-
function(string)
{
    # "Z" -> ""; "T" -> " "
    gsub("Z", "", gsub("T", " ", string))
}


# take author info and return a string with names and another with
# institutions
clean_authors <-
function(record, sep="|")
{
    authors <- pull_by_key(record, "author")

    # pull out names and paste into one string
    names <- get_key_ll(authors, "name")
    names <- paste(names, collapse=sep)

    # pull out institutions
    affiliations <- get_key_ll(authors, "affiliation")
    affiliations <- paste(affiliations, collapse=sep)
    if(length(grep("^\\|+$", affiliations)))
        affiliations <- "" # just use "" if all missing

    list(names=names, affiliations=affiliations)
}

# pull out all "link" fields from a record and converts to list with
# (link_abstrat, link_pdf, link_abstract)
clean_links <-
function(record, sep="|")
{
    links <- pull_by_key(record, "link")
    if(length(links)==0)
        return(list(link_abstract="", link_pdf="", link_doi=""))

    rel <- get_key_ll(links, "rel")
    title <- get_key_ll(links, "title")
    links <- get_key_ll(links, "href")

    # strip off trailing semi-colons
    links <- gsub("\\s*;\\s*$", "", links)

    # abstract: rel=alternate
    wh <- (rel=="alternate")
    if(any(wh)) abstract <- paste(links[wh], collapse=sep)
    else abstract <- ""

    # pdf: rel=related and title=pdf
    wh <- (rel=="related" & title=="pdf")
    if(any(wh)) pdf <- paste(links[wh], collapse=sep)
    else pdf <- ""

    # doi: rel=related and title=doi
    wh <- (rel=="related" & title=="doi")
    if(any(wh)) doi <- paste(links[wh], collapse=sep)
    else doi <- ""

    list(link_abstract=abstract, link_pdf=pdf, link_doi=doi)
}


# pull out categories and paste together
clean_categories <-
function(record, sep="|")
{
    categories <- pull_by_key(record, "category")
    terms <- get_key_ll(categories, "term")
    paste(terms, collapse=sep)
}
