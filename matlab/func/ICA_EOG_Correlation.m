function EEGset = ICA_EOG_Correlation(set_list, varargin)
    % ICA component와 EOG의 correlation을 확인

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

    EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
    eog = load([set_list.eog_folder, '\', set_list.eog_name]);


    % EOG session dividing
    if(contains(set_list.name, "base1"))
        eog.d.eog100c.wave = eog.d.eog100c.wave(60*eog.d.eog100c.Fs+1: 60*2*eog.d.eog100c.Fs);
    elseif(contains(set_list.name, "reco1"))
        eog.d.eog100c.wave = eog.d.eog100c.wave(60*13*eog.d.eog100c.Fs+6: 60*14*eog.d.eog100c.Fs+5);
    end
    % !else문에 base1, reco1이 아닐때 오류 처리 해주기

    % resampling
    eog.d.eog100c.wave = resample(eog.d.eog100c.wave, 512, 1000);
    
    EEGset.eog = eog.d.eog100c.wave;
    %calculate correlation
    EEGset.correlations = zeros(length(EEGset.chanlocs), 1);
    for i  = 1:length(EEGset.chanlocs)
        EEGset.correlations(i) = corr(EEGset.compoactivity(i, :)', eog.d.eog100c.wave);
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
        plot(eog.d.eog100c.wave);
        legend();

        figure;
        imagesc(EEGset.correlations);
        colorbar;  
        title('Correlation Matrix');
        xlabel('EOG');
        ylabel('Components');
    end

end