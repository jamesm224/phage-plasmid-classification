
#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128

##### Define Protein Files #####
#proteins='/work/cascades/clb21565/WW_Analysis/hsp/MGE_analysis/context_analysis/reassembly_workdir/clinkers/myxos.txt.fasta'
#proteins='/work/cascades/clb21565/WW_Analysis/hsp/MGE_analysis/context_analysis/reassembly_workdir/clinkers/annotationdb.faa'

##### List test directory #####
TESTDIR='/projects/ciwars/jamesm22/Final_Hybrid_Data/plasmid_padloc_data/'
cd ${TESTDIR}

# Note - you will need gff files - take a look at making_gffs.sh if you do not have those already #

# Loop through samples #
samples=`ls *.faa | awk '{split($_,x,".fa"); print x[1]}' | sort | uniq`
for sample in $samples
do
padloc --faa ${sample}.faa --gff ${sample}.gff
echo ${sample}
done
