# Setup ------------------------------------------------------------------------

library(dplyr)
library(readr)

source("setup.r")

MIpath <- setpath("Michigan")

# Read -------------------------------------------------------------------------

df <- 
  read.csv(paste0(MIpath, "/EducatorEffectivenessTrend 2.csv"),
               header = TRUE, skip = 2, nrows = 6204) %>%
  rename(year = `School Year`,
         name = `Location Name`,
         localid = `Location Code`,
         et = `Total Count `,
         e4 = `HighlyEffective Count`,
         e3 = `Effective Count`,
         e2 = `MinimallyEffective Count`,
         e1 = `Ineffective Count`)

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
    ) %>%
  mutate_at(
    vars(et, e1, e2, e3, e4), 
    list(~toNumber(.))
    ) %>%
  select("year", "name", "localid", "et", "e4", "e3", "e2", "e1")

write_csv(Michigan, "CleanData/MichiganEval.csv")
