% Total Analysis
% Use custom functions, which are contained in the func/

%% Defualt Setting

% --Add path
% \eeglab2021.1: to use EEGLAB functions
% \func: to use customized functions
% \locs: to use locs files
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;
% eeglab; close all; clear; clc;

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

for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_rmEOG.set']);

    disp([f(sub_i).name]);
    for mat_i = 1 : length(set_list)
        EEGset = pop_loadset([set_list(mat_i).folder, '\', set_list(mat_i).name]);   
    end
end