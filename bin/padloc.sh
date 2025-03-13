#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128

cd Accessory_Gene_temp_files

#diamond blastp -q Final_Final_Phages.fasta.faa --db anticrispr_V2.2.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o Phage_allgenomes_ACs.tsv -e 1e-5 --query-cover 80 --id 90


#diamond blastp -q Final_Final_Plasmids.fasta.faa --db anticrispr_V2.2.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o Plasmid_allgenomes_ACs.tsv -e 1e-5 --query-cover 80 --id 90

#diamond blastp -q Total_Final_Final_Hybrids_Updated.fasta_Clustered.fasta.faa --db anticrispr_V2.2.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o Plasmid_allgenomes_ACs.tsv -e 1e-5 --query-cover 80 --id 90

diamond blastp -q /projects/ciwars/jamesm22/Final_Hybrid_Data/Accessory_tool/Total_Final_Final_Hybrids_Updated.fasta_Clustered.fasta.faa --db /projects/ciwars/jamesm22/card-data/CARD.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 1 -o /projects/ciwars/jamesm22/Final_Hybrid_Data/Accessory_tool/CARD_phage_plasmid_rerun.tsv -e 1e-10 --id 80

#hmmsearch --tblout Hybrid_Defense.tsv padlocdb.hmm Final_Final_Plasmids.fasta.faa
