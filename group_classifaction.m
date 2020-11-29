clear all; close all; clc;
%�޸�·����current_dir ��·����Ҫ������һ�׽�ģ�õ����ݣ��Լ������õ�roi��mask������
current_dir =  'G:\task\cosmoMVPA-workshop-master';
addpath(genpath([current_dir,'\RSA_test\'])); % path to source code

%% �趨����
% study_path Ϊ���ݴ��·�������·���´��ÿ�����Ե��ļ��У�ÿ�������ļ����´��������Ե�һ�׽�ģ�õ�beta���ݣ�Ҳ����con�ļ�����
study_path  = [current_dir, '\RSA_test\']; 
%���ñ��Ե�����
subject_ids={'sub1','sub2','sub3','sub4','sub5','sub6','sub7','sub8'};
rois={'vt';'ev'};
num_cond = 6;
%����run�������ɼ��˼�����������
num_runs = 10;
nsamples = num_cond*num_runs;
%����run*condition�ľ���
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
        %ʹ��cosmo_fmri_dataset��������һ�׽�ģ�����ݺ�Ҫ��Ŀ���������з����mask����
        ds = cosmo_fmri_dataset([data_path '\glm_T_stats_perrun.nii'], ...
                     'mask', [data_path,filesep,[rois{i_roi},'_mask.nii']], ...
                     'targets', targets, ...
                     'chunks',chunks);

       % remove constant features
       ds = cosmo_remove_useless_data(ds);
       %������ݽṹ�Ƿ���ȷ������һ����ϰ��Ŷ�������������,����ֵΪ1˵����
       cosmo_check_dataset(ds)
       partitions=cosmo_nfold_partitioner(ds);
       %partitions = cosmo_nchoosek_partitioner(ds,5);
       %�����վ����������Ԥ��Ľ��
       all_pred=zeros(nsamples,1);
       %��ʼ����
       nfolds=numel(partitions.train_indices);

       for fold=1:nfolds
           train_idxs=partitions.train_indices{fold};
           test_idxs=partitions.test_indices{fold};
           ds_train=cosmo_slice(ds,train_idxs);
           ds_test=cosmo_slice(ds,test_idxs);
           %��������ʹ����lda��������Linear Discrimination Analysis�������б�����㷨����Ҳ����ʹ�����ر�Ҷ˹����svm��֧����������
           %���ر�Ҷ˹ȡ���������е�ע�ͣ���ע�͵�lda������
           % fold_pred=cosmo_classify_naive_bayes(ds_train.samples,ds_train.sa.targets,...
           %                                ds_test.samples);
           %svmȡ���������е�ע�ͣ���ע�͵�lda������
           % fold_pred=cosmo_classify_svm(ds_train.samples,ds_train.sa.targets,...
           %                                ds_test.samples);
           fold_pred=cosmo_classify_lda(ds_train.samples,ds_train.sa.targets,...
                                    ds_test.samples);
           all_pred(test_idxs)=fold_pred;
end
%����ƽ����ȷ�ʣ������
accuracy=mean(all_pred==ds.sa.targets);
sum_weighted_zs_all(i_subj)= accuracy;       
end
roi_sum{i_roi} = sum_weighted_zs_all; 
clear sum_weighted_zs_all
end
%ʹ�÷ǲμ���wilcoxon�Ƚ�����roi����ͬ�̼��ķ�������
[p,h] = ranksum(roi_sum{1},roi_sum{2},0.05);