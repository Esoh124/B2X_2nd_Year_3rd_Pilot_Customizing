function EEGset = SessionDividing(set_list, varargin)
    % base: 6min, stim: 6min, reco: 6min

    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end

    EEGset = pop_loadset([set_list.folder, '\', set_list.name]); % data load
    len_eeg = length(EEGset.data);

    [base_i, stim_i, reco_i] = FindSessionIdx(len_eeg, EEGset.srate);
    
    base_set = CreateSessionSet(set_list, EEGset, base_i, 'base');
    fprintf("  base %2.1f min", length(base_i)/EEGset.srate/60); 
    stim_set = CreateSessionSet(set_list, EEGset, stim_i, 'stim');
    fprintf("  stim %2.1f min", length(stim_i)/EEGset.srate/60); 
    reco_set = CreateSessionSet(set_list, EEGset, reco_i, 'reco');
    fprintf("  reco %2.1f min\n", length(reco_i)/EEGset.srate/60);

    EEGset = reco_set;

    if sf == 1
        fprintf("saving...\n");
        pop_saveset(base_set, [set_list.folder, '\', set_list.name(1:end-4), '_base.set']);
        pop_saveset(stim_set, [set_list.folder, '\', set_list.name(1:end-4), '_stim.set']);
        pop_saveset(reco_set, [set_list.folder, '\', set_list.name(1:end-4), '_reco.set']);
    end
end