%% Defualt Setting

% --Add path
% \eeglab2021.1: to use EEGLAB functions
% \func: to use customized functions
% \locs: to use locs files
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;

% eeglab; close all; clear; cl
% --Data preparation
data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
exception_path = "C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\exception.txt";

% Choose the subjects who are going to be analyzed
choose_sub = [1:20];

fid = fopen(exception_path, 'r');
data = textscan(fid, '%f');
fclose(fid);
number_array = data{1};
choose_sub(number_array) = [];


f = dir(data_path);
f = f(3:sum([f.isdir]))

if sum(choose_sub) > 0
    f = f(choose_sub);
end

S0_base_alpha = []
S0_base_delta = []
S0_base_theta = []
S0_base_beta = []
S0_base_gamma = []
S0_reco_alpha = []
S0_reco_delta = []
S0_reco_theta = []
S0_reco_beta = []
S0_reco_gamma = []
N020_base_alpha = []
N020_base_delta = []
N020_base_theta = []
N020_base_beta = []
N020_base_gamma = []
N020_reco_alpha = []
N020_reco_delta = []
N020_reco_theta = []
N020_reco_beta = []
N020_reco_gamma = []
channel = ["Fpz", 'Fz','Cz','Pz','Oz','C3','C4','F3','F4'];
for i  = 1: length(channel)
    disp(channel{i});
    for sub_i = 1: length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_PSD.set']);
        for set_num = 1: length(set_list)
            EEGset = pop_loadset([set_list(set_num).folder, '\', set_list(set_num).name]);
            if contains(set_list(set_num).name, 'S0')
                if contains(set_list(set_num).name, 'base')
                    S0_base_delta = [S0_base_delta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.delta];
                    S0_base_theta = [S0_base_theta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.theta];
                    S0_base_alpha = [S0_base_alpha EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.alpha];
                    S0_base_beta = [S0_base_beta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.beta];
                    S0_base_gamma = [S0_base_gamma EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.gamma];
                elseif contains(set_list(set_num).name, 'reco')
                    S0_reco_alpha = [S0_reco_alpha EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.alpha];
                    S0_reco_delta = [S0_reco_delta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.delta];
                    S0_reco_theta = [S0_reco_theta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.theta];
                    S0_reco_beta = [S0_reco_beta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.beta];
                    S0_reco_gamma = [S0_reco_gamma EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.gamma];
                else
                    continue;
                end
            elseif contains(set_list(set_num).name, 'N020')
                if contains(set_list(set_num).name, 'base')
                    N020_base_delta = [N020_base_delta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.delta];
                    N020_base_theta = [N020_base_theta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.theta];
                    N020_base_alpha = [N020_base_alpha EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.alpha];
                    N020_base_beta = [N020_base_beta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.beta];
                    N020_base_gamma = [N020_base_gamma EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.gamma];
                elseif contains(set_list(set_num).name, 'reco')
                    N020_reco_alpha = [N020_reco_alpha EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.alpha];
                    N020_reco_delta = [N020_reco_delta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.delta];
                    N020_reco_theta = [N020_reco_theta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.theta];
                    N020_reco_beta = [N020_reco_beta EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.beta];
                    N020_reco_gamma = [N020_reco_gamma EEGset.SpectralAnalysis.(channel(i)).Mean_epoch.gamma];
                else
                    continue;
                end
            else
                continue;
            end
        end
    end
    % EDAset = struct;
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'base', 'alpha', S0_base_alpha);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'base', 'delta', S0_base_delta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'base', 'theta', S0_base_theta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'base', 'beta', S0_base_beta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'base', 'gamma', S0_base_gamma);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'reco', 'alpha', S0_reco_alpha);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'reco', 'delta', S0_reco_delta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'reco', 'theta', S0_reco_theta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'reco', 'beta', S0_reco_beta);
    % EDAset = setfield(EDAset, 'Stim', 'S0', 'reco', 'gamma', S0_reco_gamma);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'base', 'alpha', N020_base_alpha);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'base', 'delta', N020_base_delta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'base', 'theta', N020_base_theta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'base', 'beta', N020_base_beta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'base', 'gamma', N020_base_gamma);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'reco', 'alpha', N020_reco_alpha);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'reco', 'delta', N020_reco_delta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'reco', 'theta', N020_reco_theta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'reco', 'beta', N020_reco_beta);
    % EDAset = setfield(EDAset, 'Stim', 'N020', 'reco', 'gamma', N020_reco_gamma);
    %boxplot
    figure;
    sgtitle(channel(i));
    subplot(2, 1, 1);
    boxplot([S0_base_delta', S0_reco_delta', S0_base_theta', S0_reco_theta', S0_base_alpha', S0_reco_alpha', S0_base_beta', S0_reco_beta', S0_base_gamma', S0_reco_gamma'], 'Labels', {'Base Delta', 'Reco Delta', 'Base Theta', 'Reco Theta', 'Base Alpha', 'Reco Alpha', 'Base Beta', 'Reco Beta', 'Base Gamma', 'Reco Gamma'});
    subtitle('S0');
    subplot(2, 1, 2);
    boxplot([N020_base_delta', N020_reco_delta', N020_base_theta', N020_reco_theta', N020_base_alpha', N020_reco_alpha', N020_base_beta', N020_reco_beta', N020_base_gamma', N020_reco_gamma'], 'Labels', {'Base Delta', 'Reco Delta', 'Base Theta', 'Reco Theta', 'Base Alpha', 'Reco Alpha', 'Base Beta', 'Reco Beta', 'Base Gamma', 'Reco Gamma'});
    subtitle('N020');
    
end


