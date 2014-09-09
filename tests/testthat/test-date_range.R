
context("search range of dates")

test_that("search date ranges is quirky", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)


    # single date doesn't work
    expect_equal( omit_attr( arxiv_count("submittedDate:2013*") ), 0)

    # * is the same as truncating; completed to earliest time with that stem
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101* TO 20131231*]") ), 92677)
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101 TO 20131231]") ),   92677)

    # to search a single year, use that year to the next one
    expect_equal( omit_attr( arxiv_count("submittedDate:[2013 TO 2014]") ),           92861)

})
