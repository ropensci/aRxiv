context("arxiv_search in batches")

test_that("batch search gives same result as all together", {
    skip_on_cran()

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # all together
    z <- arxiv_search("au:Speed AND cat:stat.AP", start=0, limit=3)
    z_time <- attr(z, "search_info")["time"]

    # in batches of 1
    suppressMessages(zBatch <- arxiv_search("au:Speed AND cat:stat.AP", start=0, limit=3, batchsize=1))

    # fix time
    at <- attr(zBatch, "search_info")
    at["time"] <- z_time
    attr(zBatch, "search_info") <- at

    expect_equal(z, zBatch)

    # in batches of 2
    suppressMessages(zBatch <- arxiv_search("au:Speed AND cat:stat.AP", start=0, limit=3, batchsize=2))

    # fix time
    at <- attr(zBatch, "search_info")
    at["time"] <- z_time
    attr(zBatch, "search_info") <- at

    expect_equal(z, zBatch)

})
