function(input, output) {
  
  output$ga <- renderText({
    paste("GA at birth:", calculate_ga(input$duedate, input$dob), "weeks")
  })
  
  output$cutoff <- renderText({
    ga <- calculate_ga(input$duedate, input$dob)
    if (ga > 45 | ga < 22.57) {
      paste(determine_cutoff(ga, input$sex))
    } else {
      paste("Cutoff for GA and sex:", determine_cutoff(ga, input$sex), "grams")
    }
  })
  
  output$result <- renderText({
    ga <- calculate_ga(input$duedate, input$dob)
    cutoff <- determine_cutoff(ga, input$sex)
    if (cutoff == "Out of range!") {
      paste("GA must be between 22.57 weeks (22 weeks 4 days) and 45 weeks.")
    } else{
      paste("Result:", compare_weight(cutoff, input$weight))
    }
    
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
    output <- process_df(df)
    return(output)
  })
  
}

