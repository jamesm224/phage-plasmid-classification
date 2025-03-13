#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p k80_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 32

# Loop through all nucleotide fasta in directory #
# Ensure you have prokka installed to run this command - it uses the gff file prokka generates #
# Alternatively to this script you can just run prokka yourself too! #
samples=`ls *.fasta | awk '{split($_,x,".fa"); print x[1]}' | sort | uniq`

for sample in $samples
do
mkdir ${sample}.gff.o
#tr "\t" "\n" < ${sample}.fasta > ${sample}.fna
split -l 2 ${sample}.fasta
Xs=x*
for X in ${Xs}; do cp "$X" "${sample}.gff.o/$(head -1 "$X" | sed 's/>//g' | sed 's/ //g')"; done

cd ${sample}.gff.o

psamples=*
for psample in $psamples; do prokka --metagenome --mincontiglen 1500 --prefix ${psample}.prokka --metagenome --fast --cpus 32 ${psample}; done
mkdir clusters
pcsamples=*.prokka
for pcsample in $pcsamples; do cp ${pcsample}/*.gff clusters/; done
cd ..
done
