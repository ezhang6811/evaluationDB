# This file compiles the cleaned csvs into a single rmd file
# Assumes that there is a folder cleanData in the working directory of the 
# project containing the clean csv files.

# Setup ------------------------------------------------------------------------

library(dplyr)
library(readr)

# Read in Files ----------------------------------------------------------------
list <- list.files("cleanData", pattern = "Eval.csv", full.names = TRUE)

files <- lapply(
  list,
  read_csv, 
  col_types = cols(.default = "d", state = "c", localid = "c", name = "c")  
)
  
df <- files %>% bind_rows() 

# Create p_ variables ----------------------------------------------------------

df2 <- df %>% 
  # LA data only has percents and no counts, need to exclude from this calculation
  filter(state != "LA") %>% 
  mutate(
    p1 = e1 / et, 
    p2 = e2 / et, 
    p3 = e3 / et, 
    p4 = e4 / et,
    ps = es / et, 
    pu = eu / et
  ) %>% 
  bind_rows(df %>% 
              filter(state == "LA") %>% 
              mutate_at(vars(p1, p2, p3, p4), ~. / 100))


# Merge NCES -------------------------------------------------------------------

nces <- read_csv("cleanData/NCES_CCD.csv") 

df_nces <- df2 %>% 
  mutate(
    localid = case_when(
      state == "MA" ~ substring(localid,1,4),
      state == "FL" ~ stringr::str_pad(localid, 2, side = "left", "0"),
      state == "IN" ~ stringr::str_pad(localid, 4, side = "left", "0"),
      TRUE ~ localid
    )) %>% 
  left_join(nces, by = c("state", "year", "localid"))

df_nces %>% group_by(state) %>% summarize(sum(is.na(NCES_leaid)))

# Rename/Reorder and Save ------------------------------------------------------

evaluationData <- df_nces %>% 
  select(
    state,
    year, 
    "district_name" = name,
    localid,
    "count_teachers" = et, 
    "count_not_evaluated" = eu, 
    "count_suppressed" = es, 
    "count_level1" = e1,
    "count_level2" = e2,
    "count_level3" = e3,
    "count_level4" = e4,
    "percent_not_evaluated" = pu, 
    "percent_suppressed" = ps, 
    "percent_level1" = p1,
    "percent_level2" = p2,
    "percent_level3" = p3,
    "percent_level4" = p4,
    "impute_level1" = e1_impute,
    "impute_level2" = e2_impute,
    "impute_level3" = e3_impute,
    "impute_level4" = e4_impute
  )

saveRDS(df, "cleanData/evaluationData.rds")