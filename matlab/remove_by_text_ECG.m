%% Load text file
file_path = 'Data_check_result_ECG.txt';

fid = fopen(file_path,  'r');

number_Array = [];

data = textscan(fid, '%f');

fclose(fid);

number_array = data{1};

%% Load data

addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;

data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';

% Choose the subjects who are goning to be analyzed
choose_sub = [1:20];

f = dir(data_path);
f = f(3:sum([f.isdir]))

if sum(choose_sub) > 0
    f = f(choose_sub);
end

i=1;
%% Remove

for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*corrECG.set']);
    EEGset= pop_loadset([set_list(sub_i).folder, '\', set_list(sub_i).name]);
    disp([set_list(sub_i).name]);

    for mat_i = 1 : length(set_list)
        if number_array(i) == 0                 %데이터 지움
            disp('Delete data');

        elseif number_array(i) == 1             %EOG 1만 지움
            [~, index] = maxk(EEGset.correlations_ecg, 1, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset,icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmECG.set']);

        elseif number_array(i) == 2             %그냥 그대로
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmECG.set']);

        else
            disp('Error');
            return;

        end
        i = i+1;

    end
end
