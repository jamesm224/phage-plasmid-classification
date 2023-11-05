##### Obtain the size of genomes for samples examined in experiment #####
import pandas as pd
import os
os.chdir('/projects/ciwars/jamesm22/Final_Hybrid_Data/')
path = "."
dir_list = os.listdir(path)
genome=pd.read_csv("Total_Final_Hybrids.tsv",sep='\t',header=None,names=['Contig','DNA'])
genome["DNA Length"]= genome["DNA"].str.len()
genome_size=genome[['DNA Length']]
genome_size=genome_size.sort_values(by=['DNA Length'])
genome_size=genome_size[genome_size['DNA Length'] > 10000]
##### Samples were filtered by <300,000bp and >10,000bp as noted in the paper ####
genome_size
