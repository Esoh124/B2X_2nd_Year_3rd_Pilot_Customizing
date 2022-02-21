%% load file
clear; close all; clc;

% load norm_X version data
cd 'E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base2reco_ratio\norm_O'
load("norm_s0.mat");
load("norm_N020.mat");
load("norm_N100.mat");
load("norm_S020.mat");
load("norm_S100.mat");

band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};

data1 = S100;
data2 = N100;
for band_i = 1 : length(band_names)

    fprintf([band_names{band_i}, ' ']);

    g_i = 1;
    fprintf([g_names{g_i}, ' ']);
    Hz_20 = transpose(getfield(data1, g_names{g_i}, band_names{band_i}));
    Hz_100 = transpose(getfield(data2, g_names{g_i}, band_names{band_i}));
    front = [Hz_20, Hz_100];

    g_i = 2;
    fprintf([g_names{g_i}, ' ']);
    Hz_20 = transpose(getfield(data1, g_names{g_i}, band_names{band_i}));
    Hz_100 = transpose(getfield(data2, g_names{g_i}, band_names{band_i}));
    cent = [Hz_20, Hz_100];

    g_i = 3;
    fprintf([g_names{g_i}, ' ']);
    Hz_20 = transpose(getfield(data1, g_names{g_i}, band_names{band_i}));
    Hz_100 = transpose(getfield(data2, g_names{g_i}, band_names{band_i}));
    pari = [Hz_20, Hz_100];

    g_i = 4;
    fprintf([g_names{g_i}, ' ']);
    Hz_20 = transpose(getfield(data1, g_names{g_i}, band_names{band_i}));
    Hz_100 = transpose(getfield(data2, g_names{g_i}, band_names{band_i}));
    occi = [Hz_20, Hz_100];

    g_i = 5;
    fprintf([g_names{g_i}, ' \n']);
    Hz_20 = transpose(getfield(data1, g_names{g_i}, band_names{band_i}));
    Hz_100 = transpose(getfield(data2, g_names{g_i}, band_names{band_i}));
    temp = [Hz_20, Hz_100];
    
    k = [];
    
end