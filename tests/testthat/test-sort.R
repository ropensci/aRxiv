context("sort_by and sort_order args work")

test_that("sort by publishedDate", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- "ti:deconvolution"

    z <- arxiv_search(query=query, sort_by="submitted", limit=2)
    expected <- c("1994-09-29 22:34:46", "1997-04-07 14:24:24")
    expect_equal(z$submitted, expected)

    total <- attr(z, "total_results")
    zr <- arxiv_search(query=query, sort_by="submitted",
                       ascending=FALSE, limit=2, start=total-12)
    expected <- c("2002-08-12 23:38:39", "2001-12-04 13:20:28")
    expect_equal(zr$submitted, expected)

})


test_that("sort by lastUpdatedDate", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- 'ti:"EM algorithm"'

    z <- arxiv_search(query=query, sort_by="updated",
                      start=12, limit=2)
    expected <- c("2011-07-13 01:34:59", "2011-10-02 19:07:38")
    expect_equal(z$updated, expected)

    total <- attr(z, "total_results")
    zr <- arxiv_search(query=query, sort_by="updated",
                       ascending=FALSE, start=total-11, limit=2)
    expected <- c("2011-04-11 12:07:03", "2011-03-18 12:56:04")
    expect_equal(zr$updated, expected)

})
