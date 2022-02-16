% B2X 2차년도 
% 3차 pilot study 

% Total Analysis
% Use custom functions, which are contained in the func/

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
for set_num = 1 : length(f)
    fprintf('%s ', f(set_num).name);
end
disp(' ');

%% mat2set
disp('--------------------   MAT2SET   --------------------')
for sub_i = 1 : length(f)
    % EEG 폴더 안의 모든 .mat 파일 list 얻기
    mat_list = dir([f(sub_i).folder '\' f(sub_i).name '\EEG\*.mat']); 
    srate = 512; % sampling rate 설정

    disp([f(sub_i).name]);
    for mat_i = 1 : length(mat_list)
        EEGset = mat2set(f(mat_i), mat_list(mat_i), srate, 1);
    end
end


