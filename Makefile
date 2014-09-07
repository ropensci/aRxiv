all: doc notes data

notes: inst/doc/arxiv_api.html inst/ToDo.html

inst/doc/arxiv_api.html: inst/doc/src/arxiv_api.md
	R -e 'library(markdown);markdownToHTML("$<", "$@")'

inst/ToDo.html: inst/ToDo.md
	R -e 'library(markdown);markdownToHTML("$<", "$@")'

doc:
	R -e 'library(devtools);document()'

data: data/arxiv_cats.RData

data/arxiv_cats.RData: inst/scripts/grab_api_manual_tables.R
# also data/query_prefixes.RData (built together)
	cd $(<D);R CMD BATCH $(<F)
