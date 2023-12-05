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
    
    
    % if EOG
    if sum(strcmp(varargin, 'EOG')) ~= 0
        is_eog = 1;
    else % ECG
        is_eog = 0; 
    end

    
    if is_eog ~=0 %EOG coherence
        EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
        eog = load([set_list.eog_folder, '\', set_list.eog_name]);
    
        % EOG session dividing
        if(contains(set_list.name, "base1"))
            eog.d.eog100c.wave = eog.d.eog100c.wave(60*eog.d.eog100c.Fs+1: 60*2*eog.d.eog100c.Fs);
            eog.d.eog100c_2.wave = eog.d.eog100c_2.wave(60*eog.d.eog100c_2.Fs+1: 60*2*eog.d.eog100c_2.Fs);
        elseif(contains(set_list.name, "reco1"))
            eog.d.eog100c.wave = eog.d.eog100c.wave(60*13*eog.d.eog100c.Fs+6: 60*14*eog.d.eog100c.Fs+5);
            eog.d.eog100c_2.wave = eog.d.eog100c_2.wave(60*13*eog.d.eog100c_2.Fs+6: 60*14*eog.d.eog100c_2.Fs+5);
        else
            disp('Error: Not base1 or reco1'); return;
        end
    
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
        EEGset.eog2 = filtfilt(b, a, EEGset.eog2);
        
        %calculate correlation
        EEGset.correlations = zeros(size(EEGset.compoactivity, 1), 1);
        EEGset.correlations2  = zeros(size(EEGset.compoactivity, 1), 1);
        for i  = 1:length(size(EEGset.compoactivity, 1))
            EEGset.correlations(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.eog'));
            EEGset.correlations2(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.eog2'));
        end
        
        if sf == 1
            fprintf("saving...%s_corrEOG.set... ", set_list.name(1:end-4));
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_corrEOG.set']);
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
        
    else %ECG coherence
        EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
        ecg = load([set_list.ecg_folder, '\', set_list.ecg_name]);

        % ECG session dividing
        if(contains(set_list.name, "base1"))
            ecg.d.ecg100c.wave = ecg.d.ecg100c.wave(60*ecg.d.ecg100c.Fs+1: 60*2*ecg.d.ecg100c.Fs);
        elseif(contains(set_list.name, "reco1"))
            ecg.d.ecg100c.wave = ecg.d.ecg100c.wave(60*13*ecg.d.ecg100c.Fs+6: 60*14*ecg.d.ecg100c.Fs+5);
        else
            disp('Error: Not base1 or reco1'); return;
        end

        % resampling
        ecg.d.ecg100c.wave = resample(ecg.d.ecg100c.wave, 512, 1000);
        EEGset.ecg = ecg.d.ecg100c.wave;

        % ECG filtering
        % noise cancellation(Filtering)(0.5 ~ 60Hz)
        Wn = [0.5, 60] / (512/2);
        N = 3;
        [a, b] = butter(N, Wn);
        ecg_h = filtfilt(a, b, EEGset.ecg);
        ecg_h = ecg_h/max(abs(ecg_h));
        EEGset.ecg = ecg_h;

        % %plotting
        % figure;
        % subplot(2, 1, 1);
        % plot(ecg.d.ecg100c.wave);
        % title('Before');
        % xlim tight;
        % subplot(2, 1, 2);
        % plot(EEGset.ecg);
        % title('After');
        % xlim tight;

        %calculate correlation
        EEGset.correlations_ecg = zeros(size(EEGset.compoactivity, 1), 1);
        for i  = 1:size(EEGset.compoactivity, 1)
            EEGset.correlations_ecg(i) = max(mscohere(EEGset.compoactivity(i, :), EEGset.ecg')); 
        end
        
        if sf == 1
            fprintf("saving....%s_corrECG.set...", set_list.name(1:end-4));
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_corrECG.set']);
            fprintf('done!\n');
        end

        if pf == 1 
            [~, I]=max(EEGset.correlations_ecg);
            disp(I);
            figure;
            subplot(2, 1, 1);
            plot(EEGset.compoactivity(I,:));
            title(EEGset.correlations_ecg(I));
            xlim([1,10*512]);
            subplot(2, 1, 2);
            plot(EEGset.ecg);
            xlim([1,10*512]);

            figure;
            imagesc(EEGset.correlations_ecg);
            colorbar;  
            title('Correlation Matrix');
            xlabel('ECG');
            ylabel('Components');
        end
    end
end