alpha_mle_distmat <- function(adata){
  if(!require(data.table)){require(data.table)}
  if(!require(magrittr)){require(magrittr)}
  
  # Make the data workable
  setDT(adata)
  
  # What combinations of variables are we working with
  vals <- unique(c(adata$entity_1, adata$entity_2))
  combos <- expand.grid(vals, vals)
  
  # Create values for the ones not compared by CoocurrenceAfinity 
  # (i.e., the diagonal)
  incomparables <- data.table(entity_1 = vals
                            , entity_2 = vals
                            , alpha_mle = 0
                            )
  indata <- rbindlist(list(adata[,.(entity_1, entity_2, alpha_mle)]
                         , incomparables))
  
  # Make it wide
  dist_mat <- dcast(indata
                  , formula = entity_1 ~ entity_2
                  , value.var = 'alpha_mle')
  
  # Name the rows
  rownames(dist_mat) <- dist_mat$entity_1
  
  # Order the rows by the variable number
  dist_mat <- dist_mat[order(as.numeric(sub("V", "", entity_1))),]
  dist_mat[, entity_1 := NULL]

  # Order the columns by variable number
  setcolorder(dist_mat, names(dist_mat) %>%
              sub("V", "", .) %>%
              as.numeric(.) %>%
              sort(.) %>%
              paste0("V", .)
              )

  # Get the matrix (upper triangle)
  dist_mat_m <- as.matrix(dist_mat)
  
  # Make the matrix square + mirrored
  dist_mat_m[lower.tri(dist_mat_m)] <- dist_mat_m[upper.tri(dist_mat_m)]
  
  # Provide an output
  return(dist_mat_m)
}
  
