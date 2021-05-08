#libraries
################################################################################
library(data.table)
library(magrittr)
library(shiny)
library(shiny.semantic)
library(plotly)
library(leaflet)

#source
################################################################################
allScripts <- list.files(path = "src", recursive = TRUE, full.names = TRUE)
lapply(allScripts, source)

#functions
################################################################################
vessels_dt <- function() 
  fread(paste0(domain, "results/vessels.csv"), stringsAsFactors = TRUE)

valid_time <- function() 
  readLines(paste0(domain, "results/timestamp.txt"))

`%inT%` <- function(x, table) {
  if (!is.null(table) && ! "" %in% table)
    x %in% table
  else
    rep_len(TRUE, length(x))
}

filter_data <- function(args, vars_dt, data) {
  res <- lapply(seq(nrow(vars_dt)), function(i) 
    data[[vars_dt[i, ID]]] %inT% args[[vars_dt[i, NID]]])
  data[Reduce(f = `&`, x = res)]
}

trans_vector <- function(dat){
  dat %>%
  unique %>%
  transpose(make.names = TRUE) %>%
  unlist
}

#definitions
################################################################################
domain <- "https://aledat.eu/shiny/vessels/"

render_cols <- 
  c("SHIPNAME", "LENGTH", "WIDTH", "FLAG", "ship_type", "DESTINATION", "port")

vars_dt <- data.table(
  ID = c("SHIPTYPE", "SHIP_ID"),
  NAME = c("ship_type", "SHIPNAME"),
  NID = c("vessel_type", "vessel_name"),
  LABEL = c("Vessel Type:", "Vessel Name:")
)

#initial choices
###############################################################################
init_dat <- vessels_dt()
init_choices <- list()

init_choices[["vessel_type"]] <- init_dat[, .(ship_type, SHIPTYPE)] %>%
  trans_vector
init_choices[["vessel_name"]] <- init_dat[, .(SHIPNAME, SHIP_ID)] %>%
  trans_vector

#pre-compute
###############################################################################
ocean_icons <- leaflet_icons("www/images/vessels/icons/")
