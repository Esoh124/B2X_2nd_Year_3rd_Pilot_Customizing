function pre_filt_EEGset = Filtering(set_list,subject, varargin)
    % Input(필수):
    %   set_list - 한개의 .mat file까지의 path
    % -------------------------------------------------
    % option(varargin):
    %   'plot' - 0 -> no plot
    %          else -> filter 전, 후 plot
    %   'save' - 0 -> 저장하지 않음
    %          else -> 저장
    %
    %20231115 LSH modify : plot all filter process
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

    pre_filt_EEGset = pop_loadset([set_list.folder, '\', set_list.name]); %set_list안의 파일 EEGLAB EEG 구조체로 읽기

    % Filtering
    % if you wanna see magnitude of the filter, put option of
    % {'plotfreqz', 1} into pop_eegfiltnew function
    EEGset1 = pop_eegfiltnew(pre_filt_EEGset, 'locutoff', 0.5, 'hicutoff', [], 'usefftfilt', 1); % 0.5Hz HPF 
    EEGset2 = pop_eegfiltnew(EEGset1, 'locutoff', [], 'hicutoff', 100, 'usefftfilt', 1); % 100Hz LPF
    EEGset3 = pop_eegfiltnew(EEGset2, 'locutoff',55,'hicutoff',65,'revfilt',1); % 필요한 경우 cutoff 변경
    
    EEGset = EEGset3;
    
    if pf == 1
        figure;
        subplot(4,1,1);
        plot(pre_filt_EEGset.data(1:2,:)'); hold on;
        xlim([0 1000]);
        subject = erase(subject, '_');
        name = erase(set_list.name, '_');
        legend();
        title(strcat(subject,{' '}, name, ' before filtering'), 'FontSize',15);
        subplot(4,1,2);
        plot(EEGset1.data(1:2,:)'); hold on;
        xlim([0 1000]);
        title(strcat(subject,{' '}, name, ' after filtering1'), 'FontSize', 15);
        subplot(4,1,3);
        plot(EEGset2.data(1:2,:)'); hold on;
        xlim([0 1000]);
        title(strcat(subject,{' '}, name, ' after filtering2'), 'FontSize', 15);
        subplot(4,1,4);
        plot(EEGset3.data(1:2,:)'); hold on;
        xlim([0 1000]);
        title(strcat(subject,{' '}, name, ' after filtering3'), 'FontSize', 15);
    end

    if sf == 1
        fprintf(" saving... %s\n", set_list.name(1:end-4));
        pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_Filt.set']);
    end
end