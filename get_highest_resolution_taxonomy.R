# This function quickly finds the highest rank that a case (sequence, bug, whatever) can be given, from a table of data containing tax_cols.
# tax_cols must be given in order from lowest to highest resolution. Outputs "Unclassified <highest-resolution rank available>" if the highest
# rank given is not available.

get_highest_resolution_taxonomy <- function(data
                                            , tax_cols = c("SuperKingdom", "Phylum", "Class"
                                                           , "Order", "Family", "Genus"
                                                           , "Species")
                                            , unassigned_current = "UNASSIGNED"
                           , prefix = "Unassigned"
                           , suffix = ""
                           ){
  # For each row, which was the highest assigned taxonomic level?
  highest_identified_rank <- apply(data[, ..tax_cols] != unassigned_current
                                   , 1
                                   , checkmate::wl)
  
  # Paste the highest assigned ranks with nfo about whether a species ID was 
  # available or not
  final_taxonomy <- sapply(seq_along(highest_identified_rank)
                           , FUN = function(i){
                             current_rank <- highest_identified_rank[i]
                             
                             out <- ifelse(current_rank == length(tax_cols)
                                    , yes = data[i, ..tax_cols][[current_rank]]
                                    , no = paste(prefix
                                                 , data[i, ..tax_cols][[current_rank]]
                                                 , suffix)
                                    )
                             out <- sub(" $", "", out)
                              })
  return(final_taxonomy)
}
