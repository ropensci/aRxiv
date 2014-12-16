library(testthat)
library(aRxiv)
if(can_arxiv_connect()) {
    # run only if can connect to aRxiv
    test_check("aRxiv")
} else {
    # if can't connect and not CRAN, throw an error
    if (identical(Sys.getenv("NOT_CRAN"), "true"))
        error("Can't connect to aRxiv")
}
