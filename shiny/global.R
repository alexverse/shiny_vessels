#libraries
library(data.table)
library(magrittr)
library(shiny)
library(shiny.semantic)
library(plotly)
library(leaflet)
library(zeallot)
library(geodist)

domain <- readLines("conf/domain.conf")

#src
allScripts <- list.files(path = "src", pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
lapply(allScripts, source) %>% 
  invisible

#for polling
get_vessels_dt <- function() 
  fread(paste0(domain, "results/vessels.csv"), stringsAsFactors = TRUE)

valid_time <- function() 
  readLines(paste0(domain, "results/timestamp.txt"))

#rows and cols to render in table
render_cols <- 
  c("SHIPNAME", "ship_type", "DESTINATION", "port", "DIST", "DWT")
render_cols_names <- 
  c("Vessel", "Type", "Destination", "Port", "Max Dist (m)", "DWT (kgr)")


n_rows <- 6 

#initial choices
init_dat <- get_vessels_dt()
init_choices <- list()

init_choices[["vessel_type"]] <- init_dat[, .(ship_type, SHIPTYPE)] %>%
  trans_vector
init_choices[["vessel_name"]] <- init_dat[, .(SHIPNAME, SHIP_ID)] %>%
  trans_vector

#leaflet icons for vessel type
ocean_icons <- leaflet_icons("www/images/vessels/icons/")
