# This function imports all files in a directory and outputs a data.frame of them all, adding a column containing the file name
# the pattern argument allows only files which follow a certain pattern (e.g. ".csv") to be imported
# the chopFromName argument chopps part of the filename off when adding the sample column (e.g. ".csv")
# the sep argument allows you to change the delimiter. Default is tab

makeLongDB <- function(path, pattern = NULL, chopFromFileName, sep = NULL){
  
  # Get file names and locations
  files <- list.files(path = path, pattern = pattern)
  fileLocation <- paste(path, files, sep = "")
  
  # Make sure all files being read are larger than 0 bytes
  files <- files[file.size(fileLocation) != 0]
  fileLocation <- fileLocation[file.size(fileLocation) != 0]
  
  # Read files into a list. Standard seperator is tab, but others can be defined
  if(is.null(sep)){
    fileList <- lapply(fileLocation, FUN = function(x){
      read.csv(x, sep = '\t', header = FALSE)}
    )
  } else{
    fileList <- lapply(fileLocation, FUN = function(x){
      read.csv(x, sep = sep, header = FALSE)}
    )
  }
  
  # Add treatment names to the assemblies
  names(fileList) <- files
  
  # Put data from all assemblies into a data frame
  longDataFrame <- do.call("rbind", fileList)
  
  # Add a Sample column
  Sample <- sub(chopFromFileName,"",rep(names(fileList), sapply(fileList, nrow)))
  sampleDataFrame <- cbind(Sample, longDataFrame)
  return(sampleDataFrame)
}
