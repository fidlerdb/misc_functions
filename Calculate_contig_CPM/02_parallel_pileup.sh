#!/bin/bash
##########################
# Charge SYNBIOGAS the hours
#SBATCH --account=scw2101

#SBATCH --job-name=pileup
## Output and error files
#SBATCH --output=OutErr/pileup.out.%J
#SBATCH --error=OutErr/pileup.err.%J

## How to run the job
#SBATCH -p highmem
#SBATCH --ntasks=5
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=1
#SBATCH --time=0-05:00:00
#SBATCH --mem=374G

## email me when the job has ended
#SBATCH --mail-type=ALL
#SBATCH --mail-user=d.fidler@bangor.ac.uk

#########################

module purge
module load parallel/20210322
module load samtools/1.17

parallel -N 1\
 --delay 0.2\
 -j $SLURM_NTASKS\
 --joblog OutErr/pileup.joblog\
 --resume\
 --retries 2\
 < commands_pileup.txt

# -N = max args to take per srun command. i.e. 1 (sample name)
# -j = number of jobs to run in parallel
