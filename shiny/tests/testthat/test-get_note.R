test_that("get_note() creates expected String with ship names", {
  
  dat <- data.table::fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
  
  expect_true(grepl(dat[1, SHIPNAME], get_note(dat, dat[1, SHIP_ID])))
  
})
