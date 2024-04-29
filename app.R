library(shiny)

# Mock scripts list
# setwd("~/Scikit-Coins")
scripts <- "./workflows"
scripts_dir <- normalizePath("./workflows", mustWork = TRUE)
home_dir <- normalizePath("~", mustWork = TRUE)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .container-fluid {
        margin-top: 20px;
      }
      .logo-container {
        height: 150px; /* Adjust the height as needed */
        margin-bottom: 20px; /* Add margin to separate from other elements */
      }
      .custom-panel {
        background-color: #ffffff;
        padding: 50px;
        border-radius: 20px;
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
        margin-bottom: 20px;
      }
      .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
        color: #fff;
      }
      .btn-primary:hover {
        background-color: #0056b3;
        border-color: #0056b3;
        color: #fff;
      }
      .input-primary input[type='text'] {
        width: 40%;
        min-width: 500px;
      } #logo {
        position: absolute;
        top: 10px;
        left: 10px;
        width: 300px; /* Adjust the width as needed */
        height: auto;
      }
    "))
  ),
  div(class = "logo-container",
      tags$img(src = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3texyMB4zGZLeQYZ33OeeyARFPDZ4wFytCNSJF7zM&s", id = "logo")
  ),
  div(style = "text-align: center; margin: 2.5%",
      tags$h1('Dynamic SLURM Job Submission App')
  ),
  div(class = "container-fluid custom-panel",
      selectInput("workflow", "Select workflow", choices = c(list.files(scripts))),
      uiOutput("dynamic_ui"),
      actionButton("submit_job", "Submit SLURM Job", class = "btn-primary"),
      br(),
      verbatimTextOutput("job_output")
  )
)

# # Define UI
# ui <- fluidPage(
#   titlePanel("Dynamic SLURM Job Submission App"),
#   selectInput("workflow", "Select workflow", list.files(scripts)),
#   uiOutput("dynamic_ui"),  # This will dynamically change based on the script selected
#   # uiOutput("file_select"),
#   # fileInput("file2", "Choose file to upload"),
#   actionButton("submit_job", "Submit SLURM Job"),
#   verbatimTextOutput("job_output")
# )

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
      
      # Interface for Edge Based Segmentation
      
      # output_loc <- file.path(scripts_dir, shQuote("Edge Based Segmentation"), "edge_based.png")
      
      output_loc <- file.path(home_dir, "edge_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location (Must be a png file)", 
                            value = output_loc)),
        column(4)  # Offset by three columns
      )
      
    } else if (input$workflow == "Region Based Segmentation") {
      # output_loc <- file.path(scripts_dir, shQuote("Region Based Segmentation"), "region_based.png")
      
      output_loc <- file.path(home_dir, "region_based.png")
      fluidRow(
        column(3),  # Offset by three columns
        column(5, textInput("output_location", "Output Location (Must be a png file)", 
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

