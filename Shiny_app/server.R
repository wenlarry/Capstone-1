library(UsingR)
source('utils.R')
data(galton)

shinyServer(  
    function(input, output) {    
        output$test <- reactive(
                shinytest(input$userInput)
            )
        }
)