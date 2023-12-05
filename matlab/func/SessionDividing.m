function EEGset = SessionDividing(set_list, varargin)
    % base: 6min, stim: 6min, reco: 6min
    % 20231115 LSH - Sampling only base 1min and recov 1min

    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end
    
    EEGset = pop_loadset([set_list.folder, '\', set_list.name]); % data load
    len_eeg = length(EEGset.data);
    [base_i, stim_i, reco_i] = FindSessionIdx(len_eeg, EEGset.srate);

    % 분석에 사용할 1분만 sampling
    base1_i = 60*EEGset.srate+1: 60*2*EEGset.srate; % 6분 base중 두번째 1분
    reco1_i = 60*13*EEGset.srate+6: 60*14*EEGset.srate+5; % 6분 stim중 두번째 1, stim 구간이 포함될 수 있기 때문에, 처음 5초 미포함

    base_set = CreateSessionSet(set_list, EEGset, base_i, 'base');
    fprintf("  base %2.1f min", length(base_i)/EEGset.srate/60); 
    stim_set = CreateSessionSet(set_list, EEGset, stim_i, 'stim');
    fprintf("  stim %2.1f min", length(stim_i)/EEGset.srate/60); 
    reco_set = CreateSessionSet(set_list, EEGset, reco_i, 'reco');
    fprintf("  reco %2.1f min\n", length(reco_i)/EEGset.srate/60);
    base1_set = CreateSessionSet(set_list, EEGset, base1_i, 'base1');
    fprintf("  base1 %2.1f min", length(base1_i)/EEGset.srate/60); 
    reco1_set = CreateSessionSet(set_list, EEGset, reco1_i, 'reco1');
    fprintf("  reco1 %2.1f min\n", length(reco1_i)/EEGset.srate/60);
    EEGset = reco_set;

    if sf == 1
        fprintf("saving...\n");
        % pop_saveset(base_set, [set_list.folder, '\', set_list.name(1:end-4), '_base.set']);
        % pop_saveset(stim_set, [set_list.folder, '\', set_list.name(1:end-4), '_stim.set']);
        % pop_saveset(reco_set, [set_list.folder, '\', set_list.name(1:end-4), '_reco.set']);
        pop_saveset(base1_set, [set_list.folder, '\', set_list.name(1:end-4), '_base1.set']);
        pop_saveset(reco1_set, [set_list.folder, '\', set_list.name(1:end-4), '_reco1.set']);
    end
end