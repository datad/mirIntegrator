
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

data("datafrom")




shinyUI(fluidPage(
  
  navbarPage("mirIntegrator app",
             tabPanel("Pathways",
                      
                      mainPanel(
                        strong("Version of KEGG Pathways"),
                        br(),
                        p(kegg_version[1]),
                        p(kegg_version[2]),
                        p(kegg_version[3]),
                        p(kegg_version[4]),
                        #code("DO SOMETHING TO UPDATE THE VERSION OF KEGG"),
                        br(),
                        #code("DO SOMETHING TO GENERATE AUGMENTED PATHWAYS"),
                        
                        plotOutput("distPlot")
                      )
                      
             ),
             tabPanel("Plot Augmented Pathways" ,
                      sidebarPanel(
                                selectInput("pathway", "Choose a pathway:",
                                            choices = as.character(sort(names_pathways)),
                                            selected = "Sulfur relay system")
                       ),
                       mainPanel(
                         plotOutput('plot')
                       )
                      ),
             tabPanel("Run Pathway Analysis" ,
                      mainPanel(
                        selectInput("mRNA", "Choose the mRNA dataset:",
                                    choices = c("GSE43592_mRNA", "load a new dataset...") ),
                        selectInput("miRNA", "Choose the micro RNA dataset:",
                                    choices = c("GSE43592_miRNA", "load a new dataset...") ),
                        actionButton("action", label = "Run Impact Analysis")
                        #plotOutput('text2r')
                        #hr(),
                        #p(verbatimTextOutput("text2r"))
                        #p(verbatimTextOutput("value"))
                      ),
                      
                      tabPanel('No filtering',       DT::dataTableOutput('ex4'))

                      
                      ),
             tabPanel("R package",
                      mainPanel(
                        strong("Installation"),
                        p("mirIntegrator is available in Bioconductor, 
                          so you can install it from your R console:"),
                        code(paste("source(",'"',"https://bioconductor.org/biocLite.R",'"',")", sep='')),
                        br(),
                        code(paste("biocLite(",'"',"mirIntegrator",'"',")",sep=''))
                        )
             )
  )

))
