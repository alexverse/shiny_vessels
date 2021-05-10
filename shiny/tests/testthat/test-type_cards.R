test_that("multiplication works", {
  
  dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
  x <- type_cards(dat)
  
  expect_equal(class(x), "shiny.tag")

})
