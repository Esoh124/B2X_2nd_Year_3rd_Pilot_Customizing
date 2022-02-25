% ratio of channels that satisfied the previouds study's results

% the number of total channel : 31
% exclude M1 channel
% the number of included channel : 30
% the number of total subjects : 20
% the number of total cases : 30*20=600


%% default setting
close all; clear; clc;
stim_param_sets = {'s0.mat', 'N020.mat', 'N100.mat', 'S020.mat', 'S100.mat'};
band_names = {'alpha', 'delta'};
group_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};

%% 1. norm_X 
cd 'D:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X'

for stim_param_i = 1 : length(stim_param_sets) % stim_parameter 별로 반복
    load(stim_param_sets{stim_param_i});
    struct_name = stim_param_sets{stim_param_i}(1:end-4);
    com = sprintf('temp_set = %s;', struct_name);
    eval(com);
    
    disp('-------------------------------------------------------------')
    for b_i = 1 : length(band_names) % alpha, delta 별로 반복
        % group 별로 나누어져 있는 channel들을 한 곳에 모은다
        chs_base = []; 
        chs_reco = []; 

        for g_i = 1 : length(group_names) % frontal, cetnral, parietal, occipital, temporal 데이터 합치기
            chs_base = [chs_base, getfield(temp_set, group_names{g_i}, 'base', band_names{b_i})];
            chs_reco = [chs_reco, getfield(temp_set, group_names{g_i}, 'reco', band_names{b_i})];
        end
            if b_i == 1 % alpha 인 경우
                test = chs_base > chs_reco;
            else % delta 인 경우
                test = chs_base < chs_reco;
            end
            fprintf([struct_name, '  ', band_names{b_i}, ': ', num2str(sum(test)), ' of 600 --> ', num2str(sum(test)/600*100),'%%\n']);
    end   
end

%% 2. norm_O
cd 'D:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O'

for stim_param_i = 1 : length(stim_param_sets) % stim_parameter 별로 반복
    load(stim_param_sets{stim_param_i});
    struct_name = stim_param_sets{stim_param_i}(1:end-4);
    com = sprintf('temp_set = %s;', struct_name);
    eval(com);
    
    disp('-------------------------------------------------------------')
    for b_i = 1 : length(band_names) % alpha, delta 별로 반복
        % group 별로 나누어져 있는 channel들을 한 곳에 모은다
        chs_base = []; 
        chs_reco = []; 

        for g_i = 1 : length(group_names) % frontal, cetnral, parietal, occipital, temporal 데이터 합치기
            chs_base = [chs_base, getfield(temp_set, group_names{g_i}, 'base', band_names{b_i})];
            chs_reco = [chs_reco, getfield(temp_set, group_names{g_i}, 'reco', band_names{b_i})];
        end
            if b_i == 1 % alpha 인 경우
                test = chs_base > chs_reco;
            else % delta 인 경우
                test = chs_base < chs_reco;
            end
            fprintf([struct_name, '  norm_', band_names{b_i}, ': ', num2str(sum(test)), ' of 600 --> ', num2str(sum(test)/600*100),'%%\n']);
    end   
end
