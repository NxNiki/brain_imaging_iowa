#!/bin/sh
##############SETUP ENVIRONMENT###################
export ETKINLAB_DIR=/Shared/jianglab
export ANALYSIS_PIPE_DIR=${ETKINLAB_DIR}/0_scripts/analysis_pipeline_cd
export SPM8DIR=${ETKINLAB_DIR}/0_scripts/spm8_sge/
export PATH=${PATH}:${ETKINLAB_DIR}
export PATH=${PATH}:${ANALYSIS_PIPE_DIR}
echo $PATH
echo $ANALYSIS_PIPE_DIR

######################
script_dir=/Shared/jianglab/0_scripts/analysis_pipeline_cd
TARGETDIR="rest"
DATADIR=${ETKINLAB_DIR}/3_Data_Working/CausalConnectome/
TASKDIR=${ETKINLAB_DIR}/3_Data_Working/CausalConnectome/rest_test/
STRUCTDIR=${ETKINLAB_DIR}/3_Data_Working/CausalConnectome/structural/
MASKDIR=${ETKINLAB_DIR}/0_scripts/CausalConnectome/ppi_masks_standard/
masks=("FIRST_L_amyg_small" "FIRST_R_amyg_small" "sgACC_6_16_-10_10mm")


cd $TASKDIR
rm -r *.$TARGETDIR

for i in `ls -r ${PWD}/CausCon_*.nii.gz`  ; do

    s=`basename $i | awk -F _ '{ print $2 }' | sed 's/CausCon//g'`
    echo ${s}

    i=$(basename $i .nii.gz)
    # if analyzed dir not exists, then do analysis below
    if [ ! -d ${i}.${TARGETDIR} ] ; then
    
        #find structural image and dir
        T1=`ls ${STRUCTDIR}*${s}*_t1.nii.gz | sed -n '1p'`
        T1=`remove_ext $T1`
        
        if [ `imtest $T1` = 0  ]  || [ ! -d ${T1}.struct_only ]; then
            echo "invalid image : $T1"
            # exit 1
        fi
        
        if [ `imtest $T1` = 1 ] && [ -d ${T1}.struct_only ]; then
            for m in "${masks[@]}"; do
                #qsub $script_dir/analysis_pipeline_Jing.sh -resting -no_resting_gm_mask -func_data $i -t1 ${T1} -tr 2 -deleteVolumes 6 -reg_info ${T1}.struct_only -fc_rois_mni ${MASKDIR}/${m}.nii.gz -atlas_conn_opts --useAllLabels -motion -output_extension ${TARGETDIR}
                $script_dir/analysis_pipeline_Jing.sh -resting -no_resting_gm_mask -func_data $i -t1 ${T1} -tr 2 -deleteVolumes 6 -reg_info ${T1}.struct_only -fc_rois_mni ${MASKDIR}/${m}.nii.gz -atlas_conn_opts --useAllLabels -motion -output_extension ${TARGETDIR}
                #analysis_pipeline_Jing.sh -resting -no_resting_gm_mask -func_data $i -t1 ${T1} -tr 2 -deleteVolumes 6 -reg_info ${T1}.struct_only -fc_rois_mni ${MASKDIR}/${m}.nii.gz -atlas_conn_opts --useAllLabels -motion -output_extension ${TARGETDIR}
                
                echo RUNNING $TARGETDIR on $i $m
            done
        fi
    
    fi #-rest_conn_only # -doGBC (global connectivity)
done
