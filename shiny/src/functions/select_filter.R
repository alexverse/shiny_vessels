#' Modified %in% operator
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

#' Filter data
#' 
#' Useful for multiple filtering. For each filter in args (multiselect or single), filter
#' data. If a filter is `NULL` or `""` return all.
#'  
#' @param args a list. Filter values per filter. In practice used for `input` filters 
#' @param vars_dt a data.table of the filters (id and label) to be used and their 
#' correspondence to the data. Note that `vars_dt` is used to make UI filters.  
#' @param data a data.table
#'
#' @return
#' @import %inT%
#'
#' @examples
#' args <- list(
#'   vessel_type = c(8, 7),
#'   vessel_name = c(1960, 2006)
#' )
#' fread("https://aledat.eu/shiny/vessels/results/vessels.csv") %>%
#'  filter_data(args, vars_dt, .)

filter_data <- function(args, vars_dt, data) {
  
  res <- lapply(seq(nrow(vars_dt)), function(i) 
    data[[vars_dt[i, ID]]] %inT% args[[vars_dt[i, NID]]])
  
  data[Reduce(f = `&`, x = res)]
}

#' Get named vector from dictionary
#'
#' Utility function used for generating named vectors for selectize filters.
#' 
#' @param dat a data.table with 2 columns. First column are for names and second for values.
#'
#' @return named vector
#'
#' @examples
#' xx <- data.table(
#'   c("FOO", "BAR"),
#'   c("foo", "bar")
#' )
#' trans_vector(xx)

trans_vector <- function(dict, ord = TRUE){
  
  res <- dict %>%
    unique %>%
    transpose(make.names = TRUE) %>%
    unlist
  
  if(ord) res <- res[order(names(res))]
  
  res
    
}

#' Filter to columns data
#' 
#' Filters to columns correspondence. Can be considered also as a configuration file.
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

vars_dt <- fread("conf/filters_conf.csv")
