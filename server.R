function(input, output) {
  
  ga <- reactive({
    calculate_ga(input$duedate, input$dob)
  })
  
  cutoff <- reactive({
    determine_cutoff(ga(), input$sex)
  })
  
  result <- reactive({
    if (cutoff() == "Out of range!") {
      return(NULL)
    } else {
      compare_weight(cutoff(), input$weight)
    }
  })
  
  result_plot <- reactive({
    plot_weight(ga(), input$weight)
  })
  
  output$ga <- renderText({
    #paste("GA at birth:", calculate_ga(input$duedate, input$dob), "weeks")
    paste("GA at birth:", ga(), "weeks")
  })
  
  output$cutoff <- renderText({
    #ga <- calculate_ga(input$duedate, input$dob)
    if (ga() > 45 | ga() < 22.57) {
      paste(cutoff())
    } else {
      paste("Cutoff for GA and sex:", cutoff(), "grams")
    }
  })

  output$result <- renderText({
    if (is.null(result())) {
      paste("GA must be between 22.57 weeks (22 weeks 4 days) and 45 weeks.")
    } else {
      paste("Result:", result())
    }
  })
  
  output$growth_plot <- renderPlot({
    result_plot()
  })
  
  output$date_template <- downloadHandler(
    filename = "date-template.csv",
    content = function(file) {
      write.csv(date_template, file, row.names=FALSE)
    }
  )
  
  output$ga_template <- downloadHandler(
    filename = "ga-template.csv",
    content = function(file) {
      write.csv(ga_template, file, row.names=FALSE)
    }
  )
  
  output$table_contents <- renderTable({
    
    # Parse upload contents
    req(input$uploaded_file)
    tryCatch(
      {
        df <- read.csv(input$uploaded_file$datapath)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    #return(df)
    
    # Determine SGA for subjects in uploaded table
    output <- process_df(df)
    return(output)
  })
  
}

