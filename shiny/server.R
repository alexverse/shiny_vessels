server <- function(input, output, session) {
  
  vessels_poll <- reactivePoll(
    1000, 
    session, 
    valid_time, 
    get_vessels_dt
  )
  
  c(filter_data, vessel_type, vessel_name) %<-% filterServer("v_data", vars_dt, vessels_poll)
  
  output$data <- renderTable({
    dat <- filter_data()
    if(!is.null(vessel_name()))
      dat <- nearest_vessels(dat, vessels_poll(), top = 6)
    dat[order(-SPEED), head(.SD, n_obs), .SDcols = render_cols]
  })
  
  output$map <- renderLeaflet({
    req(nrow(filter_data()) > 0)
    vessels_map(
      filter_data(), 
      all_vessels = is.null(vessel_name()),
      ocean_icons
    )
  })

}
