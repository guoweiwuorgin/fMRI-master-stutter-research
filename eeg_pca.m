clear;clc;
data_dir = uigetdir();
data_path = dir([data_dir,'/0*']);
eeg_list = {};
for n = 1:length(data_path)
   data_name = data_path(n+1).name;
   i_data1_path  = [data_dir,filesep,data_name,filesep];
   file_name_list = dir([i_data1_path,'v*.cnt']); 
   for runs = 1:length(file_name_list)
      run_name = file_name_list(runs).name; 
      eeg_list{runs} = pop_loadcnt([i_data1_path,run_name],'dataformat', 'auto','memmapfile', '');
      eeg_checkset(eeg_list{runs});
   end
    EEG = pop_mergeset(eeg_list{1},eeg_list{2});
    EEG = pop_mergeset(EEG,eeg_list{3});
    EEG = pop_mergeset(EEG,eeg_list{4});
    eeg_checkset(EEG);
    EEG=pop_chanedit(EEG, 'lookup','D:\MATLAB\eeglab10_0_0_0a\eeglab10_0_0_0b\plugins\dipfit2.2\standard_BESA\standard-10-5-cap385.elp');
    EEG = pop_select( EEG,'nochannel',{'CB1','CB2','HEO','VEO'});
    EEG = pop_eegfiltnew(EEG, [], 1, 3300, true, [], 0);  %¸ßÍ¨1Hz
    EEG = pop_eegfiltnew(EEG, [], 100, 132, 0, [], 0); %µÍÍ¨100Hz
    EEG = pop_reref( EEG, []); 
    EEG = pop_selectevent( EEG, 'omittype',{'1' '23' '253' '254' '3' '4' '66' '8' 'boundary'},'deleteevents','on');
    EEG = eeg_checkset(EEG);
%     EEG_forICA = pop_resample(EEG, 100);
%     EEG_forICA = pop_runica(EEG_forICA,'extended',1,'interupt','off');
%     EEG.icaweights = EEG_forICA.icaweights;
%     EEG.icasphere  = EEG_forICA.icasphere;
%      clear EEG_forICA
%     EEG = eeg_checkset(EEG, 'ica');
%     EEG = iclabel(EEG, 'default'); 
%     [~, mostDominantClassLabelVector] = max(EEG.etc.ic_classification.ICLabel.classifications, [], 2);
%     mostDominantClassLabelProbVector = zeros(length(mostDominantClassLabelVector),1);
%     for icIdx = 1:length(mostDominantClassLabelVector)
%              mostDominantClassLabelProbVector(icIdx)  = EEG.etc.ic_classification.ICLabel.classifications(icIdx, mostDominantClassLabelVector(icIdx));
%     end
%     brainLabelProbThresh  = 0; % [0-1]
%     brainIdx = find((mostDominantClassLabelVector==1 & mostDominantClassLabelProbVector>=brainLabelProbThresh) | (mostDominantClassLabelVector==7 & mostDominantClassLabelProbVector>=brainLabelProbThresh));
%     goodIcIdx = brainIdx;
%     EEG = pop_subcomp(EEG, goodIcIdx, 0, 1);
%     EEG.icaact = [];
%     EEG = eeg_checkset(EEG, 'ica');
    EEG = pop_saveset(EEG,'filename','pre_procee_LH.set','filepath',i_data1_path);  
    now_process = strcat('Now  processed --',' ',data_name,'....');
    disp(now_process);
    clear EEG
end