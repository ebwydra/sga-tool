fluidPage(
  theme = bs_theme(bootswatch = "pulse"),
  titlePanel("Small for Gestational Age (SGA) Tool"),
  p("Determine whether newborn babies are an appropriate size for gestational age at birth based on the 2013 Fenton growth charts."), 
  p(strong("How to use:"), "Enter information for a single baby directly via the user interface, or get results for multiple babies via file upload using one of two easy-to-use templates."),
  p(strong("Data source:"), "Fenton TR, Kim JH.", a(href="https://doi.org/10.1186/1471-2431-13-59", "A systematic review and meta-analysis to revise the Fenton growth chart for preterm infants."), "BMC Pediatr. 2013;13:59."),
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
                          htmlOutput("ga"),
                          htmlOutput("cutoff"),
                          htmlOutput("result"),
                          br(),
                          plotOutput('growth_plot')
                        )
                      )),
             
             
             tabPanel("Multiple Subjects",
                      sidebarLayout(
                        sidebarPanel(
                          p(strong("1. Download template (CSV)")),
                          helpText("There are two templates available: one based on dates (due date and date of birth) and the other based on gestational age (GA)."),
                          helpText("If you do not know the subject's due date or date of birth, you should use the GA template. Note that GA must be entered in exact weeks and days, not weeks completed."),
                          helpText("Weight should be provided in grams."),
                          br(),
                          downloadButton("date_template", "Date template"),
                          downloadButton("ga_template", "GA template"),
                          br(), br(), br(),
                          
                          p(strong("2. Enter subject data into template")),
                          helpText("Each template is pre-populated with a few rows of sample data so you can see how use the template. Feel free to delete these rows once you understand how to use the template!"),
                          helpText("As you enter subject data, take care not to change the column headings. When finished, be sure to save the file in CSV format."),
                          br(),
                          
                          fileInput("uploaded_file", strong("3. Upload CSV file containing subject data"),
                                    multiple = FALSE,
                                    accept = c("text/csv", 
                                               "text/comma-separated-values,text/plain",
                                               ".csv")),
                          p(strong("4. Download results (CSV)")),
                          helpText("Download a table containing your results in CSV format."), br(),
                          downloadButton("result_download", "Download results")
                        ),
                        mainPanel(
                          tableOutput("table_contents")
                        )
                      )),
             hr(),
             tags$footer("Made by Emma Brennan-Wydra.", a(href="https://github.com/ebwydra/sga-tool", "Source code available on Github."), align = "center", 
             style = "
              bottom:0;
              width:100%;
              height:50px;
              padding: 10px;
              z-index: 1000;")
  )
)


