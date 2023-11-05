##### Thank you Connor Brown for base code with this! #####

#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p k80_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 32

samples=`ls *.fasta | awk '{split($_,x,".fa"); print x[1]}' | sort | uniq`
for sample in $samples
do
mkdir ${sample}.o

split -l 2 ${sample}.fasta
Xs=x*
for X in ${Xs}; do cp "$X" "${sample}.o/$(head -1 "$X" | sed 's/>//g' | sed 's/ //g')"; done
cd ${sample}.o

psamples=*
for psample in $psamples; do prokka --metagenome --mincontiglen 1500 --prefix ${psample}.prokka --metagenome --fast --cpus 32 ${psample}; done
mkdir clusters
pcsamples=*.prokka
for pcsample in $pcsamples; do cp ${pcsample}/*.gbk clusters/; done
cd ..
done
