% wuguowei delete first images using GRETNA functions
clear all 
subname = ['9001';'9008';];
% 输入被试原始数据的文件夹名称
datapath = ('D:\resting_data_BasicStatistic\Preprocessing\FunImgARWS\');
% 输入被试原始数据文件夹存储路径
deletenumber = [3];
% 输入要删除的张数
for i = 1:size(subname)
    sub = subname(i,:);
    cd([datapath,sub]);
    a=dir('*.nii');
    picture = {a.name};
    gretna_RUN_RmFstImg(picture, deletenumber);
    mkdir([datapath,'rm',sub]);
    output =([datapath,'rm',sub] );
    input = dir([datapath,sub,'\n*.nii'])
    input = ([datapath,sub,'\',input.name])
    movefile (input,output )
end