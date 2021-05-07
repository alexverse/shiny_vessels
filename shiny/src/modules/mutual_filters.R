filterInput <- function(id, vars_dt) {
  tagList(
    lapply(seq(nrow(vars_dt)), function(i){
      selectInput(
        NS(id, vars_dt[i, NID]),
        vars_dt[i, LABEL],
        init_choices[[vars_dt[i, NID]]], 
        selectize = TRUE, 
        multiple = TRUE, 
        width = "300px",
        default_text = "ALL"
      )        
    }),
    actionLink(
      inputId = NS(id, "reset_all"),
      label = "Reset Filters",
      icon = icon("remove")
    )
  )
}

filterServer <- function(id, vars_dt) {
  
  stopifnot(is.data.table(vars_dt))
  stopifnot(!is.reactive(vars_dt))
    
  moduleServer(id, function(input, output, session) {
   
    vessels <- reactivePoll(
      1000, 
      session, 
      valid_time, 
      vessels_dt
    )
    
    react_data <- reactive({
      filter_data(input, vars_dt, vessels())
    })
    
    observeEvent(input$reset_all, {
      lapply(seq(nrow(vars_dt)), function(i)
        vessels()[, c(vars_dt[i, NAME], vars_dt[i, ID]), with = FALSE] %>%
          trans_vector %>%
          updateSelectInput(
            session, 
            inputId = vars_dt[i, NID], 
            label = vars_dt[i, LABEL], 
            choices = .
          )
      )
    })
    
    lapply(vars_dt$NID, function(x){
      observeEvent(input[[x]], {
        lapply(seq(nrow(vars_dt)), function(i){
          if(is.null(input[[vars_dt[i, NID]]]))
            react_data()[, c(vars_dt[i, NAME], vars_dt[i, ID]), with = FALSE] %>%
            trans_vector %>%
            updateSelectInput(
              session, 
              inputId = vars_dt[i, NID], 
              label = vars_dt[i, LABEL], 
              choices = .
            )
        })
      }, ignoreInit = TRUE, ignoreNULL = FALSE)
    })
    
    reactive(react_data())
    
  })
}
