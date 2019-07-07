# TODO: remove setwd, reformat

setwd(paste0(stubs$dh,"New York/EVAL"))

# read in the district data
csv2013 <- read_csv("NYSTATE_EVAL/APPR_DISTRICT_RESEARCHER_FILE_DATA.csv")
csv2014 <- read_csv("NYSTATE_EVAL_2014/APPR_DISTRICT_RESEARCHER_FILE_DATA.csv")
csv2015 <- read_csv("NYSTATE_EVAL_2015/APPR_DISTRICT_RESEARCHER_FILE_DATA.csv")
csv2016 <- read_csv("NYSTATE_EVAL_2016/APPR_RESEARCHER_DATA_PART_C_ORIGINAL_DISTRICT_2016.csv")

# Add year variables, clean up naming, stack data
csv2013$year=2013
csv2013 <- csv2013 %>% 
  rename(DISTRICT_NEEDS_CATEGORY=DISTRICT_NEEDS,
         OVERALL_RATING=OVERALL_COMPOSITE_RATING,
         OVERALL_SCORE=OVERALL_COMPOSITE_SCORE)
csv2014$year=2014
csv2015$year=2015
csv2016$year=2016
csv2016 <- select(csv2016,-SCHOOL_YEAR)
dis_csv <- rbind(csv2013,csv2014,csv2015,csv2016)

# Aggregate 
ny <- dis_csv %>% 
  mutate(c1 = substr(OVERALL_RATING,1,1)) %>% 
  group_by(c1, DISTRICT_BEDS, DISTRICT_NAME, year) %>% 
  summarize(count= n()) %>% 
  spread(c1, count) %>% 
  mutate(state="NY") %>% 
  select(state,year,localid=DISTRICT_BEDS, name="DISTRICT_NAME",e1=I,e2=D,e3=E,e4=H,es=S) %>% 
  rowwise %>% 
  mutate(et=sum(e1,e2,e3,e4,es, na.rm=T),
         name=tolower(name)) %>% 
  mutate_if(is.numeric, as.integer)
  
write_csv(ny, "cleanData/NewYorkEval.csv")