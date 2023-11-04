# Phage-Plasmid Classification

Here we classified, sorted, and analyzed phage-plasmids from samples from 4 databases to obtain a large, comprehensive collection of 5,743 unique P-P sequences.

# Overall Workflow

1. Isolated genomes from IMG/VR, PLSDB, GPD, and MGV
2. Processed samples through mobileOG-db (k=15, p=40%, q=50%, e=1e-5)
3. Reclassified results using a RF classifier with prior classified data
4. Clustered similar phage-plasmids to remove similar sequences
5. Analyzed Metadata to determine source locations of phage-plasmids
6. Additional tools for further pangenome analysis
   
<img width="750" alt="image" src="https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/65a08f67-2b46-47af-9348-ccfe7593f3b9">

# Source Code

The files in this repository contain code and smaller data files. If you want additional information, please read our paper () or reach out to James Mullet directly for further information/questions (jmullet@mit.edu).

Testing and Training Data:

   a. phage_and_plasmid _negative_controls.txt
   b. phage_plasmid_training_data.txt
   c. classified_phage_plasmids.txt

Workflow Code:

   a. optimization_experiment.sh - Examine optimal parameters for processing phage-plasmids using mobileOG-pl
   b. create_classifier_inputs.py - Convert data from mobileOG-pl to RF Classifier
   c. creating_RF_classifier.py - Train/test the RF classifier
   d. RF_classification.py - Classify samples from data
   

RF Classifier Input Example:
![image](https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/5fe27d62-1b4e-42a2-9725-d765ab1f3d4c)

Associated metadata located in supplemental tables/figures. All furthur analysis were performed using Python and R packages.
