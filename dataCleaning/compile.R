# This file compiles the cleaned csvs into a single rmd file
library(dplyr)
library(readr)

list <- list.files("cleanData", pattern = ".csv", full.names = TRUE)

files <- lapply(
  list,
  read_csv, 
  col_types = cols(.default = "d", state = "c", localid = "c", name = "c")  
)
  
df <- files %>% bind_rows()

saveRDS(df, "cleanData/evaluationData.rds")