test_that("nearest_vessels() and vessel data are compatible", {
  
  dat <- data.table::fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
  necessary_cols <- c("LON", "LAT", "SHIPTYPE")
  
  expect_true(all(necessary_cols %in% names(dat)))
  expect_true(is.data.table(nearest_vessels(dat[1:3], dat, 6)))
  
})
