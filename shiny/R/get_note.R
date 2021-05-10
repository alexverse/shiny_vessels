#' Get vessel notification
#'
#' Returns the message displayed for the last selected vessel.
#'
#' @param dat data.table for the vessels table 
#' @param ves_id vessel ids
#'
#' @return HTML for the notification
#'
#' @examples
#' dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
#' get_note(dat, dat[1, SHIP_ID])

get_note <- function(dat, ves_id){
  last_in <- dat[SHIP_ID == tail(ves_id, 1), .(SHIPNAME, DIST)]
  glue::glue('Max distance sailed by vessel
    <b>"{last_in[, SHIPNAME]}"</b>
    is 
    <b>{last_in[, DIST]} meters</b>
  ') %>% as.character
}
