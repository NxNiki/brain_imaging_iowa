#!bin/sh

set -e

##### Step01: compute mean for each atlase ##########

img_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest"
mask_dir="/Shared/jianglab/0_scripts/Xin/target_mask"
#output_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest_output"
output_dir="/raid0/homes/xniu7/rest_output_conn"

curr_dir=$(pwd)

mkdir -p $output_dir

# ---------------------------------------------------

#for img_4d in $(find $img_dir/*.rest - name 'normalized_func_data.nii.gz');
for img_4d in `ls $img_dir/??HC????/conn_*HC*/results/preprocessing/3comp*.nii*`;
do

  echo $img_4d
  #atlases="Atlases/"
  #subject_id=$(echo $img_4d | awk -F "/" "{print $6}" | sed 's/CausCon_//' | sed 's/_rest.rest//')
  subject_id=${img_4d##*conn_}
  subject_id=${subject_id%%/results*}
  echo $subject_id
  #for atlas in $(find $mask_dir -name '.nii.gz');
  for atlas in `ls $mask_dir/*.nii*`;
  do
      atlas_name=${atlas%%.nii.gz}
      atlas_name=${atlas_name##*/}
      echo $atlas
      echo $atlas_name
                                                    
      fslmeants -i $img_4d -o $output_dir/tempc02_${subject_id}_${atlas_name}.txt -m $atlas
  done
  
  ##### Step02: combine data for all atlases ##########
  cd $output_dir 
  ls tempc02_${subject_id}_*.txt | tr "\n" "\t"| sed 's/tempc02_//g'| sed 's/.txt//g' > time_course_target_${subject_id}.txt
  
  # add Feed Line, echo automaticlly add \n at the end of line, so we just add an empty charactor:
  echo "" >> time_course_target_${subject_id}.txt
  
  paste -d "\t" tempc02_*.txt >> time_course_target_${subject_id}.txt
  
  rm tempc02_${subject_id}*
  cd $curr_dir

done


