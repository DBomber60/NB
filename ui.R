library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("NYC Marathon Simulation"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Examine Simulation Under Various Scenarios."),
      
      sliderInput("arrival_rate", 
                  label = "Arrival Rate",
                  min = 5, max = 60, value = 47),
      
      textOutput("arrival_rate"),
      
      sliderInput("min_service_time", 
                  label = "Minimum Service Time",
                  min = 0.5, max = 1.5, value = .5),
      
      sliderInput("avgservicetime", 
                  label = "Average Service Time",
                  min = 0.5, max = 5, value = 1.1),
      
      sliderInput("walktime", 
                  label = "Average time to walk from line to cashier (seconds)",
                  min = 5, max = 30, value = 10),
      
      sliderInput("ppc", 
                  label = "Number of Cashiers",
                  min = 10, max = 100, value = 80),
      
      sliderInput("leave_prob", 
                  label = "Proportion of Customers Expected to Transact in Line",
                  min = 0, max = .1, value = .05),
      
      actionButton("go", "Run Simulation")
      
    ),
      
    
    mainPanel(
      #fluidRow(
      tableOutput("string"),
      plotOutput("utilization"),
      plotOutput("arrivals")
      )
    )
  )
)
