% wuguowei delete first images using GRETNA functions
clear all 
subname = ['9001';'9008';];
% ���뱻��ԭʼ���ݵ��ļ�������
datapath = ('D:\resting_data_BasicStatistic\Preprocessing\FunImgARWS\');
% ���뱻��ԭʼ�����ļ��д洢·��
deletenumber = [3];
% ����Ҫɾ��������
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