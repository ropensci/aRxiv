
context("cleaning the records")

# shorter delay to speed tests
old_delay <- getOption("aRxiv_delay")
options(aRxiv_delay=0.5)

# count papers on 1997-01-01
query <- "lastUpdatedDate:[199701010000 TO 199701012359]"
expect_equal(arxiv_count(query), 20)

# do raw search to test parsing
library(httr)
query_url <- "http://export.arxiv.org/api/query"
delay_if_necessary()
z <- POST(query_url, body=list(search_query=query,
                               start=0, max_results=20,
                               sort_by="submittedDate"))
z <- get_entries(result2list(z))

test_that("clean_authors works right", {

    cleaned_auth <- clean_authors(z[[1]])
    expected_result <- list(names="J. Michael Owen|Jens V. Villumsen",
                            affiliations="Dept. of Astronomy, Ohio State Univ.|Max Planck Institut fur Astrophysik, Garching")
    expect_equal(cleaned_auth, expected_result)

    cleaned_auth <- clean_authors(z[[2]])
    expected_result <- list(names="Yu Shi", affiliations="")
    expect_equal(cleaned_auth, expected_result)

    cleaned_auth <- clean_authors(z[[20]])
    expected_result <- list(names="Charles H. Bennett|Ethan Bernstein|Gilles Brassard|Umesh Vazirani",
                            affiliations="|||")
    expect_equal(cleaned_auth, expected_result)

})

test_that("clean_links works right", {

    cleaned_links <- clean_links(z[[1]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/astro-ph/9603156v3",
                            link_pdf="http://arxiv.org/pdf/astro-ph/9603156v3",
                            link_doi="http://dx.doi.org/10.1086/304018")
    expect_equal(cleaned_links, expected_result)


    cleaned_links <- clean_links(z[[2]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/astro-ph/9612225v2",
                            link_pdf="http://arxiv.org/pdf/astro-ph/9612225v2",
                            link_doi="")
    expect_equal(cleaned_links, expected_result)

    # manuscript with multiple DOI links
    delay_if_necessary()
    zz <- POST(query_url, body=list(id_list="1206.1585v3",
                                    start=0, max_results=1))
    zz <- get_entries(result2list(zz))

    cleaned_links <- clean_links(zz[[1]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/1206.1585v3",
                            link_pdf="http://arxiv.org/pdf/1206.1585v3",
                            link_doi="http://dx.doi.org/10.1112/jlms/jdt036|http://dx.doi.org/10.1112/jlms/jdu001")
    expect_equal(cleaned_links, expected_result)

})


test_that("clean_categories works right", {

    cleaned_categories <- clean_categories(z[[1]])
    expected_result <- "astro-ph"
    expect_equal(cleaned_categories, expected_result)

    cleaned_categories <- clean_categories(z[[2]])
    expected_result <- "astro-ph|cond-mat"
    expect_equal(cleaned_categories, expected_result)

    # manuscript with 6 categories
    delay_if_necessary()
    zz <- POST(query_url, body=list(id_list="1303.5613v1",
                                    start=0, max_results=1))
    zz <- get_entries(result2list(zz))

    cleaned_categories <- clean_categories(zz[[1]])
    expected_result <- "cs.SI|cs.LG|math.ST|physics.soc-ph|stat.ML|stat.TH"
    expect_equal(cleaned_categories, expected_result)

})

# reset delay
options(aRxiv_delay=old_delay)
