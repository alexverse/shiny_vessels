
grid_top <- grid_template(
  default = list(
    areas = rbind(c("filters", "cards")),
    rows_height = c("100%"),
    cols_width = c("20%", "80%")
  )
)

ui <- semanticPage(
  title = "Shiny Vessels",
  div(
    class = "logo",
    img(src = "images/logo.png", alt = "App logo",  width = "25%", height = "auto"), #responsive
  ),
  main_panel(
    grid(
      grid_top,
      filters = filterInput("v_data", vars_dt), 
      cards = type_cards(init_dat)
    ),
    segment(
      class = "basic",
      leafletOutput("map")
    ),
    tableOutput("data")
  )
)
