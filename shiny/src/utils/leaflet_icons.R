#' Leaflet Icons
#'
#' Creates a list of icons indicating the ship type to be dynamically called 
#' by leaflet for each vessel displayed. For each icon the height is computed 
#' from the icons' aspect ratio and the given `iconWidth`.
#' 
#' @param path path to icons for server
#' @param www path to icons to be rendered
#' @param iconWidth width of the icon image in pixels
#'
#' @return an object of type leaflet_icon_set
#'
#' @examples
#' leaflet_icons("www/icons")
leaflet_icons <- function(path, www = "images/vessels/icons/", iconWidth = 70){

  ship_icons <- list.files(path)  

  icon_ratio <- lapply(ship_icons, function(x){
    bit_image <- png::readPNG(paste0(path, x))
    height <- dim(bit_image)[1]
    width <- dim(bit_image)[2]
    width/height
  })
  names(icon_ratio) <- ship_icons
  
  ocean_icons <- lapply(ship_icons, function(x){
    iconList(
      makeIcon(
        paste0(www, x), 
        iconWidth = iconWidth,
        iconHeight = iconWidth/icon_ratio[[x]]
      )
    )
  })
  ocean_icons %<>% unlist(recursive = FALSE)
  names(ocean_icons) <- gsub("\\.png", "", ship_icons)
  attr(ocean_icons, "class") <-  "leaflet_icon_set"

  ocean_icons  

}

leaflet_tooltip <- function(flag_id, ship_name, ship_type, port, destination){
  flag_key <- tolower(flag_id)
  glue::glue('
    <i  size="large" class="{flag_key} flag"></i> <b> - {ship_name}</b>
    <ul>
    <li>Shiptype: <b>{ship_type}</b></li>
    <li>Port: <b>{port}</b></li>
    <li>Destination: <b>{destination}</b></li>
    </ul>
  ') %>% as.character
}
