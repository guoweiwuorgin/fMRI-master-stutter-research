%-----------------------------------------------------------------------
% Job saved on 09-Sep-2019 05:58:26 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)

%-----------------------------------------------------------------------
clear all;
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
%spm_get_defaults('cmdline',1);

conditionnamelists = dir('E:\idmdata\wu_script\Bids\new_first_level\');
for i = 1:length(conditionnamelists)
    conditioname = conditionnamelists(i+2).name;
    cd(['E:\idmdata\wu_script\Bids\new_first_level\',conditioname])
    
    conditionnumber = 4
    for n = 1:conditionnumber
       conditionum = n 
    
    fold = 'SPM.mat';
matlabbatch{1}.spm.stats.results.spmmat = cellstr(fold);
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts =  conditionum;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = 'tif';
matlabbatch{1}.spm.stats.results.write.none = 1;
spm_jobman('run',matlabbatch);
clear matlabbatch
    end
end