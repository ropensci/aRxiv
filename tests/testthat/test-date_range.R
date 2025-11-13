context("search range of dates")

test_that("search date ranges is quirky", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)


    # is the same as truncating; completed to earliest time with that stem
    expect_equal( omit_attr( arxiv_count("submittedDate:[19920101 TO 19921231]") ),   3191)
    expect_equal( omit_attr( arxiv_count("submittedDate:[199201010000 TO 199212312359]") ),   3191)

    # to search a single year, use that year to that same year
    expect_equal( omit_attr( arxiv_count("submittedDate:[1992 TO 1992]") ),           3191)

})
