filterInput <- function(id, vars_dt) {
  segment(
    class = "basic blue",
    lapply(seq(nrow(vars_dt)), function(i){
      selectInput(
        NS(id, vars_dt[i, NID]),
        vars_dt[i, LABEL],
        init_choices[[vars_dt[i, NID]]], 
        selectize = TRUE, 
        multiple = TRUE, 
        default_text = "ALL"
      )        
    }),
    action_button(
      class = "basic blue tiny",
      input_id = NS(id, "reset_all"),
      label = "Reset Filters",
      icon = icon("remove")
    )
  )
}

filterServer <- function(id, vars_dt, vessels_poll) {
  
  stopifnot(!is.reactive(vars_dt))
  stopifnot(is.reactive(vessels_poll))
  
  moduleServer(id, function(input, output, session) {
   
    react_data <- reactive({
      filter_data(input, vars_dt, vessels_poll())
    })
    
    observeEvent(input$reset_all, {
      lapply(seq(nrow(vars_dt)), function(i)
        vessels_poll()[, c(vars_dt[i, NAME], vars_dt[i, ID]), with = FALSE] %>%
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
    
    input_args <- lapply(vars_dt[, NID], function(x) reactive(input[[x]]))
    names(input_args) <- vars_dt[, NID]
    
    append(
      list(filter_data = reactive(react_data())),
      input_args  
    )

  })
  
}
