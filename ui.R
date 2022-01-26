fluidPage(
  
  titlePanel("SGA Tool"),
  p("Determine whether newborn babies are an appropriate size for gestational age at birth."),
  
  navbarPage("Select Format",
    tabPanel("Single Subject",
             sidebarLayout(
               sidebarPanel(
                 dateInput("duedate", label="Due date (yyyy-mm-dd)"),
                 dateInput("dob", label="Date of birth (yyyy-mm-dd)"),
                 selectInput("sex", label="Sex", choices=c("Female", "Male", "Unknown")),
                 numericInput("weight", label="Weight at birth (grams)", 3000)
               ),
               mainPanel(
                 verbatimTextOutput("ga"),
                 verbatimTextOutput("cutoff"),
                 verbatimTextOutput("result")
               )
             )),
    tabPanel("Multiple Subjects")
  )
)
  



