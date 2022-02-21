% Base_Reco

%% Default Setting
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\eeglab2021.1'
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\func'
% eeglab;
clear; close all; clc;


data_path = 'E:\B2X\2차년도\03_pilot\subject_data';
f = dir(data_path);
f = f(3:sum([f.isdir])); % dir of the all subjects

band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
session_names = {'base', 'stim', 'reco'}; 
block_names = {'s0', 'S020', 'S100', 'N020', 'N100'};

% definition of channel groups
g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};
g_names_Frontal = {'Fp1', 'Fpz', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6'};
g_names_Central = {'C3', 'Cz', 'C4'};
g_names_Parietal = {'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3', 'Pz', 'P4', 'P8'};
g_names_Occipital = {'POz', 'O1', 'Oz', 'O2'};
g_names_Temporal = {'T7', 'T8'};
g_ch_names = {g_names_Frontal, g_names_Central, g_names_Parietal, g_names_Occipital, g_names_Temporal};

base_stim_reco = struct();
% 최종 결과 예시
 
% base_stim_reco.KDH_01.S020.block_num = 1; % 5개의 block 중 몇 번째인지 
% S0는 0번째 !
% base_stim_reco.KDH_01.S020.Frontal.base.Fz.gamma = 20; % 단위: [%]
% base_stim_reco.KDH_01.S020.Frontal.base.Fz.beta = 10; 
% base_stim_reco.KDH_01.S020.Frontal.base.Fz.alpha = -20;
% base_stim_reco.KDH_01.S020.Frontal.base.Fz.theta = 30;
% base_stim_reco.KDH_01.S020.Frontal.base.Fz.delta = 50;

%% Calculate Ratio
for sub_i = 1 : length(f)
    sub_name = [f(sub_i).name(4:end), '_', f(sub_i).name(1:2)];

    for block_i = 1 : length(block_names)
        set_dir_base = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*', block_names{block_i}, '_Filt_base*PSD.set']);
        set_dir_stim = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*', block_names{block_i}, '_Filt_stim*PSD.set']);
        set_dir_reco = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*', block_names{block_i}, '_Filt_reco*PSD.set']);

        EEGset_base = pop_loadset([set_dir_base.folder, '\', set_dir_base.name]);
        EEGset_stim = pop_loadset([set_dir_stim.folder, '\', set_dir_stim.name]);
        EEGset_reco = pop_loadset([set_dir_reco.folder, '\', set_dir_reco.name]);
        
        chs = {EEGset_base.chanlocs.labels};
        for ch_i = 1 : length(chs)
            for band_i = 1 : length(band_names)
                power_base = getfield(EEGset_base, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', band_names{band_i});
                power_stim = getfield(EEGset_stim, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', band_names{band_i});
                power_reco = getfield(EEGset_reco, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', band_names{band_i});

                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'base', chs{ch_i}, 'norm_X', band_names{band_i}, power_base);
                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'stim', chs{ch_i}, 'norm_X', band_names{band_i}, power_stim);
                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'reco', chs{ch_i}, 'norm_X', band_names{band_i}, power_reco);

                % norm_power도 똑같이 적용
                norm_power_base = getfield(EEGset_base, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', 'norm', band_names{band_i});
                norm_power_stim = getfield(EEGset_stim, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', 'norm', band_names{band_i});
                norm_power_reco = getfield(EEGset_reco, 'SpectralAnalysis', chs{ch_i}, 'Mean_epoch', 'norm', band_names{band_i});

                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'base', chs{ch_i}, 'norm_O', band_names{band_i}, norm_power_base);
                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'stim', chs{ch_i}, 'norm_O', band_names{band_i}, norm_power_stim);
                base_stim_reco = setfield(base_stim_reco, sub_name, block_names{block_i}, 'reco', chs{ch_i}, 'norm_O', band_names{band_i}, norm_power_reco);
            end
        end
    end
end
% save
fprintf('Saving...');
mkdir('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\base_stim_reco.mat', 'base_stim_reco', '-mat');
fprintf(' ok!\n');

%% Data Extraction and Create s0, S020, S100, N020, N100
clearvars -except base_stim_reco band_names session_names block_names ...
    g_names g_names_Frontal g_names_Central g_names_Parietal g_names_Occipital g_names_Temporal ...
    g_ch_names f

if isempty(fieldnames(base_stim_reco))
    base_stim_reco = load("E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\base_stim_reco.mat").base_stim_reco;
end
sub_names = fieldnames(base_stim_reco);

s0 = struct();
S020 = struct();
S100 = struct();
N020 = struct();
N100 = struct();

for block_i = 1 : 5
    % s0.frontal.gamma s0.frontal.beta ... s0.frontal.delta
    % s0.central.gamma s0.central.delta ... s0.central.delta
    % ...
    % s0.temporal.gamma s0.temporal.beta ... s0.temporal.delta
    for session_i = 1 : 3    
        fprintf([block_names{block_i}, '_', session_names{session_i}, ': ']);
        for g_i = 1 : length(g_names) % 5 channel groups
            fprintf([g_names{g_i}, ' ']);
            temp_ch_names = g_ch_names{g_i};
            temp_g_name = g_names{g_i};
    
            gamma_all_sub = [];
            beta_all_sub = [];
            alpha_all_sub = [];
            theta_all_sub = [];
            delta_all_sub = [];
    
            for sub_i = 1 : length(f) % 20 subjects
                gamma_one_sub = []; % subject 한 명에 대하여, 현재 channel group에 해당 하는 모든 채널의 gamma ratio
                beta_one_sub = []; 
                alpha_one_sub = []; 
                theta_one_sub = []; 
                delta_one_sub = [];
                for band_i = 1 : length(band_names) % 5 bands
                    for ch_i = 1 : length(temp_ch_names) 
                        temp_ch = getfield(base_stim_reco, sub_names{sub_i}, block_names{block_i}, session_names{session_i}, ...
                            temp_ch_names{ch_i}, 'norm_X', band_names{band_i});
                        com = sprintf('%s_one_sub = [%s_one_sub, temp_ch];', band_names{band_i}, band_names{band_i});
                        eval(com)
                    end
                end
                gamma_all_sub = [gamma_all_sub, gamma_one_sub];
                beta_all_sub = [beta_all_sub, beta_one_sub];
                alpha_all_sub = [alpha_all_sub, alpha_one_sub];
                theta_all_sub = [theta_all_sub, theta_one_sub];
                delta_all_sub = [delta_all_sub, delta_one_sub];
            end
            com = sprintf('%s.%s.%s.gamma = gamma_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.beta = beta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.alpha = alpha_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.theta = theta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.delta = delta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);       
        end
        fprintf('... ok!\n');
    end
end

% save
fprintf('Saving...');
mkdir('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X\s0.mat', 's0', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X\S020.mat', 'S020', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X\S100.mat', 'S100', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X\N020.mat', 'N020', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X\N100.mat', 'N100', '-mat');
fprintf(' ok!\n');

%% [Normalized Version] Data Extraction and Create s0, S020, S100, N020, N100
clearvars -except base_stim_reco band_names session_names block_names ...
    g_names g_names_Frontal g_names_Central g_names_Parietal g_names_Occipital g_names_Temporal ...
    g_ch_names f

if isempty(fieldnames(base_stim_reco))
    base_stim_reco = load("E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\base_stim_reco.mat").base_stim_reco;
end
sub_names = fieldnames(base_stim_reco);

s0 = struct();
S020 = struct();
S100 = struct();
N020 = struct();
N100 = struct();

for block_i = 1 : 5
    % s0.frontal.gamma s0.frontal.beta ... s0.frontal.delta
    % s0.central.gamma s0.central.delta ... s0.central.delta
    % ...
    % s0.temporal.gamma s0.temporal.beta ... s0.temporal.delta
    for session_i = 1 : 3    
        fprintf([block_names{block_i}, '_', session_names{session_i}, ': ']);
        for g_i = 1 : length(g_names) % 5 channel groups
            fprintf([g_names{g_i}, ' ']);
            temp_ch_names = g_ch_names{g_i};
            temp_g_name = g_names{g_i};
    
            gamma_all_sub = [];
            beta_all_sub = [];
            alpha_all_sub = [];
            theta_all_sub = [];
            delta_all_sub = [];
    
            for sub_i = 1 : length(f) % 20 subjects
                gamma_one_sub = []; % subject 한 명에 대하여, 현재 channel group에 해당 하는 모든 채널의 gamma ratio
                beta_one_sub = []; 
                alpha_one_sub = []; 
                theta_one_sub = []; 
                delta_one_sub = [];
                for band_i = 1 : length(band_names) % 5 bands
                    for ch_i = 1 : length(temp_ch_names) 
                        temp_ch = getfield(base_stim_reco, sub_names{sub_i}, block_names{block_i}, session_names{session_i}, ...
                            temp_ch_names{ch_i}, 'norm_O', band_names{band_i});
                        com = sprintf('%s_one_sub = [%s_one_sub, temp_ch];', band_names{band_i}, band_names{band_i});
                        eval(com)
                    end
                end
                gamma_all_sub = [gamma_all_sub, gamma_one_sub];
                beta_all_sub = [beta_all_sub, beta_one_sub];
                alpha_all_sub = [alpha_all_sub, alpha_one_sub];
                theta_all_sub = [theta_all_sub, theta_one_sub];
                delta_all_sub = [delta_all_sub, delta_one_sub];
            end
            com = sprintf('%s.%s.%s.gamma = gamma_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.beta = beta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.alpha = alpha_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.theta = theta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);
            com = sprintf('%s.%s.%s.delta = delta_all_sub;', block_names{block_i}, temp_g_name, session_names{session_i}); eval(com);       
        end
        fprintf('... ok!\n');
    end
end

% save
fprintf('Saving...');
mkdir('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O\s0.mat', 's0', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O\S020.mat', 'S020', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O\S100.mat', 'S100', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O\N020.mat', 'N020', '-mat');
save('E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O\N100.mat', 'N100', '-mat');
fprintf(' ok!\n');