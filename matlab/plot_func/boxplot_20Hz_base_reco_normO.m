% 20Hz 
% norm_X
% base vs reco
%% load file
clear; close all; clc;

% load norm_X version data
cd 'E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O'
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

Symmetric_20Hz();
Symmetric_20Hz();

%% 1. Symmetric biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('20Hz of Symmetric Biphasic', 'FontSize', 20);

    % frontal
    nexttile; 
    base = getfield(S020, 'frontal', 'base', band_names{band_i});
    reco = getfield(S020, 'frontal', 'reco', band_names{band_i});
    if band_i == stim_th
        % delta 영역은 20Hz 자극에 대한 잡음이 끼지 않음 
        % --> delta를 분석할 때는 stimulation 구간 포함
        stim = getfield(S020, 'frontal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Frontal\_', band_names{band_i}, '\_norm'], 'FontSize', 15); 

    % central
    nexttile; 
    base = getfield(S020, 'central', 'base', band_names{band_i});
    reco = getfield(S020, 'central', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S020, 'central', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Central\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    % parietal
    nexttile; 
    base = getfield(S020, 'parietal', 'base', band_names{band_i});
    reco = getfield(S020, 'parietal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S020, 'parietal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Parietal\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    % occipital
    nexttile; 
    base = getfield(S020, 'occipital', 'base', band_names{band_i});
    reco = getfield(S020, 'occipital', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S020, 'occipital', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Occipital\_', band_names{band_i}, '\_norm'], 'FontSize', 15);
    
    % temporal
    nexttile;
    base = getfield(S020, 'temporal', 'base', band_names{band_i});
    reco = getfield(S020, 'temporal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(S020, 'temporal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);    
    title(['Temporal\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    t.Padding = 'compact';
end


%% 2. Biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('20Hz of Biphasic', 'FontSize', 20);

    % frontal
    nexttile; 
    base = getfield(N020, 'frontal', 'base', band_names{band_i});
    reco = getfield(N020, 'frontal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N020, 'frontal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Frontal\_', band_names{band_i}, '\_norm'], 'FontSize', 15); 

    % central
    nexttile; 
    base = getfield(N020, 'central', 'base', band_names{band_i});
    reco = getfield(N020, 'central', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N020, 'central', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Central\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    % parietal
    nexttile; 
    base = getfield(N020, 'parietal', 'base', band_names{band_i});
    reco = getfield(N020, 'parietal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N020, 'parietal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Parietal\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    % occipital
    nexttile; 
    base = getfield(N020, 'occipital', 'base', band_names{band_i});
    reco = getfield(N020, 'occipital', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N020, 'occipital', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);
    title(['Occipital\_', band_names{band_i}, '\_norm'], 'FontSize', 15);
    
    % temporal
    nexttile;
    base = getfield(N020, 'temporal', 'base', band_names{band_i});
    reco = getfield(N020, 'temporal', 'reco', band_names{band_i});
    if band_i == stim_th
        stim = getfield(N020, 'temporal', 'stim', band_names{band_i});
        box_input = [base', stim', reco'];
        box_label = {'Baseline', 'Stimulation', 'Recovery'};
    else
        box_input = [base', reco'];
        box_label = {'Baseline', 'Recovery'};
    end
    boxplot(box_input, 'Labels', box_label);
    set(gca, 'fontsize', 20);    
    title(['Temporal\_', band_names{band_i}, '\_norm'], 'FontSize', 15);

    t.Padding = 'compact';
end

function [] = plotting(g_name, box_label, band_name, data1, data2)
scatter([ones(length(data1), 1), 2*ones(length(data2),1)], [data1', data2']); hold on;
h1 = boxplot([data1'; data2'], [ones(length(data1),1); 2*ones(length(data2),1)], 'Labels', box_label); hold on;
% boxplot_modification(h1, data1, data2);
set(gca, 'fontsize', 20);
title([g_name, '\_', band_name, '\_normalized'], 'FontSize', 15); 
end

function [q10, q25, q75, q90] = getQuantile(data)
q = quantile(data, [0.1 0.25 0.75 0.9]);
q10=q(1); q25=q(2); q75=q(3); q90=q(4);
end

function [] = boxplot_modification(h, data1, data2)
        % boxplot modification
        % modify the figure properties (set the YData property)  
        % h(5,1) correspond the blue box  
        % h(1,1) correspond the upper whisker  
        % h(2,1) correspond the lower whisker
        [q10, q25_1, q75_1, q90] = getQuantile(data1);
        set(h(5,1), 'YData', [q10 q90 q90 q10 q10]);% blue box  
        upWhisker = get(h(1,1), 'YData');  
        set(h(1,1), 'YData', [q90 upWhisker(2)])   
        dwWhisker = get(h(2,1), 'YData');  
        set(h(2,1), 'YData', [dwWhisker(1) q10]) 
    
        [q10, q25_2, q75_2, q90] = getQuantile(data2);
        set(h(5,2), 'YData', [q10 q90 q90 q10 q10]);
        upWhisker = get(h(1,1), 'YData');  
        set(h(1,2), 'YData', [q90 upWhisker(2)])   
        dwWhisker = get(h(2,1), 'YData');  
        set(h(2,2), 'YData', [dwWhisker(1) q10]) 

%         ylim_low = (q25_2 > q25_1) * q25_1 + (q25_2 <= q25_1) * q25_2;
%         ylim_high = (q75_2 > q75_1) * q75_2 + (q75_2 <= q75_1) * q75_1;
%         ylim([ylim_low ylim_high]);
end
