# Setup ------------------------------------------------------------------------

library(dplyr)
library(readxl)
library(readr)

source("setup.r")

path <- setpath("Massachusetts")

# Read -------------------------------------------------------------------------

list <- list.files(path = path, pattern = "*.xlsx", full.names = TRUE)
files <- lapply(list, read_excel, na = c("NA","NI","NR"), skip = 1) 

years <- c(2014:2017, 2013) # 'files' is in order of file names
for(i in 1:length(files)) {
  files[[i]]$year <- years[i]
}

df <- bind_rows(files)

names(df) <- c("name", "localid", "et", "evaluated", "percentEvaluated",
               "e4", "e3", "e2", "e1", "year") 


# Clean ------------------------------------------------------------------------

convertNumber <- function(e, evaluated) {
  round(as.numeric(gsub("-", NA, e)) / 100 * evaluated, 0)
}

Massachusetts <- df %>%
  mutate(
    name = tolower(name),
    evaluated = as.numeric(gsub(",", "", evaluated)), 
    et = as.numeric(gsub(",", "", et)),
    es = ifelse(e1 == "-" & e2 == "-" & e3 == "-" & e4 == "-", evaluated, 0),
    eu = et - evaluated
    ) %>% 
  mutate_at(
    vars(e1, e2, e3, e4), 
    list(~convertNumber(., evaluated))
    ) %>% 
  select("name", "localid", "year", "et", "eu", "es",
         "e4", "e3", "e2", "e1") %>% 
  filter(name != "state totals") %>% 
  arrange(localid, year)

write_csv(Massachusetts, "CleanData/MassachusettsEval.csv")
