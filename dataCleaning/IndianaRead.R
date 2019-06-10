setwd(paste0(stubs$dh,"Indiana/Evaluation"))

# file and sheet names
y1 <- c("sboe-data-er-data-report-12-13.xlsx", "12-13 corp level ER data", "12-13 school level ER data")
y2 <- c("sboeresultsdatareport2013-14.xlsx", c("Corp", "School",  "Retention Rate"))
y3 <- c("2014-15-evaluation-ratings-er-data-website.xlsx", c("Corporation", "School",  "Retention (School Level)"))
y4 <- c("2015-16evaluationratings-er-data.xlsx", c("Corporation", "School", "Retention"))

# read in the data - here i read in a bunch of data beyond just the district counts but dont do anything with it
# year 1
corp.y1 <- read_excel(y1[1], sheet= y1[2], skip=1)
schl.y1 <- read_excel(y1[1], sheet= y1[3], skip=1)

# year 2
corp.y2 <- read_excel(y2[1], sheet= y2[2], range=cell_cols("A:I"))
schl.y2 <- read_excel(y2[1], sheet= y2[3])
retn.y2 <- read_excel(y2[1], sheet= y2[4])

# year 3
corp.y3 <- read_excel(y3[1], sheet= y3[2])
schl.y3 <- read_excel(y3[1], sheet= y3[3])
retn.y3 <- read_excel(y3[1], sheet= y3[4])

# year 4
corp.y4 <- read_excel(y4[1], sheet= y4[2])
schl.y4 <- read_excel(y4[1], sheet= y4[3])
retn.y4 <- read_excel(y4[1], sheet= y4[4])

# most recent district directory
directory <- read_excel(paste0(stubs$dh,"Indiana/2017-2018-school-directory-2017-08-07.xlsx")) %>% 
    select(corpnum=1,corp=2) %>% 
    mutate(corpnum=as.numeric(corpnum)) %>% 
    arrange(corp)

# stack up the data
# corp
names(corp.y1) <- c("corpnum", "corp", "e4", "e3", "e2", "e1", "unrated", "total")
corp.y1$year = 2013
corp.y1$e4 <- as.numeric(corp.y1$e4)

names(corp.y2) <- c("corpnum", "corp", "corpgrade", "unrated", "e1", "e2", "e3", "e4", "total")
corp.y2$corpnum <- as.numeric(corp.y2$corpnum)
corp.y2$unrated<- as.numeric(corp.y2$unrated)
corp.y2$year = 2014

names(corp.y3) <- c("corp", "e1", "e2", "e3", "e4","unrated", "total")
corp.y3$e1 <- as.numeric(corp.y3$e1)
corp.y3$year = 2015

names(corp.y4) <- c("corp", "e1", "e2", "e3", "e4","unrated", "total")
corp.y4$year = 2016

corp <- bind_rows(corp.y1, corp.y2, corp.y3, corp.y4) %>% 
    select(-corpgrade) %>% 
    left_join(directory, by="corp") %>% 
    mutate(state="IN",
           corpnum=coalesce(corpnum.x,corpnum.y)) %>% 
    select(-corpnum.x, -corpnum.y) %>% 
    mutate(corp = tolower(corp),
           corp = gsub("community", "com", corp),
           corp = gsub("corporation", "corp", corp),
           corp = gsub("district", "dist", corp),
           corp = gsub("school", "sch", corp)) %>% 
    arrange(corp, year) %>% 
    mutate(corpnum = ifelse(corp==lag(corp) & year==2015, lag(corpnum),corpnum),
           corpnum = ifelse(corp==lag(corp) & year==2016, lag(corpnum),corpnum),
           corpnum = as.character(corpnum)) %>% 
    mutate(e1 = ifelse(is.na(e1),0,e1),
           e2 = ifelse(is.na(e2),0,e2),
           e3 = ifelse(is.na(e3),0,e3),
           e4 = ifelse(is.na(e4),0,e4),
           unrated = ifelse(is.na(unrated),0,unrated),
           total = ifelse(is.na(total),0,total)) %>% 
  mutate_if(is.numeric, as.integer) %>% 
  filter(!is.na(corp)&!is.na(corpnum)) %>% 
  select(state, year, localid=corpnum, name=corp, e1, e2, e3, e4, eu=unrated, et=total)

write_csv(corp, "cleanData/IndianaEval.csv")