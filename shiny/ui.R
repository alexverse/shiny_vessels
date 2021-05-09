
grid_top <- grid_template(
  default = list(
    areas = rbind(c("filters", "cards")),
    rows_height = c("100%"),
    cols_width = c("20%", "80%")
  )
)

ui <- semanticPage(
  title = "Shiny Vessels",
  titlePanel(
    div(
      img(src = "images/logo.png",  width = "20%", height = "auto"), #responsive
    )
  ),
  mainPanel( #main_panel from semantic produces a 3 in the end!
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
