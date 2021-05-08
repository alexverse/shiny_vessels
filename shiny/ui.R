ui <- semanticPage(
  tags$head(tags$style(src = "css/flags.css")),
  filterInput("v_data", vars_dt),
  leafletOutput("map"),
  tableOutput("data")
)
