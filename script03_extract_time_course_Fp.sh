#!bin/sh

set -e
##### Step01: compute mean for each atlase ##########

img_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest"
mask_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/post_processing/VisorT1_iso2nii-selected/wMNI/IndEnvMask"
output_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest_output"

mkdir -p $output_dir

# ---------------------------------------------------

#for img_4d in $(find $img_dir/*.rest - name 'normalized_func_data.nii.gz');
for img_4d in `ls $img_dir/*.rest/normalized_func_data.nii.gz`;
do
  echo $img_4d
  #atlases="Atlases/"
  #subject_id=$(echo $img_4d | awk -F "/" "{print $6}" | sed 's/CausCon_//' | sed 's/_rest.rest//')
  subject_id=${img_4d##*CausCon_}
  subject_id=${subject_id%%_rest*}
  subject_id=${subject_id:(-4)}
  echo $subject_id

  #for atlas in $(find $mask_dir -name '.nii.gz');
  for atlas in `ls $mask_dir/L_Fp/$subject_id*.nii.gz`;
  do
      fslmeants -i $img_4d -o $output_dir/tempc01_${subject_id}_Ind_L_Fp.txt -m $atlas
  done
  
  for atlas in `ls $mask_dir/R_Fp/$subject_id*.nii.gz`;
  do
      fslmeants -i $img_4d -o $output_dir/tempc01_${subject_id}_Ind_R_Fp.txt -m $atlas
  done
  
  ##### Step02: combine data for all atlases ##########
  if [ -f tempc01_${subject_id}*Fp.txt]; then

      ls $output_dir/tempc01_${subject_id}_*.txt | tr "\n" "\t"| sed 's/tempc01_//g'| sed 's/.txt//g' > time_course_ind_fp${subject_id}.txt
      
      # add Feed Line, echo automaticlly add \n at the end of line, so we just add an empty charactor:
      echo "" >> time_course_ind_fp${subject_id}.txt
      
      paste -d "\t" tempc01_*.txt >> time_course_ind_fp${subject_id}.txt
      
      cp time_course_ind_fp${subject_id}.txt $output_dir
      #mv time_course_ind_fp${subject_id}.txt $output_dir
      rm tempc01_${subject_id}*

  if

done


