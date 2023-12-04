%% Load text file
file_path = 'Data_check_result.txt';

fid = fopen(file_path,  'r');

number_Array = [];

data = textscan(fid, '%f');

fclose(fid);

number_array = data{1};

% Total Analysis
% Use custom functions, which are contained in the func/

%% Load data

% --Add path
% \eeglab2021.1: to use EEGLAB functions
% \func: to use customized functions
% \locs: to use locs files
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;
% eeglab; close all; clear; cl
% --Data preparation
data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';

% Choose the subjects who are goning to be analyzed
choose_sub = [1:20];

f = dir(data_path);
f = f(3:sum([f.isdir]))
eog_f = dir(eog_path);
eog_f = eog_f(3:sum([eog_f.isdir]))
if sum(choose_sub) > 0
    f = f(choose_sub);
    eog_f = eog_f(choose_sub);
end


i=1;
%% 
for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*corr.set']);
    EEGset= pop_loadset([set_list(sub_i).folder, '\', set_list(sub_i).name]);
    disp([set_list(sub_i).name]);

    for mat_i = 1 : length(set_list)
        if number_array(i) == 0                 %데이터 지움
            disp('Delete data');

        elseif number_array(i) == 1             %EOG 1만 지움
            [~, index] = maxk(EEGset.correlations, rm, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset,icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);

        elseif number_array(i) == 2             %EOG 2만 지움
            [~, index] = maxk(EEGset.correlations2, rm, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset,icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);

        elseif number_array(i) == 3             %EOG 1&2  지움
            [~, index] = maxk(EEGset.correlations, rm, 'ComparisonMethod', 'abs');
            [~, index2] = maxk(EEGset.correlations2, rm, 'ComparisonMethod', 'abs');
            index = [index index_2];
            index = unique(index);
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset,icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);

        elseif number_array(i) == 4             %그냥 그대로
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
        else
            disp('Error');
            return;
        end
        i = i+1;
        EEGset = Filtering(set_list(mat_i),f(sub_i).name, 'plot', 0, 'save', 1);
    end
end
