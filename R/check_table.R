#' Table content check based on json schema template for uploaded user csv tables
#'
#' @param user_table_csv_paths list of paths, provided by the user
#' @param table_names list of user table names
#' @param json_template_path path of json file for schema template
#' @param delimiter csv file delimiter, default ","
#'
#' @return list(table_format_results, combined_check_df) where table_format_results 
#' is a data frame with format information related with user tables, and 
#' combined_check_df is a data frame with table and related table information
#' @export 
#'
check_table <- function(user_table_csv_paths, table_names, json_template_path, delimiter = ","){
  # Get the table names
  #table_names <- gsub("\\.csv","",basename(user_table_csv_paths))
  # Read the json template schema
  json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE

  # Call extract_relation_json to get table relations
  table_relations <- as.data.frame(do.call(rbind, 
                                           lapply(table_names, 
                                                  function(x) 
                                                    extract_relation_json(json_template,x)
                                                  )
                                           )
                                   )
  # Check if supplied tables also contains related tables
  related_table_list <- setdiff(table_relations$related_table_name, table_names)
  related_table_list <- related_table_list[related_table_list!="Failed"]
  flag <- 0
  if (length(related_table_list) > 0){
    initial_results <- data.frame(table_name = related_table_list, 
                                  column_content = "Failed",
                                  column_note = "This related table is missing")
    flag <- 1
  } 
  
  user_table_info <- data.frame(table_paths = user_table_csv_paths, table_name = table_names)
  table_results <- as.data.frame(
    do.call(
      rbind,
      apply(user_table_info, 1,
             # tryCatch to handle unexpected csv formats
             function(x){
               try_output <- tryCatch(
                 expr = {
                   # Read table provided by the user
                   message(paste("Reading", x[2]))
                   user_table_df <- utils::read.csv(x[1], sep = delimiter)
                   },
                 error = function(e){
                   message(paste0("Check ", x[2], ", the csv is not in expected format!"))
                   #print(e)
                   return("Error")
                   }
                 )
               table_name <- gsub("\\.csv","",x[2])
               
               # Continue with error handling...
               if (any(try_output == "Error")){
                 column_content = "Failed"
                 column_note = "File is not in table format"
               } else {

                 if (ncol(user_table_df) < 2){
                   message(paste0(x[2]," is not in expected format (check delimiter)"))
                   column_content = "Failed"
                   column_note = "File has less than 2 columns, check the delimiter"
                 } else { 

                   # Check the content for columns

                   check_column_result <- extract_table_columns(json_template,table_name)
                   
                   if (length(check_column_result) == 1 && any("Failed" %in% check_column_result)){
                     column_content = check_column_result
                     column_note = paste0(table_name, " is not present in the schema. Check the naming of the table")
                   } else {
 
                     expected_column_list <- check_column_result$name
                     table_columns <- colnames(user_table_df)
                     if (identical(sort(table_columns), sort(expected_column_list))){
                       column_content = "Passed"
                       column_note = paste0(table_name, " has all the expected columns")
                     } else {
                       column_content = "Failed"
                       column_note = ""
                       if (length(setdiff(expected_column_list,table_columns)) > 0 ){
                         column_note = paste0(column_note, 
                                              table_name, 
                                              " is missing '",
                                              setdiff(expected_column_list,
                                                      table_columns),
                                              "' "
                                              )
                       }
                       if (length(setdiff(table_columns, expected_column_list)) > 0 ){
                         column_note = paste0(column_note, 
                                              table_name, 
                                              " has '",
                                              setdiff(table_columns, 
                                                      expected_column_list),
                                              "' which is not found in the schema")
                       }
                     }
                   }
                   
                   }
                 
               }
             
               return(data.frame(table_name = table_name, 
                                 column_content = column_content,
                                 column_note = column_note))
               })
      )
    )
  
  # File format information about supplied tables
  table_format_results <- table_results
  if (flag == 1){
    table_format_results <- rbind(table_results,initial_results)
  }
  
  # Content information within relation schema
  # Merge with table_relations
  
  colnames(table_format_results) = c("related_table_name",
                                     "related_column_content",
                                      "related_column_note")
  combined_check_df <- base::merge(table_relations, 
                                   table_format_results, 
                                   by = "related_table_name",
                                   all.x = T) 
    
  combined_check_df <- base::merge(combined_check_df, 
                                   table_results, 
                                   by = "table_name",
                                   all.x = T) 
    


  # Reorder the columns
  combined_check_df <- combined_check_df[,c("table_name",
                                            "primary_key",
                                            "column_content",
                                            "column_note",
                                            "related_table_name",
                                            "foreign_key",
                                            "related_column_content",
                                            "related_column_note")]

  
  return(list(table_format_results, combined_check_df))

  
}