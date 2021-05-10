#libraries
library(data.table)
library(magrittr, warn.conflicts = FALSE)
library(shiny)
library(shiny.semantic, warn.conflicts = FALSE)
library(plotly, warn.conflicts = FALSE)
library(leaflet)
library(zeallot)
library(geodist)
library(waiter)

domain <- readLines("conf/domain.conf")

#src
list.files(path = "R", recursive = TRUE, full.names = TRUE) %>% lapply(source)

#for polling
get_vessels_dt <- function() 
  fread(paste0(domain, "results/vessels.csv"), stringsAsFactors = TRUE)

get_ts_dt <- function() 
  fread(paste0(domain, "results/ts_data.csv"), stringsAsFactors = TRUE)


valid_time <- function() 
  readLines(paste0(domain, "results/timestamp.txt"))

#rows and cols to render in table
render_cols <- 
  c("SHIPNAME", "ship_type", "DESTINATION", "port", "DIST")

render_cols_names <- 
  c("Vessel", "Type", "Destination", "Port", "Max Dist (m)")

n_rows <- 6 

#initial choices
init_dat <- get_vessels_dt()
init_choices <- list()

init_choices[["vessel_type"]] <- init_dat[, .(ship_type, SHIPTYPE)] %>%
  trans_vector
init_choices[["vessel_name"]] <- init_dat[, .(SHIPNAME, SHIP_ID)] %>%
  trans_vector

#visuals
ocean_icons <- leaflet_icons("www/images/vessels/icons/")

sv_colors <- c(
  "#ba6161",
  "#a19e5d",
  "#7dbaa7",
  "#4d7291",
  "#c3d7e8",
  "#028ee6",
  "#424242",
  "#e57368",
  "#787878"
)

fonts <- "Lato"
