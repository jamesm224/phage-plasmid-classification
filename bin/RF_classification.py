##### Code for processing data against RF Classifer #####

import pickle
import pandas as pd
import os
import numpy as np
os.chdir('/path/to/workdirectory')
path = "."
dir_list = os.listdir(path)

##### Load saved classifer as a pickle file #####
filename = 'finalized_model.sav'
MODEL = pickle.load(open(filename, 'rb'))
MODEL

##### Load data to be classified #####
colname=["Specific Contig","Bacteriophages","Insertion sequences","Integrative elements","Plasmids","Multiple","Total Number of Hits","% Phage","% Plasmid","IE","Phage","RRR","SDT","T","Amount of Unique ORFs"]
tx=pd.read_csv("contig21_input.csv")
lm=tx[['Specific Contig']]  
Xa=np.array(tx)
Xa

##### Process the prediction of samples #####
ls=[]
ld=[]
for i in list(range(0,len(Xa))):
        o=MODEL.predict_proba([Xa[i].tolist()])
        o1=MODEL.predict([Xa[i].tolist()])
        ld.append(o1[0])
        ls.append(o[0])
output=pd.DataFrame(ls).reset_index()
cns=['index','P_plasmid', 'P_Phage', 'P_Hybrid']
output.columns=cns
output

##### Appropriately rename outputs #####
output_classification=pd.DataFrame(ld).reset_index()
cns=['idk','MGE Type']
output_classification.columns=cns
output_classification['MGE Type'] = output_classification['MGE Type'].replace(to_replace='1', value='phage')
output_classification['MGE Type'] = output_classification['MGE Type'].replace(to_replace='0', value='plasmid')
output_classification['MGE Type'] = output_classification['MGE Type'].replace(to_replace='2', value='hybrid')
output_classification

##### Obtain final output dataframe #####
final_out= pd.concat([OUT, lm,OUT_Identity], axis=1, join="inner")

##### Optional Data Wrangling #####
final_out=final_out.drop('index',axis=1)
final_out=final_out.drop('idk',axis=1)
final_out.to_csv('RF_outputfile.csv') 
