#
### Data Science_Capstone_final Project_ShinyApp
### This is Ui.R file for ShinyApp


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Next Word Prediction", "Data Science_Capstone Project"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          textInput("txt",label = "Enter a text to predict the next word", value = "", width = NULL, placeholder = NULL),
          h4('Please use \'Submit\' to observe the predicted word.'),
          h4('(Sample Input:\'What are you\' or \'We are doing\')'),
          actionButton("Submit","Submit")
        ),

        
        mainPanel(
           h3("Predicted next Word"),
           h4("Phrase entered:"),
           verbatimTextOutput("inputText"),
           h4('Next predicted words'),
           verbatimTextOutput("prediction"),
                   )
    )
))


