# This script calculates TPM values for all contigs

#!/usr/bin/env Rscript
#### USAGE ####

# RScript Calculate_TPM.R
# --FPKM_dir=<directory}
# --Outfile=<directory>

# For each input sample, this program calculates TPM, from the bbmap pileup
# fpkm output.

################
#### Begin program ####

#### Clean workspace and import libraries ####

rm(list = ls())
gc(full = TRUE)


# Import packages needed
library(data.table)
library(compiler)
library(purrr)

print(paste("data.table using", getDTthreads(), "threads."))

#### Tell R which inputs are which ####
library(optparse)
options = list(
  make_option("--FPKM_dir", type="character", default=NULL),
  make_option("--Outfile", type="character", default="./")
);

# Arguments for testing
#args <- c("--FPKM_dir=05_Contig_abundance/Input_files/"
#          , "--Outfile=05_Contig_abundance/test_outfiles/TPM_out.csv")

# Parse these arguments
arguments <- parse_args(OptionParser(option_list = options)
                        #                        , args = args # For testing
)

# Find all of the FPKM file names
af <- list.files(arguments$FPKM_dir, full.names = TRUE, pattern = ".fpkm.tsv")

# Report which file is which
print(paste("FPKM =", arguments$FPKM_dir))
print(paste("Output file =", arguments$Outfile))

# Create a function to calculate TPM and output the values in a standardised 
# format
print(paste("Loading TPM calculation function.", Sys.time()))


calculate_TPM <- function(Sample){
  # Import the data for the sample
  Sample_names <- list.files(arguments$FPKM_dir, pattern = ".fpkm.tsv")
  ff <- fread(paste0(arguments$FPKM_dir, "/", Sample_names[Sample])
              , sep = "\t"
              , skip = 4
              , select = c("#Name", "FPKM"))
  setnames(ff, old = "#Name", new = "Contig") # Work with nice names
  setkey(ff, "Contig") # Enable faster merging
  
  # Calculate TPM values for the sample according to:
  # https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-021-02936-w#Sec2
  Sigma_FPKM <- sum(ff$FPKM)
  ff[, TPM := (FPKM*1e6)/Sigma_FPKM]
  
  ## Tidy, then output the data
  # Keep only columns of interest
  colstokeep <- c("Contig", "TPM")
  ff <- ff[, ..colstokeep]
  
  # Rename the column so that it is the sample name
 # Sample_names <- list.files(arguments$FPKM_dir, pattern = ".fpkm.tsv")
  setnames(ff, c("Contig", sub(".fpkm.tsv", "", Sample_names[Sample])))
  
  # Output the data
  return(ff)
  }

calculate_TPM <- cmpfun(calculate_TPM)

# Calculate TPM values for all samples
print(paste("Beginning TPM calculation for each sample.", Sys.time()))
out_l <- lapply(seq_along(af), calculate_TPM)

# Cheekily save this in binary format so that I get an output on SLURM
saveRDS(out_l, file = sub(".csv", ".rds", arguments$Outfile))

print(paste("Reducing into a single table.", Sys.time()))
# Put all of this information in the same table
out <- out_l %>% reduce(merge.data.table, by = "Contig", all = TRUE)

# Output a file of scaled TPM values
print(paste("Writing to file.", Sys.time()))
fwrite(out, file = arguments$Outfile)
