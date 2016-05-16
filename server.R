
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(mirIntegrator)

data(augmented_pathways)
data(kegg_pathways)
data(names_pathways)

shinyServer(
  
  function(input, output) {
  
   

  output$distPlot <- renderPlot({

    plot_change(kegg_pathways,augmented_pathways, names_pathways)

  })
  

  output$plot <- renderPlot({
    pathway <- input$pathway
    
    pos <- which(pathway == names_pathways)
    idp <- names(names_pathways[pos])
    
    #plot(1,main=pathway)
    plot_augmented_pathway(kegg_pathways[[idp]],
                           augmented_pathways[[idp]],
                           names_pathways[idp] )

  }, height=700)
  
  
#   output$value <- renderPrint({ 
#     if(input$action != 0 )
#     {
#       show_t()
#     }
#     
#      })
  
  output$text2r <- renderPlot({ 
    if(input$action != 0 )
     {
    # Create 0-row data frame which will be used to store data
    dat <- data.frame(x = numeric(0), y = numeric(0))
    
    withProgress(message = 'Making plot', value = 0, {
      # Number of times we'll go through the loop
      n <- 1000
      
      for (i in 1:n) {
        # Each time through the loop, add another row of data. This is
        # a stand-in for a long-running computation.
        dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
        
        # Increment the progress bar, and update the detail text.
        incProgress(1/n, detail = paste("Doing part", i))
        
        # Pause for 0.1 seconds to simulate a long computation.
        Sys.sleep(0.1)
      }
    })
    
    plot(dat$x, dat$y)
    }
  })
  ######
  #table
  # turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    if(input$action != 0 )
    {
      # Create 0-row data frame which will be used to store data
      dat <- data.frame(x = numeric(0), y = numeric(0))
      
      withProgress(message = 'Running Impact Analysis', value = 0, {
        DT::datatable(show_t(), options = list(searching = FALSE))
      })
      
    }
    
      )
  
})



show_t <- function(){
  text2r <- ""
  require(graph)
   require(ROntoTools)
  data(GSE43592_mRNA)
  data(GSE43592_miRNA)
    data(augmented_pathways)
 data(names_pathways)
 lfoldChangeMRNA <- GSE43592_mRNA$logFC
 names(lfoldChangeMRNA) <- GSE43592_mRNA$entrez
 lfoldChangeMiRNA <- GSE43592_miRNA$logFC
 names(lfoldChangeMiRNA) <- GSE43592_miRNA$entrez
 keggGenes <- unique(unlist( lapply(augmented_pathways,nodes) ) )
 interGMi <- intersect(keggGenes, GSE43592_miRNA$entrez)
 interGM <- intersect(keggGenes, GSE43592_mRNA$entrez)
 ## For real-world analysis, nboot should be >= 2000
   peRes <- pe(x= c(lfoldChangeMRNA, lfoldChangeMiRNA ),
                               graphs=augmented_pathways, nboot = 200, verbose = FALSE)
   text2r <- paste(text2r, (paste("There are ", length(unique(GSE43592_miRNA$entrez)),
                               "miRNAs meassured and",length(interGMi),
                                "of them were included in the analysis.")), sep ="\n")
   text2r <<- paste(text2r, paste("There are ", length(unique(GSE43592_mRNA$entrez)),
                                      "mRNAs meassured and", length(interGM),
                                    "of them were included in the analysis."), sep ="\n")
   summ <- Summary(peRes)
   rankList <- data.frame(summ,path.id = row.names(summ))
   tableKnames <- data.frame(path.id = names(names_pathways),names_pathways)
   rankList <- merge(tableKnames, rankList, by.x = "path.id", by.y = "path.id")
   rankList <- rankList[with(rankList, order(pPert)), ]
   rankList <- rankList[, c(2,7,8,9,10)]
   
  
  return ( rankList);
}