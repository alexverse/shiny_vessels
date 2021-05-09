server <- function(input, output, session) {
  
  vessels_poll <- reactivePoll(
    1000, 
    session, 
    valid_time, 
    get_vessels_dt
  )

  c(filter_data, vessel_type, vessel_name) %<-% filterServer("v_data", vars_dt, vessels_poll)
  
  observeEvent(vessel_name(),{
    req(vessel_name())
    get_toaster(filter_data(), vessel_name(), session)
  })
  
  observeEvent(filter_data(),{
    req(nrow(filter_data()) == 0)
    warn_toaster(session)
  })
  
  output$map <- renderLeaflet({
    
    on.exit(waiter_hide())

    req(nrow(filter_data()) > 0) 
    
    vessels_map(
      filter_data(), 
      all_vessels = is.null(vessel_name()),
      ocean_icons
    )
    
  })
  
  output$data <- renderTable({
    
    dat <- filter_data()
    
    if(!is.null(vessel_name()))
      dat <- nearest_vessels(dat, vessels_poll(), top = 6)
    
    dat <- dat[order(-DIST), head(.SD, n_rows), .SDcols = render_cols]
    setnames(dat, render_cols_names)
    
    dat
    
  }, caption = "<h3> - Nearest vessels by max distance sailed - </h3>", caption.placement = "top")
  
}
