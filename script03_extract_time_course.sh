#!bin/sh

set -e
##### Step01: compute mean for each atlase ##########

img_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest"
mask_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/post_processing/VisorT1_iso2nii-selected/wMNI/GroupEnvMask"
output_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest_output"

mkdir -p $output_dir
curr_dir=$(pwd)

# ---------------------------------------------------

#for img_4d in $(find $img_dir/*.rest - name 'normalized_func_data.nii.gz');
for img_4d in `ls $img_dir/*.rest/normalized_func_data.nii.gz`;
do
  echo $img_4d
  #atlases="Atlases/"
  #subject_id=$(echo $img_4d | awk -F "/" "{print $6}" | sed 's/CausCon_//' | sed 's/_rest.rest//')
  subject_id=${img_4d##*CausCon_}
  subject_id=${subject_id%%_rest*}
  echo $subject_id
  #for atlas in $(find $mask_dir -name '.nii.gz');
  for atlas in `ls $mask_dir/*.nii.gz`;
  do
      atlas_name=${atlas%%.nii.gz}
      atlas_name=${atlas_name##*/}
      echo $atlas
      echo $atlas_name
                                                    
      fslmeants -i $img_4d -o $output_dir/tempc01_${subject_id}_${atlas_name}.txt -m $atlas
  done
  
  ##### Step02: combine data for all atlases ##########
  cd $output_dir 
  ls tempc01_${subject_id}_*.txt | tr "\n" "\t"| sed 's/tempc01_//g'| sed 's/.txt//g' > time_course_${subject_id}.txt
  
  # add Feed Line, echo automaticlly add \n at the end of line, so we just add an empty charactor:
  echo "" >> time_course_${subject_id}.txt
  
  paste -d "\t" tempc01_*.txt >> time_course_${subject_id}.txt
  
  rm $output_dir/tempc01_${subject_id}*
  cd $curr_dir

done


