#' rwebridgechecker shiny app
#'
#' In the console, type: rwebridgechecker_app()
#' @param ... no argument is supplied
#'
#' @return Opens the shiny app in a new window or in browser
#' @export
#'

rwebridgechecker_app <- function(...) {
  # File upload size is increased
  options(shiny.maxRequestSize = 100 * 1024^2)
  # temp directory for results
  output_directory <- tempdir()
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
  ui <- shiny::fluidPage(
    theme = shinythemes::shinytheme("spacelab"),
    #shiny::h1("RWEBRIDGE-CHECKER"),
    shiny::h3("RWEBRIDGE-CHECKER: Consistency check for metadata tables with RWE-BRIDGE schema"),
    shiny::navbarPage("CHECK",
      shiny::tabPanel("Select table(s) in csv format",
                      shiny::fluidRow(
                        shiny::column(width = 12,
                                      shiny::fileInput("table_files",
                                                       "Upload the table(s)",
                                                       accept = ".csv",
                                                       multiple = T)),
                        ),
                      shiny::actionButton("Go","Check consistency"),
                      shiny::h4(""),
                      shiny::h4("File format results"),
                      shiny::tableOutput("format_table"),
                      shiny::h4(""),
                      shiny::h4("Table content information within relation schema"),
                      shiny::tableOutput("relation_table"),
                      ),
      shiny::tabPanel("Generate report",
                      shiny::h4("Download html report for the checked file(s)"),
                      shiny::downloadButton(
                        outputId = "report",
                        label = "Generate report")
                      )
      )
    )

  server <- function(input, output, session) {
    
    # Study variables vs events, drugs, vaccines, additional concepts, algorithms codelists
    shiny::observeEvent(input$Go, {
      
      check_table_results <- check_table(input$table_files$datapath, 
                                         gsub("\\.csv","",input$table_files$name),
                                         json_template_path, 
                                         delimiter = ",")
      output$format_table <- shiny::renderTable({
        check_table_results[1]
      })
      output$relation_table <- shiny::renderTable({
        check_table_results[2]
      })
        
      # Save format_table
      utils::write.table(check_table_results[1], paste(output_directory,
                                                       "format_table.csv",
                                                       sep = "/"), row.names = F,
                           quote = F, sep = ",")
      
      # Save relation_table
      utils::write.table(check_table_results[2], paste(output_directory,
                                                       "relation_table.csv",
                                                       sep = "/"), row.names = F,
                         quote = F, sep = ",")
        
      }
    )

    output$report <- shiny::downloadHandler(
      filename <-  "rwebridgechecker_report.html",
      content = function(file) {
        tempReport <- file.path(output_directory, 
                                "rwebridgechecker_report.Rmd")
        file.copy(system.file("rmd",
                              "rwebridgechecker_report.Rmd",
                              package = "RWEBRIDGECHECKER"),
                  tempReport, 
                  overwrite = TRUE)
        params <- list(output_dir = output_directory)
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
    session$onSessionEnded(function() {
      shiny::stopApp()
    })
  }
  shiny::shinyApp(ui, server)

}
