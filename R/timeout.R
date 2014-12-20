# functions to allow message rather than error on timeout
# (this is to allow more graceful treatment of connection problems when testing on CRAN)

message_on_timeout <-
    function()
{
    result <- as.logical(Sys.getenv("aRxiv_message_on_timeout"))
    if(is.na(result)) result <- FALSE
    result
}

set_message_on_timeout <-
    function(value)
{
    Sys.setenv(aRxiv_message_on_timeout=as.logical(value))
}

timeout_action <-
    function(e)
{
    if(message_on_timeout()) {
        message(e)
        cat("\n")
    }
    else stop(e)

    NULL
}
