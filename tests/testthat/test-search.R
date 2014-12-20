context("basic searches")

test_that("empty results don't give an error", {
    skip_on_cran()

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


test_that("weird results for IDs not found", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # if id_list is syntactically correct but no manuscript, get weird results
    empty <- empty_result()
    blank <- rbind(empty,
                   as.data.frame(matrix(rep("", ncol(empty)), nrow=1),
                                 stringsAsFactors=FALSE))
    dimnames(blank) <- list(1, colnames(empty))

    z <- omit_attr(arxiv_search(id_list="0041.0148"))
    expect_equal(z, blank)

    # if you add a version number, the result includes the id and the
    #     links to the abstract and PDF
    id <- "0041.0148v1"
    z <- omit_attr(arxiv_search(id_list=id))
    expected <- blank
    expected$id <- id
    expected$link_abstract <- paste0("http://arxiv.org/abs/", id)
    expected$link_pdf <- paste0("http://arxiv.org/pdf/", id)
    expect_equal(z, expected)

})


test_that("total_result attribute is correct", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    query <- "ti:deconvolution"
    cnt <- arxiv_count(query)
    z <- arxiv_search(query, limit=2)
    expect_equal( omit_attr(cnt), attr(z, "total_result") )


})
