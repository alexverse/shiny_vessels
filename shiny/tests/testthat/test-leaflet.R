test_that("leaflet functions are ok", {
  
  dat <- data.table(fread("https://aledat.eu/shiny/vessels/results/vessels.csv"))
  
  lc <- leaflet_icons("www/images/vessels/icons/", www = "www/images/vessels/icons/")
  expect_equal(class(lc), "leaflet_icon_set")
  
  pl <- vessels_map(dat[1:10], FALSE, lc)
  expect_equal(class(pl)[1], "leaflet")

})
