% Initialise SPM
% wuguowei using spm
%--------------------------------------------------------------------------
clear all
spm('Defaults','fMRI');
spm_jobman('initcfg');
% spm_get_defaults('cmdline',true);
clear matlabbatch
data_path = ['F:\BaiduNetdiskDownload\data\EMOTION\pre_fMRI\'];
subname = dir([data_path,'Fun\sub*']);
% 每个被试的文件夹名，T1像和功能像的要一致
runs_name = {'run1',;'run2';'run3';'run4';}
% T1像和功能像的上一层文件夹的路径
TIFFileInLog=[data_path,'Norm\'] ;
mkdir(TIFFileInLog);
for i = 9:size(subname)
 sub = subname(i).name;
 for runmuber = 1:4
runname = runs_name{runmuber,:};
fundata = spm_select('ExtFPList', fullfile(data_path,'Fun\',sub,runname), '.*\.nii$');
T1data = spm_select('ExtFPList', fullfile(data_path,'T1\',sub), '^co.*\.nii$');
TRdata =2;
% 改成你的TR
slice_number = 25;
% 改成你的slicenumber
TAdata = TRdata-(TRdata/slice_number);
reference_number = 25;
% 改成你的参考层
slice_order = [1:2:25,2:2:25];
% 改成你的扫描顺序
% 剩下的就等着就行啦
% Slice Timing Correction
%--------------------------------------------------------------------------
matlabbatch{1}.spm.temporal.st.scans{1} = cellstr(fundata);
matlabbatch{1}.spm.temporal.st.nslices = slice_number;
matlabbatch{1}.spm.temporal.st.tr = TRdata;
matlabbatch{1}.spm.temporal.st.ta = TAdata;
matlabbatch{1}.spm.temporal.st.so = slice_order;
matlabbatch{1}.spm.temporal.st.refslice = reference_number;
% Realign
%--------------------------------------------------------------------------
matlabbatch{2}.spm.spatial.realign.estwrite.data{1} = cellstr(spm_file(fundata,'prefix','a'));
% Coregister
%--------------------------------------------------------------------------
matlabbatch{3}.spm.spatial.coreg.estimate.ref    = cellstr(spm_file(fundata(1,:),'prefix','meana'));
matlabbatch{3}.spm.spatial.coreg.estimate.source = cellstr(T1data);
% Segment
%--------------------------------------------------------------------------
matlabbatch{4}.spm.spatial.preproc.channel.vols  = cellstr(T1data);
matlabbatch{4}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{4}.spm.spatial.preproc.warp.write    = [0 1];
% Normalise: Write
%--------------------------------------------------------------------------
matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(T1data,'prefix','y_','ext','nii'));
matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(char(spm_file(fundata,'prefix','ra')));
matlabbatch{5}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                                                          90 90 108];
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
% Smooth
%--------------------------------------------------------------------------
matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(fundata,'prefix','wra'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
spm_jobman('run',matlabbatch);
Path=fileparts(fundata(1,:));
TIFFileInRaw=fullfile(Path, ['NormChk_', sub,runname '.tif']);
fundata1 = spm_select('ExtFPList', fullfile(data_path,'Fun\',sub,runname), '^wra.*\.nii$');
GRETNAPath=fileparts(which('gretna.m'));
Ch2Filename=fullfile(GRETNAPath, 'Templates', 'ch2.nii');

% Follow Mingrui Xia's SeeCAT
ch2_hdr=spm_vol(Ch2Filename);
ch2_vol=spm_read_vols(ch2_hdr);
    
c_view_u=ch2_vol(:,ceil(end/2),:);
c_view_u=squeeze(c_view_u)';
c_view_u=c_view_u(end:-1:1,:);
c_view_u=c_view_u./max(c_view_u(:))*255;
c_view_u=imresize(c_view_u,217/181);
    
s_view_u=ch2_vol(ceil(end/2),:,:);
s_view_u=squeeze(s_view_u)';
s_view_u=s_view_u(end:-1:1,:);
s_view_u=s_view_u./max(s_view_u(:))*255;
s_view_u=imresize(s_view_u, 217/181);
    
a_view_u=ch2_vol(:,:,ceil(end/2));
a_view_u=squeeze(a_view_u)';
a_view_u=a_view_u(end:-1:1,:);
a_view_u=a_view_u./max(a_view_u(:))*255;
    
underlay=uint8([c_view_u, s_view_u, a_view_u]);
underlay=repmat(underlay, [1, 1, 3]);

mean_hdr=spm_vol(fundata1);
mean_vol=spm_read_vols(mean_hdr);
        
c_view_o=mean_vol(:,ceil(end/2),:);
c_view_o=squeeze(c_view_o)';
c_view_o=c_view_o(end:-1:1,:);
c_view_o=c_view_o./max(c_view_o(:))*255;
c_view_o=imresize(c_view_o, size(c_view_u));
        
s_view_o=mean_vol(ceil(end/2),:,:);
s_view_o=squeeze(s_view_o)';
s_view_o=s_view_o(end:-1:1,:);
s_view_o=s_view_o./max(s_view_o(:))*255;
s_view_o=imresize(s_view_o, size(s_view_u));
        
a_view_o=mean_vol(:,:,ceil(end/2));
a_view_o=squeeze(a_view_o)';
a_view_o=a_view_o(end:-1:1,:);
a_view_o=a_view_o./max(a_view_o(:))*255;
a_view_o=imresize(a_view_o, size(a_view_u));
        
overlay=uint8([c_view_o, s_view_o, a_view_o]);
overlay=repmat(overlay,[1,1,3]);
overlay(:,:,2:3)=overlay(:,:,2:3)/2;
outputimg=imresize(imadd(underlay./2,overlay./2),2);      
imwrite(outputimg, TIFFileInRaw);
%
movefile(TIFFileInRaw, TIFFileInLog);
%headmotion
RpFile = dir([data_path,'Fun\',sub,filesep,runname,'\*.txt']);
RPdir = fullfile(data_path,'Fun\',sub,runname);
Rp = load([RPdir,filesep,RpFile.name]);
MaxRp = max(abs(Rp));
MaxRp(4:6)=MaxRp(4:6)*180/pi;
% 3mm 3Degree
if any(MaxRp>3)
    CPath=fullfile(data_path, 'MaxHeadMotionParameterLargerThan3mmOr3Degree',filesep,sub,filesep,runname);
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath,filesep,'headmotion.txt');
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');
end
% 2mm 2Degree
if any(MaxRp>2)
    CPath=fullfile(data_path, 'MaxHeadMotionParameterLargerThan2mmOr2Degree',filesep,sub,filesep,runname);
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath,filesep,'headmotion.txt');
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');
end
% 1mm 1Degree
if any(MaxRp>1)
    CPath=fullfile(data_path, 'MaxHeadMotionParameterLargerThan1mmOr1Degree',filesep,sub,filesep,runname);
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath,filesep,'headmotion.txt');
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');    
end
 end
end
disp('all done')