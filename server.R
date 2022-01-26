function(input, output) {
  
  output$dob_as_character <- renderText({
    as.character(input$duedate)
  })
  
  output$dob_raw <- renderText({
    input$duedate
  })
  
  output$ga <- renderText({
    paste("GA at birth:", calculate_ga(input$duedate, input$dob), "weeks")
  })
  
  output$cutoff <- renderText({
    ga <- calculate_ga(input$duedate, input$dob)
    if (ga > 45 | ga < 22.57) {
      paste(determine_cutoff(ga, input$sex))
    } else {
      paste("Cutoff:", determine_cutoff(ga, input$sex), "grams")
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
  
}