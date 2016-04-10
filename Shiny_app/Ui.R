shinyUI(fluidPage( 
    headerPanel("Text predictor"),  
    fluidRow(column(12,
                    textInput('userInput', 'Enter your text:', width = "90%"))
        ),
    fluidRow(
        column(1,
            textOutput('suggest1')
        ),
        column(1,
            textOutput('suggest2')
        ),
        column(1,
            textOutput('suggest3')
        )
    )
))

?textInput
