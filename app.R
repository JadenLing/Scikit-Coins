library(shiny)

# Mock scripts list
# setwd("~/Scikit-Coins")
scripts <- "./workflows"
scripts_dir <- normalizePath("./workflows", mustWork = TRUE)

# Define UI
ui <- fluidPage(
  titlePanel("Dynamic SLURM Job Submission App"),
  selectInput("workflow", "Select workflow", list.files(scripts)),
  uiOutput("dynamic_ui"),  # This will dynamically change based on the script selected
  # uiOutput("file_select"),
  # fileInput("file2", "Choose file to upload"),
  actionButton("submit_job", "Submit SLURM Job"),
  verbatimTextOutput("job_output")
)

# Define server logic
server <- function(input, output) {
  
  # # Directory in HPC system where the files are stored 
  # hpc_files_dir <- "~"
  # 
  # # List files in the directory to select from
  # available_files <- list.files(hpc_files_dir, full.names = TRUE)
  # 
  # # Update the select input with the list of files
  # output$file_select <- renderUI({
  #   selectInput("selected_file", "Choose a file:", available_files)
  # })
  
  # Dynamic UI based on the selected workflow
  output$dynamic_ui <- renderUI({
    if (input$workflow == "Edge Based Segmentation") {
      # Interface for Script A
      # output <- paste0(scripts_dir, "/Edge Based Segmentation/edge_based.png")
      output_loc <- file.path(scripts_dir, shQuote("Edge Based Segmentation"), "edge_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location", 
                            value = output_loc)),
        column(4)  # Offset by three columns
      )
    } else if (input$workflow == "Region Based Segmentation") {
      # Interface for Script B
      output_loc <- file.path(scripts_dir, shQuote("Region Based Segmentation"), "region_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location", 
                            value = output_loc)),
        column(4)  # Offset by three columns
      )
    } else if (input$workflow == "HDAB") {
      file_loc <- file.path(scripts_dir, shQuote("HDAB"))
      
      fluidRow(
        column(6, textInput("input_location", "Input Location", 
                            value = file_loc)),
      
        column(6, textInput("output_location", "Output Location", 
                            value = file_loc))
      )
    }
  })
  
  observeEvent(input$submit_job, {
    # Depending on the script, construct the command differently
    
    ## ADD WORKFLOWS HERE
    
    if (input$workflow == "Edge Based Segmentation") {
      script_file_folder <- file.path(scripts_dir, shQuote("Edge Based Segmentation"))
      script_file_path <- file.path(scripts_dir, shQuote("Edge Based Segmentation"), "testscript.sh")
      # sbatch_command <- sprintf("sbatch %s %s %s", script_file_path, script_file_folder, input$output_location)
      

    } else if (input$workflow == "Region Based Segmentation") {
      script_file_folder <- file.path(scripts_dir, shQuote("Region Based Segmentation"))
      script_file_path <- file.path(scripts_dir, shQuote("Region Based Segmentation"), "testscript.sh")
      

    } else if (input$workflow == "HDAB") {
      script_file_folder <- file.path(scripts_dir, shQuote("HDAB"))
      script_file_path <- file.path(scripts_dir, shQuote("HDAB"), "submit_copy.sh")
      
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

