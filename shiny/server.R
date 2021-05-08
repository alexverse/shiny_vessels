server <- function(input, output, session) {
  
  c(filter_data, vessel_name) %<-% filterServer("v_data", vars_dt)
  
  output$data <- renderTable(head(filter_data()))
  
  output$map <- renderLeaflet({
    req(nrow(filter_data()) > 0)
    vessels_map(
      filter_data(), 
      all_vessels = is.null(vessel_name())
    )
  })

}
