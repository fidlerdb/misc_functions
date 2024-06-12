# Sorting or ordering an AIC table

# This function produces an AIC table as with the function stats::AIC, however, the output is ordered so that the 
# most efficient model is at the top, and so that every subsequent model is less efficient.

AICsort <- function(input, ...){
  
  Call <- match.call()
  Call$k <- NULL
  rn <- as.character(Call[-1L])
  
  out <- AIC(input, ...)
  rownames(out) <- rn
  out <- out[order(out$AIC, decreasing = FALSE),]
  return(out)
}
