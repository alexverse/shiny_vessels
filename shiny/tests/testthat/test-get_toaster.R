test_that("reactive tests for toasts", {
  
  server <- function(input, output, session)"foo"
  dat <- fread("https://aledat.eu/shiny/vessels/results/vessels.csv")
  
  toastyy <- NULL
  testServer(server, {
    toasty <<- get_toaster(dat, dat[1, SHIP_ID], session)
  })
  expect_true(grepl("^-", toasty))
  
  toasty <- NULL
  testServer(server, {
    toasty <<- warn_toaster(session)
  })
  expect_true(grepl("^-", toasty))
  
})
