all: doc data vignettes
.PHONY: doc data vignettes

doc:
	R -e 'devtools::document()'

vignettes: inst/doc/aRxiv.html

inst/doc/aRxiv.html: vignettes/aRxiv.Rmd
	cd $(<D); \
	R -e "rmarkdown::render('$(<F)', output_dir='../$(@D)')"

data: data/arxiv_cats.RData

data/arxiv_cats.RData: inst/scripts/grab_api_manual_tables.R
# also data/query_terms.RData (built together)
	cd $(<D);R CMD BATCH $(<F)
