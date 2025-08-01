aRxiv 0.12
----------

### BUG FIXES

* The package had totally stopped working. Got it working again by
  using `GET` rather than `POST`, and `query` rather than `body`.

* Fixed a typo in `arxiv_count()` that had been introduced way back in
  December, 2014.


aRxiv 0.10
----------

### BUG FIXES

* Small revision to aRxiv vignette to deal with the change in the
  structure of the `arxiv_cats` dataset.


aRxiv 0.8
---------

### MINOR CHANGES

* Update arxiv_cats, datasets with category information, and the scripts to
  build that and the dataset query_terms.


aRxiv 0.6
---------

### MINOR CHANGES

* For testing, switch to use of github actions rather than appveyor
  and travis.

### BUG FIXES

* Partial fix of a case with a corrupt record. Was getting an error if
  you search multiple batches and later ones were NULL.


aRxiv 0.5.20
------------

### MINOR CHANGES

* Small fixes regarding use of class(), in particular changing
  class(x)=="blah" to inherits(x, "blah").


aRxiv 0.5.19
------------

### MINOR CHANGES

* Add ORCIDs

* Update vignette


aRxiv 0.5.18
------------

### MINOR CHANGES

* Convert documentation to markdown


aRxiv 0.5.17
------------

### MINOR CHANGES

* Two small fixes to the vignette.


aRxiv 0.5.16
------------

### BUG FIXES

* To eliminate continued pain over empty search queries, just trap
  them in advance and don't send them to arXiv.


aRxiv 0.5.15
------------

### BUG FIXES

* Results for empty search queries seems to have changed; fixed to
  give appropriate return values.


aRxiv 0.5.10
------------

### BUG FIXES

* Fix a small problem related to a new behavior in a pre-release
  version of the httr package. (httr is no longer dropping NULLs from
  the POST search body.)

* Fix a test error, that arose due to a change in the order of records
  returned by a query.


aRxiv 0.5.8
------------

### BUG FIXES

* arXiv connection errors was causing test errors. Added a function to
  test connection to arXiv; tests are skipped if we can't connect.

* try to avoid many of the tests on CRAN, where intermittent test
  errors will cause universal headaches.


aRxiv 0.5.5
------------

### BUG FIXES

* Fix mistakes in the table in the help for arxiv_search that
  describes the output.

* When searching in batches, arxiv_search could return more than the
  requested limit.

* Fix tests of date range; a new 2013 arXiv manuscript changed the
  expected count.


aRxiv 0.5.2
------------

### NEW FEATURES

* released to CRAN
