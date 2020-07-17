#!/bin/bash 
# File: download_SRA.sh 
## Konstantinos Con_Yel 
## Download SRA data with the help of docker 

shopt -s xpg_echo

INPUT_txt="$1" 
OUTPUT_DIR="$PWD/downloaded_SRA"
PROCESSORS="${2:-4}"

DOCKER="docker" 
PIGZ="pigz" 

if [ $# -lt 1 ]; then 
echo "USAGE: download_SRA.sh <INPUT_txt> <PROCESSORS>, input.txt should /
have all SRA ids, one per line, the script downloads everything on $PWD/downloaded_SRA dir" w
exit 1 
fi 

mkdir "$PWD/downloaded_SRA"
echo "it's downloading the files in : $OUTPUT_DIR with $PROCESSORS processors"

# check prerequisites
PREREQS="${DOCKER} ${PIGZ}" 

for prereq in $PREREQS; do 
if ! [ -x "$(command -v ${prereq})" ]; then 
echo "the ${prereq} not found"; 
exit 1 
fi
done 


while read -r line; do
 echo "Now downloading "${line}"\n"
 docker run --rm -v "$OUTPUT_DIR":/data -w /data inutano/sra-toolkit fasterq-dump "${line}" -t /data/shm -e $PROCESSORS
 if [[ -s $OUTPUT_DIR/${line}.fastq ]]; then
 echo "Using pigz on ${line}.fastq" 
     pigz --best $OUTPUT_DIR/${line}*.fastq
 else 
    echo "$OUTPUT_DIR/${line}.fastq not found"
 fi
 done < "$INPUT_txt"
