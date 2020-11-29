clear all; close all; clc;
%修改路径，current_dir 的路径中要包括你一阶建模好的数据，以及你做好的roi的mask的数据
current_dir =  'G:\task\cosmoMVPA-workshop-master';
addpath(genpath([current_dir,'\RSA_test\'])); % path to source code

%% 设定数据
% study_path 为数据存放路径，这个路径下存放每个被试的文件夹，每个被试文件夹下存放这个被试的一阶建模好的beta数据，也就是con文件数据
study_path  = [current_dir, '\search_light_group\']; 
%设置被试的数据
subject_ids={'sub1','sub2','sub3','sub4','sub5','sub6'};
num_cond = 6;
%设置run数，即采集了几个长段数据
num_runs = 10;
nsamples = num_cond*num_runs;
%生成run*condition的矩阵
targets  = repmat((1:num_cond)', num_runs,1);
chunks   = floor(((1:(num_cond*num_runs))-1)/num_cond)'+1;
nsubjects=numel(subject_ids);
   
for i_subj=1:nsubjects
        subject_id=subject_ids{i_subj};
        data_path=fullfile(study_path, subject_id);
        %使用cosmo_fmri_dataset函数导入一阶建模的数据和要在目标脑区进行分类的mask数据
        ds = cosmo_fmri_dataset([data_path '\glm_T_stats_perrun.nii'], ...
                     'mask', [data_path,filesep,'brain_mask.nii'], ...
                     'targets', targets, ...
                     'chunks',chunks);
       output_path = data_path;
       % remove constant features
       ds = cosmo_remove_useless_data(ds);
       %检查数据结构是否正确，这是一个好习惯哦，避免后续出错,返回值为1说明对
       cosmo_check_dataset(ds)
       partitions=cosmo_nfold_partitioner(ds);
       %partitions = cosmo_nchoosek_partitioner(ds,5);
       %开始创建
       nfolds=numel(partitions.train_indices);
       %选择你需要使用的交叉验证的方法，这里和我们在roi中使用的都一样，这里使用cosmo_nfold_partitioner创建交叉验证的矩阵，可自己修改
       measure = @cosmo_crossvalidation_measure;
       measure_args = struct();
       measure_args.partitions = cosmo_nfold_partitioner(ds);
       %选择你需要使用的交叉验证的方法
       measure_args.classifier = @cosmo_classify_lda;
      %设置search_light的体素数目，常用的数目是200，如果对体素数目如何影响分类能力，可以从50开始多设置一些来进行测试，为了少用点时间，我们使用10个体素
       nvoxels_per_searchlight=10;
       nbrhood=cosmo_spherical_neighborhood(ds,...
                        'count',nvoxels_per_searchlight);
       % 运行search_light，在全脑中，这一步比较费时
       lda_results = cosmo_searchlight(ds,nbrhood,measure,measure_args);
       % 按照层打印结果
        
        cosmo_plot_slices(lda_results);
        graph_path = [output_path,'\searchlight.jpg'];
        saveas(gcf, graph_path);
        close(gcf);
        % 定义输出nii的名字和位置
        output_fn=fullfile(output_path,[subject_id,'searchligt.nii']);
        % 保存存有分类正确率的脑图（仍旧是个体空间，组分析需要对这个图进行配准，一定要记得使用两步配准法中的逆矩阵进行配准，或者你也可以直接使用配准并做完smooth的数据
        %来这里做全脑的search-light分析，这样更简单一些，许多研究也都是这样做的）
        cosmo_map2fmri(lda_results, output_fn);
end
%保存了每个被试的结果后，进行单样本t检验，和机会正确率进行比较，本例子中有6个condition，机会正确率为1/6，单样本t检验的mean值设置为1/6即可，可以使用spm进行多重比较矫正，推荐体素水平的FDR方法
