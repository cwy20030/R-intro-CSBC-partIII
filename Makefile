all:
	make README.md
	make 02-starting-with-data.md
	make 03-tidy-data.md
	make 04-dplyr.md
	make 05-visualization-ggplot2.md
	make 02-starting-with-data.html
	make 03-tidy-data.html
	make 04-dplyr.html
	make 05-visualization-ggplot2.html

%.md: %.Rmd
	Rscript -e "knitr::knit('$^')"

%.html: %.md
	Rscript -e "rmarkdown::render('$^')"

