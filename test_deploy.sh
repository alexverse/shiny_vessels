#!/bin/bash
VOLUME="/srv/shiny-server/vessels/"

if [ ! -d "$VOLUME" ]
then
  mkdir "$VOLUME"  
fi

#run offline jobs
if [ $# -eq 1 ]
then
  cd jobs
  Rscript -e "library(rmarkdown); rmarkdown::render('get_clean.Rmd')"
  ls | grep -vE '\.csv|\.html|\.png|\.txt' > .exclude.txt
  rsync -vaz --exclude-from=.exclude.txt --exclude=".*" "$PWD"/ $VOLUME/results --delete
  cd ..
fi

#run tests
cd shiny
Rscript -e 'library(testthat, warn.conflicts = F); source("global.R"); test_res <- list.files(path = "tests/testthat/", recursive = TRUE, full.names = TRUE) %>% lapply(source)'
cd ..

#deploy to shiny server
rsync -vaz --exclude=".*" shiny/ $VOLUME/app --delete
