#!/bin/sh

input_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/post_processing/tmsfmri/group_analysis_HRF_all"
#mask=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz;
mask="/Shared/jianglab/3_Data_Working/masks/gray_thr0.3.nii"

tms_site=("L_aMFG" "R_aMFG" "L_pMFG" "R_pMFG" "R_M1")

for site in "${tms_site[@]}"; do
  for f in $input_dir/$site/NTHC_2ndlevel/CausCon*.nii; do
  #for f in $input_dir/$site/NTS_2ndlevel/CausCon*.nii; do
    echo $f
    m=$(fslstats -t $f -n -M -k $mask)
    s=$(fslstats -t $f -n -S -k $mask)

    f_out=${f%%.nii}_zscore_gm.3_mask

    fslmaths $f -sub $m -div $s -mas $mask $f_out
  done
done


