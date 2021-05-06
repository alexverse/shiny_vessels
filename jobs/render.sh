#!/bin/bash
FOLDER="/srv/shiny-server/vessels/"

if [ ! -d "$FOLDER" ]
then
  mkdir "$FOLDER"  
fi

Rscript -e "library(rmarkdown); rmarkdown::render('get_clean.Rmd')"
ls | grep -vE '\.csv|\.html|\.png' > exclude.txt 
rsync -vaz --exclude-from=exclude.txt --exclude=".*" "$PWD"/ $FOLDER --delete
