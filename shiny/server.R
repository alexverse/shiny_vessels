server <- function(input, output, session) {
  filt_data <- filterServer("v_data", vars_dt)
  output$data <- renderTable(head(filt_data()))
}
