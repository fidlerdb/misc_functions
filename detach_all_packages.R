detach_all_packages <- function(){
  # Remove loaded via namespace
  lapply(names(sessionInfo()$loadedOnly), require, character.only = TRUE)
  
  # Remove other packages
  invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE, force=TRUE))
}
