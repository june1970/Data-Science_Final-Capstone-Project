#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)
#library(stringr)
#library(sqldf)

suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

#twoGrams <- read.csv('C:/Users/HP/Desktop/Grace R/Course 10/Coursera-SwiftKey/final/en_US/Final Project_Shinyapp/bigram.csv', header = TRUE, stringsAsFactors = FALSE)
#threeGrams <- read.csv('C:/Users/HP/Desktop/Grace R/Course 10/Coursera-SwiftKey/final/en_US/Final Project_Shinyapp/trigram.csv', header = TRUE, stringsAsFactors = FALSE)
#fourGrams <- read.csv('C:/Users/HP/Desktop/Grace R/Course 10/Coursera-SwiftKey/final/en_US/Final Project_Shinyapp/quadgram.csv', header = TRUE, stringsAsFactors = FALSE)


# Load Quadgram,Trigram & Bigram Data frame files

quadgram <- readRDS("quadgram.RData");
trigram <- readRDS("trigram.RData");
bigram <- readRDS("bigram.RData");
#mesg <<- ""



shinyServer(function(input, output) {
    output$inputText <- renderText({ input$txt }, quoted = FALSE)
    observeEvent(input$Submit, {
        txt <- gsub("\'","\'\'",input$txt)
        nwords <- str_count(txt, "\\S+")
        formattedTxt <- paste(unlist(strsplit(isolate(txt),' ')), collapse = '_')
        output$suggestions  <- renderPrint({
            if(nwords >= 5){
                print(getPreds(formattedTxt, 5))
            }
            else{
                
                print(getPreds(formattedTxt, nwords + 1))
            }
        })
    })
    
    
    getPreds <- function(str, nGrams){
        if (nGrams == 1) {
            return('Not found')
        }
        if (length(unlist(strsplit(str, "_"))) > nGrams - 1) {
            str <-
                paste(tail(unlist(strsplit(str, "_")), nGrams - 1), collapse = '_')
        }
        if (nGrams == 5) {
            query = sprintf("select Pred from fiveGrams where nGrams = '%s' order by Frequency desc limit 3",
                            str)
        }
        else if (nGrams == 4) {
            query = sprintf("select Pred from fourGrams where nGrams = '%s' order by Frequency desc limit 3",
                            str)
        }
        else if (nGrams == 3) {
            query = sprintf("select Pred from threeGrams where nGrams = '%s' order by Frequency desc limit 3",
                            str)
        }
        else if (nGrams == 2) {
            query = sprintf("select Pred from twoGrams where nGrams = '%s' order by Frequency desc limit 3",
                            str)
        }
        res <- sqldf(query)
        if (nrow(res) == 0) {
            getPreds(str, nGrams - 1)
        }
        else {
            return(res)
        }
    }
    
})
