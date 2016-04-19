shinyServer(
    
    function(input, output) {
        source('utils.R', local = TRUE)
        predictions <- reactive(
                kn_predictor(input$userInput, input$profanity)
            )
        output$suggest1 <- reactive(predictions()[1]$end)
        output$suggest2 <- reactive(predictions()[2]$end)
        output$suggest3 <- reactive(predictions()[3]$end)
        output$top10 <- renderTable(data.table(top10 = predictions()[1:10,end]))
        output$person_handle <- renderText("Standard")
        observeEvent(input$changeButton, {
            # Wire it up to go back to standard
            handle <- input$person
            if(handle == "Standard"){
                uni_DT <<- readRDS("tables/uni_DT.rds")
                bi_DT <<- readRDS("tables/bi_DT.rds")
                tri_DT <<- readRDS("tables/tri_DT.rds")
            }else{
                uni_DT <<- readRDS(paste0("alt_tables/", handle, "/uni_DT.rds"))
                bi_DT <<- readRDS(paste0("alt_tables/", handle, "/bi_DT.rds"))
                tri_DT <<- readRDS(paste0("alt_tables/", handle, "/tri_DT.rds"))
                output$person_handle <- renderText(input$person)
            }
        })
        
        }
)