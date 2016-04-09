shinyUI(pageWithSidebar(  
    headerPanel("Text predictor"),  
    sidebarPanel(    
        textInput('userInput', 'Enter your text:')),
    mainPanel(    
        textOutput('test')
    )
))