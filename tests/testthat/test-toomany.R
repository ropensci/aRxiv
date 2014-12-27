context("is_too_many")

test_that("is_too_many gives reasonable info", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # this search should give a very large number
    suppressMessages(expect_true(is_too_many("au:A", start=0, limit=NULL) > 170000))

    # this search should give 0 (not too many results)
    expect_equal(is_too_many("au:A", start=0, limit=10), 0)

})

test_that("arxiv_search throws error with huge result", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # should give error, to prevent huge result
    suppressMessages(expect_error(arxiv_search("au:A", limit=NULL)))
})
