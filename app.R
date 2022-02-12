#
# SAFOD-K-Ar-Dating-Analysis
# 
#
# AUTHOR: Jenna Everard
# LAST MODIFIED: Thursday, February 10th, 2022
#

library(shiny)
library(ggplot2)
library(ggthemes)
library(plotly)
library(MASS)
library(pracma)
library(rsconnect)
library(IsoplotR)

# Calculates summary statistics and updates main sample dataframe 
#
# PARAMS:
#     input: 
#     sample: dataframe form of input csv file
summary_stat_df <- function(input, sample) {
  
  # list allows function to return multiple dataframes
  output <- list()
  
  # convert to percentages
  sample[1:nrow(sample), 2:5] <- sample[1:nrow(sample), 2:5] * 100
  
  # calculate percent detrital and add column
  detrital_percentages <- c()
  for (i in 1:nrow(sample))
  {
    detrital_percentages[i] <- sample$Musc[i]/(sample$illite[i] + 
                                                 sample$Musc[i]) * 100
  }
  sample$detritalPercent <- detrital_percentages
  
  # calculate error in percent detrital and add column
  detritalError <- c()
  for (i in 1:nrow(sample))
  {
    detritalError[i] <- 0
    combined_value <- sample$illite[i] + sample$Musc[i]
    combined_error <- sample$illiteError[i] + sample$MuscError[i]
    largest_possible <- (sample$Musc[i] + sample$MuscError[i]) / 
      (combined_value - combined_error) * 100
    smallest_possible <- (sample$Musc[i] - sample$MuscError[i]) / 
      (combined_value + combined_error) * 100
    if ((largest_possible - sample$detritalPercent[i]) > 
        (sample$detritalPercent[i] - smallest_possible)) {
      detritalError[i] <- largest_possible - sample$detritalPercent[i]
    } else {
      detritalError[i] <- sample$detritalPercent[i] - smallest_possible
    }
  }
  sample$detritalError <- detritalError
  
  # organize the data to graph into a new dataframe
  plot_data <- data.frame(x = sample$detritalPercent[1:(nrow(sample) - 1)],
                          y = sample$age[1:(nrow(sample) - 1)],
                          ymin = sample$age[1:(nrow(sample) - 1)] - 
                            sample$ageError[1:(nrow(sample) - 1)],
                          ymax = sample$age[1:(nrow(sample) - 1)] + 
                            sample$ageError[1:(nrow(sample) - 1)],
                          xmin = sample$detritalPercent[1:(nrow(sample) - 1)] - 
                            sample$detritalError[1:(nrow(sample) - 1)],
                          xmax = sample$detritalPercent[1:(nrow(sample) - 1)] + 
                            sample$detritalError[1:(nrow(sample) - 1)])
  
  # add both resulting dataframes to output list and return 
  output$plot_data = plot_data
  output$sample = sample
  
  return(output)
}

# Only run in interactive sessions
# if (interactive()) {

# App Appearance
ui <- fluidPage(

    # Application title
    titlePanel("Analysis of K/Ar Dating of Size Separates"),

    # Sidebar with file input and text input
    sidebarLayout(
        sidebarPanel(
            fileInput("sample_csv",
                        "csv file:",
                        multiple = FALSE,
                        accept = "csv",
                        buttonLabel = "Browse...",
                        placeholder = "No file selected"),
            textInput("sample_num",
                      "sample number:",
                      value = "",
                      placeholder = "..."),
            downloadButton(
              "sample_download",
              label="Example Input File",
              icon = shiny::icon("download")
            ),
            checkboxInput("isbulk", "Display Bulk Data (Coffey et. al.)?", value=FALSE)
        ),

        # Show data analysis outputs
        mainPanel(
          
          # image of core with specific sample location highlighted
          verbatimTextOutput("sampleheading"),
          htmlOutput("sample_on_core"),
          
          # input data table
          verbatimTextOutput("heading1"),
          tableOutput("inputTable"),
          
          # data table for graph
          verbatimTextOutput("heading2"),
          tableOutput("adjustedInput"),
          
          # graph with weighted linear regression
          verbatimTextOutput("heading2_5"),
          plotlyOutput("distPlot2", height="700", width="100%"),
          
          br(),
          
          # Age determinations based on weighted linear regression
          verbatimTextOutput("heading3")
        )
    )
)

