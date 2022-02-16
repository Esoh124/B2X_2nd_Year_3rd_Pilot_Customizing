
function EEGset = B2X2_Filtering_v02(f_list, sf)
    % 0.5 Hz HPF
    % 100 Hz LPF
    % 60 Hz BRF (Band Rejection Filter)
    
    % input
    % 1. f : dir(default_path)
    % 2. sf : saveflag (save the EEGset when sf=1)
    
    % default setting
    chs = {'F3', 'Fz', 'F4', 'C3', 'Cz', 'C4', 'O1', 'Oz', 'O2'};
    EEGset = pop_loadset([f_list.folder, '\', f_list.name]);
    
    for ch_num = 1 : length(chs)
        subplot(9,2,2*ch_num-1);
        plot(EEGset.data(ch_num,:));
        xlim([0 100]);
    end
    
    EEGset = pop_eegfiltnew(EEGset, 'locutoff', 0.5, 'hicutoff', [], 'usefftfilt', 1); % 0.5Hz HPF 
    % if you wanna see magnitude of the filter, put option of
    % {'plotfreqz', 1} into pop_eegfiltnew function
    EEGset = pop_eegfiltnew(EEGset, 'locutoff', [], 'hicutoff', 100, 'usefftfilt', 1); % 100Hz LPF
    EEGset = pop_eegfiltnew(EEGset, 'locutoff',55,'hicutoff',65,'revfilt',1); % 필요한 경우 cutoff 변경
    
    for ch_num = 1 : length(chs)
        subplot(9,2,2*ch_num);
        plot(EEGset.data(ch_num,:));
        xlim([0 100]);
    end
    
    if sf == 1
        fprintf(" saving... %s\n", f_list.name(1:5));
        pop_saveset(EEGset, [f_list.folder, '\', f_list.name(1:end-4), '_Filt.set']);
    end
    
end
