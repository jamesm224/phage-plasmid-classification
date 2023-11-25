#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 24
#module load Anaconda
source activate BiopythonProject
#module purge


TESTDIR='/projects/ciwars/jamesm22/filter_experiments'

plasmid_purities='50 60 70 80 90'
phage_purities='50 60 70 80 90'
filter_phages='50 60 70 80'
filter_plasmids='50 60 70 80'
min_plasmids='10 15 20 25 30 35'
min_phages='10 15 20 25 30 35'

cd ${TESTDIR}
for plasmid_purity in $plasmid_purities
do
for phage_purity in $phage_purities
do
for filter_phage in $filter_phages
do
for filter_plasmid in $filter_plasmids
do
for min_plasmid in $min_plasmids
do
for min_phage in $min_phages
do
metadata='mobileOG-db-beatrix-1.6-All.csv'

python ${TESTDIR}/Hybrid1_optimization.py --o ${plasmid_purity}:${phage_purity}:${filter_phage}:${filter_plasmid}:${min_plasmid}:${min_phage} --i ${metadata} --p ${plasmid_purity} --h ${phage_purity} --fp ${filter_plasmid} --fh ${filter_phage} --mp ${min_plasmid} --mh ${min_plasmid}

done
done
done
done
done
done
