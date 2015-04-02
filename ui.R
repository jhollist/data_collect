
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)


shinyUI(fluidPage(
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
)
