
#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 128
#proteins='/work/cascades/clb21565/WW_Analysis/hsp/MGE_analysis/context_analysis/reassembly_workdir/clinkers/myxos.txt.fasta'
#proteins='/work/cascades/clb21565/WW_Analysis/hsp/MGE_analysis/context_analysis/reassembly_workdir/clinkers/annotationdb.faa'
TESTDIR='/projects/ciwars/jamesm22/Final_Hybrid_Data/plasmid_padloc_data/'
cd ${TESTDIR}
samples=`ls *.faa | awk '{split($_,x,".fa"); print x[1]}' | sort | uniq`
for sample in $samples
do
padloc --faa ${sample}.faa --gff ${sample}.gff
#prodigal -i ${sample}.fasta -o prodigal_out -a ${sample}.faa -p meta
#padloc --faa /projects/ciwars/jamesm22/Final_Hybrid_Data/fastANI_Hybrids_Clustered/${sample}.faa --gff /projects/ciwars/jamesm22/Final_Hybrid_Data/fastANI_H
ybrids_Clustered/${sample}.gff
#echo ${sample}
done
