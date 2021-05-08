#' @title Modified %in% operator
#' 
#' Works as `%in%` but when rhs is `""` or `NULL` returns all `TRUE`. This is useful
#' and simplifies considerably the code when no filters are selected and want to return 
#' all observations. (in other words `NULL` filter corresponds to all data)
#'
#' @param x lhs 
#' @param table rhs
#'
#' @return boolean vector
#'
#' @examples
#' 1:3 %inT% NULL
`%inT%` <- function(x, table) {
  if (!is.null(table) && ! "" %in% table)
    x %in% table
  else
    rep_len(TRUE, length(x))
}

#' @title Filter data
#' 
#' Useful for multiple filtering. For each filter (multiselect or single) filter
#' dataset. If a filter is `NULL` or `""` return all.
#'  
#' @param args a list. Filter values per filter. In practice used for `input` filters 
#' @param vars_dt a data.table of the filters (id and label) to be used and their 
#' correspondence to the data. Note that `vars_dt` is used to make UI filters.  
#' @param data a data.table
#'
#' @return
#' @export
#'
#' @examples
#' args <- list
filter_data <- function(args, vars_dt, data) {
  res <- lapply(seq(nrow(vars_dt)), function(i) 
    data[[vars_dt[i, ID]]] %inT% args[[vars_dt[i, NID]]])
  data[Reduce(f = `&`, x = res)]
}

#' @title Filter to columns data
#' 
#' Filters to colums correspondence. Can be considered also as a configuration file.
#' It is used by the filter module to generate the filters.  
#'     
#' @format A data.table with 4 variables, which are:
#' \describe{
#' \item{ID}{Filtering data column with ids}
#' \item{NAME}{Filtering data column with names}
#' \item{NID}{Corresponding UI id in filters module namespace}
#' \item{LABEL}{Corresponding UI name in filters module namespace}
#' }
#'
vars_dt <- data.table(
  ID = c("SHIPTYPE", "SHIP_ID"),
  NAME = c("ship_type", "SHIPNAME"),
  NID = c("vessel_type", "vessel_name"),
  LABEL = c("Vessel Type:", "Vessel Name:")
)

