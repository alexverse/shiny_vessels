test_that("multiplication works", {

  xx <- fread("https://aledat.eu/shiny/vessels/results/ts_data.csv")
  
  expect_equal(class(plot_ts(xx[ship_type == "Tanker"], NULL))[1], "plotly")

})
