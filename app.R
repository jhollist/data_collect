library(shiny)
library(RSQLite)
library(DBI)


con <- dbConnect(RSQLite::SQLite(),"workshop_form.sqlite3")
if(length(dbListTables(con))==0){
  my_df <- data.frame(rexp=1,
                      rstudioexp=1,
                      rscriptexp=1,
                      rscriptrank=1,
                      spatialexp=1,
                      spatialrank=1,
                      rrdocsexp=1,
                      rrdocsrank=1,
                      vcexp=1,
                      vcrank=1,
                      opendataexp=1,
                      opendatarank=1,
                      dmexp=1,
                      dmrank=1,
                      other="other")
   dbWriteTable(con,"questions",my_df)
} else {
  my_df <- dbReadTable(con,"questions")
}

server<-function(input, output) {
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- renderDataTable({
    #add dependence on button
    input$update_it
    # Update database: 
    my_df <- isolate({
      new_row<-data.frame(rexp=input$rexp,
                          rstudioexp=input$rstudioexp,
                          rscriptexp=input$rscriptexp,
                          rscriptrank=input$rscriptrank,
                          spatialexp=input$spatialexp,
                          spatialrank=input$spatialrank,
                          rrdocsexp=input$rrdocsexp,
                          rrdocsrank=input$rrdocrank,
                          vcexp=input$vcexp,
                          vcrank=input$vcrank,
                          opendataexp=input$opendataexp,
                          opendatarank=input$opendatarank,
                          dmexp=input$dmexp,
                          dmrank=input$dmrank,
                          other=input$other,
                          stringsAsFactors = FALSE)
      test_df<-all(new_row != data.frame(rexp=1,
                                         rstudioexp=1,
                                         rscriptexp=1,
                                         rscriptrank=1,
                                         spatialexp=1,
                                         spatialrank=1,
                                         rrdocsexp=1,
                                         rrdocsrank=1,
                                         vcexp=1,
                                         vcrank=1,
                                         opendataexp=1,
                                         opendatarank=1,
                                         dmexp=1,
                                         dmrank=1,
                                         other="other"))
      if(F){
        dbWriteTable(con,"questions",new_row,append=TRUE)
        my_df <- dbReadTable(con,"questions")
      }
      my_df
    })
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 10))
}

ui<-fluidPage(
  title = 'Survey for IALE Open Science Workshop',
  sidebarLayout(
    sidebarPanel(
      # rexp Input
      numericInput("rexp", label = h3("Enter rexp"),value=1, min = 1, max = 5),
      # rstudioexp
      numericInput("rstudioexp", label = h3("Enter rstudioexp"),value=1, min = 1, max = 5),
      # rscriptexp
      numericInput("rscriptexp", label = h3("Enter rscriptexp"),value=1, min = 1, max = 5),
      # rscriptrank
      numericInput("rscriptrank", label = h3("Enter rscriptrank"),value=1, min = 1, max = 5),
      # spatialexp
      numericInput("spatialexp", label = h3("Enter spatialexp"),value=1, min = 1, max = 5),
      # spatialrank
      numericInput("spatialrank", label = h3("Enter spatialrank"),value=1, min = 1, max = 5),
      # rrdocsexp
      numericInput("rrdocsexp", label = h3("Enter rrdocsexp"),value=1, min = 1, max = 5),
      # rrdocsrank
      numericInput("rrdocsrank", label = h3("Enter rrdocsrank"),value=1, min = 1, max = 5),
      # vcexp
      numericInput("vcexp", label = h3("Enter vcexp"),value=1, min = 1, max = 5),
      # vcrank
      numericInput("vcrank", label = h3("Enter vcrank"),value=1, min = 1, max = 5),
      # opendataexp
      numericInput("opendataexp", label = h3("Enter opendataexp"),value=1, min = 1, max = 5),
      # opendatarank
      numericInput("opendatarank", label = h3("Enter opendatarank"),value=1, min = 1, max = 5),
      # dmexp
      numericInput("dmexp", label = h3("Enter dmexp"),value=1, min = 1, max = 5),
      # dmrank
      numericInput("dmrank", label = h3("Enter dmrank"),value=1, min = 1, max = 5),
      # other
      textInput("other", label = h3("Enter other comments"),value="No Comment", value = "No Other Comments"),
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

