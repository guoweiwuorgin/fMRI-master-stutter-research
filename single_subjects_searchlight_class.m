clear all; close all; clc;
%�޸�·����current_dir ��·����Ҫ������һ�׽�ģ�õ����ݣ��Լ������õ�roi��mask������
current_dir =  'G:\task\cosmoMVPA-workshop-master';
addpath(genpath([current_dir,'\RSA_test\'])); % path to source code

%% �趨����
% study_path Ϊ���ݴ��·�������·���´��ÿ�����Ե��ļ��У�ÿ�������ļ����´��������Ե�һ�׽�ģ�õ�T-map����
study_path  = [current_dir, '\RSA_test\']; 

% ������Ҫ���з���ı��Բ���
subject_id = 'sub1';
data_path  = [study_path, subject_id]; 
output_path = data_path;
num_cond = 6;
%����run�������ɼ��˼�����������
num_runs = 10;
nsamples = num_cond*num_runs;
%����run*condition�ľ���
targets  = repmat((1:num_cond)', num_runs,1);
chunks   = floor(((1:(num_cond*num_runs))-1)/num_cond)'+1;
%ʹ��cosmo_fmri_dataset��������һ�׽�ģ�����ݺ�Ҫ��Ŀ���������з����mask����
ds = cosmo_fmri_dataset([data_path '\glm_T_stats_perrun.nii'], ...
                     'mask', [data_path '\brain_mask.nii'], ...
                     'targets', targets, ...
                     'chunks',chunks);
% remove constant features
ds = cosmo_remove_useless_data(ds);
%������ݽṹ�Ƿ���ȷ������һ����ϰ��Ŷ�������������
cosmo_check_dataset(ds)
%ѡ������Ҫʹ�õĽ�����֤�ķ����������������roi��ʹ�õĶ�һ��������ʹ��cosmo_nfold_partitioner����������֤�ľ��󣬿��Լ��޸�
measure = @cosmo_crossvalidation_measure;
measure_args = struct();
measure_args.partitions = cosmo_nfold_partitioner(ds);
%ѡ������Ҫʹ�õĽ�����֤�ķ���
measure_args.classifier = @cosmo_classify_lda;
%����search_light��������Ŀ�����õ���Ŀ��200�������������Ŀ���Ӱ��������������Դ�50��ʼ������һЩ�����в��ԣ�Ϊ�����õ�ʱ�䣬����ʹ��10������
nvoxels_per_searchlight=10;
nbrhood=cosmo_spherical_neighborhood(ds,...
                        'count',nvoxels_per_searchlight);
% ����search_light����ȫ���У���һ���ȽϷ�ʱ
lda_results = cosmo_searchlight(ds,nbrhood,measure,measure_args);
% ���ղ��ӡ���
cosmo_plot_slices(lda_results);
% �������nii�����ֺ�λ��
output_fn=fullfile(output_path,[subject_id,'searchligt.nii']);
% ������з�����ȷ�ʵ���ͼ���Ծ��Ǹ���ռ䣬�������Ҫ�����ͼ������׼��һ��Ҫ�ǵ�ʹ��������׼���е�����������׼��������Ҳ����ֱ��ʹ����׼������smooth������
%��������ȫ�Ե�search-light��������������һЩ������о�Ҳ�����������ģ�
cosmo_map2fmri(lda_results, output_fn);







             