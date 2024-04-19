library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Directory Browser"),
  textInput("dirpath", "Enter directory path:", value = getwd()),
  actionButton("go", "Go"),
  actionButton("back", "Go Back"),
  uiOutput("file_list_ui"),
  verbatimTextOutput("selected_file")
)

# Define server logic
server <- function(input, output, session) {
  current_dir <- reactiveVal(getwd()) # Reactive value to store current directory
  
  observeEvent(input$go, {
    # Safely update current directory when 'Go' is clicked
    tryCatch({
      if(nzchar(input$dirpath)) { # Ensure the input is not empty
        new_dir <- normalizePath(input$dirpath, mustWork = TRUE)
        current_dir(new_dir) # Update only if path is successfully normalized
      }
    }, error = function(e) {
      # Handle error if path is not valid
      showModal(modalDialog(
        title = "Error",
        paste("Error in path: ", e$message), # Show the specific error message
        easyClose = TRUE,
        footer = NULL
      ))
      current_dir(getwd()) # Reset to working directory
    })
  })
  
  observeEvent(input$back, {
    # Navigate to the parent directory
    tryCatch({
      setwd(current_dir()) # Ensure the working directory is set to current_dir
      parent_dir <- dirname(getwd())
      if(file.exists(parent_dir)) {
        current_dir(parent_dir)
        updateTextInput(session, "dirpath", value = current_dir())
      }
    }, error = function(e) {
      showModal(modalDialog(
        title = "Error",
        paste("Error navigating to parent directory: ", e$message),
        easyClose = TRUE,
        footer = NULL
      ))
    })
  })
  
  output$file_list_ui <- renderUI({
    # List files and directories in the current directory
    dir_contents <- list.files(current_dir(), full.names = TRUE)
    file_buttons <- lapply(seq_along(dir_contents), function(i) {
      path <- dir_contents[i]
      btn_id <- paste0("btn_", i)  # Unique ID for each button
      if (file.info(path)$isdir) {
        actionButton(btn_id, label = basename(path))
      } else {
        span(basename(path))  # Just display the file name for files
      }
    })
    do.call(tagList, file_buttons)  # Return a list of buttons
  })
  
  # This observer reacts to any button press
  observe({
    lapply(seq_along(list.files(current_dir(), full.names = TRUE)), function(i) {
      btn_id <- paste0("btn_", i)
      observeEvent(input[[btn_id]], {
        path <- list.files(current_dir(), full.names = TRUE)[i]
        if (file.info(path)$isdir) {
          current_dir(path)  # Update the current directory
          updateTextInput(session, "dirpath", value = path)
        }
      }, ignoreNULL = TRUE)
    })
  })
}

# Run the app
shinyApp(ui = ui, server = server)
