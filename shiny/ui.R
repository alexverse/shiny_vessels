ui <- semanticPage(
  leafletOutput("map"),
  filterInput("v_data", vars_dt),
  tableOutput("data")
)
