test_that("relation extraction from json works", {
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
    
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
  results <- extract_relation_json(json_template,"study_variables")
  expect_equal(ncol(results),4)
  
})

test_that("relation extraction from json - failure works", {
  json_template_path <- system.file("extdata",
                                    "RWEBRIDGE_schema.json",
                                    package = "RWEBRIDGECHECKER")
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
  results <- extract_relation_json(json_template,"random_name")
  expect_equal(results,"Failed")
  
})
