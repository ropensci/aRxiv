
## The arXiv API

Here I'll write down my notes as I study the [arXiv](http://arxiv.org)
API, in preparation for developing the R package
[aRxiv](https://github.com/ropensci/aRxiv).

The key source of information is the
[arXiv API user manual](http://arxiv.org/help/api/user-manual).

### Basics

Queries are submitted via HTTP, either with HTTP GET (in which
parameters are passed in the url) or HTTP POST (in which parameters
are passed in the HTTP request header).

The url to use is like

    http://export.arxiv.org/api/{method_name}?{parameters}

An example using HTTP GET is

    http://export.arxiv.org/api/query?search_query=all:electron&start=0&max_results=10
    
Results are in [Atom 1.0](http://www.ietf.org/rfc/rfc4287.txt) format:
XML 1.0 with UTF-8 encoding.

Good result will have a `200 OK` status in HTTP header of response.

### Query

See the
[Details of query construction](http://arxiv.org/help/api/user-manual#query_details).

There are six possible parts to the query.

- `search_query`, a string with a query to search
- `id_list`, a comma-delimited string with a list of
   [arXiv identifiers](http://arxiv.org/help/arxiv_identifier)
- `start`, an integer with the index (starting at 0) of first search result
   to return
- `max_results`, an integer with the maximum number of search results
  to return
- `sortBy`, a string indicating how to sort the results, taking values
  `relevance`, `lastUpdatedDate`, or `submittedDate`
- `sortOrder`, a string that is either `ascending` `descending`

If only `search_query` is provided, all articles matching the query
will be returned. If only `id_list` is provided, all articles in that
list will be returned. If both are provided, all articles in the list
that match the query are returned.

Use `start` and `max_results` to grab results in batches, and **add a
3 sec delay between calls**.

Also, be careful that search doesn't return a huge number of results.
The total results will be shown in the output, `<opensearch:totalResults>`.

Here's a list of `search_query` prefixes (preceding search term and
separated by a colon).

term  | description
:-----|:-----------
`ti`  | Title
`au`  | Author
`abs` | Abstract
`co`  | Comment
`jr`  | Journal reference
`cat` | subject category
`rn`  | report number
`all` | all of above

It looks like there are others not on this list. For example
[this post](https://groups.google.com/forum/#!topic/arxiv-api/I95YLIPesSE)
suggests searching for a range of dates:

    lastUpdatedDate:[201112021159 TO 201112051159]    

You can also use the Boolean operators `AND`, `OR`, and `ANDNOT`.

For spaces, use `+`.

For phrases, surround in double-quotes, using `%22`.

For parentheses (for grouping in searches), use `%28` for left-parens
and `%29` for right-parents.

Regarding arXiv document identifiers: different versions can be
obtained by using the main identifier with `vn` appended, where `n` is
the integer version number.  For example, if the main ID is
`cond-mat/0207270`, version 2 will have ID `cond-mat/0207270v2`.
Also note that the format of the version numbers changed in April,
2007.


### Returned results

The returned results will have a single <feed> containing the
following at the top

  tag      | description
:----------|:-----------
`<title>`  | canonicalized version of the query
`<id>`     | unique id for the query
`<link>`   | URL to retrieve feed again
`<update>` | time feed was last updated

It will also contain a number of 
[OpenSearch Extension Elements](http://a9.com/-/spec/opensearch/1.1/)

- `<opensearch:totalResults>`, the total number of results for the search
- `<opensearch:startIndex>`, an integer like `start`
- `<opensearch:itemsPerPage>`, an integer like `max_results`


Following that stuff is a set of `<entry>` elements containing the
following.

  tag         | description
:-------------|:-----------
`<title>`     | title of article
`<id>`        | url to abstract page
`<published>` | date of first version
`<updated>`   | date of retrieved article
`<summary>`   | abstract
`<author>`    | one such for each author, in order of authorship
`<category>`  | describes arXiv, ACM, or MSC classification (can be multiple)
`<link>`      | up to 3, distinguished by `rel` and `title` attributes


Each `<author>` element will contain a `<name>` with the name of
author. There may also be `<arxiv:affiliation>` with the author's
affiliation.

The `<category>` element contains the attribute `term` with the
category term.

The `<link>` elements are links to the abstract, the PDF, and (if
present) the DOI.

link     | features
:--------|:--------
Abstract | `rel=alternate`
PDF      | `rel=related` and `title=pdf`
DOI      | `rel=doi` and `title=[the doi]`


There may also be the following tags

- `<arxiv:primary_category>`, with attribute `term` being the primary
  arxiv category
- `<arxiv:comment>` contains the authors' comment
- `<arxiv:journal_ref>` contains the journal reference, if supplied
- `<arxiv:doi>` contains the DOI for the article, if supplied


### Errors

For more information about Errors, see
[this section](http://arxiv.org/help/api/user-manual#errors) of the
arXiv API user manual.

With an error, the `<feed>` will have a single `<entry>` representing the
error, and `<id>` will contain a link like `http://arxiv.org/api/errors#...`.

The single `<entry>` will contain

   tag      | description
:-----------|:-----------
`<summary>` | error message
`<link>`    | url to detailed explanation
`<title>`   | just `Error`
`<author>`  | will contain `<name>` with `arXiv api core`

Example errors include
- `start` must be an integer
- `start` much be >= 0
- `max_results` must be an integer
- `max_results` must be >= 0
- malformed id

Need to detect an error and then print the short message plus a link
to the detail.



### Tables

The [arXiv API user manual](http://arxiv.org/help/api/user-manual) has
a bunch of useful tables, particularly the list of subject
classifications.

5.1 Details of query contruction
- `Table: search_query field prefixes`
- `Table: search_query Boolean operators`
- `Table: search_query grouping operators`

5.2 Details of Atom Results Returned
- `Table: Atom elements`
  - section `feed elements`
  - section `entry elements`


5.3 Subject Classifications
- `Table: Subject Classifications`




<!-- the following to make it look nicer -->
<link href="https://www.biostat.wisc.edu/~kbroman/markdown.css" rel="stylesheet"></link>
<link href="https://www.biostat.wisc.edu/~kbroman/markdown_modified.css" rel="stylesheet"></link>
