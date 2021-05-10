#' Toast 
#'
#' HTML generated to notify on selected vessel
#'
#' @param dat data.table 
#' @param vessel_id 
#'
#' @return HTML
#'
#' @examples

get_toaster <- function(dat, vessel_id, session){
  
  stopifnot(!is.reactive(dat))
  stopifnot(!is.reactive(vessel_id))
  
  get_note(dat, vessel_id) %>%
    toast(
      duration = 5, 
      class = "teal raised", 
      session = session,
      toast_tags = list(
        position = "bottom right",
        showIcon = "water"
      )
    )

}

warn_toaster <- function(session)
  toast(
    duration = 10, 
    "No data found. Reset filters", 
    class = "warning", 
    session = session,
    toast_tags = list(
      position = "bottom right", 
      showIcon = "exclamation triangle"
    )
  )
