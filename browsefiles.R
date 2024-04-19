library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Directory Browser"),
  textInput("dirpath", "Enter directory path:", value = "~/"),
  actionButton("go", "Go"),
  # actionButton("back", "Back"),
  uiOutput("file_list_ui"),
  verbatimTextOutput("selected_file")
)


server <- function(input, output, session) {
  current_dir <- reactiveVal(getwd()) # Reactive value to store current directory
  
  observeEvent(input$go, {
    # Update current directory when 'Go' is clicked
    tryCatch({
      new_dir <- normalizePath(input$dirpath, mustWork = TRUE)
      current_dir(new_dir)
    }, error = function(e) {
      # Handle error if path is not valid
      current_dir(getwd())
      showModal(modalDialog(
        title = "Error",
        "Invalid directory path. Please enter a valid path."
      ))
    })
  })
  
  # observeEvent(input$back, {
  #   # Navigate to the parent directory
  #   setwd(current_dir())  # Ensure the working directory is set to current_dir
  #   parent_dir <- dirname(getwd())
  #   current_dir("../")
  #   updateTextInput(session, "dirpath", value = current_dir())
  # })
  
  output$file_list_ui <- renderUI({
    # List files and directories in the current directory
    dir_contents <- list.files(current_dir(), full.names = TRUE)
    file_buttons <- lapply(seq_along(dir_contents), function(i) {
      path <- dir_contents[i]
      btn_id <- paste0("btn_", i) # Unique ID for each button
      if (file.info(path)$isdir) {
        actionButton(btn_id, label = basename(path))
      } else {
        span(basename(path)) # Just display the file name for files
      }
    })
    do.call(tagList, file_buttons) # Return a list of buttons
  })
  
  # This observer reacts to any button press
  observe({
    lapply(seq_along(list.files(current_dir(), full.names = TRUE)), function(i) {
      btn_id <- paste0("btn_", i)
      observeEvent(input[[btn_id]], {
        # If it's a directory, change to that directory when clicked
        path <- list.files(current_dir(), full.names = TRUE)[i]
        if (file.info(path)$isdir) {
          current_dir(path) # Update the current directory
          updateTextInput(session, "dirpath", value = path)
        }
      }, ignoreNULL = TRUE)
    })
  })
}


# Run the app
shinyApp(ui = ui, server = server)

# # Define server logic
# server <- function(input, output, session) {
#   current_dir <- reactiveVal(getwd()) # Reactive value to store current directory
#   
#   observeEvent(input$go, {
#     # Update current directory when 'Go' is clicked
#     tryCatch({
#       new_dir <- normalizePath(input$dirpath, mustWork = TRUE)
#       current_dir(new_dir)
#     }, error = function(e) {
#       # Handle error if path is not valid
#       current_dir(getwd())
#       showModal(modalDialog(
#         title = "Error",
#         "Invalid directory path. Please enter a valid path."
#       ))
#     })
#   })
#   
#   output$file_list_ui <- renderUI({
#     # List files and directories in the current directory
#     dir_contents <- list.files(current_dir(), full.names = TRUE)
#     file_paths <- lapply(dir_contents, function(path) {
#       btn_id <- gsub("[[:punct:]]", "", basename(path)) # Clean-up ID
#       if (file.info(path)$isdir) {
#         actionButton(btn_id, label = basename(path), class = "dir-button")
#       } else {
#         actionButton(btn_id, label = basename(path), class = "file-button")
#       }
#     })
#     do.call(tagList, file_paths) # Return a list of buttons
#   })
#   
#   # Detect any button click
#   observe({
#     dir_contents <- list.files(current_dir(), full.names = TRUE)
#     for (path in dir_contents) {
#       btn_id <- gsub("[[:punct:]]", "", basename(path))
#       output$selected_file <- renderText({basename(path)})
#       if (file.info(path)$isdir) {
#               # If it's a directory, change to that directory when clicked
#               observeEvent(input[[btn_id]], {
#                 current_dir(path)
#                 updateTextInput(session, "dirpath", value = path)
#               }, ignoreNULL = FALSE)
#       }
#       # output$selected_file <- renderText({paste(dir_contents)})
#       # btn_id <- gsub("[[:punct:]]", "", basename(path))
#     }
#   })
#   # observe({
#   #   dir_contents <- list.files(current_dir(), full.names = TRUE)
#   #   for (path in dir_contents) {
#   #     btn_id <- gsub("[[:punct:]]", "", basename(path))
#   #     if (file.info(path)$isdir) {
#   #       # If it's a directory, change to that directory when clicked
#   #       observeEvent(input[[btn_id]], {
#   #         current_dir(path)
#   #         updateTextInput(session, "dirpath", value = path)
#   #       }, ignoreNULL = FALSE)
#   #     } else {
#   #       # If it's a file, update the selected file output
#   #       observeEvent(input[[btn_id]], {
#   #         output$selected_file <- renderText({ path })
#   #       }, ignoreNULL = FALSE)
#   #     }
#   #   }
#   # })
# }
