# make sure not to make calls too often

# get time of last call
get_arxiv_time <-
function()
{
   last <- as.numeric(Sys.getenv("aRxiv_time"))
   ifelse(is.na(last), 0, last)
}

# set arxiv time to current
set_arxiv_time <-
function() {
    Sys.setenv(aRxiv_time = as.numeric(Sys.time()))
}

# time since last call
time_since_arxiv <-
function() {
    as.numeric(Sys.time()) - get_arxiv_time()
}

# check for last time since call, and delay if necessary
# also re-set the arxiv_time
delay_if_necessary <-
function()
{
    # look for delay amount in options; otherwise set to default
    delay_amount <- getOption("aRxiv_delay")
    if(is.null(delay_amount)) delay_amount <- 3

    if((timesince = time_since_arxiv()) < delay_amount)
        Sys.sleep(delay_amount - timesince)

    set_arxiv_time()
}
