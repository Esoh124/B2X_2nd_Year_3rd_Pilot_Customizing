% B2X 2차년도 
% 3차 pilot study 

% Total Analysis
% Use custom functions, which are contained in the func/

eeglab;
close all; clear; clc

%% Defualt Setting

% --Add path
% \eeglab2021.1: to use EEGLAB functions
% \func: to use customized functions
% \locs: to use locs files
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\eeglab2021.1'
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\func'
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\locs'

% --Data preparation
data_path = 'E:\B2X\2차년도\03_pilot\subject_data';
% Choose the subjects who are goning to be analyzed
choose_sub = [1];
f = dir(data_path);
f = f(3:sum([f.isdir]));
if sum(choose_sub) > 0
    f = f(choose_sub);
end

fprintf('Selected Subjects: ');
for mat_i = 1 : length(f)
    fprintf('%s ', f(mat_i).name);
end
disp(' ');

%% set the flags for the functions below whether run or not
%       mat2set    Filtering    SessionDividing    
flag = [0           0           0];
%% mat2set
warning('off')
if flag(1) == 1
    disp('--------------------   MAT2SET   --------------------')
    for sub_i = 1 : length(f)
        % EEG 폴더 안의 모든 .mat 파일 list 얻기
        set_list = dir([f(sub_i).folder '\' f(sub_i).name '\EEG\*.mat']); 
        
        % optional parameters for mat2set
        fs = 512; % sampling rate 
        n_ch = 31; % number of channels
    
        disp([f(sub_i).name]);
        for mat_i = 1 : length(set_list)
            EEGset = mat2set(f(sub_i), set_list(mat_i), fs, n_ch, 'save', 1);
        end
    end
    warning('on')
end

%% Filtering
if flag(2) == 1
    disp('--------------------  FILTERING  --------------------')
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*.set']);
    
        disp([f(sub_i).name]);
        for mat_i = 1 : length(set_list)
            EEGset = Filtering(set_list(mat_i), 'plot', 0, 'save', 1);
        end
    end
end

%% Session Dividing
if flag(3) == 1
    disp('--------------------SESSION DIVIDING--------------------')
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*_Filt.set']);
    
            disp([f(sub_i).name]);
            for set_num = 1 : length(set_list)
                EEGset = SessionDividing(set_list(set_num), 'save', 1);
            end
    end
end

%% ICA component calculation
disp('--------------------  ICA Calculation  --------------------')
for sub_iter = 1 : length(f)
    set_list = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_Reref.set']);

    disp([f(sub_iter).name]);
    for set_num = 1 : length(set_list)
        EEGset = B2X2_ICA_Component_Extraction(set_list(set_num), 1);
    end
end
