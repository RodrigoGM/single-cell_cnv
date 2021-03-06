#!/bin/bash
#BSUB -n 3 -R "rusage[mem=3]" -W 89

set -e -x -o pipefail -u

VARBIN=$HOME/genomes/homo_sapiens/Ensembl/GRCh37.p13/Sequence/varbin/

BAM=$1

OUT5=varbin5k
[ -d $OUT5 ] || mkdir $OUT5
OUT20=varbin20k
[ -d $OUT20 ] || mkdir $OUT20
OUT50=varbin50k
[ -d $OUT50 ] || mkdir $OUT50

EXTENSION=$2
[[ ! -z "$EXTENSION" ]] || EXTENSION=.bam

MID=$( basename $BAM $EXTENSION )
echo $MID

## ploidy multipliers, min and max
MIN=$3
MAX=$4

module load R/R-3.5.2
## source /home/gularter/opt/miniconda3/bin/activate single-cell-cnv
 
Rscript ./src/cbs.r --genomePath=$VARBIN --cell.varbin=${OUT50}/${MID}.50k.varbin.out.txt --seq.stats=${OUT50}/${MID}.50k.varbin.stats.txt --bin.size=50k --ploidy.range=${MIN},${MAX} &
Rscript ./src/cbs.r --genomePath=$VARBIN --cell.varbin=${OUT20}/${MID}.20k.varbin.out.txt --seq.stats=${OUT20}/${MID}.20k.varbin.stats.txt --bin.size=20k --ploidy.range=${MIN},${MAX} &
Rscript ./src/cbs.r --genomePath=$VARBIN --cell.varbin=${OUT5}/${MID}.5k.varbin.out.txt --seq.stats=${OUT5}/${MID}.5k.varbin.stats.txt --bin.size=5k --ploidy.range=${MIN},${MAX} &

wait ${!}

