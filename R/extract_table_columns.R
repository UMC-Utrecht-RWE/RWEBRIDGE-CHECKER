#' Extraction of list of column names for a table, from json schema
#'
#' @param json_data list, nested json data importon from json schema file
#' @param table_name string, table name to be search for in the schema
#'
#' @return table_info, list of column names if the table_name is found, 
#' or string "Failed" otherwise
#' @export
#'
extract_table_columns <- function(json_data, table_name){
  # Extact column names for table_name
  
  # Check if the table_name exists
  if (any(table_name %in% json_data$name)){
    table_index <- which(json_data$name == table_name)
    # Get column names
    table_info <- json_data[[2]][[table_index]]["name"]
  } else {
    table_info <- "Failed"
  }
  return(table_info)
}