function Result = change(set_list, varargin)
    % base에서 reco로의 변화율을 각 채널에 저장한다.
    
    for set_num = 1:length(set_list)
        if(contains(set_list(set_num).name, 'base'))
            base_EEG = pop_loadset([set_list(set_num).folder, '\', set_list(set_num).name]);
        else(contains(set_list(set_num).name, 'reco'))
            reco_EEG = pop_loadset([set_list(set_num).folder, '\', set_list(set_num).name]);
        end
    end
    Result = struct();
    chs = {base_EEG.chanlocs.labels};
    for ch_num =1:length(chs)
        change_rate_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma*100;
        Result = setfield(Result, chs{ch_num}, 'gamma', change_rate_gamma);
        change_rate_delta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta*100;
        Result = setfield(Result, chs{ch_num}, 'delta', change_rate_delta);
        change_rate_theta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta*100;
        Result = setfield(Result, chs{ch_num}, 'theta', change_rate_theta);
        change_rate_alpha = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha*100;
        Result = setfield(Result, chs{ch_num}, 'alpha', change_rate_alpha);
        change_rate_beta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta*100;
        Result = setfield(Result, chs{ch_num}, 'beta', change_rate_beta);
    end

end