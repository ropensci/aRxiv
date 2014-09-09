
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


test_that("weird results for IDs not found", {

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

    z <- omit_attr(arxiv_search(id_list="0041.0148v1"))

})
