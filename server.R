library(shiny)
#library(ggplot2)
#library(simmer)
#library(dplyr)
#library(simmer.plot)
#library(parallel)
#library(xtable)
source("marathon.R")


install_load <- function (package1, ...)  {   
  
  # convert arguments to vector
  packages <- c(package1, ...)
  
  # start loop to determine if each package is installed
  for(package in packages){
    
    # if package is installed locally, load
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package))
    
    # if package is not installed locally, download, then load
    else {
      install.packages(package)
      do.call("library", list(package))
    }
  } 
}

install_load("ggplot2", "simmer", "dplyr", "simmer.plot", "parallel", "xtable")

# Define server logic
shinyServer(function(input, output) {
  output$arrival_rate = renderText({
    paste("Expected number of customers:", input$arrival_rate*600)
  })
  
  v = reactiveValues(data = 0)
  
  observeEvent(input$go, {v$data = marathon_plots(arrival_rate = input$arrival_rate, 
                                                  avgservicetime = input$avgservicetime,
                                                  min_service_time = input$min_service_time,
                                                  walktime = input$walktime/60,
                                                  ppc = input$ppc/2, leave_prob = input$leave_prob)})

  output$string = renderTable({
    if(length(v$data)==1) return()
    v$data[[3]]
  })
  
  output$utilization = renderPlot({
    if(length(v$data)==1) return()
    v$data[[1]]
  })
  output$arrivals = renderPlot({
    if(length(v$data)==1) return()
    v$data[[2]]
  })
  

  })