library(shiny)

# Mock scripts list
scripts <- "./scripts"

# Define UI
ui <- fluidPage(
  titlePanel("Dynamic SLURM Job Submission App"),
  selectInput("workflow", "Select workflow", list.files(scripts)),
  uiOutput("dynamic_ui"),  # This will dynamically change based on the script selected
  actionButton("submit_job", "Submit SLURM Job"),
  verbatimTextOutput("job_output")
)

# Define server logic
server <- function(input, output) {
  
  # Dynamic UI based on the selected workflow
  output$dynamic_ui <- renderUI({
    if (input$workflow == "Edge Based Segmentation") {
      # Interface for Script A
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location", 
                            value = "/home/users/allstaff/ling.j/trial_slurm/output.txt")),
        column(4)  # Offset by three columns
      )
    } else if (input$workflow == "Region Based Segmentation") {
      # Interface for Script B
      fluidRow(
        column(4),  # Offset by four columns
        column(2, numericInput("input_b1", "Input for B1", value = 5)),
        column(2, checkboxInput("input_b2", "Option for B2", value = TRUE)),
        column(4)  # Offset by four columns
      )
    }
  })
  
  observeEvent(input$submit_job, {
    # Depending on the script, construct the command differently
    if (input$workflow == "Edge Based Segmentation") {
      sbatch_command <- sprintf("sbatch testscript.sh")
      # Construct the command for Script A using input$input_a1 and input$input_a2
    } else if (input$workflow == "Region Based Segmentation") {
      sbatch_command <- sprintf("sbatch testscript.sh")
      # Construct the command for Script B using input$input_b1 and input$input_b2
    }
    
    
    # Example sbatch command (you would adjust this based on the selected script and inputs)
    # sbatch_command <- sprintf("sbatch your_script.sh")
    # Example system call (adjust according to your actual command construction logic)
    # result <- system(sbatch_command, intern = TRUE)
    
    ## IMPORTANT: Try to get the output location to work properly in the script
    
    # Example placeholder for job submission output
    output$job_output <- renderText({
      # Replace this with the actual submission result
      result <- system("ls", intern = TRUE)
      
      paste("Job submission output:", result, sep = "\n")
      # paste("Pretend submission output for", input$workflow)
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)

