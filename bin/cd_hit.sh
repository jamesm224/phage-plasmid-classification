##### Code to cluster phage-plasmids by CD-HIT-EST #####
#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128

cd-hit-est -i $1 -o $1_Clustered.fasta -n 10 -c 0.97 -M 0 -T 10
