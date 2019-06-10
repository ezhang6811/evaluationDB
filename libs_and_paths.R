library(pdftools)
library(tidyverse)
library(readxl)
library(haven)
library(ggridges)
library(lme4)
library(lfe)
library(knitr)

# experimental library
#library(RecordLinkage)
library(survminer)
library(survival)

# helper functions
source("PayrollData/code/helperFunctions/clean_names.R")
source("PayrollData/code/helperFunctions/missing_summary.R")

# this is the full list of states I have data for in some way or another
statelist <- c("")

# Data is stored in two primary locations
  # raw files are on my external ssd disk
  # clean filse are on the laptop disk
stubs <- list()
stubs$dh <- "/Volumes/SSD/DataHouse/StateData/"
stubs$cl <- "/Users/williamlief/Documents/Research Projects/DistrictVariation/"

paths <- list()
paths$ccd_district <- paste0(stubs$dh,"NCES CCD/DistrictFiles/")
#paths$seda <- paste0(stubs$dh, )# SEDA data
# State raw files


paths$agg <- paste0(stubs$cl,"AggregateFiles/") # clean aggregate files
paths$eval <- paste0(stubs$cl, "DistrictEvalFiles/") # clean district eval results
paths$payroll <- paste0(stubs$cl,"PayrollData/") # clean payroll results