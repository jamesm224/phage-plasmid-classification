#!/bin/bash
#SBATCH -t 140:00:00
#SBATCH -p normal_q
#SBATCH -A prudenlab
#SBATCH -N 1 
#SBATCH -n 24

TESTDIR='/path/to/workdirectory'


##### Range of experimental values tested #####
identities='40 50 60 70 80 90'
coverages='40 50 60 70 80 90'


##### Parser Script #####
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

    case $key in
    -i|--input)
      samples="$2"
      shift
      shift
      ;;
    -k|--kvalue)
      KVALUE="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--escore)
      ESCORE="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--pidentvalue)
      PIDENTVALUE="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--db)
      DIAMOND="$2"
      shift # past argument
      shift # past value
      ;;
    -q|--queryscore)
      QUERYSCORE="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--metadata)
      METADATA="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--output)
      OUTPUT="$2"
      shift # past argument
      shift # past value  
      ;;
     esac
done

set -- "${POSITIONAL[@]}"
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi


##### Loop through unique parameters in optimization #####
cd ${TESTDIR}
for identity in $identities
do
for coverage in $coverages
do


##### Load samples from trainining data and process through the different parameters #####
metadata='mobileOG-db-beatrix-1.6-All.csv'
samples='P-P_CompleteGenomes.fasta'
for sample in $samples
do
prodigal -i ${sample} -p meta -a ${sample}.faa
diamond blastp -q ${sample}.faa --db mobileOG-db-beatrix-1.6.dmnd --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 15 -o ${sample}.tsv -e 1e-5 -p ${identity} -q ${coverage}
python mobileOGs-pl-kyanite.py --o ${sample}:${identity}:${coverage} --i ${sample}.tsv -m mobileOG-db-beatrix-1.6.All.csv
done
done
done
