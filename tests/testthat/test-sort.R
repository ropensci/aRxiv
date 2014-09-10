
context("sort_by and sort_order args work")

test_that("sort by publishedDate", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- "ti:deconvolution"

    z <- arxiv_search(query=query, sort_by="submittedDate", limit=2)
    expected <- c("1994-09-29T22:34:46Z", "1997-04-07T14:24:24Z")
    expect_equal(z$submitted, expected)

    total <- attr(z, "total_results")
    zr <- arxiv_search(query=query, sort_by="submittedDate",
                       ascending=FALSE, limit=2, start=total-12)
    expected <- c("2002-08-12T23:38:39Z", "2001-12-04T13:20:28Z")
    expect_equal(zr$submitted, expected)

})


test_that("sort by lastUpdatedDate", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- 'ti:"EM algorithm"'

    z <- arxiv_search(query=query, sort_by="lastUpdatedDate",
                      start=12, limit=2)
    expected <- c("2011-07-13T01:34:59Z", "2011-10-02T19:07:38Z")
    expect_equal(z$updated, expected)

    total <- attr(z, "total_results")
    zr <- arxiv_search(query=query, sort_by="lastUpdatedDate",
                       ascending=FALSE, start=total-11, limit=2)
    expected <- c("2011-04-11T12:07:03Z", "2011-03-18T12:56:04Z")
    expect_equal(zr$updated, expected)

})
