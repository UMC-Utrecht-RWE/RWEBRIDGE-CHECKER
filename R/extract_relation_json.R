#' Relation table extraction from json template for a given table name
#'
#' @param json_data list, nested json data importon from json schema file
#' @param table_name string, table name to be search for in the schema
#'
#' @return relation_df, a data frame if the table_name is found, 
#' or string "Failed" otherwise
#' @export
#'
extract_relation_json <- function(json_data, table_name){
  # Extract relation between tables (primary key, foreign key) from json
  # Check if the table_name exists
  if (any(table_name %in% json_data$name)){
    table_index <- which(json_data$name == table_name)
    relation_df <- data.frame(table_name = character(), 
                              primary_key = character(),
                              related_table_name = character(),
                              foreign_key = character())
    
    tt <- as.data.frame(json_data[["columns"]][[table_index]])
    table_name_i <- json_data$name[table_index]
    primary_key_i <- tt$name[stats::complete.cases(tt$primary_key)]
    
    # No foreign_key
    if (is.null(tt$foreign_key)){
      relation_df <- rbind(relation_df, 
                           data.frame(table_name = table_name_i,
                                      primary_key = primary_key_i,
                                      related_table_name = NA,
                                      foreign_key = NA))
    }
    else{
      # One or multiple foreign_key cases 
      related_tables <- sapply(tt$foreign_key[stats::complete.cases(tt$foreign_key)], 
                               function(x) strsplit(x,"[.]"))
      
      for (j in c(1:length(related_tables))){
        relation_df <- rbind(relation_df, 
                             data.frame(table_name = table_name_i,
                                        primary_key = primary_key_i,
                                        related_table_name = related_tables[[j]][1],
                                        foreign_key = related_tables[[j]][2]))
      }
      
    }
    
  } else {
    relation_df <- data.frame(table_name = table_name,
                              primary_key = "Failed",
                              related_table_name = "Failed",
                              foreign_key = "Failed")
  }
  
  return(relation_df)
}