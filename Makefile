inst/doc/arxiv_api.html: inst/doc/src/arxiv_api.md
	R -e 'library(markdown);markdownToHTML("$<", "$@")'
