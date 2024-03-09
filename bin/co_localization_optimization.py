#!/usr/bin/python

import pandas as pd
import os
from itertools import groupby
import argparse

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

STMetadata=pd.read_csv("mobileOGs_Cluster_Purity.csv")
STMetadata['Plasmid Purity'] = STMetadata['Plasmid Purity'].astype(float)
Plasmid_Hits=STMetadata.loc[(STMetadata['Plasmid Purity'] > args.p)]
Final_Plasmid_Hits=Plasmid_Hits[["mobileOG Cluster"]]
Phage_Hits=STMetadata.loc[(STMetadata['Phage Purity'] > args.h)]
Final_Phage_Hits=Phage_Hits[["mobileOG Cluster"]]
