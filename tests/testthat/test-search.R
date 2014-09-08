
context("basic searches")

test_that("empty results don't give an error", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # blank search
    expect_equal(omit_attr(arxiv_count("")), 0)
    expect_equal(omit_attr(arxiv_search("")), empty_result())

    # null search
    expect_equal(omit_attr(arxiv_count()), 0)
    expect_equal(omit_attr(arxiv_search()), empty_result())

    # surely this also returns nothing
    query <- paste0("cat:", paste(LETTERS, collapse=""))
    expect_equal(omit_attr(arxiv_count(query)), 0)
    expect_equal(omit_attr(arxiv_search(query)), empty_result())

})
