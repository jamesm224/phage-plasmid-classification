##### Code to generate microbeannotator results #####

#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128

##### Create database #####
microbeannotator_db_builder -d MicrobeAnnotator_DB -m blast -t 128 --light

##### Run samples against db #####
microbeannotator -i /projects/ciwars/jamesm22/Clustered_Hybrids/*.faa -d MicrobeAnnotator_DB -m blast -p 10 -t 10 -o /projects/ciwars/jamesm22/MicrobeAnnota
tor_DB/
