%% load file
clear; close all; clc;

% load norm_X version data
cd 'E:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O'
load("s0.mat");
load("N020.mat");
load("N100.mat");
load("S020.mat");
load("S100.mat");


band_names = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
g_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};


data1 = S100;
data2 = S100;
for band_i = 1 : length(band_names)    

    fprintf([band_names{band_i}, ' ']);

    g_i = 1;
    fprintf([g_names{g_i}, ' ']);
    base = getfield(data1, g_names{g_i}, 'base', band_names{band_i});
    reco = getfield(data2, g_names{g_i}, 'reco', band_names{band_i});
    front = [base', reco'];

    g_i = 2;
    fprintf([g_names{g_i}, ' ']);
    base = getfield(data1, g_names{g_i}, 'base', band_names{band_i});
    reco = getfield(data2, g_names{g_i}, 'reco', band_names{band_i});
    cent = [base', reco'];

    g_i = 3;
    fprintf([g_names{g_i}, ' ']);
    base = getfield(data1, g_names{g_i}, 'base', band_names{band_i});
    reco = getfield(data2, g_names{g_i}, 'reco', band_names{band_i});
    pari = [base', reco'];

    g_i = 4;
    fprintf([g_names{g_i}, ' ']);
    base = getfield(data1, g_names{g_i}, 'base', band_names{band_i});
    reco = getfield(data2, g_names{g_i}, 'reco', band_names{band_i});
    occi = [base', reco'];

    g_i = 5;
    fprintf([g_names{g_i}, ' \n']);
    base = getfield(data1, g_names{g_i}, 'base', band_names{band_i});
    reco = getfield(data2, g_names{g_i}, 'reco', band_names{band_i});
    temp = [base', reco'];

    k = [];
end
