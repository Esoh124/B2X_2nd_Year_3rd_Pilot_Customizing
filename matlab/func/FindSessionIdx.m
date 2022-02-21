function [base_i, stim_i, reco_i] = FindSessionIdx(len_eeg, fs)
    % base: 6분, stim: 6 분, reco: 6분
    % reco: stim 구간이 포함될 수 있기 때문에, 처음 5초 미포함
    
    t = 0 : 1/fs : (len_eeg-1)/fs;
   
    base2 = 6*60; % end time [sec]
    base_i(1)=1; % start index 
    [~, base_i(2)] = min(abs(t-base2)); % end index
    base_i = base_i(1):base_i(2); % indices of session base
    
    stim_i(1) = base_i(end)+1; % start index
    stim2 = 60*(6+6); % end time [sec]
    [~, stim_i(2)] = min(abs(t-stim2)); % end index
    stim_i = stim_i(1):stim_i(2); % indices of session base
    
    reco_i(1) = stim_i(end)+fs*5; % start index
    reco_i(2) = length(t); % end idex
    reco_i = reco_i(1):reco_i(2);
end