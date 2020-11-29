
clear all; close all; clc;
%修改路径，current_dir 的路径中要包括你一阶建模好的数据，以及你做好的roi的mask的数据
current_dir =  'G:\task\cosmoMVPA-workshop-master';
addpath(genpath([current_dir,'\RSA_test\'])); % path to source code

%%
save_results = 1; % 1 for yes, 0 for no
show_results = 0;
study_path  = [current_dir, '\RSA_test\']; 
subject_id = 'sub1';
data_path  = [study_path, subject_id];
targets=repmat(1:6,1,10);
chunks=floor(((1:60)-1)/6)+1;
output_path = current_dir;
ds = cosmo_fmri_dataset(fullfile(data_path,'glm_T_stats_perrun.nii'),...
                        'mask',fullfile(data_path, 'brain_mask.nii'), ...
                                'targets',targets,'chunks',chunks);
ds_stim=cosmo_fx(ds,@(x)mean(x,1),{'chunks'});
cl_nh=cosmo_cluster_neighborhood(ds_stim);
n_neighbors_per_feature=cellfun(@numel,cl_nh.neighbors);
plot(sort(n_neighbors_per_feature))
opt=struct();
opt.h0_mean=0;
opt.niter=200;
tfce_z_ds_stim=cosmo_montecarlo_cluster_stat(ds_stim,cl_nh,opt);
cosmo_plot_slices(tfce_z_ds_stim);
primates_insects_mask=cosmo_match(ds.sa.targets,[1 2 5 6]);
ds_primates_insects=cosmo_slice(ds, primates_insects_mask);
ds_primates_insects.sa.targets(cosmo_match(...
                            ds_primates_insects.sa.targets,[1 2]))=1;
ds_primates_insects.sa.targets(cosmo_match(...
                            ds_primates_insects.sa.targets,[5 6]))=2;
ds_avg_primate_insects=cosmo_average_samples(ds_primates_insects);
cl_nh=cosmo_cluster_neighborhood(ds_avg_primate_insects);
opt=struct();
opt.niter=200;
tfce_z_ds_primate_vs_insects=cosmo_montecarlo_cluster_stat(...
                                    ds_avg_primate_insects,cl_nh,opt);
cosmo_plot_slices(tfce_z_ds_primate_vs_insects);


















%% Define data
% load null_data
fprintf('Now loading null datasets:\n');
for n = 1:numNullDatasets
    nulldata_path = '/Users/afam/Documents/Integration/null_data_randCond/';
    nulldata_path = strcat(nulldata_path,'smoothed_MNI_naive_bayes_searchlight_nulldata_',int2str(n),'.nii.gz/');
    null_data{n} = cosmo_fmri_dataset(strcat(nulldata_path,'all_nulldata_',int2str(numSubjs),'.nii.gz'), ...
                        'mask', 'mni_brain_mask.nii.gz', ...
                        'targets', targets, 'chunks', chunks);
   
%     null_data{n}=cosmo_remove_useless_data(null_data{n});
    
    disp(n)
end

% load original results
ds = cosmo_fmri_dataset(strcat('all_subjs.nii.gz'), ...
                        'mask', 'mni_brain_mask.nii.gz', ...
                        'targets', targets, ...
                        'chunks', chunks);

ds = cosmo_remove_useless_data(ds);

%% Define neighborhood 

fprintf('Now defining neighborhood:\n');
cl_nh = cosmo_cluster_neighborhood(ds);

% % Show a plot with the sorted number of neighbors for each voxel
% n_neighbors_per_feature = cellfun(@numel,cl_nh.neighbors);
% plot(sort(n_neighbors_per_feature))


%% Run cosmo_montecarlo_cluster_stat
% There is one condition per chunk; all targets are set to 1.
% Thus the subsequent anaylsis is a one-sample t-test.

opt = struct();
opt.h0_mean = 0.25; % t-test against this mean (chance accuracy)

% set the number of iterations.
opt.niter = 100; % recommended 10,000 for publication-quality results (but obviously takes a lot longer to run)

opt.null = null_data;

% % specify what cluster statistic to use (default is tfce)
% opt.cluster_stat = 'maxsize';
% opt.cluster_stat = 'maxsum';
% opt.cluster_stat = 'max';

% % this must be defined if cluster_stat is not tfce
% opt.p_uncorrected = 0.01; %0.001;

output_file = strcat('TFCE_group_',int2str(numSubjs),'s_',int2str(opt.niter),'iter_',int2str(numNullDatasets),...
                    'nulldata.nii');
output_path = strcat(output_path, output_file);

% using cosmo_montecarlo_cluster_stat, compute a map with z-scores
% against the null hypothesis of a mean [opt.h0_mean], corrected for multiple
% comparisons
fprintf('Now running t-tests:\n');
tfce_z_ds_stim = cosmo_montecarlo_cluster_stat(ds, cl_nh, opt);

%%
% Plot results, if specified
if show_results
    cosmo_plot_slices(tfce_z_ds_stim);
end

% Store results to disc, if specified
if save_results
    cosmo_map2fmri(tfce_z_ds_stim, output_path);
end