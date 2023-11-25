##### Load Packages and set working directory #####
import pandas as pd
import os
import numpy as np
os.chdir('/projects/ciwars/jamesm22/')
path = "."
dir_list = os.listdir(path)
SMetadata=pd.read_csv('mobileOG-db-beatrix-1.6-All.csv')

##### Define and Subset Metadata File Columns #####
Subset_Metadata=SMetadata[["PlasmidRefSeq","COMPASS","pVOG","immedb","ICE","IME","CIME","AICE","ISFinder","GPD","ACLAME"]].astype(float)
STMetadata= SMetadata[["mobileOG Cluster","Major mobileOG Category","Minor mobileOG Categories","Name","mobileOG Entry Name"]]
Subset_Metadata["mobileOG Cluster"] = SMetadata['mobileOG Cluster']

##### Group the appropriate MGE Categories Together #####
Subset_Metadata["Plasmid"] =Subset_Metadata["PlasmidRefSeq"] + Subset_Metadata["COMPASS"]
Subset_Metadata['Phage']=Subset_Metadata["pVOG"] + Subset_Metadata["GPD"]
Subset_Metadata["Insertion Sequence"] =Subset_Metadata["ISFinder"]
Subset_Metadata["Integrative Element"] =Subset_Metadata["AICE"] + Subset_Metadata["ICE"]+ Subset_Metadata["CIME"]+ Subset_Metadata["IME"]+ Subset_Metadata["i
mmedb"]
Subset_Metadata["Multiple"] =Subset_Metadata["ACLAME"]
Subset_Metadata['Total Number of Hits'] = Subset_Metadata['Phage']  + Subset_Metadata['Multiple'] + Subset_Metadata['Plasmid'] + Subset_Metadata['Integrative
 Element'] + Subset_Metadata['Insertion Sequence']
STMetadata=STMetadata.sort_values(by=['mobileOG Cluster'])

##### Obtain the counts of each mobileOG cluster for each MGE class #####
STMetadata['Plasmid'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Plasmid'].transform('sum')
STMetadata['Phage'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Phage'].transform('sum')
STMetadata['IGE'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Integrative Element'].transform('sum')
STMetadata['Insertion Sequence'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Insertion Sequence'].transform('sum')
STMetadata['MISC'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Multiple'].transform('sum')
STMetadata['Total'] = Subset_Metadata.groupby(['mobileOG Cluster'])['Total Number of Hits'].transform('sum')

##### Calculate the purity of each MGE class for each respective mobileOG cluster #####
STMetadata['Phage Purity'] = (STMetadata['Phage'] / STMetadata['Total']) *100
STMetadata['Plasmid Purity'] = (STMetadata['Plasmid'] / STMetadata['Total']) *100
STMetadata['IS Purity'] = (STMetadata['Insertion Sequence'] / STMetadata['Total']) *100
STMetadata['IGE Purity'] = (STMetadata['IGE'] / STMetadata['Total']) *100
STMetadata['MISC Purity'] = (STMetadata['MISC'] / STMetadata['Total']) *100
STMetadata

##### Save the output files of the purity of each unique mobileOG Clusters #####
STMetadata.to_csv("mobileOGs_Cluster_Purity.csv")
