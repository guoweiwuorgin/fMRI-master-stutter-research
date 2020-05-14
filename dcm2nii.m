% wuguowei  dcm2nii 
clear all 
data_path = 'F:\BaiduNetdiskDownload\data\EMOTION\post_fMRI\';
data_path1 =  'F:\BaiduNetdiskDownload\data\EMOTION\post_fMRI\';
path_name = dir([data_path,'sub*']);
data_type = {'S2010';'S4010';'S5010';'S6010';'S7010'};
dcm2niipath = ('F:\BaiduNetdiskDownload\data\EMOTION\pre_fMRI\duizhaozu\chuliscripts\Dcm2Nii\dcm2nii.exe');
for i = 2:size(path_name )
  sub = path_name(i).name;  
  full_path =  [data_path,sub,filesep];
  T1data_path = [data_path1,'T1\',sub,'\'];
  fundata_path_run1 = [data_path1,'Fun\',sub,filesep,'run1'];
  fundata_path_run2 = [data_path1,'Fun\',sub,filesep,'run2'];
  fundata_path_run3 = [data_path1,'Fun\',sub,filesep,'run3'];
  fundata_path_run4 = [data_path1,'Fun\',sub,filesep,'run4'];
  T1 =  [full_path,filesep,data_type{1}];
  Fun_run1 = [full_path,filesep,data_type{2}];
  Fun_run2 = [full_path,filesep,data_type{3}];
  Fun_run3 = [full_path,filesep,data_type{4}]; 
  Fun_run4 = [full_path,filesep,data_type{5}];
  mkdir(T1data_path);
  mkdir(fundata_path_run1);
  mkdir(fundata_path_run2);
  mkdir(fundata_path_run3);
  mkdir(fundata_path_run4);
  system([dcm2niipath,' -o ',T1data_path,' ', T1]);
  system([dcm2niipath,' -o ',fundata_path_run1,' ',Fun_run1]);
  system([dcm2niipath,' -o ',fundata_path_run2,' ',Fun_run2]);
  system([dcm2niipath,' -o ',fundata_path_run3,' ',Fun_run3]);
  system([dcm2niipath,' -o ',fundata_path_run4,' ',Fun_run4]);
end

