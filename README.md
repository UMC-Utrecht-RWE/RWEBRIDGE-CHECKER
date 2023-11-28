
# RWEBRIDGE-CHECKER

<!-- badges: start -->
<!-- badges: end -->

RWEBRIDGE-CHECKER is an R package with a Shiny app for meta data file comparison to check the consistencies. The goal is to diagnose the inconsistencies between the meta data files before running the analytical pipeline. This package is the generalized version of metadatachecker, implemented within BRIDGE framework.

## Installation

You can install the development version of RWEBRIDGE-CHECKER (or the latest stable release) like so:

**Option 1.** Using devtools (recommended):

Download and unzip (in your working enviroment) or clone the repo. Let's say your folder is here:

- on Mac, the *"path_to_the_directory_of_the_package"* looks something like this: "/Users/zkurkcuo/Desktop/RWEBRIDGE-CHECKER"
- on Windows, the *"path_to_the_directory_of_the_package"* looks something like this: "C:/Users/zkurkcuo/Desktop/RWEBRIDGE-CHECKER" (it should be **"/"**, and not "\\")

and on R console, type the following:
``` r
# If you don't have devtools, install it
install.packages("devtools")
#Install RWEBRIDGE-CHECKER by typing this on R console
devtools::install("path_to_the_directory_of_the_package", dependencies = TRUE)
```
If it asks about updating the packages that are available in your system, I usually skip it and hope that I won't break anything. So far it worked, but please check it.

**Option 2.** Building from source (not recommended, but if you really have to, then it is in the following way):

Download or clone the repo, then open RStudio>Open Project, select RWEBRIDGE-CHECKER folder. 
From top right panel of RStudio, select "Build" tab and press Install. If you encounter with
an error related with a missing library, install that library. These are the 
needed libraries for metadatachecker:

- jsonlite (>= 1.8.7),
- kableExtra (>= 1.3.4),
- knitr (>= 1.43),
- rmarkdown (>= 2.23),
- shiny (>= 1.7.5),
- shinythemes (>= 1.2.0)

## Example

Here is how you can use RWEBRIDGE-CHECKER: 


On R console, type the following:
``` r
library(RWEBRIDGECHECKER)
```

After importing the library, write the following on the console:

``` r
rwebridgechecker_app()
```

A Shiny app will launch in a new window or in your default browser (if you set it as "Run External" from the menu next to "Run app"). 

In the app:

- First tab is for checking the user table format and columns based on expected schema of the database (json).

You need to select and upload csv tables that you want to check. After pressing "Check consistency" button,
two tables will appear:


- Second tab is for generating an html report of the results and a downloadable html file is generated. 

It is also possible to use individual functions of the package. An example
is provided below for extract_relation_json function, which extrac the list of 
related table from json for a given table name.

``` r
library(RWEBRIDGECHECKER)
json_template_path <- system.file("extdata",
                                  "RWEBRIDGE_schema.json",
                                  package = "RWEBRIDGECHECKER")
    
json_template <- jsonlite::fromJSON(json_template_path)$RWE_BRIDGE
results <- extract_relation_json(json_template,"study_variables")
#> results
#       table_name primary_key related_table_name foreign_key
#1 study_variables variable_id          code_list  concept_id

```


