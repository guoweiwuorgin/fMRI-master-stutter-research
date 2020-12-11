for file in `cat list.txt`
do
   eddy_correct DWI.nii.gz DWI_eddy.nii.gz 0
   fdt_rotate_bvecs DWI.bvec DWI_rotated.bvec DWI_eddy.ecclog
   fslroi DWI_eddy.nii.gz b0 0 1
   bet b0 nodif_brain -f 0.2 -R -m 
   dtifit -k DWI_eddy.nii.gz -m nodif_brain_mask.nii.gz -r DWI_rotated.bvec -b DWI.bval -o dti 
   cd ..
done
