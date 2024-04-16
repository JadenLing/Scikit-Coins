library(shiny)

# Mock scripts list
setwd("~/Scikit-Coins")
scripts <- "./scripts"
scripts_dir <- normalizePath("./scripts", mustWork = TRUE)

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
      # output <- paste0(scripts_dir, "/Edge Based Segmentation/edge_based.png")
      output <- file.path(scripts_dir, shQuote("Edge Based Segmentation"), "edge_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location", 
                            value = output)),
        column(4)  # Offset by three columns
      )
    } else if (input$workflow == "Region Based Segmentation") {
      # Interface for Script B
      output <- file.path(scripts_dir, shQuote("Region Based Segmentation"), "region_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location", 
                            value = output)),
        column(4)  # Offset by three columns
      )
    }
  })
  
  observeEvent(input$submit_job, {
    # Depending on the script, construct the command differently
    if (input$workflow == "Edge Based Segmentation") {
      script_file_folder <- file.path(scripts_dir, shQuote("Edge Based Segmentation"))
      script_file_path <- file.path(scripts_dir, shQuote("Edge Based Segmentation"), "testscript.sh")
      # sbatch_command <- sprintf("sbatch %s %s %s", script_file_path, script_file_folder, input$output_location)
      

    } else if (input$workflow == "Region Based Segmentation") {
      script_file_folder <- file.path(scripts_dir, shQuote("Region Based Segmentation"))
      script_file_path <- file.path(scripts_dir, shQuote("Region Based Segmentation"), "testscript.sh")
      
      # Construct the command for Script B using input$input_b1 and input$input_b2
    }
    
    sbatch_command <- sprintf("sbatch %s %s %s", script_file_path, script_file_folder, input$output_location)
    
    # result <- system(sbatch_command, intern = TRUE)
    
    ## IMPORTANT: Try to get the output location to work properly in the script
    
    # Example placeholder for job submission output
    output$job_output <- renderText({
      # Replace this with the actual submission result
      result <- system(sbatch_command, intern = TRUE)

      paste("Job submission output:", result, sep = "\n")
      # paste("Pretend submission output for", input$workflow)
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)

