##### Examined PFAM Distributions from phage-plasmids #####

##### Load packages and Data #####
import pandas as pd
import os
import numpy as np
os.chdir('/projects/ciwars/jamesm22/Final_Hybrid_Data/')
path = "."
dir_list = os.listdir(path)
raw_meta=pd.read_csv('PFAM_Metadata_Complete_Updated.csv')
meta=pd.read_csv('mobileOG-db_1.6.orthology_assignments.tsv',sep='\t')
meta['Major_category'] = meta['#query'].str.split('|').str[3]
meta['Minor_category'] = meta['#query'].str.split('|').str[4]
small_meta= meta[["PFAMs","Major_category","Minor_category"]]
small_meta=small_meta.assign(PFAMs=small_meta['PFAMs'].str.split(",")).explode('PFAMs')

##### Subset data based on specific protein functions #####
working_meta=small_meta[small_meta['Minor_category']=='lysis/lysogeny']
working_meta = working_meta.replace('-', np.nan)
working_meta=working_meta.dropna()
working_meta= working_meta.drop_duplicates(subset=['PFAMs'])
working_meta=small_meta[small_meta['Major_category']=='replication/recombination/repair']
working_meta=working_meta[working_meta['Minor_category']!='phage']
working_meta = working_meta.replace('-', np.nan)
working_meta=working_meta.dropna()
working_meta= working_meta.drop_duplicates(subset=['PFAMs'])
working_meta

##### Combine proteins with PFAMs to obtain all PFAMs from phage-plasmids with specific mobileOG-db functions #####
##### Customizable to whatever major/minor categories being examined #####
merged_pfam=pd.merge(working_meta,raw_meta, on='PFAMs', how='inner')
#merged_pfam.to_csv('PFAM_working_output.csv')
