
# Setup ------------------------------------------------------------------------


library(dplyr)
library(readxl)
library(readr)


source("setup.r")

path <- setpath("Massachusettes")

# Read -------------------------------------------------------------------------


list <- list.files(path = path, pattern = "*.xlsx", full.names = TRUE)
files <- lapply(list, read_excel, na = c("NA","NI","NR"), skip = 1) 

years <- c(2014:2017,2013)
for(i in 1:length(files)) {
  files[[i]]$year <- years[i]
}

df <- bind_rows(files)

names(df) <- c("name", "localid", "et", "evaluated", "percentEvaluated",
               "e4", "e3", "e2", "e1", "year") 

convertNumber <- function(e, evaluated) {
  as.numeric(e) / 100 * as.numeric(evaluated)
}

Massachusetts <- df %>%
  mutate(name = tolower(name),
         es = ifelse(e1 == "-" & e2 == "-" & e3 == "-" & e4 == "-", evaluated, 0),
         e4 = convertNumber(e4, evaluated),
         e3 = convertNumber(e3, evaluated),
         e2 = convertNumber(e2, evaluated),
         e1 = convertNumber(e1, evaluated),
         
         eu = as.numeric(et) - as.numeric(evaluated)) %>% 
  
  mutate_at(vars(e1, e2, e3, e4), funs(round(.,0))) %>% 
  
  select("name", "localid", "year", "et", "eu", "es",
         "e4", "e3", "e2", "e1")

write_csv(Massachusetts, "MassachusettsEval.csv")
