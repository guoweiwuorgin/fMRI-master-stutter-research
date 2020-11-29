clear all; close all; clc;



%% Define data
% manually define path where data is located
current_dir = 'G:\task\cosmoMVPA-workshop-master';
study_path  = [current_dir, '\RSA_test\'];

data_path = fullfile(study_path,'sub1');
data_fn   = fullfile(data_path,'/glm_T_stats_perrun.nii');
mask_fn   = fullfile(data_path,'/brain_mask.nii');
%define targets by your design:condition and sessions
n_cond  = 6;
n_runs  = 10;
targets = repmat(1:n_cond,1,n_runs)';
%load your data
ds = cosmo_fmri_dataset(data_fn, ...
                        'mask', mask_fn,...
                        'targets', targets);

% compute runs average  for each unique target, so that the dataset has 6 samples - one for each target

ds_mean = cosmo_fx(ds, @(x)mean(x,1), 'targets', 1);

% load V1 model and behavioral DSMs
models_path=[current_dir,filesep];
load(fullfile(models_path,'behav_sim.mat'));
load(fullfile(models_path,'v1_model.mat')); 
 % remove constant features
% ds_mean = cosmo_remove_useless_data(ds_mean);

measure_args.target_dsm = behav;
measure_args.center_data = false;
ds_sa = cosmo_target_dsm_corr_measure(ds_mean,measure_args);

%define the searchligt parameters
nbrhood = cosmo_spherical_neighborhood(ds_mean,'count',100);

 opt=struct();
opt.progress=true;          % do not show progress
opt.metric='correlation'; % (instead of default 'correlation')
measure=@cosmo_dissimilarity_matrix_measure;
sl_ds=cosmo_searchlight(ds_mean, nbrhood, measure, opt);

output_path = pwd;
cosmo_map2fmri(sl_ds, ...
            fullfile(output_path,'/rsm_searchlight_behav.nii'));
figure              
cosmo_plot_slices(cosmo_slice(ds,15))
