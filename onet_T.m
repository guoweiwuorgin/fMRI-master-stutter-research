%-----------------------------------------------------------------------
% Job saved on 14-Sep-2020 11:35:10 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clear;clc;
spm('Defaults','fMRI');
spm_jobman('initcfg');
number1 = ['03';'04';'05';'06';'07';'08';'19';'20';'21';'22';'23';'25';'26';'27';];
number2 = ['02';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'30';'31';'32';];
group1 = {};
 for i = 1:14
 sub1 = number2(i,:);
 data_path1 = ['G:\data\new_first_level\sub',sub1];
 group1{i,1} = [data_path1,'\con_0001.nii'];
 end
 out_dir = 'G:\data\second_level\stutter\prime'
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(group1);
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
spmpath=[out_dir,'\SPM.mat'];%%%%%%%%%%%%%%%%
matlabbatch{2}.spm.stats.fmri_est.spmmat = {spmpath};
matlabbatch{3}.spm.stats.con.spmmat ={spmpath};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name   = 'inter_difference';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep= 'none';
spm_jobman('run',matlabbatch);
