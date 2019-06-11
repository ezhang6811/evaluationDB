# This is a set up file
# TODO need to replace libs_and_paths

# paths ------------------------------------------------------------------------

# Set datapath to location where you downloaded the data
datapath <- "mypath"

setpath <- function(state) {
  if (datapath == "mypath") warning("datapath set to mypath, did you forget to change it in the setup file?")
  paste(datapath, state, "evaluation", sep = "/")
}