# Server Logic
server <- function(input, output) {
    
    sample_data <- read.csv("sample.csv")
    
    # heading for core image   
    output$sampleheading <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        "Sample Position:"
    })
    
    # Display core image based on text input
    # TODO:
    #   - generalize so that it reads folder of core images
    #   - ask for which core
    output$sample_on_core <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        if(strcmpi(input$sample_num, "1") || strcmpi(input$sample_num, "one"))
        {
            ret <- c('<img src="', "images/1.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "2") || strcmpi(input$sample_num, "two"))
        {
            ret <- c('<img src="', "images/2.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "3") || strcmpi(input$sample_num, "three"))
        {
            ret <- c('<img src="', "images/3.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "4") || strcmpi(input$sample_num, "four"))
        {
            ret <- c('<img src="', "images/4.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "5") || strcmpi(input$sample_num, "five"))
        {
            ret <- c('<img src="', "images/5.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "6") || strcmpi(input$sample_num, "six"))
        {
            ret <- c('<img src="', "images/6.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "7") || strcmpi(input$sample_num, "seven"))
        {
            ret <- c('<img src="', "images/7.png", '" width="80%">')
        }
        else if(strcmpi(input$sample_num, "8") || strcmpi(input$sample_num, "eight"))
        {
            ret <- c('<img src="', "images/8.png", '" width="80%">')
        }
        else 
        {
            ret <- c("invalid or incorrect sample number entered")
        }
        ret
    })
  
    # heading for first data table  
    output$heading1 <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        "Input:"
        })

    # Display input table    
    output$inputTable <- renderTable({
        req(input$sample_csv)
        req(input$sample_num)
        
        sample_i <- input$sample_csv
        
        # display error message if no input was given
        ext <- tools::file_ext(sample_i$datapath)
        req(sample_i)
        validate(need(ext == "csv", "Please upload a csv file"))
        
        data <- read.csv(sample_i$datapath, header=TRUE)
        data
    })
  
    # heading for calculated data table  
    output$heading2 <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        "Data for Linear Regression:"
        })
  
    # Calculate and print revised dataframe that will be used for graphing  
    output$adjustedInput <- renderTable({
        req(input$sample_csv)
        req(input$sample_num)
        
        sample <- read.table(input$sample_csv$datapath, sep=',', header=TRUE)
        
        # output from function defined at top
        ret <- summary_stat_df(input, sample)
        
        plot_data <- ret$plot_data
        
        # re-name the columns of the table
        names(plot_data)[1] <- "2M1 %"
        names(plot_data)[2] <- "Ages (Ma)"
        
        plot_data
    })
  
    # heading for graph  
    output$heading2_5 <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        "Graph with York Regression:"
    })

    # Display graph with weighted linear regression
    output$distPlot2 <- renderPlotly({
        req(input$sample_csv)
        req(input$sample_num)
        sample <- read.table(input$sample_csv$datapath, sep=',', header=TRUE)
        
        # output from function defined at top
        ret <- summary_stat_df(input, sample)
        plot_data <- ret$plot_data
        sample <- ret$sample
        
        X <- sample$detritalPercent[1:nrow(sample) - 1]
        Y <- sample$age[1:nrow(sample) - 1]
        sX <- sample$detritalError[1:nrow(sample) - 1]
        sY <- sample$ageError[1:nrow(sample) - 1]
        
        data <- cbind(X, sX, Y, sY)
        
        fit <- york(data)
        trend2 <- function(x) (fit$b[1]*x) + fit$a[1]
        
        # making dataframe that will be used to graph trendline
        trend_data <- data.frame(
            x = c(0:100)
        )
        y_col <- trend2(trend_data$x)
        trend_data$y <- y_col
        
        # initialize graph with proper x-axis range
        base <- ggplot() + xlim(0,100)
        
        if (input$isbulk)
        {
          # calculations for bulk sample (will be the singular pink point)
          bulk_x <- sample$detritalPercent[nrow(sample)]
          bulk_xmin <- sample$detritalPercent[nrow(sample)] - sample$detritalError[nrow(sample)]
          bulk_xmax <- sample$detritalPercent[nrow(sample)] + sample$detritalError[nrow(sample)]
          bulk_y <- sample$age[nrow(sample)]
          bulk_ymin <- sample$age[nrow(sample)] - sample$ageError[nrow(sample)]
          bulk_ymax <- sample$age[nrow(sample)] + sample$ageError[nrow(sample)]
        
          # arrange bulk sample calculations into a new dataframe
          bulk <- data.frame(x=bulk_x,
                            y = bulk_y,
                            ymin = bulk_ymin,
                            ymax = bulk_ymax,
                            xmin=bulk_xmin, 
                            xmax=bulk_xmax)
        }
        
        # add trend line to graph
        age_plot <- base + 
            geom_line(aes(x=trend_data$x, y=trend_data$y), linetype="dashed", color="grey", size=1.5)
        
        if(input$isbulk)
        {
          # add size-fraction data and bulk data to the graph
          age_plot <- age_plot +
              geom_point(data=plot_data, aes(x = x, y = y), size=4, shape="square") + 
              geom_errorbar(data=plot_data, mapping=aes(x=x,ymin=ymin,ymax=ymax), width=1, size=0.5) + 
              geom_errorbarh(data=plot_data, mapping=aes(y=y,xmin=xmin, xmax=xmax), size=0.5) +
              theme_minimal() +
              geom_point(data=bulk, aes(x=x, y=y), size=4, shape="square", color="orchid2") +
              geom_errorbar(data=bulk, mapping=aes(x=x,ymin=ymin,ymax=ymax), width=1, size=0.5, color="orchid2") +
              geom_errorbarh(data=bulk, mapping=aes(y=y,xmin=xmin, xmax=xmax), size=0.5, color="orchid2") +
              ylim(0,NA) +
              labs(x="Percent 2M1", y="Age (Ma)") +
              theme(
                  axis.text.x = element_text(size=15),
                  axis.text.y = element_text(size=15),
                  axis.title.y = element_text(size=20, margin=margin(r=20)),
                  axis.title.x = element_text(size=20, margin=margin(t=20))
              )
        }
        else
        {
          age_plot <- age_plot +
            geom_point(data=plot_data, aes(x = x, y = y), size=4, shape="square") + 
            geom_errorbar(data=plot_data, mapping=aes(x=x,ymin=ymin,ymax=ymax), width=1, size=0.5) + 
            geom_errorbarh(data=plot_data, mapping=aes(y=y,xmin=xmin, xmax=xmax), size=0.5) +
            theme_minimal() +
            ylim(0,NA) +
            labs(x="Percent 2M1", y="Age (Ma)") +
            theme(
              axis.text.x = element_text(size=15),
              axis.text.y = element_text(size=15),
              axis.title.y = element_text(size=20, margin=margin(r=20)),
              axis.title.x = element_text(size=20, margin=margin(t=20))
            )
        }
        
        # return interactive plotly graph
        ggplotly(age_plot)
       
    })
    
    
    
    # Display authigenic and detrital ages beneath graph
    output$heading3 <- renderText({
        req(input$sample_csv)
        req(input$sample_num)
        
        sample <- read.table(input$sample_csv$datapath, sep=',', header=TRUE)
        
        # output from function defined at top
        ret <- summary_stat_df(input, sample)
        plot_data <- ret$plot_data
        sample <- ret$sample
        
        # calculate york regression

        X <- sample$detritalPercent[1:nrow(sample) - 1]
        Y <- sample$age[1:nrow(sample) - 1]
        sX <- sample$detritalError[1:nrow(sample) - 1]
        sY <- sample$ageError[1:nrow(sample) - 1]
        
        data <- cbind(X, sX, Y, sY)
        
        fit <- york(data)
        trend2 <- function(x) (fit$b[1]*x) + fit$a[1]
        
        
        # Formatting text output
        line1 <- paste("Age of Authigenic Illite:", 
                       round(fit$a[1], 4), 
                       "Ma +/-", 
                       round(fit$a[2], 4), 
                       sep="\t")
        line2 <- paste("Age of Detrital Minerals:", 
                       round(trend2(100), 4), 
                       "Ma +/-", 
                       round((fit$a[2] + (fit$b[2]*100)), 4),
                       sep="\t")
        
        combined_lines <- paste(line1, line2, sep="\n")
    })
    
    output$sample_download <- downloadHandler(
      filename = function() {
        paste("sample-SAFOD-input.csv", sep="")
      },
      content = function(file) {
        write.csv(sample_data, file, row.names=FALSE)
      }
    )
    
}

# Run the application 
shinyApp(ui = ui, server = server)
#}
