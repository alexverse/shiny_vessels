#' Time series plot
#'
#' @param data data.table
#' @param pallete cha vector or NULL
#'
#' @examples
#' xx <- fread("https://aledat.eu/shiny/vessels/results/ts_data.csv")
#' plot_ts(xx[ship_type == "Tanker"], NULL)

plot_ts <- function(data, pallete){
  plot_ly(
    data, 
    x = ~ date,
    y = ~ date_dist,
    color = ~ ship_type,
    colors = pallete,
    mode = 'lines'
  ) %>% 
    add_lines %>%
    layout(
      title = "<b>Mean distance between consecutive ponits</b>",
      xaxis = list(title = "Time"),
      yaxis = list(title = "Distance (m)"), 
      font = fonts
    )
  
}
