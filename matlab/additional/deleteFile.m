%% Load data

addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;

data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';

% Choose the subjects who are going to be analyzed

choose_sub = [1:20];

f = dir(data_path);
f = f(3:sum([f.isdir]));

if sum(choose_sub)>0
    f = f(choose_sub);
end


%% Remove EOG
for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*rmECG.set']);
    for file_i = 1:length(set_list)
        file_path = fullfile(set_list(file_i).folder, set_list(file_i).name);
        delete(file_path);
        disp(['Deleted: ', file_path]);
    end
end