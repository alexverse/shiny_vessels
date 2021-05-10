test_that("check dropdown filters utils", {
  
  #return all if no selected filter
  expect_true(all(1:3 %inT% NULL))
  expect_true(all(1:3 %inT% ""))
  
  #this are the vectors from selected filters, input reactives are used
  args <- list(
    vessel_type = c(8, 7),
    vessel_name = c(1960, 2006)
  )
  
  dat <- data.table::fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
  x <- filter_data(args, vars_dt, dat)
  
  expect_equal(nrow(x), 2)

})
