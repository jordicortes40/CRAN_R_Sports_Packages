
#Load Packages ####
library(shiny)
library(reactable)
library(tidyverse)
library(htmltools)

#Load Data ####
data <- read.csv("https://raw.githubusercontent.com/josedv82/CRAN_R_Sports_Packages/main/Data/R%20Sports%20Packages.csv?token=GHSAT0AAAAAABNVESCXQVOABWNTNEJEPBVIYPSZPAQ") %>%
        select(`Category Classification` = 21, Sport = 8, `Methodology Type` = 12, Package = 2, Date = 1, `Short Title` = 3, -4, -5, -6, `Includes Data` = 7, Gender = 9, Category = 10, `Statistical Analysis Methodology` = 11, 
               `Includes Tutorial` = 13, `1st Release Package` = 14, `1st Release Version` = 15, `Last Release Date` = 16, 
               `Last Release Version` = 17, `R Journal` = 18, JQAS = 19, `Citation` = 20,  `Creator's Country` = 22, `Creator's Gender` = 23, 
               `Year Created` = 24, `Year Updated` = 25)   

data1 <- data %>% select(`Category Classification`, Sport,`Methodology Type`, Package)

data2 <- data %>% select(-`Category Classification`, -Sport, -`Methodology Type`, -Citation)

data3 <- data %>% select(Package, Citation)

html <- function(x, inline = FALSE) {
  container <- if (inline) htmltools::span else htmltools::div
  container(dangerouslySetInnerHTML = list("__html" = x))
}

#UI ####
ui <- fluidPage(
  
  #theming   
  theme = shinythemes::shinytheme("flatly"),
  
  tags$head(tags$style("#modal1 .modal-body {background-color: white; padding: 10px}
                       #modal1 .modal-content  {-webkit-border-radius: 6px !important;-moz-border-radius: 6px !important;border-radius: 6px !important;}
                       #modal1 .modal-dialog { width: 880px; display: inline-block; text-align: left; vertical-align: top;}
                       #modal1 .modal-header {background-color: #404764; border-top-left-radius: 6px; border-top-right-radius: 6px}
                       #modal1 .modal { text-align: center; padding-right:0px; padding-top: 24px;}
                       #moda1 .close { font-size: 16px}")),
  
  
br(),  


#sidebar
sidebarLayout(
    fluid = T,
    
    
    
    sidebarPanel(width = 2, style = "position:fixed;width: 15%",
                 
                 #top buttons
                 actionButton("info", "Info", icon = icon("info-circle"), style = "border-color: darkgray; color: black"),
                 actionButton("code", "Code", icon = icon("github"), style = "border-color: darkgray; color: black", onclick ="window.open('https://github.com/jordicortes40/CRAN_R_Sports_Packages', '_blank')"),
                 
                 br(),
                 br(),
                 br(),
    
                 #select category
                 shinyWidgets::prettyCheckboxGroup(
                   inputId = "filter1",
                   label = "Select Category", 
                   choices = unique(data1$`Category Classification`),
                   icon = icon("check"), 
                   bigger = TRUE,
                   status = "info",
                   animation = "jelly",
                   selected = c("Sports technology", "Sports performance analysis", "Athlete health", "Movement integration", "eSports")
                 ),
                 
                 
                # #select Sport
                # shinyWidgets::prettyCheckboxGroup(
                #   inputId = "filter2",
                #   label = "Select Sport", 
                #   choices = unique(data1$`Sport`),
                #   icon = icon("check"), 
                #   bigger = TRUE,
                #   status = "info",
                #   animation = "jelly",
                #   selected = NULL
                # ),
                 
                br(),
                br(),
                br(),
                
                downloadButton('downloadData', 'Download Table', style = "border-color: darkgray; color: black")
                 
    
    ),

  

#mainpanel 
mainPanel(width = 10, reactableOutput('table'))


)


)

#Server ####
server <- function(input, output) {
  
  #info modal
  observeEvent(input$info, {
    
    showModal(tags$div(id="modal1", modalDialog(
      inputId = 'Dialog1', 
      title = HTML('<span style="color:white; font-size: 20px; font-weight:bold; font-family:sans-serif ">About the paper....<span>
                   <button type = "button" class="close" data-dismiss="modal" ">
                   <span style="color:white; ">x <span>
                   </button> '),
      
      tags$a("link to paper and description"),
      
      easyClose = TRUE,
      footer = NULL )))
    
  })
  
  
  #reactive dataset for table
  dat <- reactive({
    
    data1 %>% filter(`Category Classification` %in% input$filter1)
  #%>% filter(`Sport` %in% input$filter2)
    
  })
  
  #reactive dataset for download button
  datos <- reactive({
    
    data %>% filter(`Category Classification` %in% input$filter1)
    #%>% filter(`Sport` %in% input$filter2)
    
  })
  
  #Code to download button
  output$downloadData <- downloadHandler(
    
    
       filename = function() {
         paste('data-', Sys.Date(), '.csv', sep='')
       },
       content = function(con) {
         write.csv(datos(), con)
       }
     )
  
  

  #Table ####
  output$table <- renderReactable ({
    
    
# Master Table #####
    reactable(dat(),
              
              defaultColDef = colDef(
                align = "left",
                minWidth = 120,
                headerStyle = list(background = "#f7f7f8")
              ),
              
              columns = list(
                `Category Classification` = colDef(minWidth = 250),
                `Sport` = colDef(minWidth = 250),
                `Methodology Type` = colDef(minWidth = 250),
                
                Package = colDef(
                  minWidth = 300,
                  
                  # Blend Package & Title Columns ####
                  cell = function(value, index) {
                    `Short Title` <- data$`Short Title`[index]
                    div(
                      div(style = list(fontWeight = 600), value),
                      div(style = list(fontSize = 12), `Short Title`)
                    )
                  },
                
                  #code for level 1 nested table ####
               details = function(index){
                  Package <- data2[data2$Package == data1$Package[index], ]
                  div(
                    reactable(Package,
                              
                              columns = list(
                                
                                `Short Title` = colDef(show = FALSE),
                                `Package` = colDef(
                                  
                                  
                                  #code for level 2 nested table ####
                                  details = function(index){
                                    Citation <- data3[data3$Package == data2$Package[index], ]
                                    div(
                                      reactable(Citation,
                                                
                                                columns = list(
                                                
                                                `Package` = colDef(show = FALSE)
                                                
                                                )
                                                
                                                
                                           )  
                                    )
                                    }
                                )
                              )
                           )
                  )#div
               }
                )  
                
              ),
              
              bordered = TRUE,
              highlight = TRUE,
              sortable = TRUE,
              showSortable = TRUE,
              filterable = TRUE,
              
              theme = reactableTheme(cellStyle = list(display = "flex", flexDirection = "column", justifyContent = "center"))
              
              )
    
   
    
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
