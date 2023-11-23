-- Creating study_variables table
CREATE TABLE study_variables (
  variable_id varchar(50) PRIMARY KEY,
  concept_id varchar(50) REFERENCES code_lists(concept_id),
  exposure boolean,
  outcome boolean,
  covariate boolean,
  data_type varchar(50),
  start_look_back int,
  end_look_back int,
  variable_description int
);

-- Creating composite_study_variables table
CREATE TABLE composite_study_variables (
  variable_id varchar(50) PRIMARY KEY REFERENCES study_variables(variable_id),
  sub_variable_id varchar(50) REFERENCES study_variables(variable_id),
  combination_rule varchar(50)
);

-- Creating complex_study_variables table
CREATE TABLE complex_study_variables (
  variable_id varchar(50) PRIMARY KEY REFERENCES study_variables(variable_id),
  function varchar(50)
);

-- Creating code_lists table
CREATE TABLE code_lists (
  concept_id varchar(50) PRIMARY KEY REFERENCES study_variables(concept_id),
  cdm_name varchar(50),
  cdm_table_name varchar(50),
  coding_system varchar(50) REFERENCES coding_systems(coding_system),
  code varchar(50)
);

-- Creating coding_systems table
CREATE TABLE coding_systems (
  coding_system varchar(50) PRIMARY KEY,
  dap_name varchar(50) REFERENCES dap(dap_name),
  start_exact_match varchar(50)
);

-- Creating dap_specific_concept_map table
CREATE TABLE dap_specific_concept_map (
  concept_id varchar(50) PRIMARY KEY REFERENCES study_variables(concept_id),
  dap_name varchar(50) REFERENCES dap(dap_name),
  cdm_name varchar(50),
  cdm_table_name varchar(50),
  column_name varchar(50),
  expected_value varchar(50),
  keep_value_column_name varchar(50),
  keep_date_column_name varchar(50)
);

-- Creating dictionary table
CREATE TABLE dictionary (
  variable_id varchar(50) PRIMARY KEY REFERENCES study_variables(variable_id),
  dap_name varchar(50) REFERENCES dap(dap_name),
  original_value varchar(50),
  standart_value varchar(50)
);

-- Creating dap table
CREATE TABLE dap (
  dap_name varchar(50) PRIMARY KEY,
  start_study_period varchar(50),
  end_study_period varchar(50)
);

-- Creating study_cohort table
CREATE TABLE study_cohort (
  cohort_name varchar(50) PRIMARY KEY,
  study_objective varchar(50),
  variable_id varchar(50) REFERENCES study_variables(variable_id)
);

-- Creating criteria table
CREATE TABLE criteria (
  cohort_name varchar(50) PRIMARY KEY REFERENCES study_cohort(cohort_name),
  exclusion_inclusion varchar(50),
  criteria_application_order integer,
  criteria_definition varchar(50)
);

