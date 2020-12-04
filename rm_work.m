% Initialise SPM
%--------------------------------------------------------------------------
clear all
spm('Defaults','fMRI');
spm_jobman('initcfg');
%%
sub_path = {};
outputdir = 'E:\idmdata\wu_script\Bids\second_level\interfrence';
matlabbatch{1}.spm.stats.factorial_design.dir = {outputdir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'prime';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;
% '24' ;'28' '29' '01';
number = ['03';'04';'05';'06';'07';'08';'19';'20';'21';'22';'23';'25';'26';'27';'02';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'30';'31';'32';];

for i=1:length(number)
    sub = number(i,:);
    data_path = ['E:\idmdata\wu_script\Bids\new_first_level\sub',sub];
    sub_path{1} = fullfile(data_path,'\con_0003.nii');
    sub_path{2} = fullfile(data_path,'\con_0004.nii');

    if i <= 14 
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).scans = cellstr(sub_path');
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).conds = [1 1 
                                                                                  1 2 
                                                                                  ];
    else
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).scans = cellstr(sub_path');
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).conds = [2 1 
                                                                                  2 2 
                                                                                  ];       
            
    end
end
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.inter.fnums = [2
                                                                                  3
                                                                                  ];
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'D:\toolbox\DPABI_V4.2_190919\DPABI_V4.2_190919\Templates\BrainMask_05_61x73x61.img'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
%% estimation
spmpath=[outputdir,'\SPM.mat'];%%%%%%%%%%%%%%%%
matlabbatch{2}.spm.stats.fmri_est.spmmat = {spmpath};
spm_jobman('run',matlabbatch);

