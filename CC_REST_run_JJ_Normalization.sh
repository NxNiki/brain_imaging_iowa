#!/bin/sh


######################
TARGETDIR="rest"

DATADIR=$SCRATCH/CausalConnectome/rest/
FSLDIR=/share/software/user/open/fsl/5.0.10
cd $DATADIR

for i in `ls -d CausCon_**.${TARGETDIR}`  ; do

if [ ! -f ${i}/prefiltered_func_data.nii.gz ] ; then
cp archive/${i}/prefiltered_func_data.nii.gz ${i}/
fi

if [ ! -f ${i}/normalized_func_data.nii.gz ] ; then
  sbatch -p normal,owners --time=00:20:00 --wrap="${FSLDIR}/bin/applywarp -i ${i}/prefiltered_func_data.nii -w ${i}/reg/highres2standard_warp --premat=${i}/reg/example_func2highres.mat -r ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -o ${i}/normalized_func_data.nii -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask"

#gunzip -f ${i}/normalized_func_data.nii.gz
    echo RUNNING on $i
fi

done
cd ../

#
