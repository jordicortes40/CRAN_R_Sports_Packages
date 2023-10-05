
#Load Packages ####
library(shiny)
library(reactable)
library(tidyverse)
library(htmltools)

#Load Data ####
data <- read.csv("Data/R Sports Packages.csv") %>%
        select(`Category Classification` = Category.1, Sport = Sport,
               `Methodology Type` = Metodhology_type, Package = Package, Date = Date,
               `Short Title` = Title, `Includes Data` = Data, Gender = Gender,
               Category = Category, `Statistical Analysis Methodology` = Statistical_methodology,
               `Includes Tutorial` = Tutorial, `1st Release Package` = Creation_date,
               `1st Release Version` = version_first, `Last Release Date` = Version_last,
               `Last Release Version` = Date_last, `R Journal` = R_journal, JQAS = JQAS,
               `Citation` = Citation,  `Creator's Country` = Creator.s.Country,
               `Creator's Gender` = Creator.s.gender, `Year Created` = year_creation,
               `Year Updated` = year_updated)

data1 <- data %>% select(`Category Classification`, Sport,`Methodology Type`, Package)

data2 <- data %>% select(-`Category Classification`, -Sport, -`Methodology Type`, -Citation)

data3 <- data %>% select(Package, Citation) %>%
  mutate_if(is.character, utf8::utf8_encode)

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
                   selected = c("Sports technology", "Sports performance analysis",
                                "Athlete health", "Movement integration", "eSports")
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
                    `Short Title` <- datos()[["Short Title"]][index]
                    div(
                      div(style = list(fontWeight = 600), value),
                      div(style = list(fontSize = 12), `Short Title`)
                    )
                  },

                  #code for level 1 nested table ####
               details = function(index){
                  Package <- data2[data2$Package == dat()[["Package"]][index], ]
                  div(
                    reactable(Package,

                              columns = list(

                                `Short Title` = colDef(show = FALSE),
                                `Package` = colDef(


                                  #code for level 2 nested table ####
                                  details = function(index){
                                    Citation <- data3[data3$Package == Package[["Package"]][index], ]
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
