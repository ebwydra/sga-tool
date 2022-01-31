function(input, output) {
  
  # Reactives
  
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
  
  result_table <- reactive({
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
    
    # Determine SGA for subjects in uploaded table
    output <- process_df(df)
    return(output)
  })
  
  # Output rendering
  
  output$ga <- renderText({
    paste("<strong>", "GA at birth:", "</strong>", ga(), "weeks")
  })
  
  output$cutoff <- renderText({
    if (ga() > 45 | ga() < 22.57) {
      paste("<p class=\"text-danger\"><strong>Error: </strong>", cutoff(), " GA must be between 22.57 weeks (22 weeks 4 days) and 45 weeks.</p>")
    } else {
      paste("<strong>", "SGA cutoff based on GA and sex:", "</strong>", cutoff(), "grams")
    }
  })

  output$result <- renderText({
    if (is.null(result())) {
      paste(NULL)
    } else {
      paste("<strong>", "Result:", "</strong>", result())
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
    result_table()
  }, striped = TRUE, bordered = TRUE, hover = TRUE, na = "")
  
  output$result_download <- downloadHandler(
    filename = "sga_results.csv",
    content = function(file) {
      write.csv(result_table(), file, row.names=FALSE)
    }
  )
  
}

