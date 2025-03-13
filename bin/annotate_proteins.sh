#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128

# To annotate proteins you must use various database: 
# AntiCrisprDBv2.2 (anti-CRISPR systems): https://doi.org/10.1093/database/baac010
# CARD Database (ARGs): https://doi.org/10.1093/nar/gkac920
# VFDB (Virulence Factors): https://doi.org/10.1093/nar/gkab1107
# BacMet2 (MRGs): https://doi.org/10.1093/nar/gkt1252
# Padloc (Defense System): See padloc_analysis.sh script

##### Here are a few examples - they are the same minus swapping out the database #####
# AntiCRISPR Annotations #
#diamond blastp -q phage_plasmids.faa --db anticrispr_V2.2.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o phage_plasmid_output_ACs.tsv -e 1e-5 --query-cover 80 --id 90

# CARD Annotations #
diamond blastp -q phage_plasmids.faa --db CARD.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o phage_plasmid_output_CARD.tsv -e 1e-5 --query-cover 80 --id 90

