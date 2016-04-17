library(UsingR)
source('utils.R')

shinyServer(  
    function(input, output) {    
        foo <- reactive(
                kn_predictor(input$userInput, input$profanity)
            )
        output$suggest1 <- reactive(foo()[1]$end)
        output$suggest2 <- reactive(foo()[2]$end)
        output$suggest3 <- reactive(foo()[3]$end)
        output$top10 <- renderTable(data.table(top10 = foo()[1:10,end]))
        }
)