#' Get nearest vessels
#'
#' Calculate nearest vessels (excluding self similar) from the center of selected vessels.
#' The calculation is restricted to vessels of the same type. 
#'  
#' @param x selected vessels
#' @param y target vessels
#' @param top_ vessels to display
#'
#' @return data.table with nearest vessels
#'
#' @examples
#' dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
#' nearest_vessels(dat[1:3], dat, 6)

nearest_vessels <- function(x, y, top_){
  
  center_map <- x[, .(LON = mean(LON), LAT = mean(LAT))]
  rel_vessels <- y
  
  center_map <- center_map[complete.cases(center_map)]
  rel_vessels <- rel_vessels[complete.cases(rel_vessels[, .(LON, LAT)])]
  
  rel_vessels[, 
              rel_dist := geodist(
                center_map, 
                rel_vessels[, .(LON, LAT)], 
                measure = "geodesic"
              ) %>% t
  ]
  
  #exclude self similar
  res <- rel_vessels[!SHIP_ID %in% x$SHIP_ID]
  
  res[order(rel_dist), head(.SD, top_)]
  
}
