function EEGset = ICA_Correlation(set_list, varargin)
    % ICA component와 EOG or ECG의 correlation을 확인

    % set save_flag
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end

    % set plot_flag
    if sum(strcmp(varargin, 'plot')) ~= 0
        pf = varargin{circshift(strcmp(varargin, 'plot'),1)};
    else
        pf = 0;
    end
    
    % if ECG
    if sum(strcmp(varargin, 'ECG')) ~= 0
        is_ecg = 1;
    else
        is_ecg = 0;
    end
    
    % if EOG
    if sum(strcmp(varargin, 'EOG')) ~= 0
        is_eog = 1;
    else
        is_eog = 0;
    end


    if is_eog
        EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
        eog = load([set_list.eog_folder, '\', set_list.eog_name]);
    
        % EOG session dividing
        if(contains(set_list.name, "base1"))
            eog.d.eog100c.wave = eog.d.eog100c.wave(60*eog.d.eog100c.Fs+1: 60*2*eog.d.eog100c.Fs);
            eog.d.eog100c_2.wave = eog.d.eog100c_2.wave(60*eog.d.eog100c.Fs+1: 60*2*eog.d.eog100c.Fs);
        elseif(contains(set_list.name, "reco1"))
            eog.d.eog100c.wave = eog.d.eog100c.wave(60*13*eog.d.eog100c.Fs+6: 60*14*eog.d.eog100c.Fs+5);
            eog.d.eog100c_2.wave = eog.d.eog100c_2.wave(60*13*eog.d.eog100c.Fs+6: 60*14*eog.d.eog100c.Fs+5);
        else
            disp('Error: Not base1 or reco1'); return;
        end
        % !else문에 base1, reco1이 아닐때 오류 처리 해주기
    
        % resampling
        eog.d.eog100c.wave = resample(eog.d.eog100c.wave, 512, 1000);
        eog.d.eog100c_2.wave = resample(eog.d.eog100c_2.wave, 512, 1000);
        EEGset.eog = eog.d.eog100c.wave;
        EEGset.eog2 = eog.d.eog100c_2.wave;
    
        % EOG filtering
        % butter worth [1, 20]Hz band-pass filter
        Wn = [1, 20] / (512/2);
        [b, a] = butter(2, Wn, 'bandpass');
        EEGset.eog = filtfilt(b, a, EEGset.eog);
        EEGset.eog2 = filtfilt(b, a, EEGset.eog);
        
        %calculate correlation
        EEGset.correlations = zeros(length(EEGset.chanlocs), 1);
        for i  = 1:length(EEGset.chanlocs)
            EEGset.correlations(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.eog'));
            EEGset.eorrelations2(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.eog2'));
        end
        
        if sf == 1
            fprintf("saving...%s_corr.set... ", set_list.name(1:end-4));
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_corr.set']);
            fprintf('done!\n')
        end
    
        if pf == 1

            %plotting
            figure;
            subplot(2, 1, 1);
            plot(eog.d.eog100c.wave);
            title('Before');
            xlim tight;
            subplot(2, 1, 2);
            plot(EEGset.eog);
            title('After');
            xlim tight;

            %corr가장 높은 component와, EOG plot
            [M, I]=max(EEGset.correlations);
            disp(I);
            figure;
            plot(EEGset.compoactivity(I,:));
            hold on;
            plot(EEGset.eog);
            legend();
    
            figure;
            imagesc(EEGset.correlations);
            colorbar;  
            title('Correlation Matrix');
            xlabel('EOG');
            ylabel('Components');
        end
    elseif is_ecg
        EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
        ecg = load([set_list.ecg_folder, '\', set_list.ecg_name]);
    
        % ECG session dividing
        if(contains(set_list.name, "base1"))
            ecg.d.eog100c.wave = ecg.d.ecg100c.wave(60*ecg.d.ecg100c.Fs+1: 60*2*ecg.d.ecg100c.Fs);
        elseif(contains(set_list.name, "reco1"))
            ecg.d.eog100c.wave = ecg.d.ecg100c.wave(60*13*ecg.d.ecg100c.Fs+6: 60*14*ecg.d.ecg100c.Fs+5);
        end
        % !else문에 base1, reco1이 아닐때 오류 처리 해주기
    
        % resampling
        ecg.d.ecg100c.wave = resample(ecg.d.ecg100c.wave, 512, 1000);
        
        EEGset.ecg = ecg.d.ecg100c.wave;
    
        % EOG filtering
        % butter worth [1, 20] band-pass filter
        Wn = [1, 20] / (512/2);
        [b, a] = butter(2, Wn, 'bandpass');
        EEGset.eog = filtfilt(b, a, EEGset.eog);
    
        %plotting
        figure;
        subplot(2, 1, 1);
        plot(eog.d.eog100c.wave);
        title('Before');
        xlim tight;
        subplot(2, 1, 2);
        plot(EEGset.eog);
        title('After');
        xlim tight;
        
        %calculate correlation
        EEGset.correlations = zeros(length(EEGset.chanlocs), 1);
        for i  = 1:length(EEGset.chanlocs)
            % EEGset.correlations(i) = corr(EEGset.compoactivity(i, :)', eog.d.eog100c.wave);
            %tmp = mscohere(EEGset.compoactivity(i, :), EEGset.eog');
            EEGset.correlations(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.eog'));
        end
        
        if sf == 1
            fprintf("saving...%s_corr.set... ", set_list.name(1:end-4));
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_corr.set']);
            fprintf('done!\n')
        end
    
        if pf == 1
            %corr가장 높은 component와, EOG plot
            [M, I]=max(EEGset.correlations);
            disp(I);
            figure;
            plot(EEGset.compoactivity(I,:));
            hold on;
            plot(EEGset.eog);
            legend();
    
            figure;
            imagesc(EEGset.correlations);
            colorbar;  
            title('Correlation Matrix');
            xlabel('EOG');
            ylabel('Components');
        end
    end


end