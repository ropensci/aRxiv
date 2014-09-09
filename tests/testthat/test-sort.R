
context("sort_by and sort_order args work")

test_that("sort by publishedDate", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- "ti:deconvolution AND submittedDate:[199001010000 TO 201409062400]"

    z <- arxiv_search(query=query, sort_by="submittedDate", limit=2)
    expected <- c("1994-09-29T22:34:46Z", "1997-04-07T14:24:24Z")
    expect_equal(z$submitted, expected)

    zr <- arxiv_search(query=query, sort_by="submittedDate",
                       ascending=FALSE, limit=2)
    expected <- c("2014-08-16T00:18:50Z", "2014-08-13T09:27:05Z")
    expect_equal(zr$submitted, expected)

})


test_that("sort by lastUpdatedDate", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- "ti:deconvolution AND submittedDate:[199001010000 TO 201409062400]"

    z <- arxiv_search(query=query, sort_by="lastUpdatedDate",
                      start=12, limit=2)
    expected <- c("2002-09-01T21:56:01Z", "2003-01-31T20:34:03Z")
    expect_equal(z$updated, expected)

    zr <- arxiv_search(query=query, sort_by="lastUpdatedDate",
                       ascending=FALSE, start=4, limit=2)
    expected <- c("2014-07-16T21:37:43Z", "2014-07-13T17:35:22Z")
    expect_equal(zr$updated, expected)

})
