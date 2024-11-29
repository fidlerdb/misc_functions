# create_commands_pileup.txt
# Loop over each line of the file samples.txt, and put the sample name in the places I want them
# Print each of these to a single line
# Create this file, run:
# chmod +x create_commands_bedtools.txt
# ./create_commands_pileup.txt > commands_pileup.txt
# That output can be passed to a run script.

mkdir pileup_out
mkdir FPKM_out

for line in $(cat samples.txt);
 do    echo "./bbmap/pileup.sh in=bams/$line.bam out=pileup_out/$line.cov rpkm=FPKM_out/$line.fpkm.tsv";
 done > commands_pileup.txt

#./bbmap/pileup.sh in=../Mapping/BAM_no_duplicates/$line.nodup.bam out=pileup_out/$line.cov rpkm=FPKM_out/$line_fpkm.tsv
#./bbmap/pileup.sh in=../Mapping/BAM_no_duplicates/$line.nodup.bam out=pileup_out/$line.cov rpkm=RPKM/$line_fpkm.tsv

