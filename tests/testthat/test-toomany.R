
context("is_too_many")

test_that("is_too_many gives reasonable info", {

    # this search should give a very large number
    expect_true(is_too_many("au:A", start=0, end=NULL) > 170000)

    # this search should give 0 (not too many results)
    expect_equal(is_too_many("au:A", start=0, end=10), 0)

})

test_that("arxiv_search throws error with huge result", {

    # should give error, to prevent huge result
    expect_error(arxiv_search("au:A", end=NULL))

})
