library(UsingR)
source('utils.R')

shinyServer(  
    function(input, output) {    
        foo <- reactive(
                kn_predictor(input$userInput)
            )
        output$suggest1 <- reactive(foo()[1]$end)
        output$suggest2 <- reactive(foo()[2]$end)
        output$suggest3 <- reactive(foo()[3]$end)
        }
)