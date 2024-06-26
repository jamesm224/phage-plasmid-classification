#!/usr/bin/python

##### Load Packages #####
import pandas as pd
import os
from itertools import groupby
import argparse

##### Define Argparse Script #####
parser=argparse.ArgumentParser(description='parse seqs to extract taxa')
parser.add_argument("--i", type=str, required=True,
                    help="Input clust file")
parser.add_argument("--o", type=str, required=True,
                    help="Output file")
parser.add_argument("--p", type=float, required=True,
                    help="Output file")
parser.add_argument("--h", type=float, required=True,
                    help="Output file")
parser.add_argument("--fp", type=float, required=True,
                    help="Output file")
parser.add_argument("--fh", type=float, required=True,
                    help="Output file")
parser.add_argument("--mp", type=float, required=True,
                    help="Output file")
parser.add_argument("--mh", type=float, required=True,
                    help="Output file")
args=parser.parse_args()
path = "."
dir_list = os.listdir(path)

##### Define Variables and load input files #####
##### mobileOGs_Cluster_Purity.csv made using the generate_purity.py  #####
STMetadata=pd.read_csv("mobileOGs_Cluster_Purity.csv")
STMetadata['Plasmid Purity'] = STMetadata['Plasmid Purity'].astype(float)
Plasmid_Hits=STMetadata.loc[(STMetadata['Plasmid Purity'] > args.p)]
Final_Plasmid_Hits=Plasmid_Hits[["mobileOG Cluster"]]
Phage_Hits=STMetadata.loc[(STMetadata['Phage Purity'] > args.h)]
Final_Phage_Hits=Phage_Hits[["mobileOG Cluster"]]
Hybrid_data=pd.read_csv("Filtered_PAPERControl.csv")
Total_Hybrids=Hybrid_data[['Specific Contig']]
Total_Hybrids=Total_Hybrids.groupby(by=["Specific Contig"]).size().reset_index()

##### Filter variables by mobileOG cluster purity #####
Processed_Phage_Merge=pd.merge(Hybrid_data,Final_Phage_Hits,left_on=Hybrid_data["mobileOG ID"], right_on=Final_Phage_Hits["mobileOG Cluster"], left_index=False, right_index=False)
Processed_Phage_Merge=Processed_Phage_Merge.loc[(Processed_Phage_Merge['% Plasmid'] > args.fp)]
Processed_Plasmid_Merge=pd.merge(Hybrid_data,Final_Plasmid_Hits,left_on=Hybrid_data["mobileOG ID"], right_on=Final_Plasmid_Hits["mobileOG Cluster"], left_index=False, right_index=False)
Processed_Plasmid_Merge=Processed_Plasmid_Merge.loc[(Processed_Plasmid_Merge['% Phage'] > args.fh)]
Processed_Filter_Merge=Hybrid_data.loc[(Hybrid_data['% Phage']> args.mh) & (Hybrid_data['% Plasmid'] > args.mp)]
Final_Processed_Hybrids=pd.concat([Processed_Plasmid_Merge, Processed_Phage_Merge,Processed_Filter_Merge]).reset_index()
Final_Processed_Hybrids=Final_Processed_Hybrids.groupby(by=["Specific Contig"]).size().reset_index()
Total_Samples=len(Total_Hybrids)
False_Negatives=len(Total_Hybrids)-len(Final_Processed_Hybrids)
True_Positives=len(Final_Processed_Hybrids)

##### Write Experiments to output files #####
outFile = open("{}.tsv".format(args.o), "w")
outFile.write(str(Total_Samples) + ',' + str(False_Negatives) + ',' + str(True_Positives))
outFile.close()
