# TODO: Figure out how to parse pdf instead of copy pasting
# rewrite this code, its terrible

# Setup ------------------------------------------------------------------------

library(dplyr)
library(readxl)
library(readr)
library(pdftools)

source("setup.r")
path <- setpath("Florida")

# Read -------------------------------------------------------------------------

# EvaluationRatings.pdf # 2012
# EduEvalRatings.pdf # 2013
# 1314EduEvalRatings.pdf # 2014
# 1415DistEduEvalRate.pdf # 2015
# 1516DistEduEvalRate.xls # 2016
# 1617DistEduEvalRate.xls # 2017

y1 <- pdf_text(paste(path, "EvaluationRatings.pdf", sep = "/"))
y2 <- pdf_text(paste(path, "EduEvalRatings.pdf", sep = "/"))
y3 <- pdf_text(paste(path, "1314EduEvalRatings.pdf", sep = "/"))
y4 <- pdf_text(paste(path, "1415DistEduEvalRate.pdf", sep = "/"))
y5 <- read_excel(paste(path, "1516DistEduEvalRate.xls", sep = "/"),
                 sheet="Clsrm Tchrs - Pct by Dist")
y6 <- read_excel(paste(path, "1617DistEduEvalRate.xls", sep = "/"),
                 sheet="Clsrm Tchrs - Pct by Dist")

# here everything is printed in the log, in theory i would figure out how to parse this, but lets be practical im just going to copy pasta to excel and save as csvs
cat(y1[1]) 
cat(y1[2])
cat(y2[2])
cat(y3[1])
cat(y4[1])

# reimport the csvs
y1 <- read_csv(paste0(path, "/ParsedPDFs/eval2012.csv"))
y2 <- read_csv(paste0(path, "/ParsedPDFs/eval2013.csv"))
y3 <- read_csv(paste0(path, "/ParsedPDFs/eval2014.csv"))
y4 <- read_csv(paste0(path, "/ParsedPDFs/eval2015.csv"))

# clean up the excel files
names(y5) <- c("DistrictNum","Name","HighlyEffective","pcthe","Effective","pcte","NeedsImprovement","pctni","Developing3yrs","pctd3y","Unsatisfactory","pctu","NotEvaluated","pctne","Total")
y5 <- y5[-c(1,2),-c(4,6,8,10,12,14)]

names(y6) <- c("DistrictNum","Name","HighlyEffective","pcthe","Effective","pcte","NeedsImprovement","pctni","Developing3yrs","pctd3y","Unsatisfactory","pctu","NotEvaluated","pctne","Total")
y6 <- y6[-c(1,2),-c(4,6,8,10,12,14)]

y1$year = 2012
y2$year = 2013
y3$year = 2014
y4$year = 2015
y5$year = 2016
y6$year = 2017

fl56 <- bind_rows(y5,y6) %>% 
  mutate(DistrictNum=as.numeric(DistrictNum),
         HighlyEffective=as.numeric(HighlyEffective),
         Effective=as.numeric(Effective),
         NeedsImprovement=as.numeric(NeedsImprovement),
         Developing3yrs=as.numeric(Developing3yrs),
         Unsatisfactory=as.numeric(Unsatisfactory))

# needsimprovement and developing are the same, but teachers in their first three years get the developing rating
fl <- bind_rows(y1,y2,y3,y4,fl56) %>% 
  filter(Name != "STATEWIDE TOTAL") %>% 
  mutate(e2=Developing3yrs+NeedsImprovement,
         state="FL",
         name = tolower(Name)) %>% 
  mutate_if(is.numeric, as.integer) %>% 
  select(state, year, localid=DistrictNum, name, e1=Unsatisfactory, e2, 
         e3=Effective, e4=HighlyEffective, eu=NotEvaluated, et=Total)

write_csv(fl, "cleanData/FloridaEval.csv")
