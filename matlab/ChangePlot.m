load('Change.mat');

channel = ["Fpz", 'Fz','Cz','Pz','Oz','C3','C4','F3','F4'];

for i  = 1: length(channel)
    disp(channel{i});
    tmp_S0_delta = [];
    tmp_S0_theta = [];
    tmp_S0_alpha = [];
    tmp_S0_beta = [];
    tmp_S0_gamma = [];
    tmp_N020_delta = [];
    tmp_N020_theta = [];
    tmp_N020_alpha = [];
    tmp_N020_beta = [];
    tmp_N020_gamma = [];
    names = fieldnames(Change);
    for j = 1: length(names)
        tmp_S0_delta = [tmp_S0_delta Change.(names{j}).S0.(channel{i}).delta];
        tmp_S0_theta = [tmp_S0_theta Change.(names{j}).S0.(channel{i}).theta];
        tmp_S0_alpha = [tmp_S0_alpha Change.(names{j}).S0.(channel{i}).alpha];
        tmp_S0_beta = [tmp_S0_beta Change.(names{j}).S0.(channel{i}).beta];
        tmp_S0_gamma = [tmp_S0_gamma Change.(names{j}).S0.(channel{i}).gamma];
        tmp_N020_delta = [tmp_N020_delta Change.(names{j}).N020.(channel{i}).delta];
        tmp_N020_theta = [tmp_N020_theta Change.(names{j}).N020.(channel{i}).theta];
        tmp_N020_alpha = [tmp_N020_alpha Change.(names{j}).N020.(channel{i}).alpha];
        tmp_N020_beta = [tmp_N020_beta Change.(names{j}).N020.(channel{i}).beta];
        tmp_N020_gamma = [tmp_N020_gamma Change.(names{j}).N020.(channel{i}).gamma];
    end

    %boxplot
    figure;
    sgtitle(channel{i});
    subplot(2, 1, 1);
    boxplot([tmp_S0_delta', tmp_S0_theta', tmp_S0_alpha', tmp_S0_beta', tmp_S0_gamma'], 'Labels', {'S0 Delta', 'S0 Theta', 'S0 Alpha', 'S0 Beta', 'S0 Gamma'});
    subtitle('S0 ChangeRate');
    ylim([0 500]);
    subplot(2, 1, 2);
    boxplot([tmp_N020_delta', tmp_N020_theta', tmp_N020_alpha', tmp_N020_beta', tmp_N020_gamma'], 'Labels', {'N020 Delta', 'N020 Theta', 'N020 Alpha', 'N020 Beta', 'N020 Gamma'});
    subtitle('N020 ChangeRate');
    ylim([0 500]);
    
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
    % figure;
    % sgtitle(channel(i));
    % subplot(2, 1, 1);
    % boxplot([S0_base_delta', S0_reco_delta', S0_base_theta', S0_reco_theta', S0_base_alpha', S0_reco_alpha', S0_base_beta', S0_reco_beta', S0_base_gamma', S0_reco_gamma'], 'Labels', {'Base Delta', 'Reco Delta', 'Base Theta', 'Reco Theta', 'Base Alpha', 'Reco Alpha', 'Base Beta', 'Reco Beta', 'Base Gamma', 'Reco Gamma'});
    % subtitle('S0');
    % subplot(2, 1, 2);
    % boxplot([N020_base_delta', N020_reco_delta', N020_base_theta', N020_reco_theta', N020_base_alpha', N020_reco_alpha', N020_base_beta', N020_reco_beta', N020_base_gamma', N020_reco_gamma'], 'Labels', {'Base Delta', 'Reco Delta', 'Base Theta', 'Reco Theta', 'Base Alpha', 'Reco Alpha', 'Base Beta', 'Reco Beta', 'Base Gamma', 'Reco Gamma'});
    % subtitle('N020');
    % 
end


