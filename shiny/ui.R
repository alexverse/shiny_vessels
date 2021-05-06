ui <- semanticPage(
    segment(
      selectInput(
        "vessel_type", 
        "Vessel Type:",
        init_type_choices, 
        selectize = TRUE, 
        multiple = TRUE, 
        width = "300px",
        default_text = "ALL"
      ),
      selectInput(
        "vessel_name", 
        "Vessel Name:",
        init_vessels, 
        selectize = TRUE, 
        multiple = TRUE, 
        width = "300px",
        default_text = "ALL"
      ),
      tableOutput("data")
    )
)
