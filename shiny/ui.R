
grid_top <- grid_template(
  default = list(
    areas = rbind(c("filters", "cards")),
    rows_height = c("100%"),
    cols_width = c("20%", "80%")
  )
)

grid_center <- grid_template(
  default = list(
    areas = rbind("leaflet"),
    rows_height = c("100%"),
    cols_width = c("100%")
  )
)

grid_bottom <- grid_template(
  default = list(
    areas = rbind(c("xtable", "plotly")),
    rows_height = c("100%"),
    cols_width = c("40%", "60%")
  )
)

ui <- semanticPage(
  title = "Shiny Vessels",
  use_waiter(),
  waiter_show_on_load(html = spin_wave(), color = "#2185d0"),
  titlePanel(
    div(
      img(src = "images/logo.png",  width = "20%", height = "auto"),
    )
  ),
  mainPanel( #TODO main_panel from semantic produces a 3 in the end!
    grid(
      grid_top,
      filters = filterInput("v_data", vars_dt), 
      cards = type_cards(init_dat)
    ),
    grid(
      grid_center,
      leaflet = leafletOutput("map")
    ),
    grid(
      grid_bottom,
      xtable = segment(
        class = "basic",
        tableOutput("data")
      ),
      plotly = segment(
        class = "basic",
        plotlyOutput("plot")
      ) 
    )
  )
)
