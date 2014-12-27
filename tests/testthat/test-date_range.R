context("search range of dates")

test_that("search date ranges is quirky", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)


    # single date doesn't work
    expect_equal( omit_attr( arxiv_count("submittedDate:2013*") ), 0)

    # * is the same as truncating; completed to earliest time with that stem
    expect_equal( omit_attr( arxiv_count("submittedDate:[19920101* TO 19921231*]") ), 3182)
    expect_equal( omit_attr( arxiv_count("submittedDate:[19920101 TO 19921231]") ),   3182)

    # to search a single year, use that year to the next one
    expect_equal( omit_attr( arxiv_count("submittedDate:[1992 TO 1993]") ),           3190)

})
