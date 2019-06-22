# This is a set up file
# Follow these steps to get the project up and working

# 1 Download raw data from dropbox link
# 2 set the datapath below to the location where you have downloaded the raw data
# 3 in the project working directory create a folder called cleanData. The 
# dataCleaning scripts will output clean csvs to that directory


# paths ------------------------------------------------------------------------

# Set datapath to location where you downloaded the data
datapath <- "mypath"

setpath <- function(state) {
  if (datapath == "mypath") warning("datapath set to mypath, did you forget to change it in the setup file?")
  paste(datapath, state, "evaluation", sep = "/")
}




