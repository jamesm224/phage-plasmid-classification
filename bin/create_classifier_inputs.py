import pandas as pd 
from pathlib import Path

##### Process the mobileOG-pl outputs into one dataframe #####


##### Path to outouts #####
working_directory="/projects/ciwars/jamesm22/test_df"


##### Create empty dfs #####
temp_protein_hits_out=[]
temp_summary_out=[]


##### Load protein output files and convert to obtain mobileOG-db Major Category counts #####
for protein_output in Path(working_directory).glob('*.mobileOG.Alignment.Out.csv'):
    hybrid_protein = pd.read_csv(protein_output)
    temp_protein_hits_out.append(hybrid_protein) 

protein_hits_out = pd.concat(temp_protein_hits_out, ignore_index=True)

temp_protein_hits_out=protein_hits_out[['Specific Contig','Major mobileOG Category']]

subset_protein_hits_out=temp_protein_hits_out.groupby(['Specific Contig','Major mobileOG Category']).size()
subset_protein_hits_out=subset_protein_hits_out.reset_index()
subset_protein_hits_out.columns = ['Specific Contig','Major mobileOG Category','values']

final_protein_hits_out=pd.pivot(subset_protein_hits_out, index='Specific Contig', columns='Major mobileOG Category').reset_index()
final_protein_hits_out.columns = ['Specific Contig','IE','Phage','RRR','SDT','T']
final_protein_hits_out=final_protein_hits_out.fillna(0)
final_protein_hits_out


##### Load genome summary files and convert to easy to interpret format #####
for summary_output in Path(working_directory).glob('*.summary.csv'):
    hybrid_summary = pd.read_csv(summary_output)
    temp_summary_out.append(hybrid_summary)
summary_hits_out = pd.concat(temp_summary_out, ignore_index=True)
summary_hits_out=summary_hits_out.drop(columns=['Unnamed: 0','Percent Insertion sequences','Percent Integrative elements','Percent Multiple'])
summary_hits_out.rename(columns={'Percent Bacteriophages':'% Phage','Percent Plasmids':'% Plasmid'}, inplace=True)
summary_hits_out


##### Merge and load the proteins and summary files to obtain cleaned df #####
merge_df=pd.merge(summary_hits_out, final_protein_hits_out, on='Specific Contig', how='outer')
merge_df.drop_duplicates(subset=['Specific Contig'], keep="first", inplace=True)
merge_df.reset_index()
merge_df
