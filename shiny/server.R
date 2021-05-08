server <- function(input, output, session) {
  
  filter_data <- filterServer("v_data", vars_dt)
  
  output$data <- renderTable(head(filter_data()))
  
  output$map <- renderLeaflet({

    render_data <- filter_data()
    req(nrow(render_data) > 0)
    
    tiles <- providers$Esri.WorldStreetMap
    
    leaf <- render_data %>%
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
    
    if(nrow(render_data) > 100){
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
          popup = ~ leaflet_tooltip(FLAG, SHIPNAME, ship_type, port, DESTINATION), 
          icon = ~ ocean_icons[ship_type]
        ) %>%
        addCircleMarkers(
          ~ LON, 
          ~ LAT, 
          popup = ~ leaflet_tooltip(FLAG, SHIPNAME, ship_type, port, DESTINATION)
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
        
        leaf
        
    }
        
    
    })

}
