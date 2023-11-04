# phage-plasmid-classification

Here we classified, sorted, and analyzed phage-plasmids from samples from 4 databases!

# How did we do it?

1. Isolated genomes from IMG/VR, PLSDB, GPD, and MGV
2. Processed samples through mobileOG-db (k=15, p=40%, q=50%, e=1e-5)
3. Reclassified results using a RF classifier with prior classified data
4. Clustered similar phage-plasmids to remove similar sequences
5. Analyzed Metadata to determine source locations of phage-plasmids
6. Additional tools for further pangenome analysis
   
<img width="570" alt="image" src="https://github.com/jamesm224/phage-plasmid-classification/assets/86495895/65a08f67-2b46-47af-9348-ccfe7593f3b9">
