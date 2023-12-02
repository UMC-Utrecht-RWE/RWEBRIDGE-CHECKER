test_that("check_table results", {
  
  # Read schema in json
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
  
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
  
  # Read a list of tables
  csv_paths <- c(system.file("extdata",
                             "study_variables.csv",
                             package = "RWEBRIDGECHECKER"),
                 system.file("extdata",
                             "dictionary.csv",
                             package = "RWEBRIDGECHECKER")
  )
  table_names <- c("study_variables","dictionary")
  check_table_results <- check_table(csv_paths,
                                     table_names,
                                     json_template_path)
  
  expect_setequal(c("Passed","Failed","Failed","Failed"), 
                  check_table_results[[1]]$column_content)
  expect_setequal(c("study_variables","dictionary","code_list","dap"), 
                  check_table_results[[1]]$table_name)
  expect_equal(nrow(check_table_results[[2]]),3)
})
