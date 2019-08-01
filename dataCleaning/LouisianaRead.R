# Setup ------------------------------------------------------------------------

library(readxl)
library(tidyverse)
library(data.table)

source("setup.r")

lapath <- setpath("Louisiana")

# Read -------------------------------------------------------------------------

read_fun <- function(ranges, file, sheet, top_row_drop, year, path = lapath) {
    ranges %>% 
    map_dfc(
      ~read_excel(
        paste(path, file, sep = "/"),
        col_types = "text",
        sheet, 
        range = .)
    ) %>% 
    filter(row_number() > top_row_drop) %>% 
    mutate(year = year) 
}


# 2012-13
d1 <- read_fun(ranges = list("A3:A74", "G3:J74"),
               file = "appendix-a---table-1-teacher-compass-scores-by-district.xlsx",
               sheet = "Teacher Data by Parish",
               top_row_drop = 2,
               year = 2013)

# 2013-14
d2 <- read_fun(ranges = list("A3:A74", "J3:M74"), 
               file = "2013-2014-compass-teacher-results-by-parish.xlsx",
               sheet = "Teacher Data by Parish",
               top_row_drop = 2, 
               year = 2014)

# 2014-15
d3 <- read_fun(ranges = list("A6:E77"), 
               file = "2014-2015-compass-teacher-results-by-lea.xlsx",
               sheet = "Teacher Data by District",
               top_row_drop = 2, 
               year = 2015)

# 2015-16
d4 <- read_fun(ranges = list("A6:F77"), 
               file = "2015-2016-compass-teacher-results-by-district.xlsx",
               sheet = "district list",
               top_row_drop = 2, 
               year = 2016)

# 2016-17
d5 <- read_fun(ranges = list("A6:F79"), 
               file = "2016-2017-compass-teacher-results-by-district-and-school.xlsx",
               sheet = "State-District Level",
               top_row_drop = 2, 
               year = 2017)

# 2017-18
d6 <- read_fun(ranges = list("A6:F78"), 
               file = "2017-2018-compass-teacher-results-by-district-and-school.xlsx",
               sheet = "State-District Level",
               top_row_drop = 2, 
               year = 2018)


# Combine ---------------------------------------------------------------------

df <- 
  bind_rows(d1, d2, d3, d4, d5, d6) %>% 
  rename(parish_name = `Parish Name`, 
         localid = `Sponsor Code`,
         p1 = Ineffective, 
         p2 = `Effective: Emerging`, 
         p3 = `Effective: Proficient`, 
         p4 = `Highly Effective`) %>% 
  mutate(p1_impute = 0,
         p2_impute = 0)

# Impute and convert to numeric

dt <- as.data.table(df) # or use setDT(df)
dt[p1 %in% c("≤1%", "<1%"), `:=`(p1 = "0", p1_impute = 1)]
dt[p2 %in% c("≤1%", "<1%"), `:=`(p2 = "0", p2_impute = 1)]

dt <- as_tibble(dt) %>% 
  mutate_at(vars(p1, p2, p3, p4), list(~as.numeric(.))) %>% 
  as.data.table()

dt[year %in% c(2013, 2014), `:=`(p1 = p1 * 100, p2 = p2 * 100, p3 = p3 * 100, p4 = p4 * 100)]
dt[p1_impute == 1 & p2_impute != 1, `:=`(p1 = 100 - (p4 + p3 + p2))]
dt[p1_impute == 1 & p2_impute == 1, `:=`(p2 = 100 - (p4 + p3))]
dt[p1_impute != 1 & p2_impute == 1, `:=`(p2 = 100 - (p4 + p3 + p1))]

# Clean -----------------------------------------------------------------------

df2 <- as_tibble(dt) %>% 
  mutate(name = coalesce(parish_name, LEA), 
         localid = if_else(year == 2015, substr(name, 1, 3), localid),
         name    = if_else(year == 2015, substr(name, 7, nchar(name)), name),
         name = gsub("School District", "Parish", name)) %>% 
  select(-c(parish_name, LEA)) 

# 2013 and 2014 are missing localid 
ids <- df2 %>% 
  select(localid2 = localid, name) %>% 
  filter(!is.na(localid2)) %>% 
  distinct(name, .keep_all = TRUE) 

df3 <- df2 %>% 
  left_join(ids, by = "name") %>% 
  mutate(
    localid = if_else(year %in% c(2013, 2014), localid2, localid),
    localid = 
      case_when(name %in% 
                  c("East Baton Rouge including RSD", 
                    "East Baton Rouge Parish + Recovery Parish Baton Rouge") ~ "017", 
                name %in% 
                  c("Orleans Parish including RSD and OPSB", 
                    "Orleans Parish + Recovery Parish New Orleans") ~ "036", 
                TRUE ~ localid)) %>% 
  select(-localid2)

write_csv(df3, "CleanData/LouisianaEval.csv")

