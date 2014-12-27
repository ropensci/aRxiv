# functions to allow message rather than error on timeout
# (this is to allow more graceful treatment of connection problems when testing on CRAN)

# whether to print message (rather than error) on timeout
message_on_timeout <-
    function()
{
    result <- as.logical(Sys.getenv("aRxiv_message_on_timeout"))
    if(is.na(result)) {
        result <- FALSE
        set_message_on_timeout(result)
    }
    result
}

# set whether to print message (rather than error) on timeout
set_message_on_timeout <-
    function(value)
{
    Sys.setenv(aRxiv_message_on_timeout=as.logical(value))
}

# action if arxiv times out
timeout_action <-
    function()
{
    if(!message_on_timeout()) stop()

    NULL
}

# get timeout amount
get_arxiv_timeout <-
    function()
{
    result <- as.numeric(Sys.getenv("aRxiv_timeout"))
    if(is.na(result)) {
        result <- 30 # default is 30 seconds
        set_arxiv_timeout(result)
    }
    result
}

# set timeout amount
set_arxiv_timeout <-
    function(value)
{
    if(value < 0.001) value <- 0.001 # don't let it be < 1 ms
    Sys.setenv(aRxiv_timeout = as.numeric(value))
}
