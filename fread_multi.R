# This function imports all files in a directory and outputs a data.table of them all, adding a 
# column containing the file name
# the pattern argument allows only files which follow a certain pattern (e.g. ".csv") to be imported
# the remove_from_name argument chops part of the filename off when adding the sample column (e.g. ".csv", this can be a more complex regex)
# Other fread arguments are accepted

fread_multi <- function(path, pattern = NULL, remove_from_name  = "", file_meaning = NULL, ...){
  
  # Ensure we can read in the data
  if(!require(data.table)){install.packages('data.table')}
  library(data.table)
  
  # Get file names and locations
  files <- list.files(path = path, pattern = pattern)
  file_location <- paste(path, files, sep = "")
  
  # Make sure all files being read are larger than 0 bytes
  files <- files[file.size(file_location) != 0]
  file_location <- file_location[file.size(file_location) != 0]
  
  # Read files into a list. Standard seperator is tab, but others can be defined
 # if(is.null(sep)){
    file_list <- lapply(file_location, FUN = function(x){
      fread(x, ...)}
    )
  
  # Add file names to the list
  names(file_list) <- files
  
  # Stick them together
  long_dt <- rbindlist(file_list, idcol = "File", fill = TRUE, use.names = TRUE)
  
  # Tidy up
  long_dt[, File := sub(remove_from_name, "", File)]
  if(!is.null(file_meaning)){setnames(long_dt, old = "File", new = file_meaning)}
  
  # Output the data.table
  return(long_dt)
}
