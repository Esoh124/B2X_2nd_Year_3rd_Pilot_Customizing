% extract epoch_data

% 100Hz 자극은 모든 주파수 영역에 대해서 분석
% 20Hz 자극은 delta 영역에 대해서만 분석


%% Default Setting
close all; clear; clc;
% add EEGLAB path
addpath 'D:\B2X\2차년도\03_pilot\CODE\matlab\eeglab2021.1'
eeglab; close all; clear; clc;

% Choose subjects who are going to be analyzed
subjcet_path = 'D:\B2X\2차년도\03_pilot\subject_data';
% choose_sub = 1:20; 
choose_sub = 19;
f = dir(subjcet_path);
f = f(3:sum([f.isdir]));
if sum(choose_sub) > 0
    f = f(choose_sub);
end

fprintf('Selected Subjects: ');
for mat_i = 1 : length(f)
    fprintf('%s ', f(mat_i).name);
end
disp(' ');

% naming initiation
stim_param_names =  {'s0', 'N020', 'N100', 'S020', 'S100'};
band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};

g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};
g_names_Frontal = {'Fp1', 'Fpz', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6'};
g_names_Central = {'C3', 'Cz', 'C4'};
g_names_Parietal = {'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3', 'Pz', 'P4', 'P8'};
g_names_Occipital = {'POz', 'O1', 'Oz', 'O2'};
g_names_Temporal = {'T7', 'T8'};
g_ch_names = {g_names_Frontal, g_names_Central, g_names_Parietal, g_names_Occipital, g_names_Temporal};

%% Extract the PSD of each epoch
% input: all EEGset files from all subjects
% ouput: epoch_by_sub

% form of output
% epoch_by_sub.s0.KDH_01.frontal.F7.gamma 
% epoch_by_syb.s0.KDH_01.frontal.FC5

% output struct initiation
s0 = struct();
N020 = struct();
N100 = struct();
S020 = struct();
S100 = struct();


for sub_i = 1 : length(f)
    EEGset_path = [f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset'];
    sub_name = [f(sub_i).name(4:end), '_', f(sub_i).name(1:2)];
    for stim_param_i = 1 : length(stim_param_names)
        % get dir of .set files based on stim_param_i
        dir_base = dir([EEGset_path, '\', '*', stim_param_names{stim_param_i}, '_Filt_base*_PSD.set']);
        dir_stim = dir([EEGset_path, '\', '*', stim_param_names{stim_param_i}, '_Filt_stim*_PSD.set']);
        dir_reco = dir([EEGset_path, '\', '*', stim_param_names{stim_param_i}, '_Filt_reco*_PSD.set']);

        set_base = pop_loadset([dir_base.folder, '\', dir_base.name]);
        set_stim = pop_loadset([dir_stim.folder, '\', dir_stim.name]);
        set_reco = pop_loadset([dir_reco.folder, '\', dir_reco.name]);
        
        for g_i = 1 : length(g_names)
            temp_g_chs = g_ch_names{g_i};
            for g_ch_i = 1 : length(temp_g_chs)
                for b_i = 1 : length(band_names)
                    temp_ch_base = getfield(set_base, 'SpectralAnalysis', temp_g_chs{g_ch_i}, 'epoch_data', band_names{b_i});
                    temp_ch_stim = getfield(set_stim, 'SpectralAnalysis', temp_g_chs{g_ch_i}, 'epoch_data', band_names{b_i});
                    temp_ch_reco = getfield(set_reco, 'SpectralAnalysis', temp_g_chs{g_ch_i}, 'epoch_data', band_names{b_i});
                    temp_concat = [temp_ch_base, temp_ch_stim, temp_ch_reco];
                    com = sprintf('%s = setfield(%s, sub_name, g_names{g_i}, temp_g_chs{g_ch_i}, band_names{b_i}, temp_concat);', stim_param_names{stim_param_i}, stim_param_names{stim_param_i});
                    eval(com);
                end
            end
        end
    end
end

epoch_by_sub.s0 = s0;
epoch_by_sub.N020 = N020;
epoch_by_sub.N100 = N100;
epoch_by_sub.S020 = S020;
epoch_by_sub.S100 = S100;

%% 2. epoch_by_ch
% input: epoch_by_sub
% output: epoch_by_ch

% -- form of input
% epoch_by_sub.s0.KDH_01.frontal.F7.gamma 

% -- desired form of output
% epoch_by_ch.s0.Fp1 = [b1_1, b1_2, ..., b1_39, s1_1, s1_2, ..., s1_39, r1_1, r1_2, ..., r1_39;
%                       b2_1, b2_2, ..., b2_39, s2_1, s2_2, ..., s2_39, r2_1, r2_2, ..., r2_39;
%                       ...
%                       b20_1, b20_2, ..., b20_39, s20_1, s20_2, ..., s20_39, r20_1, r20_2, ..., r20_39]

epoch_by_ch = struct();

for stim_param_i = 1 : length(stim_param_names)
    for g_i = 1 : length(g_names) % frontal, central, parietal, occipital, temporal
        temp_g = g_ch_names{g_i};
        for g_ch_i = 1 : length(temp_g) % if temp_g is occipital, channels are POz, O1, Oz, O2
            ch_by_all_sub = [];
            for sub_i = 1 : length(f)
                ch_by_one_sub = getfield(epoch_by_sub, stim_param_names{stim_param_i}, sub_names{sub_i}, g_names{g_i}, temp_g{g_ch_i});
                test = [];
            end
        end
    end
end




