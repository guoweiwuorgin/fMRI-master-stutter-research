clear;
names = dir('*.nii');;
for i = 1:length(names)
    load_name = names(i).name;
    picture{i} = spm_vol(load_name);
    picture_data{i} = spm_read_vols(picture{i});
    index_nonzeros{i} = find(picture_data{i} > 0 );
end
data_withmotion = index_nonzeros{1};
data_withoutmotion = index_nonzeros{2};
the_real_recorevory = sum(ismember(data_withmotion,data_withoutmotion));
the_overlap_rate = sum(ismember(data_withmotion,data_withoutmotion))/length(data_withmotion);
the_cover_rate = sum(ismember(data_withmotion,data_withoutmotion))/length(data_withoutmotion);
