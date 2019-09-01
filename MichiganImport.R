setwd("C:/Users/zjm/Desktop/Michigan")
library(dplyr)
library(readr)

df <- read.csv("EducatorEffectivenessTrend 2.csv", header = TRUE, skip = 2, nrows = 6204)

names(df) <- c("year", "name", "loctype", "localid", "teacher", "et",
               "e4", "e3", "e2", "effectiveormore", "ineffectiveorless",
               "e1", "e4%", "e3%", "e2%", "effectiveormore%",
               "ineffectiveorless%", "e1%")

df <- df[-c(1:7), ]

toNumber = function(e)
{
  as.numeric(gsub(",", "", e))
}

Michigan <- df %>%
  mutate(
    state = "MI",
    name = tolower(name),
    year = as.numeric(substr(year, 1, 4)) + 1
    ) %/%
  mutate_at(
    vars(et, e1, e2, e3, e4), 
    list(~toNumber(.))
    ) %>%
  
  select("year", "name", "localid", "et", "e4", "e3", "e2", "e1")

write_csv(Michigan, "MichiganEval.csv")
