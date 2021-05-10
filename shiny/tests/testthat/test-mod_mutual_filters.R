test_that("Testing reactive module with dynamic UI", {
  
  vars_dt <- fread("conf/filters_conf.csv")
  dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")  
  
  x <- reactive(dat)
  
  testServer(filterServer, args = list(vars_dt = vars_dt, vessels_poll = x), {
      session$setInputs(vessel_type = c(8, 7), vessel_name = c(1960, 2006))
      session$flushReact()
      expect_equal(nrow(react_data()), 2)
  })
  
})
