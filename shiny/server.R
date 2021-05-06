server <- function(input, output, session) {
  
  vessels <- reactivePoll(
    1000, 
    session, 
    valid_time, 
    vessels_dt
  )
  
  react_data <- reactive({
    res <- list(
      SHIP_ID = input$vessel_name,
      SHIPTYPE = input$vessel_type
    ) %>%
      filter_data(vessels())
    res
  })
  
  filtr_vars <- c("vessel_type", "vessel_name")
  
  lapply(c("vessel_type", "vessel_name"), function(x){
    
    observeEvent(input[[x]], {
  
      if(is.null(input$vessel_name)){
        react_data()[, .(SHIPNAME, SHIP_ID)] %>%
          trans_vector %>%
          updateSelectInput(session, "vessel_name", "Vessel Name:", choices = .)
      }
      
      if(is.null(input$vessel_type)){
        react_data()[, .(ship_type, SHIPTYPE)] %>%
          trans_vector %>%
          updateSelectInput(session, "vessel_type", "Vessel Type:", choices = .)
      }
      
    }, ignoreInit = TRUE, ignoreNULL = FALSE)
    
  })
  
  output$data <- renderTable({
    react_data()[, ..render_cols] %>%
      head(100)
  })
  
}
