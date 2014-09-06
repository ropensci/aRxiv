
context("arxiv_search in batches")

test_that("batch search gives same result as all together", {

    # shorter delay to speed tests
    old_delay <- getOption("aRxiv_delay")
    on.exit(options(aRxiv_delay=old_delay))
    options(aRxiv_delay=0.5)

    # all together
    z <- arxiv_search("au:Broman AND cat:stat.AP", start=0, end=2)

    # in batches of 1
    zBatch <- arxiv_search("au:Broman AND cat:stat.AP", start=0, end=2, batchsize=1)
    expect_equal(z, zBatch)

    # in batches of 2
    zBatch <- arxiv_search("au:Broman AND cat:stat.AP", start=0, end=2, batchsize=2)
    expect_equal(z, zBatch)

})