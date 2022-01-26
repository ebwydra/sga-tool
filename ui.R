fluidPage(
  
  titlePanel("SGA Tool"),
  p("Determine whether newborn babies are an appropriate size for gestational age at birth based on the 2013 Fenton growth charts. Enter information for a single baby directly via the user interface, or get results for multiple babies via file upload using one of two easy-to-use templates."),
  p(strong("Data Source:"), "Fenton TR, Kim JH. A systematic review and meta-analysis to revise the Fenton growth chart for preterm infants. BMC Pediatr. 2013;13:59. doi:10.1186/1471-2431-13-59"),
  navbarPage("Select Format",
             tabPanel("Multiple Subjects",
                      sidebarLayout(
                        sidebarPanel(
                          p(strong("1. Download template (CSV)")),
                          helpText("There are two templates available: one based on dates (due date and date of birth) and the other based on gestational age (GA)."),
                          helpText("If you do not know the subject's due date or date of birth, you should use the GA template. Note that GA must be entered in exact weeks and days, not weeks completed."),
                          helpText("Weight should be provided in grams."),
                          downloadButton("date_template", "Download date template"),
                          downloadButton("ga_template", "Download GA template"),
                          br(), br(), br(),
                          
                          p(strong("2. Enter subject data into template")),
                          helpText("Each template is pre-populated with a few rows of sample data so you can see how to enter data into the template. Feel free to delete these rows once you understand how to use the template!"),
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
                      )),         
             
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
             ))
    
     
  )
)


