
context("search range of dates")

test_that("search date ranges is quirky", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    expect_equal( omit_attr( arxiv_count("submittedDate:2013*") ), 0)
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101* TO 20131231*]") ),       92677)
    expect_equal( omit_attr( arxiv_count("submittedDate:[201301010000 TO 201312312359]") ), 92860)
    expect_equal( omit_attr( arxiv_count("submittedDate:[201301010000 TO 201312312400]") ), 92861)
    expect_equal( omit_attr( arxiv_count("submittedDate:[201301010000 TO 201312319999]") ), 92861)
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101* TO 20131231*]") ),       92677)
    expect_equal( omit_attr( arxiv_count("submittedDate:[201301010000 TO 20131231*]") ),    92677)
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101* TO 201312319999]") ),    92861)
    expect_equal( omit_attr( arxiv_count("submittedDate:[20130101 TO 201312319999]") ),     92861)

})
