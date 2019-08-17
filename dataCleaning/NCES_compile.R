library(tidyverse)

path <- "/Volumes/SSD/DataHouse/NCES CCD/DistrictFiles"

list <- list.files(path = path, 
                   pattern="*.txt", full.names = TRUE)
files <- lapply(list, read_tsv)

# Just pulling basic identifiers for districts

y1 <- files[[1]] %>% select(SURVYEAR, LEAID, FIPST, MSTATE, STID, NAME, TYPE)
y2 <- files[[2]] %>% select(SURVYEAR, LEAID, FIPST, MSTATE, STID, NAME, TYPE)
y3 <- files[[3]] %>% select(SURVYEAR, LEAID, FIPST, MSTATE, STID, NAME, TYPE)
y4 <- files[[4]] %>% select(SURVYEAR, LEAID, FIPST, MSTATE, STID, NAME, TYPE)
y5 <- files[[5]] %>% select(SCHOOL_YEAR = SURVYEAR, LEAID, FIPST, MSTATE=STABR, STID=ST_LEAID, NAME=LEA_NAME, TYPE=LEA_TYPE)
y7 <- files[[6]] %>% select(SCHOOL_YEAR, LEAID, FIPST, MSTATE, STID=ST_LEAID, NAME=LEA_NAME, TYPE=LEA_TYPE)

y6 <- read_csv(paste0(path, "/ccd_lea_029_1516_w_1a_011717.csv")) %>% 
  select(SCHOOL_YEAR=SURVYEAR, LEAID, FIPST, MSTATE=STABR, STID=ST_LEAID, NAME=LEA_NAME, TYPE=LEA_TYPE)

y8 <- read_csv(paste0(path, "/ccd_lea_029_1718_w_0a_03302018.csv")) %>% 
  select(SCHOOL_YEAR, LEAID, FIPST, MSTATE=ST, STID=ST_LEAID, NAME=LEA_NAME, TYPE=LEA_TYPE)

y9 <- read_csv(paste0(path, "/ccd_lea_029_1819_w_0a_04082019_csv.csv")) %>% 
  select(SCHOOL_YEAR, LEAID, FIPST, MSTATE=ST, STID=ST_LEAID, NAME=LEA_NAME, TYPE=LEA_TYPE)


nces <- bind_rows(y1,y2,y3,y4,y5,y6,y7,y8,y9) %>% 
  mutate(SURVYEAR = if_else(is.na(SURVYEAR),as.double(substr(SCHOOL_YEAR,1,4)),SURVYEAR),
         year = SURVYEAR + 1) %>% 
  select(year,state=MSTATE, localid=STID,NCES_name=NAME,NCES_type=TYPE,NCES_leaid=LEAID) %>%
  # 2017 and later, localid is prefixed with State-
  mutate(localid = ifelse(year %in% 2017:2019, substring(localid,4),localid))

write_csv(nces,"cleanData/nces_ccd.csv")


# Type Codes
# 1 = Regular local school district.  Locally governed agency responsible for providing free public elementary or secondary education; includes independent school districts and those that are a dependent segment of a local government such as a city or county.
# 2 = Local school district that is a component of a supervisory union.  Regular local school district that shares its superintendent and administrative services with other school districts participating in the supervisory union.
# 3 = Supervisory Union.  An education agency that performs administrative services for more than one school district, providing a common superintendent for participating districts.
# 4 = Regional Education Service Agency.  Agency providing specialized education services to a variety of local education agencies, or a county superintendent serving the same purposes.
# 5 = State-Operated Agency.  Agency that is charged, at least in part, with providing elementary and/or secondary instruction or support services. Includes the State Education Agency if this agency operates schools. Examples include elementary/secondary schools operated by the state for the deaf or blind; and programs operated by state correctional facilities. 
# 6 = Federally-Operated Agency.  A federal agency that is charged, at least in part, with providing elementary or secondary instruction or support services.
# 7 = Charter Agency.  All schools associated with the agency are charter schools. 
# 8 = Other Education Agency.  Agency providing elementary or secondary instruction or support services that does not fall within the definitions of agency types 1ñ7 

