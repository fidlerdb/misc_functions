#!/bin/bash
#############################
# Charge SYNBIOGAS the hours
#SBATCH --account=scw2101

# job name
#SBATCH --job-name=TPM

## job stdout file
#SBATCH --output=OutErr/TPM.out.%J

## job stderr file
#SBATCH --error=OutErr/TPM.err.%J

## email me when the job starts and ends
#SBATCH --mail-type=ALL
#SBATCH --mail-user=d.fidler@bangor.ac.uk

## How are we running the job?
#SBATCH --partition=dev # High-throughput partition for serial jobs
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=0-00:59:00
##SBATCH --test-only

########################

module purge
module load R/4.1.0

Rscript R_Scripts/Calculate_TPM.R --FPKM_dir=FPKM_out --Outfile=Blackout_contigs_TPM.csv
