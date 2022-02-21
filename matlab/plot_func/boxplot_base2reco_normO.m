%% load file
clear; close all; clc;

% load norm_X version data
cd 'E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base2reco_ratio\norm_O'
load("norm_s0.mat");
load("norm_N020.mat");
load("norm_N100.mat");
load("norm_S020.mat");
load("norm_S100.mat");

% 1. 20Hz vs 100Hz
%                                                      Figure(gamma)
%
%     subplot1(frontal)       subplot2(central)      subplot3(parietal)     subplot4(occipital)      subplot5(temporal)
%   --------------------    --------------------    --------------------    --------------------    --------------------
%   |           100Hz  |    |                  |    |                  |    |                  |    |                  |
%   |   20Hz    ----   |    |                  |    |                  |    |                  |    |                  |
%   |   ----    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    |  |   |    |                  |    |                  |    |                  |    |                  |
%   |   |  |    ----   |    |                  |    |                  |    |                  |    |                  |
%   |   ----           |    |                  |    |                  |    |                  |    |                  |
%   --------------------    --------------------    --------------------    --------------------    --------------------

% 2. Biphasic vs Symmetric Biphasic
%                                                      Figure(gamma)
%
%        subplot1(frontal)           subplot2(central)       subplot3(parietal)      subplot4(occipital)      subplot5(temporal)
%   ----------------------------    --------------------    --------------------    --------------------    --------------------
%   |              Symmetric   |    |                  |    |                  |    |                  |    |                  |
%   |                Biphasic  |    |                  |    |                  |    |                  |    |                  |
%   |   Biphasic      ----     |    |                  |    |                  |    |                  |    |                  |
%   |     ----        |  |     |    |                  |    |                  |    |                  |    |                  |
%   |     |  |        |  |     |    |                  |    |                  |    |                  |    |                  |
%   |     |  |        |  |     |    |                  |    |                  |    |                  |    |                  |
%   |     |  |        ----     |    |                  |    |                  |    |                  |    |                  |
%   |     ----                 |    |                  |    |                  |    |                  |    |                  |
%   ----------------------------    --------------------    --------------------    --------------------    --------------------

band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};

% 20Hz vs 100Hz
S020_vs_S100(band_names, g_names, N020, N100, S020, S100);
N020_vs_N100(band_names, g_names, N020, N100, S020, S100);

% biphasic vs symmetric biphasic
S020_vs_N020(band_names, g_names, N020, N100, S020, S100);
S100_vs_N100(band_names, g_names, N020, N100, S020, S100);


function [] = S020_vs_S100(band_names, g_names, N020, N100, S020, S100) %--norm_O
    %     1.1 S020 vs S100 --norm_O
    for band_i = 1 : length(band_names)
        figure;
        t = tiledlayout(1,5); sgtitle('20Hz vs 100Hz for Symmetric Biphasic as base2reco ratio', 'FontSize', 20);
        box_label = {'20Hz', '100Hz'};
        
        for g_i = 1 : length(g_names)
            nexttile; 
            Hz_20 = getfield(S020, g_names{g_i}, band_names{band_i});
            Hz_100 = getfield(S100, g_names{g_i}, band_names{band_i});
            plotting(g_names{g_i}, box_label, band_names{band_i}, Hz_20, Hz_100);
        end
       
        t.Padding = 'compact';
    end
end

function [] = N020_vs_N100(band_names, g_names, N020, N100, S020, S100) %--norm_O
    %     1.2 N020 vs N100 --norm_O
    for band_i = 1 : length(band_names)
        figure;
        t = tiledlayout(1,5); sgtitle('20Hz vs 100Hz for Unsymmetric Biphasic as base2reco ratio', 'FontSize', 20);
        box_label = {'20Hz', '100Hz'};

        for g_i = 1 : length(g_names)
            nexttile; 
            Hz_20 = getfield(N020, g_names{g_i}, band_names{band_i});
            Hz_100 = getfield(N100, g_names{g_i}, band_names{band_i});
            plotting(g_names{g_i}, box_label, band_names{band_i}, Hz_20, Hz_100);
        end

        t.Padding = 'compact';
    end
end

function [] = S020_vs_N020(band_names, g_names, N020, N100, S020, S100) %--norm_O
    %     2.1 S020 vs N020
    for band_i = 1 : length(band_names)
        figure;
        t = tiledlayout(1,5); sgtitle('Biphasic vs Symmetric Biphasic for 20Hz as base2reco ratio', 'FontSize', 20);
        box_label = {'biphasic', 'sym_biphasic'};

        for g_i = 1 : length(g_names)
            nexttile; 
            biphasic = getfield(S020, g_names{g_i}, band_names{band_i});
            sym_biphasic = getfield(N020, g_names{g_i}, band_names{band_i});
            plotting(g_names{g_i}, box_label, band_names{band_i}, biphasic, sym_biphasic);
        end
    
        t.Padding = 'compact';
    end
end

function [] = S100_vs_N100(band_names, g_names, N020, N100, S020, S100) %--norm_O
    %     2.2 S100 vs N100
    for band_i = 1 : length(band_names)
        figure;
        t = tiledlayout(1,5); sgtitle('Biphasic vs Symmetric Biphasic for 100Hz as base2reco ratio', 'FontSize', 20);
        box_label = {'biphasic', 'sym_biphasic'};
    
        for g_i = 1 : length(g_names)
            nexttile; 
            biphasic = getfield(S100, g_names{g_i}, band_names{band_i});
            sym_biphasic = getfield(N100, g_names{g_i}, band_names{band_i});
            plotting(g_names{g_i}, box_label, band_names{band_i}, biphasic, sym_biphasic);
        end

        t.Padding = 'compact';
    end
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

