% 20Hz 
% norm_X
% base vs reco
%% load file
clear; close all; clc;
addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\plot_func'
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

Symmetric_20Hz(band_names, g_names, N020, N100, S020, S100);
Biphasic_20Hz(band_names, g_names, N020, N100, S020, S100);

function [] = Symmetric_20Hz(band_names, g_names, N020, N100, S020, S100)
% 1. Symmetric biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('20Hz of Symmetric Biphasic', 'FontSize', 20);

    box_label = {'Baseline', 'Recovery'};
    
    for g_i = 1 : length(g_names)
        nexttile; 
        base = getfield(S020, g_names{g_i}, 'base', band_names{band_i});
        reco = getfield(S020, g_names{g_i}, 'reco', band_names{band_i});
        plotting(g_names{g_i}, box_label, band_names{band_i}, base, reco);
    end
    
    t.Padding = 'compact';
end
end

function [] = Biphasic_20Hz(band_names, g_names, N020, N100, S020, S100)
% 2. Biphasic 20Hz
for band_i = 1 : length(band_names)    
    figure;
    t = tiledlayout(1,5); sgtitle('20Hz of Biphasic', 'FontSize', 20);
    box_label = {'Baseline', 'Recovery'};
    
    for g_i = 1 : length(g_names)
        nexttile; 
        base = getfield(N020, g_names{g_i}, 'base', band_names{band_i});
        reco = getfield(N020, g_names{g_i}, 'reco', band_names{band_i});
        plotting(g_names{g_i}, box_label, band_names{band_i}, base, reco);
    end

    t.Padding = 'compact';
end
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


