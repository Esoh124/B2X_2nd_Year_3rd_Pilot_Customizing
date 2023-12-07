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
        reco_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma;
        Result = setfield(Result, chs{ch_num}, 'reco' ,'gamma', reco_gamma);
        reco_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta;
        Result = setfield(Result, chs{ch_num}, 'reco' ,'delta', reco_gamma);
        reco_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta;
        Result = setfield(Result, chs{ch_num}, 'reco' ,'theta', reco_gamma);
        reco_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha;
        Result = setfield(Result, chs{ch_num}, 'reco' ,'alpha', reco_gamma);
        reco_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta;
        Result = setfield(Result, chs{ch_num}, 'reco' ,'beta', reco_gamma);
        reco_gamma = base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma;
        Result = setfield(Result, chs{ch_num}, 'base' ,'gamma', reco_gamma);
        reco_gamma = base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta;
        Result = setfield(Result, chs{ch_num}, 'base' ,'delta', reco_gamma);
        reco_gamma = base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta;
        Result = setfield(Result, chs{ch_num}, 'base' ,'theta', reco_gamma);
        reco_gamma = base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha;
        Result = setfield(Result, chs{ch_num}, 'base' ,'alpha', reco_gamma);
        reco_gamma = base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta;
        Result = setfield(Result, chs{ch_num}, 'base' ,'beta', reco_gamma);
        change_rate_gamma = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.gamma*100;
        Result = setfield(Result, chs{ch_num}, 'change_rate' ,'gamma', change_rate_gamma);
        change_rate_delta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.delta*100;
        Result = setfield(Result, chs{ch_num}, 'change_rate', 'delta', change_rate_delta);
        change_rate_theta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.theta*100;
        Result = setfield(Result, chs{ch_num}, 'change_rate', 'theta', change_rate_theta);
        change_rate_alpha = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.alpha*100;
        Result = setfield(Result, chs{ch_num}, 'change_rate', 'alpha', change_rate_alpha);
        change_rate_beta = reco_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta/base_EEG.SpectralAnalysis.(chs{ch_num}).Mean_epoch.norm.beta*100;
        Result = setfield(Result, chs{ch_num}, 'change_rate', 'beta', change_rate_beta);
    end

end