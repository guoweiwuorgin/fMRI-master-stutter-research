for file in `cat list.txt`
do
    echo $file
    cd $file
    dcm2nii DWI
    cd DWI
    mv 20*.nii.gz DWI.nii.gz
    mv 20*.bval DWI.bval
    mv 20*.bvec DWI.bvec
    mv DWI.nii.gz ../
    mv DWI.bval ../
    mv DWI.bvec ../
    cd ..
	dcm2nii T1
	cd T1
	mv co*.nii.gz T1.nii.gz
	mv T1.nii.gz ../
	cd ../../
done
