%-----------------------------------------------------------------------
% Job saved on 08-Jun-2020 11:21:08 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
spm('Defaults','fMRI');
spm_jobman('initcfg');

  out_dir = 'E:\idmdata\wu_script\Bids\second_level\interference_main'  
  number = ['03';'04';'05';'06';'07';'08';'19';'20';'21';'22';'23';'25';'26';'27';'02';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'30';'31';'32';];

%%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};

for i=1:size(number)
    sub = number(i,:);
    data_path = ['E:\idmdata\wu_script\Bids\new_first_level\sub',sub]
    data{1,1}=fullfile(data_path,'\con_0003.nii');
    data{2,1}=fullfile(data_path,'\con_0004.nii');
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans = cellstr(data);
end

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'D:\toolbox\DPABI_V4.2_190919\DPABI_V4.2_190919\Templates\GreyMask_02_61x73x61.img'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
%%
spmpath=[out_dir,'\SPM.mat'];%%%%%%%%%%%%%%%%
matlabbatch{2}.spm.stats.fmri_est.spmmat = {spmpath};
matlabbatch{3}.spm.stats.con.spmmat ={spmpath};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name   = 'prime_noprime';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep= 'none';
spm_jobman('run',matlabbatch);

