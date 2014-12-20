context("arxiv_errors")

test_that("arxiv_error_message gives right info", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # do raw searches and send results to arxiv_error_message
    library(httr)
    query_url <- "http://export.arxiv.org/api/query"

    delay_if_necessary()
    good <- POST(query_url, body=list(id_list="1403.3048,1402.2633,1309.1192"))
    good <- result2list(good)
    expect_null(arxiv_error_message(good))

    delay_if_necessary()
    bad <- POST(query_url, body=list(id_list="1403.3048,1402.2633,1309.119"))
    bad <- result2list(bad)
    expect_equal(arxiv_error_message(bad), "incorrect id format for 1309.119")

})

test_that("arxiv_search throws error", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    expect_error(arxiv_search(id_list="1403.3048,1402.2633,1309.119"))

})
