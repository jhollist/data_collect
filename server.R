
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
  
   
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- renderDataTable({
    #add dependence on button
    input$update_it
    
    # Update database: 
    my_df <- isolate({
      new_row<-data.frame(name=input$name,age=input$age,stringsAsFactors = FALSE)
      if(all(new_row != data.frame(name="Name",age=21))){
        dbWriteTable(con,"people",new_row,append=TRUE)
        my_df <- dbReadTable(con,"people")
      }
      my_df
    })
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  my_df
})