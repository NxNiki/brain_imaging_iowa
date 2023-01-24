#!bin/sh

##### Step01: compute mean for each atlase ##########

img_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest"
mask_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/post_processing/VisorT1_iso2nii-selected/wMNI/IndEnvMask"
output_dir="/Shared/jianglab/3_Data_Working/CausalConnectome/rest_output_conn_indmask"

mkdir -p $output_dir
curr_dir=$(pwd)

# ---------------------------------------------------

#for img_4d in $(find $img_dir/*.rest - name 'normalized_func_data.nii.gz');
#for img_4d in `ls $img_dir/*.rest/normalized_func_data.nii.gz`;
for img_4d in `ls $img_dir/??HC????/conn_*HC*/results/preprocessing/3comp*.nii`;
do
    echo $img_4d
    #atlases="Atlases/"
    #subject_id=$(echo $img_4d | awk -F "/" "{print $6}" | sed 's/CausCon_//' | sed 's/_rest.rest//')
    subject_id=${img_4d##*conn_}
    subject_id=${subject_id%%/results*}
    subject_id=${subject_id:(-4)}
    echo $subject_id

    #for atlas in $(find $mask_dir -name '.nii.gz');
    for atlas in `ls $mask_dir/*/$subject_id*.nii*`;
    do
        roi=$(echo $atlas | awk -F '/' '{print $10}')
        mask_size=${atlas##*_}
        mask_size=${mask_size%%.nii*}
        echo $roi
        echo $mask_size
        fslmeants -i $img_4d -o $output_dir/tempc01_${subject_id}_${roi}_${mask_size}.txt -m $atlas
    done
    
    ##### Step02: combine data for all atlases ##########
    cd $output_dir
    if compgen -G "tempc01_*.txt" > /dev/null; then 
        ls tempc01_${subject_id}_*.txt | tr "\n" "\t"| sed 's/tempc01_//g'| sed 's/.txt//g' > time_course_ind_${subject_id}.txt
        # add Feed Line, echo automaticlly add \n at the end of line, so we just add an empty charactor:
        echo "" >> time_course_ind_${subject_id}.txt
        paste -d "\t" tempc01_${subject_id}_*.txt >> time_course_ind_${subject_id}.txt
        rm tempc01_${subject_id}*
    fi

    cd $curr_dir
    #break
done


