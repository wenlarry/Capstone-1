shinyUI(fluidPage( 
    headerPanel("Text predictor"),
    fluidRow(column(9,
    fluidRow(
        column(5,
               radioButtons('profanity', 'profanity filter', 
                            c('On'= TRUE,
                              'Off'= FALSE), inline = TRUE))
    ),
    fluidRow(
        column(2,
               textOutput('suggest1')
        ),
        column(2,
               textOutput('suggest2')
        ),
        column(2,
               textOutput('suggest3')
        )
    ),
    fluidRow(
        column(9,
            textInput('userInput', '', width = "90%", placeholder = "Enter your text"))
    )),
    column(3,
        tableOutput('top10'))
    )
))

?textInput
