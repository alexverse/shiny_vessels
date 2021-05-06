library(data.table)
library(magrittr)
library(shiny)
library(shiny.semantic)
library(plotly)
library(leaflet)

domain <- "https://aledat.eu/shiny/vessels/"
render_cols <- c("SHIPNAME", "LENGTH", "WIDTH", "FLAG", "ship_type", "DESTINATION", "port")

vessels_dt <- function() fread(paste0(domain, "results/vessels.csv"), stringsAsFactors = TRUE)

valid_time <- function() readLines(paste0(domain, "results/timestamp.txt"))

`%inT%` <- function(x, table) {
  if (!is.null(table) && ! "" %in% table)
    x %in% table
  else
    rep_len(TRUE, length(x))
}

filter_data <- function(args, data) {
  res <- lapply(names(args), function(x) data[[x]] %inT% args[[x]])
  data[Reduce(f = `&`, x = res)]
}

trans_vector <- function(dat){
  dat %>%
  unique %>%
  transpose(make.names = TRUE) %>%
  unlist
}

init_dat <- vessels_dt()

init_type_choices <- init_dat[, .(ship_type, SHIPTYPE)] %>% 
  trans_vector

init_vessels <- init_dat[, .(SHIPNAME, SHIP_ID)] %>% 
  trans_vector
