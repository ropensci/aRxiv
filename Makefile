all: doc data vignettes
.PHONY: doc data vignettes test

doc:
	R -e 'devtools::document()'

test:
	R -e 'devtools::test()'

vignettes: inst/doc/aRxiv.html

inst/doc/aRxiv.html: vignettes/aRxiv.Rmd
	cd $(<D); \
	R -e "rmarkdown::render('$(<F)', output_dir='../$(@D)')"

data: data/arxiv_cats.RData data/query_terms.RData

data/arxiv_cats.RData: inst/scripts/grab_arxiv_cats.R
	cd $(<D);R CMD BATCH $(<F)

data/query_terms.RData: inst/scripts/grab_query_terms.R
	cd $(<D);R CMD BATCH $(<F)
