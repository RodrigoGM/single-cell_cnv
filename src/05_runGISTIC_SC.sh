#!/bin/bash
## run as bsub -Is -n 1 -M 4 -W 16:00 ./runGistic.sh
#BSUB -n 1 -M 12 -W 359

set -e -x -o pipefail -u

HG19MAT=${HOME}/genomes/homo_sapiens/Ensembl/GRCh37.p13/Sequence/GISTIC2/hg19.mat

VBINS50K=res/gistic/grch37.bin.boundaries.50k.bowtie.k50.makerFile.txt
VBINS20K=res/gistic/grch37.bin.boundaries.20k.bowtie.k50.makerFile.txt
VBINS5K=res/gistic/grch37.bin.boundaries.5k.bowtie.k50.makerFile.txt


CONF=$1
INFILE=$2
EXTENSION=$3
[[ ! -z "$EXTENSION" ]] || EXTENSION=.seg
OUT_STEM=$( basename $INFILE $EXTENSION )   
OUT_DIR=$4

BD=${OUT_DIR}/out_SC_${OUT_STEM}_c${CONF}  ## out_hg19_1M_c${CONF}


[[ -d $BD ]] || mkdir $BD

## Set thresholds for copy number to AMP = log2(2.5/2), and DEL = log2(1.2/2)
~/bin/gistic2 -refgene ${HG19MAT} -b ${BD} -seg ${INFILE} -mk $VBINS50K \
	      -ta 0.321 -td 0.736 -conf 0.${CONF} -broad 1 -twoside 1 \
	      -res 0.03 -genegistic 1 -rx 0 -js 8 -cap 3.3219\
	      -savegene 1 -gcm median -v 10 -armpeel 1


## __END__
## Usage: gp_gistic2_from_seg -b base_dir -seg segmentation_file
## -refgene ref_gene_file  [-mk markers_file] [-alf array_list_file(def:empty)]
## [-cnv cnv_file] [-ta amplifications_threshold(def=.1)] [-td deletions_threshold(def=.1)]
## [-js join_segment_size(def=8)] [-ext extension] [-qvt qv_thresh(def=0.25)]
## [-rx remove_x(def=1)] [-v verbosity_level(def=0)] [-cap cap_val(def=1.5]]
## [-broad run_broad_analysis(def=0)] [-brlen broad_length_cutoff(def=0.98)]
## [-maxseg max_sample_segs(def=2500)] [-res res(def=0.05)] [-conf conf_level(def=0.75)]
## [-genegistic do_gene_gistic(def=0)] [-smalldisk save_disk_space(def=0)]
## [-smallmem use_segarray(def=1)] [-savegene write_gene_files(def=0)]
## [-arb do_arbitration(def=1)] [-twosides use_two_sided(def=0)] [-peaktype peak_types(def=robust)]
## [-saveseg save_seg_data(def=1)] [-savedata write_data_files(def=1)]
## [-armpeel armpeel(def=1)] [-gcm gene_collapse_method(def=mean)]
## [-scent sample_center(def=median)] [-maxspace max_marker_spacing]
## [-logdat islog(def=auto-detect)]
