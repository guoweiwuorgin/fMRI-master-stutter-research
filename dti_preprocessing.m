clear all;

root = uiget_multi(pwd,'please select DTI data folder');
T1   = uiget_multi(pwd,'please select T1 data folder');
FSL  = uiget_multi(pwd,'please select FSL dir');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root = root{1};
T1   = T1{1};
FSL  = FSL{1};
subs = dir(root);
for i=1:length(subs)
    if ~isequal(subs(i).name,'.') && ~isequal(subs(i).name,'..')
    Img = dir([root,filesep,subs(i).name,filesep,'*.nii']);
    if isempty(Img)
        Img = dir([root,filesep,subs(i).name,filesep,'*.img']);
    end
    if ~isempty(Img)
        fprintf('dti preprocessing for subjid - %s \n',subs(i).name);
        if ~exist([root,filesep,subs(i).name,filesep,'bvals'],'file')
            bval = dir([root,filesep,subs(i).name,filesep,'*.bval']);
            movefile([root,filesep,subs(i).name,filesep,bval.name],[root,filesep,subs(i).name,filesep,'bvals']);
        end
        if ~exist([root,filesep,subs(i).name,filesep,'bvecs'],'file')
            bvec = dir([root,filesep,subs(i).name,filesep,'*.bvec']);
            movefile([root,filesep,subs(i).name,filesep,bvec.name],[root,filesep,subs(i).name,filesep,'bvecs']);
        end
        
        % eddy current
        fprintf('Eddy current correction for subjid - %s \n',subs(i).name);
        command = ['eddy_correct ',[root,filesep,subs(i).name,filesep,Img.name],' ',[root,filesep,subs(i).name,filesep,'data'],' 0'];
        unix(command);
        % correct the gradients
        fprintf('Correct gradients for subjid - %s \n',subs(i).name);
        command = ['fdt_rotate_bvecs  ',[root,filesep,subs(i).name,filesep,'bvecs'],'  ',[root,filesep,subs(i).name,filesep,'eddy_bvecs'],' ',[root,filesep,subs(i).name,filesep,'data.ecclog']];
        unix(command);
        % Bet
        fprintf('Bet for subjid - %s \n',subs(i).name);
        command = ['bet ',[root,filesep,subs(i).name,filesep,'data.nii.gz'],' ',[root,filesep,subs(i).name,filesep,'nodif_brain'], ' -f 0.2 -g 0 -m'];
        unix(command);
        t1Img = dir([T1,filesep,subs(i).name,filesep,'*.nii']);
        if isempty(t1Img)
            t1Img = dir([T1,filesep,subs(i).name,filesep,'*.img']);
        end
        if isempty(t1Img)
            error('No T1 images found');
        end
        command = ['bet ',[T1,filesep,subs(i).name,filesep,t1Img.name],' ',[T1,filesep,subs(i).name,filesep,'T1_data_brain'],'  -R -f 0.2 -g 0'];
        unix(command);
        % dtifit
        fprintf('dtifit for subjid - %s \n',subs(i).name);
        command = ['dtifit ','--data=',[root,filesep,subs(i).name,filesep,'data.nii.gz'],' --out=',[root,filesep,subs(i).name,filesep,'dti'],...
                   ' --mask=',[root,filesep,subs(i).name,filesep,'nodif_brain_mask.nii.gz'],...
                   ' --bvecs=',[root,filesep,subs(i).name,filesep,'eddy_bvecs'],...
                   ' --bvals=',[root,filesep,subs(i).name,filesep,'bvals']];
        unix(command);
        command = ['cp  ',[root,filesep,subs(i).name,filesep,'dti_L1.nii.gz'],' ',[root,filesep,subs(i).name,filesep,'dti_AD.nii.gz']];
        unix(command);
        command = ['fslmaths ',[root,filesep,subs(i).name,filesep,'dti_L2.nii.gz'],' -add ',[root,filesep,subs(i).name,filesep,'dti_L3.nii.gz'],' -div 2 ',[root,filesep,subs(i).name,filesep,'dti_RD.nii.gz']];
        unix(command);
%          % normalize
         fprintf('Normalization for subjid - %s \n',subs(i).name);
         command = ['fsl_reg ',[root,filesep,subs(i).name,filesep,'dti_FA.nii.gz'],' ',[FSL,filesep,'data',filesep,'standard',filesep,'MNI152_T1_2mm_brain.nii.gz'],...
                    ' ',[root,filesep,subs(i).name,filesep,'MNI_dti_FA.nii.gz']];
         unix(command);
         command = ['fsl_reg ',[root,filesep,subs(i).name,filesep,'dti_AD.nii.gz'],' ',[FSL,filesep,'data',filesep,'standard',filesep,'MNI152_T1_2mm_brain.nii.gz'],...
                   ' ',[root,filesep,subs(i).name,filesep,'MNI_dti_AD.nii.gz']];
        unix(command);
         command = ['fsl_reg ',[root,filesep,subs(i).name,filesep,'dti_RD.nii.gz'],' ',[FSL,filesep,'data',filesep,'standard',filesep,'MNI152_T1_2mm_brain.nii.gz'],...
                    ' ',[root,filesep,subs(i).name,filesep,'MNI_dti_RD.nii.gz']];
         unix(command);
         command = ['fsl_reg ',[root,filesep,subs(i).name,filesep,'dti_MD.nii.gz'],' ',[FSL,filesep,'data',filesep,'standard',filesep,'MNI152_T1_2mm_brain.nii.gz'],...
                    ' ',[root,filesep,subs(i).name,filesep,'MNI_dti_MD.nii.gz']];
         unix(command);
    end
    end
end