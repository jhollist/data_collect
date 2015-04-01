
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(RSQLite)
library(DBI)

con <- dbConnect(RSQLite::SQLite(),"my_db.sqlite3")
my_df <- dbReadTable(con,"people")

shinyServer(function(input, output) {

  rv <- reactiveValues(cachedTbl = NULL)
  
  output$my_df <- renderDataTable({
    
    #add dependence on button
    input$actionButtonID
    
    my_df<-rbind(my_df, c(input$name, input$age))
    dbWriteTable(con,"people",my_df)
    con <- dbConnect(RSQLite::SQLite(),"my_db.sqlite3")
    return(dbReadTable(con,"people"))
    })
   
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- renderDataTable({
    my_df
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  
})