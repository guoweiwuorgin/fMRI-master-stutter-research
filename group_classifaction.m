clear all; close all; clc;
%修改路径，current_dir 的路径中要包括你一阶建模好的数据，以及你做好的roi的mask的数据
current_dir =  'G:\task\cosmoMVPA-workshop-master';
addpath(genpath([current_dir,'\RSA_test\'])); % path to source code

%% 设定数据
% study_path 为数据存放路径，这个路径下存放每个被试的文件夹，每个被试文件夹下存放这个被试的一阶建模好的beta数据，也就是con文件数据
study_path  = [current_dir, '\RSA_test\']; 
%设置被试的数据
subject_ids={'sub1','sub2','sub3','sub4','sub5','sub6','sub7','sub8'};
rois={'vt';'ev'};
num_cond = 6;
%设置run数，即采集了几个长段数据
num_runs = 10;
nsamples = num_cond*num_runs;
%生成run*condition的矩阵
targets  = repmat((1:num_cond)', num_runs,1);
chunks   = floor(((1:(num_cond*num_runs))-1)/num_cond)'+1;
nsubjects=numel(subject_ids);
sum_weighted_zs_all=zeros(nsubjects,1);
nrois=numel(rois);
roi_sum = {}; 
for i_roi = 1:nrois     
for i_subj=1:nsubjects
        subject_id=subject_ids{i_subj};
        data_path=fullfile(study_path, subject_id);
        %使用cosmo_fmri_dataset函数导入一阶建模的数据和要在目标脑区进行分类的mask数据
        ds = cosmo_fmri_dataset([data_path '\glm_T_stats_perrun.nii'], ...
                     'mask', [data_path,filesep,[rois{i_roi},'_mask.nii']], ...
                     'targets', targets, ...
                     'chunks',chunks);

       % remove constant features
       ds = cosmo_remove_useless_data(ds);
       %检查数据结构是否正确，这是一个好习惯哦，避免后续出错,返回值为1说明对
       cosmo_check_dataset(ds)
       partitions=cosmo_nfold_partitioner(ds);
       %partitions = cosmo_nchoosek_partitioner(ds,5);
       %创建空矩阵，用来存放预测的结果
       all_pred=zeros(nsamples,1);
       %开始创建
       nfolds=numel(partitions.train_indices);

       for fold=1:nfolds
           train_idxs=partitions.train_indices{fold};
           test_idxs=partitions.test_indices{fold};
           ds_train=cosmo_slice(ds,train_idxs);
           ds_test=cosmo_slice(ds,test_idxs);
           %我们这里使用了lda方法，即Linear Discrimination Analysis，线性判别分析算法，你也可以使用朴素贝叶斯或者svm（支持向量机）
           %朴素贝叶斯取消下面两行的注释，并注释掉lda那两行
           % fold_pred=cosmo_classify_naive_bayes(ds_train.samples,ds_train.sa.targets,...
           %                                ds_test.samples);
           %svm取消下面两行的注释，并注释掉lda那两行
           % fold_pred=cosmo_classify_svm(ds_train.samples,ds_train.sa.targets,...
           %                                ds_test.samples);
           fold_pred=cosmo_classify_lda(ds_train.samples,ds_train.sa.targets,...
                                    ds_test.samples);
           all_pred(test_idxs)=fold_pred;
end
%计算平均正确率，并输出
accuracy=mean(all_pred==ds.sa.targets);
sum_weighted_zs_all(i_subj)= accuracy;       
end
roi_sum{i_roi} = sum_weighted_zs_all; 
clear sum_weighted_zs_all
end
%使用非参检验wilcoxon比较两个roi对相同刺激的分类能力
[p,h] = ranksum(roi_sum{1},roi_sum{2},0.05);