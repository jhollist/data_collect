library(shiny)
library(RSQLite)
library(DBI)

con <- dbConnect(RSQLite::SQLite(),"my_db.sqlite3")
my_df <- dbReadTable(con,"people")

server<-function(input, output) {
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
}

ui<-fluidPage(
  title = 'Display and Edit A Data Table',
  sidebarLayout(
    sidebarPanel(
      # Name Input
      textInput("name", label = h3("Enter Name"), value = "Name"),
      # Age Input
      numericInput("age", label = h3("Enter Age"),value = 21 , min = 0, max = 110),
      # Button
      #update button
      actionButton("update_it","Update Database")
    ),
    mainPanel(
      dataTableOutput('mytable3')
    )
  )
)

shinyApp(ui = ui, server = server)

