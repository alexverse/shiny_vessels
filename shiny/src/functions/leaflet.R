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


distance_tooltip <- function(flag_id, ship_name, ship_type, port, destination, distance, delta_tau){
  flag_key <- tolower(flag_id)
  distance <- round(distance, 3) #karney distance has accuracy less than 1mm!
  glue::glue('
    <i  size="large" class="{flag_key} flag"></i> <b> - {ship_name}</b>
    <ul>
    <li>Shiptype: <b>{ship_type}</b></li>
    <li>Port: <b>{port}</b></li>
    <li>Destination: <b>{destination}</b></li>
    <li>Distance: <b>{distance}m</b></li>
    <li>&#8796 t: <b>{delta_tau}sec</b></li>
    </ul>
  ') %>% as.character
}


#' Interactive map 
#'
#' @param render_data data to be rendered 
#' @param all_vessels boolean indicating if a vessel filter is in use 
#' @param ocean_icons `leaflet_icons` for vessel type 
#'
#' @return leaflet map
#'
#' @examples
#' vessels_map(vessels_data, FALSE, ocean_icons)
vessels_map <- function(render_data, all_vessels, ocean_icons){

  tiles <- providers$Esri.WorldStreetMap
  
  startIcon <- makeIcon(
    iconUrl = "images/start.png",
    iconWidth = 38, 
    iconHeight = 38
  )
  
  leaf <- 
    render_data[complete.cases(render_data[, .(LON, LAT)])] %>%
    leaflet %>%
    addProviderTiles(tiles) %>%
    addMiniMap(
      tiles = tiles, 
      toggleDisplay = TRUE,
      position = "bottomright"
    ) %>%
    htmlwidgets::onRender("
          function(el, x) {
            var myMap = this;
            myMap.on('baselayerchange',
              function (e) {
            myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
            })
          }
        ")
  
  if(all_vessels){
    
    leaf %<>%
      addMarkers(
        ~ LON,
        ~ LAT,
        popup = ~ leaflet_tooltip(FLAG, SHIPNAME, ship_type, port, DESTINATION), 
        icon = ~ ocean_icons[ship_type],
        clusterOptions = markerClusterOptions() 
      )
    
  }else{
    
    leaf %<>%
      addMarkers(
        ~ fromLON, 
        ~ fromLAT, 
        icon = startIcon
      ) %>%
      addMarkers(
        ~ LON, 
        ~ LAT, 
        popup = ~ distance_tooltip(FLAG, SHIPNAME, ship_type, port, DESTINATION, DIST, delta_tau), 
        icon = ~ ocean_icons[ship_type]
      )
    
    to_data <- render_data[, .(SHIP_ID, LON, LAT)]
    from_data <- render_data[, .(SHIP_ID, fromLON, fromLAT)]
    setnames(from_data, names(to_data))
    poly_data <- rbind(from_data, to_data)
    
    for(i in unique(poly_data$SHIP_ID)){
      leaf %<>% addPolylines(
        data = poly_data[SHIP_ID == i,], 
        lat = ~LAT, 
        lng = ~LON, 
        group = ~SHIP_ID
      )
    }

  }
  
  leaf
  
}
