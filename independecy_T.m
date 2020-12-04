%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear;clc;
spm('Defaults','fMRI');
spm_jobman('initcfg');
number1 = ['03';'04';'05';'06';'07';'08';'19';'20';'21';'22';'23';'25';'26';'27';];
number2 = ['02';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'30';'31';'32';];
group1 = {};
 for i = 1:14
 sub1 = number1(i,:);
 data_path1 = ['E:\idmdata\wu_script\Bids\new_first_level\sub',sub1];
 group1{i,1} = [data_path1,'\con_0005.nii'];
 group1{i+14,1} = [data_path1,'\con_0006.nii'];
 end

 
 for n = 1:14
 sub2 = number2(n,:);
 data_path2 = ['E:\idmdata\wu_script\Bids\new_first_level\sub',sub2];   
 group2{n,1} = [data_path2,'\con_0005.nii'];
 group2{n+14,1} = [data_path2,'\con_0006.nii'];
 end
out_dir = 'E:\idmdata\wu_script\Bids\second_level\new_group_chayi'
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(group1);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(group2);
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'D:\toolbox\DPABI_V4.2_190919\DPABI_V4.2_190919\Templates\GreyMask_02_61x73x61.img'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
spmpath=[out_dir,'\SPM.mat'];%%%%%%%%%%%%%%%%
matlabbatch{2}.spm.stats.fmri_est.spmmat = {spmpath};
matlabbatch{3}.spm.stats.con.spmmat ={spmpath};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name   = 'inter_difference';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep= 'none';
spm_jobman('run',matlabbatch);


