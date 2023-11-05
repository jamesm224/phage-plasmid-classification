
#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 32
#module load Anaconda/2020.11
#source activate mobileOG-db
./mobileOGs-pl-kyanite.sh -i $1 -d mobileOG-db-beatrix-1.6.dmnd -m mobileOG-db-beatrix-1.6.All.csv -k 15 -e 1e-5 -p 40 -q 50
