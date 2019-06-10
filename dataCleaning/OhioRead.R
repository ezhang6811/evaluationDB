setwd(paste0(stubs$dh,"Ohio/Teacher Evaluations/"))

df <- read_excel("2014-SY-Ohio-Teacher-and-Principal-Evaluations.xlsx", sheet="Teachers - District")
names(df) <- c("localid","name","county","e1","e2","e3","e4")

# any category with less than three teachers is suppressed. I am filling in zeros

Ohio <- df %>% 
  mutate(state="OH",
         name=tolower(name),
         e1=as.numeric(e1),
         e2=as.numeric(e2),
         e3=as.numeric(e3),
         e4=as.numeric(e4),
         
         e1_impute = ifelse(is.na(e1),1,0),
         e1 = ifelse(is.na(e1),0,e1),
         
         e2_impute = ifelse(is.na(e2),1,0),
         e2 = ifelse(is.na(e2),0,e2),
         
         e3_impute = ifelse(is.na(e3),1,0),
         e3 = ifelse(is.na(e3),0,e3),
         
         e4_impute = ifelse(is.na(e4),1,0),
         e4 = ifelse(is.na(e4),0,e4),
         
         et = e1+e2+e3+e4,
         year = 2014) %>% 
  mutate_if(is.numeric, as.integer) %>% 
  select(state, year, localid, name, e1, e2, e3, e4, et, e1_impute, e2_impute, e3_impute, e4_impute)
  
write_csv(Ohio, "cleanData/OhioEval.csv")