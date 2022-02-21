% 100Hz 
% norm_X
% base vs reco
%% load file
clear; close all; clc;

% load norm_X version data
cd 'E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X'
load("s0.mat");
load("N020.mat");
load("N100.mat");
load("S020.mat");
load("S100.mat");

%                                                      Figure(gamma)
%
%     subplot1(frontal)       subplot2(central)      subplot3(parietal)     subplot4(occipital)      subplot5(temporal)
%   --------------------    --------------------    --------------------    --------------------    --------------------
%   |           reco   |    |                  |    |                  |    |                  |    |                  |
%   |   base    ----   |    |                  |    |                  |    |                  |    |                  |
%   |   ----    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    ----   |    |                  |    |                  |    |                  |    |                  |
%   |   ----           |    |                  |    |                  |    |                  |    |                  |
%   --------------------    --------------------    --------------------    --------------------    --------------------

band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};
stim_th = 6;

%% 1. Symmetric biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('100Hz of Symmetric Biphasic', 'FontSize', 20);

    % frontal
    nexttile; 
    base = getfield(S100, 'frontal', 'base', band_names{band_i});
    reco = getfield(S100, 'frontal', 'reco', band_names{band_i});
    if band_i == stim_th
        % delta 영역은 20Hz 자극에 대한 잡음이 끼지 않음 
        % --> delta를 분석할 때는 stimulation 구간 포함
        stim = getfield(S100, 'frontal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Frontal\_', band_names{band_i}], 'FontSize', 15); 

    % central
    nexttile; 
    base = getfield(S100, 'central', 'base', band_names{band_i});
    reco = getfield(S100, 'central', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S100, 'central', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Central\_', band_names{band_i}], 'FontSize', 15);

    % parietal
    nexttile; 
    base = getfield(S100, 'parietal', 'base', band_names{band_i});
    reco = getfield(S100, 'parietal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S100, 'parietal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Parietal\_', band_names{band_i}], 'FontSize', 15);

    % occipital
    nexttile; 
    base = getfield(S100, 'occipital', 'base', band_names{band_i});
    reco = getfield(S100, 'occipital', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S100, 'occipital', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Occipital\_', band_names{band_i}], 'FontSize', 15);
    
    % temporal
    nexttile;
    base = getfield(S100, 'temporal', 'base', band_names{band_i});
    reco = getfield(S100, 'temporal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S100, 'temporal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);    
    title(['Temporal\_', band_names{band_i}], 'FontSize', 15);

    t.Padding = 'compact';
end


%% 2. Biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('20Hz of Biphasic', 'FontSize', 20);

    % frontal
    nexttile; 
    base = getfield(N100, 'frontal', 'base', band_names{band_i});
    reco = getfield(N100, 'frontal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N100, 'frontal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Frontal\_', band_names{band_i}], 'FontSize', 15); 

    % central
    nexttile; 
    base = getfield(N100, 'central', 'base', band_names{band_i});
    reco = getfield(N100, 'central', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N100, 'central', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Central\_', band_names{band_i}], 'FontSize', 15);

    % parietal
    nexttile; 
    base = getfield(N100, 'parietal', 'base', band_names{band_i});
    reco = getfield(N100, 'parietal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N100, 'parietal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Parietal\_', band_names{band_i}], 'FontSize', 15);

    % occipital
    nexttile; 
    base = getfield(N100, 'occipital', 'base', band_names{band_i});
    reco = getfield(N100, 'occipital', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N100, 'occipital', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Occipital\_', band_names{band_i}], 'FontSize', 15);
    
    % temporal
    nexttile;
    base = getfield(N100, 'temporal', 'base', band_names{band_i});
    reco = getfield(N100, 'temporal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N100, 'temporal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);    
    title(['Temporal\_', band_names{band_i}], 'FontSize', 15);

    t.Padding = 'compact';
end
