##### Convert CARD output to specific classes of ARGs #####

##### Load Packages and Data #####
import pandas as pd
import os
os.chdir('/projects/ciwars/jamesm22/card-data/')
path = "."
dir_list = os.listdir(path)
ARG_work=pd.read_csv("Plasmid_Test_ARGs.tsv",sep='\t',header=None)
ARG_work.columns =['0', '1', '2', '3','4','5','6']

##### Data Wrangling #####
ARG_work['Specific Contig'] = ARG_work['1'].str.split('>').str[1]
ARG_work['Specific Contig'] = ARG_work['1'].str.split('#').str[0]
ARG_work['Specific Contig'] = ARG_work['Specific Contig'].apply(lambda r: '_'.join(r.split('_')[:-1]))
ARG_work['ARG'] = ARG_work['0'].str.split('|').str[3]
ARG_work['ARG'] = ARG_work['ARG'].str.split('[').str[0]
ARG_work['Assoc'] = ARG_work['0'].str.split('|').str[3]
ARG_work['Predicted Host'] = ARG_work['Assoc'].str.split('[').str[1]
ARG_work['Predicted Host']= ARG_work['Predicted Host'].str.replace("]","")
ARG_work['ARO'] = ARG_work['0'].str.split('|').str[2]
ARG_work['ARG'] = ARG_work['ARG'].str.split('[').str[0]
ARG_work['Predicted Gene Name'] = ARG_work['0'].str.split('|').str[1]
ARG_work['ARG']= ARG_work['ARG'].str.replace("Escherichia coli","")
ARG_work['MGE']='Plasmid'
ARG_work

##### Subset Data in managable data output #####
ARG_Plasmid=ARG_work[['MGE','ARG','ARO','Specific Contig','Predicted Gene Name','Predicted Host']]
ARG_Plasmid=ARG_Plasmid.rename(columns={"0": "Summary Output"})
ARG_Plasmid.to_csv('Plasmid_ARGs_test.csv')

##### Get statistics from outputs #####
ARG_Final = ARG[['ARG']]
ARG_Final=ARG_Final.groupby(['ARG']).size().reset_index()
ARG_Final.columns =['ARG','Freq']
ARG_Final=ARG_Final.sort_values(by=['Freq'],ascending=False)
ARG_Final['Freq']=ARG_Final['Freq'].astype(int)
Sum = ARG_Final['Freq'].sum().astype(int)
ARG_Final['Abundance']=(ARG_Final['Freq']/Sum)*100
ARG_Final
