# This file compiles the cleaned csvs into a single rmd file

# Setup ------------------------------------------------------------------------

library(dplyr)
library(readr)

source("setup.r")
clean <- setpath("Clean")


# Read in Files ----------------------------------------------------------------
list <- list.files(clean, pattern = ".csv", full.names = TRUE)

files <- lapply(
  list,
  read_csv, 
  col_types = cols(.default = "d", state = "c", localid = "c", name = "c")  
)
  
df <- files %>% bind_rows() 

# Merge NCES -------------------------------------------------------------------

# TODO

# Rename/Reorder and Save ------------------------------------------------------

df <- df %>% 
  select(
    state,
    year, 
    "district_name" = name,
    localid,
    "teachers" = et, 
    "not_evaluated" = eu, 
    "suppressed" = es, 
    "level1" = e1,
    "level2" = e2,
    "level3" = e3,
    "level4" = e4,
    "impute_level1" = e1_impute,
    "impute_level2" = e2_impute,
    "impute_level3" = e3_impute,
    "impute_level4" = e4_impute
  )

saveRDS(df, paste(clean, "evaluationData.rds", sep = "/"))