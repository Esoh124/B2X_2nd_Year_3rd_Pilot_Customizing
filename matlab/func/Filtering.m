function pre_filt_EEGset = Filtering(set_list, varargin)
    % Filtering the singals using EEGLAB filtering function, pop_eegfiltnew()
    % 0.5 Hz HPF
    % 100 Hz LPF
    % 60 Hz BRF (Band Rejection Filter)

    % set save_flag
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'),1)};
    else
        sf = 0;
    end
    
    % set plot_flag
    if sum(strcmp(varargin, 'plot')) ~= 0
        pf = varargin{circshift(strcmp(varargin, 'plot'),1)};
    else
        pf = 0;
    end

    pre_filt_EEGset = pop_loadset([set_list.folder, '\', set_list.name]);

    % Filtering
    % if you wanna see magnitude of the filter, put option of
    % {'plotfreqz', 1} into pop_eegfiltnew function
    EEGset1 = pop_eegfiltnew(pre_filt_EEGset, 'locutoff', 0.5, 'hicutoff', [], 'usefftfilt', 1); % 0.5Hz HPF 
    EEGset2 = pop_eegfiltnew(EEGset1, 'locutoff', [], 'hicutoff', 100, 'usefftfilt', 1); % 100Hz LPF
    EEGset3 = pop_eegfiltnew(EEGset2, 'locutoff',55,'hicutoff',65,'revfilt',1); % 필요한 경우 cutoff 변경
    
    EEGset = EEGset3;
    
    if pf == 1
        figure;
        subplot(2,1,1);
        plot(pre_filt_EEGset.data(1:2,:)'); hold on;
        xlim([0 200]);
        title('before filtering', 'FontSize',15);

        subplot(2,1,2);
        plot(EEGset3.data(1:2,:)'); hold on;
        xlim([0 200]);
        title('after filtering', 'FontSize', 15);
    end

    if sf == 1
        fprintf(" saving... %s\n", set_list.name(1:5));
        pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_Filt.set']);
    end
end