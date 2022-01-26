fluidPage(
  
  titlePanel("SGA Tool"),
  p("Determine whether newborn babies are an appropriate size for gestational age at birth."),
  
  navbarPage("Select Format",
    tabPanel("Single Subject",
             sidebarLayout(
               sidebarPanel(
                 dateInput("duedate", label="Due date (mm-dd-yyyy)", format="mm-dd-yyyy"),
                 dateInput("dob", label="Date of birth (mm-dd-yyyy)", format="mm-dd-yyyy"),
                 selectInput("sex", label="Sex", choices=c("Female", "Male", "Unknown")),
                 numericInput("weight", label="Weight at birth (grams)", 3000)
               ),
               mainPanel(
                 verbatimTextOutput("ga"),
                 verbatimTextOutput("cutoff"),
                 verbatimTextOutput("result")
               )
             )),
    
    tabPanel("Multiple Subjects",
             sidebarLayout(
               sidebarPanel(
                 p(strong("1. Download template (CSV)")),
                 helpText("There are two templates available: one based on dates (due date and date of birth) and the other based on gestational age (GA)."),
                 downloadButton("date_template", "Download date template"),
                 downloadButton("ga_template", "Download GA template"),
                 br(), br(), br(),
                 p(strong("2. Fill in template with subject data")),
                 helpText("Each template is pre-populated with a few rows of sample data so you can see how to enter data into the template. Feel free to delete these rows."),
                 helpText("As you enter subject data, take care not to change the column headings. When finished, be sure to save the file in CSV format."),
                 br(),
                 fileInput("uploaded_file", "3. Upload CSV file containing subject data",
                           multiple = FALSE,
                           accept = c("text/csv", 
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
               ),
               mainPanel(
                 tableOutput("table_contents")
               )
             ))
  )
)
  



