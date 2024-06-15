# Phage-Plasmid Classification

Here we classified, sorted, and analyzed phage-plasmids from around 1,100,000 genomes from 4 databases to obtain a large, comprehensive collection of 5,743 unique P-P sequences from a diverse array of environmental source locations.

Phage-Plasmid Example:

![proksee (4)](https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/ebe7a099-d634-4f36-bf60-c70e560b195d)
Example identified above visualized with Proksee, mobileOG-db, CARD, and Prokka:

 
# Overall Workflow

1. Isolated genomes from IMG/VR, PLSDB, GPD, and MGV
2. Processed samples through mobileOG-db (k=15, p=40%, q=50%, e=1e-5)
3. Reclassified results using a RF classifier with prior classified data
4. Clustered similar phage-plasmids to remove similar sequences
5. Analyzed Metadata to determine source locations of phage-plasmids
6. Additional tools for further accessory gene analysis

<img width="878" alt="figure_1" src="https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/25dbd2d3-0bb3-4e26-968b-0e45b4bdff38">






# Source Code

The files in this repository contain code and smaller data files. If you want additional information, please read our paper () or reach out to James Mullet directly for further information/questions (jmullet@mit.edu). Additionally, genomes and other metadata can be found on Figshare located here: 

1. Bins Folder - Contains many scripts used in the experimental design of this project
2. Data Folder - Includes the input testing/training data and classified phage-plasmid accessions
3. Plots Folder - Contain a few of the plots code created in experiment (feel free to reach out if you want additional plots code)
   
RF Classifier Input Example:
![image](https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/5fe27d62-1b4e-42a2-9725-d765ab1f3d4c)

Associated metadata located in supplemental tables/figures. All further analysis were performed using Python and R packages.
