test_that("extract_table_columns works", {
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
  
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
  results <- extract_table_columns(json_template,"study_variables")
  expect_equal(nrow(results),9)
})
test_that("extract_table_columns -failure works", {
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
  results <- extract_table_columns(json_template,"random_name")
  expect_equal(results,"Failed")
  
})