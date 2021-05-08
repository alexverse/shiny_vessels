#libraries
################################################################################
library(data.table)
library(magrittr)
library(shiny)
library(shiny.semantic)
library(plotly)
library(leaflet)
library(zeallot)

#source
################################################################################
allScripts <- list.files(path = "src", recursive = TRUE, full.names = TRUE)
lapply(allScripts, source)

#functions
################################################################################
get_vessels_dt <- function() 
  fread(paste0(domain, "results/vessels.csv"), stringsAsFactors = TRUE)

valid_time <- function() 
  readLines(paste0(domain, "results/timestamp.txt"))

#definitions
################################################################################
domain <- "https://aledat.eu/shiny/vessels/"

render_cols <- 
  c("SHIPNAME", "LENGTH", "WIDTH", "FLAG", "ship_type", "DESTINATION", "port")

#initial choices
###############################################################################
init_dat <- get_vessels_dt()
init_choices <- list()

init_choices[["vessel_type"]] <- init_dat[, .(ship_type, SHIPTYPE)] %>%
  trans_vector
init_choices[["vessel_name"]] <- init_dat[, .(SHIPNAME, SHIP_ID)] %>%
  trans_vector

#pre-compute
###############################################################################
ocean_icons <- leaflet_icons("www/images/vessels/icons/")
