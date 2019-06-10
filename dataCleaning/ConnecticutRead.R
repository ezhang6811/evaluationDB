url <- "https://projects.ctmirror.org/tools/fancytable/table.html?d=Schooldistrictevaluationsbetween2013and2015-3-1-2016-31188"

X <- rvest()

library(rvest)
library(magrittr)

url %>%
  read_html() %>%
  html_nodes("iframe") %>%
  extract(3) %>% 
  html_attr("src") %>% 
  read_html() %>% 
  html_node("#searchResultsTable") %>% 
  html_table() %>%
  head()