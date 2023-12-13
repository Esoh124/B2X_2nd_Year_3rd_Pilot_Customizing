features = struct('pNN50', {}, 'pNN40', {},'pNN30', {},'RMSSD', {}, 'SDNN', {},'nLF', {},'nHF', {}, 'LFHF', {}, 'stim', {}, 'session', {}, 'name', {});
fieldname = fieldnames(Change);

for tmp_i = 1:length(fieldnames(Change))%15 명
    i = tmp_i*4-3;% 4개 s0 base, stim, n020 base, stim
    
    % S0 base
    xname = fieldname(tmp_i);
    name = erase(xname, 'x');
    features(i).name = name;
    features(i).stim = 'S0';
    features(i).session = 'base'
    chname = fieldnames(Change.(xname{1, 1}).S0);
    for j = 1:length(chname)
        chgamma = strcat(chname(j), 'gamma');
        chdelta = strcat(chname(j), 'delta');
        chtheta = strcat(chname(j), 'theta');
        chalpha = strcat(chname(j), 'alpha');
        chbeta = strcat(chname(j), 'beta');
        features(i).(chgamma{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).base.gamma;
        features(i).(chdelta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).base.delta;
        features(i).(chtheta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).base.theta;
        features(i).(chalpha{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).base.alpha;
        features(i).(chbeta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).base.beta;
    end
    ecg_names = fieldnames(S0);
    for t = 1:length(ecg_names)
        tmp_name = ecg_names(t);
        disp(tmp_name(4:end));
        tmp_name = tmp_name{1, 1};
        if(contains(xname{1, 1}, tmp_name(4:end)))
            features(i).pNN50 = S0.(tmp_name).base.base_1.time_result.pNN50;
            features(i).pNN40 = S0.(tmp_name).base.base_1.time_result.pNN40;
            features(i).pNN30 = S0.(tmp_name).base.base_1.time_result.pNN30;
            features(i).RMSSD = S0.(tmp_name).base.base_1.time_result.RMSSD;
            features(i).SDNN = S0.(tmp_name).base.base_1.time_result.SDNN;
            features(i).nLF = S0.(tmp_name).base.base_1.freq_result.lomb.hrv.nLF;
            features(i).nHF = S0.(tmp_name).base.base_1.freq_result.lomb.hrv.nHF;
            features(i).LFHF = S0.(tmp_name).base.base_1.freq_result.lomb.hrv.LFHF;
        end
    end

    % S0 reco
    i = i+1;
    xname = fieldname(tmp_i);
    name = erase(xname, 'x');
    features(i).name = name;
    features(i).stim = 'S0';
    features(i).session = 'reco'
    chname = fieldnames(Change.(xname{1, 1}).S0);
    for j = 1:length(chname)
        chgamma = strcat(chname(j), 'gamma');
        chdelta = strcat(chname(j), 'delta');
        chtheta = strcat(chname(j), 'theta');
        chalpha = strcat(chname(j), 'alpha');
        chbeta = strcat(chname(j), 'beta');
        features(i).(chgamma{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).reco.gamma;
        features(i).(chdelta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).reco.delta;
        features(i).(chtheta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).reco.theta;
        features(i).(chalpha{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).reco.alpha;
        features(i).(chbeta{1, 1}) = Change.(xname{1, 1}).S0.(chname{j, 1}).reco.beta;
    end
    ecg_names = fieldnames(S0);
    for t = 1:length(ecg_names)
        tmp_name = ecg_names(t);
        disp(tmp_name(4:end));
        tmp_name = tmp_name{1, 1};
        if(contains(xname{1, 1}, tmp_name(4:end)))
            features(i).pNN50 = S0.(tmp_name).recov.recov_1.time_result.pNN50;
            features(i).pNN40 = S0.(tmp_name).recov.recov_1.time_result.pNN40;
            features(i).pNN30 = S0.(tmp_name).recov.recov_1.time_result.pNN30;
            features(i).RMSSD = S0.(tmp_name).recov.recov_1.time_result.RMSSD;
            features(i).SDNN = S0.(tmp_name).recov.recov_1.time_result.SDNN;
            features(i).nLF = S0.(tmp_name).recov.recov_1.freq_result.lomb.hrv.nLF;
            features(i).nHF = S0.(tmp_name).recov.recov_1.freq_result.lomb.hrv.nHF;
            features(i).LFHF = S0.(tmp_name).recov.recov_1.freq_result.lomb.hrv.LFHF;
        end
    end



    % N020 base
    i = i+1;
    xname = fieldname(tmp_i);
    name = erase(xname, 'x');
    features(i).name = name;
    features(i).stim = 'N020';
    features(i).session = 'base'
    chname = fieldnames(Change.(xname{1, 1}).N020);
    for j = 1:length(chname)
        chgamma = strcat(chname(j), 'gamma');
        chdelta = strcat(chname(j), 'delta');
        chtheta = strcat(chname(j), 'theta');
        chalpha = strcat(chname(j), 'alpha');
        chbeta = strcat(chname(j), 'beta');
        features(i).(chgamma{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).base.gamma;
        features(i).(chdelta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).base.delta;
        features(i).(chtheta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).base.theta;
        features(i).(chalpha{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).base.alpha;
        features(i).(chbeta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).base.beta;
    end
    ecg_names = fieldnames(N020);
    for t = 1:length(ecg_names)
        tmp_name = ecg_names(t);
        disp(tmp_name(4:end));
        tmp_name = tmp_name{1, 1};
        if(contains(xname{1, 1}, tmp_name(4:end)))
            features(i).pNN50 = N020.(tmp_name).base.base_1.time_result.pNN50;
            features(i).pNN40 = N020.(tmp_name).base.base_1.time_result.pNN40;
            features(i).pNN30 = N020.(tmp_name).base.base_1.time_result.pNN30;
            features(i).RMSSD = N020.(tmp_name).base.base_1.time_result.RMSSD;
            features(i).SDNN = N020.(tmp_name).base.base_1.time_result.SDNN;
            features(i).nLF = N020.(tmp_name).base.base_1.freq_result.lomb.hrv.nLF;
            features(i).nHF = N020.(tmp_name).base.base_1.freq_result.lomb.hrv.nHF;
            features(i).LFHF = N020.(tmp_name).base.base_1.freq_result.lomb.hrv.LFHF;
        end
    end


    % N020 reco
    i = i+1;
    xname = fieldname(tmp_i);
    name = erase(xname, 'x');
    features(i).name = name;
    features(i).stim = 'N020';
    features(i).session = 'reco'
    chname = fieldnames(Change.(xname{1, 1}).N020);
    for j = 1:length(chname)
        chgamma = strcat(chname(j), 'gamma');
        chdelta = strcat(chname(j), 'delta');
        chtheta = strcat(chname(j), 'theta');
        chalpha = strcat(chname(j), 'alpha');
        chbeta = strcat(chname(j), 'beta');
        features(i).(chgamma{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).reco.gamma;
        features(i).(chdelta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).reco.delta;
        features(i).(chtheta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).reco.theta;
        features(i).(chalpha{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).reco.alpha;
        features(i).(chbeta{1, 1}) = Change.(xname{1, 1}).N020.(chname{j, 1}).reco.beta;
    end
    ecg_names = fieldnames(N020);
    for t = 1:length(ecg_names)
        tmp_name = ecg_names(t);
        disp(tmp_name(4:end));
        tmp_name = tmp_name{1, 1};
        if(contains(xname{1, 1}, tmp_name(4:end)))
            features(i).pNN50 = N020.(tmp_name).recov.recov_1.time_result.pNN50;
            features(i).pNN40 = N020.(tmp_name).recov.recov_1.time_result.pNN40;
            features(i).pNN30 = N020.(tmp_name).recov.recov_1.time_result.pNN30;
            features(i).RMSSD = N020.(tmp_name).recov.recov_1.time_result.RMSSD;
            features(i).SDNN = N020.(tmp_name).recov.recov_1.time_result.SDNN;
            features(i).nLF = N020.(tmp_name).recov.recov_1.freq_result.lomb.hrv.nLF;
            features(i).nHF = N020.(tmp_name).recov.recov_1.freq_result.lomb.hrv.nHF;
            features(i).LFHF = N020.(tmp_name).recov.recov_1.freq_result.lomb.hrv.LFHF;
        end
    end
end

save('features.mat', 'features');
