

# Setup ------------------------------------------------------------------------

library(readxl)
library(tidyverse)

source("setup.r")

lapath <- setpath("Louisiana")

# Read -------------------------------------------------------------------------

read_fun <- function(ranges, file, sheet, top_row_drop, year, path = lapath) {
    ranges %>% 
    map_dfc(
      ~read_excel(
        paste(path, file, sep = "/"),
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
d2 <- read_fun(ranges = list(), 
               file = "",
               sheet = "",
               top_row_drop = 0, 
               year = )

# 2014-15
d3 <- read_fun(ranges = list(), 
               file = "",
               sheet = "",
               top_row_drop = 0, 
               year = )

# 2015-16
d4 <- read_fun(ranges = list(), 
               file = "",
               sheet = "",
               top_row_drop = 0, 
               year = )

# 2016-17
d5 <- read_fun(ranges = list(), 
               file = "",
               sheet = "",
               top_row_drop = 0, 
               year = )

# 2017-18
d6 <- read_fun(ranges = list("B6:F78"), 
               file = "2017-2018-compass-teacher-results-by-district-and-school.xlsx",
               sheet = "State-District Level",
               top_row_drop = 2, 
               year = 2018)


 # Combine ---------------------------------------------------------------------
df <- bind_rows(d1, d2, d3, d4, d5, d6)
