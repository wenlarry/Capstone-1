shinyUI(fluidPage( 
    headerPanel("Borrow my Swiftkey"),
    br(),
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
        ),
        fluidRow(
            column(9, p(strong('Please grade me based on the Standard (default) dataset. 
                               Before changing below settings.'))
                        )),
        fluidRow(
            column(9, p('You are currently texting as:', 
                        textOutput('person_handle')), br())),
        fluidRow(
            column(9,
                   radioButtons('person', "Who's Swiftkey?", 
                                c('Standard' = 'Standard',
                                  'Hillary Clinton'= 'HillaryClinton',
                                  'Bernie Sanders'= 'BernieSanders',
                                  'Donald Trump' = 'realDonaldTrump',
                                  'Ted Cruz' = 'tedcruz',
                                  'Rodger Peng' = 'rdpeng',
                                  'Jeff Leek' = 'jtleek',
                                  'Brian Caffo'= 'bcaffo',
                                  'Hillary Parker' ='hspter',
                                  'Hadley Wickham' = 'hadleywickham',
                                  'Kanye West' = 'kanyewest',
                                  'Kendrick Lamar' = 'kendricklamar',
                                  'DJ Khaled' = 'djkhaled'
                                  ),
                                inline = TRUE))),
        fluidRow(
            column(9,
                   actionButton('changeButton', "Change Person")
                   )),
        fluidRow(
            column(9,br(), 
                    "*Note: Current alternate swiftkeys are purely based 
                    on tweets so the sample sizes are small and may(does) lead to 
                    odd results.")),
        fluidRow(
            column(9, 
                   "*Note2: Unfortunately for all of us, Beyonce doesn't tweet 
                    so you get DJ Khaled instead. The world is an unfair place 
                    :/"))
        ),
        column(3,
            tableOutput('top10'))
    )
))

