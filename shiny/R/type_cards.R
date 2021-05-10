#' Generates type cards
#'
#' Generates UI cards and vessel type metadata.
#' 
#' @param dat data.table for vessels table
#'
#' @return HTML 
#'
#' @examples
#' dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
#' type_cards(dat)

type_cards <- function(dat){
  
  st_vessels <- dat[, .(
    avg_len = round(mean(LENGTH, na.rm = TRUE)),
    avg_width = round(mean(WIDTH, na.rm = TRUE)),
    N = .N), by = "ship_type"][order(-N)]
  
  st_vessels[, im_path := paste0("images/vessels/icons/", ship_type ,".png")]
  segment(
    class = "basic blue",
    cards(
      class = "nine blue",
      st_vessels %>%
        purrrlyr::by_row(~ {
          card(
            class = "basic",
            div(
              class = "content",
              div(
                img(src = .$im_path, class = "right floated mini ui image")
              ),
              div(class = "header", .$ship_type),
              div(class = "meta", paste("Total: ", .$N)),
              div(class = "description", paste0("Avg length: ", .$avg_len, "m")),
              div(class = "description", paste0("Avg width: ", .$avg_width, "m")),
            ),
          )
        }) %>% {.$.out}
    )
  )
}
