clear all;clc;
data_dir = uigetdir();
data_path = dir([data_dir,'/0*']);
Cond={'20','21','22','24'};

%% time-frequency analysis for multiple conditions
outpath = [data_dir,'/newresults'];
for i=1:length(data_path)
    data_name = data_path(i).name;
    setpath  = [data_dir,filesep,data_name,filesep];
    file_name_list = dir([setpath,'*oarf.cnt']); 
    setname = file_name_list(1).name;
    EEG= pop_loadcnt([setpath,setname],'dataformat', 'auto','memmapfile', ''); 
    EEG=pop_chanedit(EEG, 'lookup','D:\\MATLAB\\eeglab12_0_2_6b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp');
    EEG= eeg_checkset( EEG );
    EEG = pop_select( EEG,'channel',{'AF3','AF4','F3','F4','FC3','FC4','C3','C4'});
    EEG= eeg_checkset( EEG );
    for j=1:length(Cond)       
        EEG_new = pop_epoch( EEG, Cond(j), [-1  2.5], 'newname', 'CNT file epochs', 'epochinfo', 'yes'); 
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = pop_rmbase( EEG_new, [-1000 0]); 
        EEG_new = eeg_checkset( EEG_new );
        for nchan=1:size(EEG_new.data,1)
            x = squeeze(EEG_new.data(nchan,:,:)); 
            xtimes=EEG_new.times/1000; 
            t=EEG_new.times/1000;
            f=1:1:30; 
            Fs = EEG.srate;
            winsize = 0.4; 
            [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
            P_data(i,j,nchan,:,:)=squeeze(mean(P,3)); %%P_data (without baseline correciton):  subj*cond*chan*f*time
        end
    end    
end

%% baseline correction 

t_pre_idx=find((t>=-0.8)&(t<=-0.2));
for i=1:size(P_data,1)
    for j=1:size(P_data,2)
        for ii=1:size(P_data,3)
            for jj=1:size(P_data,4)
                temp_data=squeeze(P_data(i,j,ii,jj,:));
                P_BC(i,j,ii,jj,:)=temp_data-mean(temp_data(t_pre_idx));
            end
        end
    end
end

%% Ftest for each time-frequency point
P_anova = zeros(8,length(f),3000);
F_anova = zeros(8,length(f),3000);
for chanal_number = 1:size(EEG_new.data,1)
data_test=squeeze(P_data(:,:,chanal_number,:,:)); %% select the data at each chanel, data_test: subj*cond*frequency*time
  for i=1:size(data_test,3)
    for j=1:size(data_test,4)
        data_anova=squeeze(data_test(:,:,i,j)); %% select the data at time-frequency point
        [p, table] = anova_rm(data_anova,'off');  %% perform repeated measures ANOVA
        P_anova(chanal_number,i,j)=p(1); %% save the data from ANOVA
        F_anova(chanal_number,i,j)=table{2,5}; %% F value from ANOVA
    end
  end
end

%% fdr correction to account for multiple comparisons
chanel_name = {'AF3','AF4','F3','F4','FC3','FC4','C3','C4'};
mkdir(outpath);
for P_trail = 1:8   
  [p_fdr2, p_masked] = fdr(squeeze(P_anova(P_trail,:,:)) ,0.05);%% fdr correction for p values from ANOVA
  p_list{P_trail} = p_fdr2;
  figure; imagesc(t,f,squeeze(P_anova(P_trail,:,:))); axis xy; caxis([0 p_fdr2]); colormap default;colorbar('location','Eastoutside');
  pic = getframe(gcf);
  imwrite(pic.cdata, [outpath,'/TFD_',chanel_name{P_trail},'.png']);
  close all
end
for P_trail = 1:8   
  data_new=squeeze(P_data(:,:,P_trail,:,:));
  data_ave = squeeze(mean(data_new,1));
  for condi = 1:4
  tfd_data =  data_ave(condi,:,:);   
  figure; imagesc(t,f,squeeze(tfd_data)); axis xy; colormap default;colorbar('location','Eastoutside');
  pic = getframe(gcf);
  imwrite(pic.cdata, [outpath,'/TFD_',chanel_name{P_trail},'_',num2str(condi),'.png']);
  close all
  end
end
for P_trail = 1:8   
  data_new=squeeze(P_data(:,:,P_trail,:,:));
  data_ave = squeeze(mean(data_new,1));
  for condi = 2:4
  tfd_data =  data_ave(condi,:,:) - data_ave(1,:,:);   
  figure; imagesc(t,f,squeeze(tfd_data)); axis xy; colormap default;colorbar('location','Eastoutside');
  pic = getframe(gcf);
  imwrite(pic.cdata, [outpath,'/chyiTFD_',chanel_name{P_trail},'_',num2str(condi),'.png']);
  close all
  end
end




