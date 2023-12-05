function [command, index] = EOG_remove(set_list,  varargin)
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end

    if sum(strcmp(varargin, 'remove')) ~= 0
        rm = varargin{circshift(strcmp(varargin, 'remove'), 1)};
    else
        rm = 0;
    end
    
    if sum(strcmp(varargin, 'try')) ~= 0
        temp = varargin{circshift(strcmp(varargin, 'try'), 1)};
    else
        temp = 0;
    end
    
    EEGset= pop_loadset([set_list.folder, '\', set_list.name]);             %data load
    
    if temp == 0
        
        [~, index]= maxk(EEGset.correlations, rm, 'ComparisonMethod','abs');   
    else
        [~, index]= maxk(EEGset.correlations2, rm, 'ComparisonMethod','abs');   
    end

    
    disp('EOG remove component 1')
    disp(index(1));
    disp('EOG remove component 2')
    disp(index(2));

    EEGset_1 = pop_subcomp(EEGset, index(1), 1);    % 1개 제거
    EEGset_2 = pop_subcomp(EEGset, index, 1);       % 2개 제거
    
    %plotting
    close all;
    figure;
    subtitle(set_list.name);
    subplot(4, 1, 1);
    if(temp ==  0)
        plot(EEGset.eog);
    else
        plot(EEGset.eog2);
    end
    xlim([1,10*512]);
    title('EOG');
    subplot(4, 1, 2);
    plot(EEGset.data(26, :));
    xlim([1, 10*512]);
    title('raw EEG(FP1)');
    subplot(4, 1, 3);
    plot(EEGset_1.data(26,:));
    xlim([1, 10*512]);
    title('removed EOG 1 ');
    subplot(4, 1, 4);
    plot(EEGset_2.data(26, :));
    xlim([1, 10*512]);
    title('removed EOG 2');

    figure;
    subtitle('component coherence');
    subplot(3, 1, 1);
    if(temp ==  0)
        plot(EEGset.eog);
    else
        plot(EEGset.eog2);
    end
    xlim([1,10*512]);
    title('EOG');
    subplot(3, 1, 2);
    plot(EEGset.compoactivity(index(1), :))
    xlim([1,10*512]);
    title('EOG & Component 1 ');
    subplot(3, 1, 3);
    plot(EEGset.compoactivity(index(2), :))
    xlim([1,10*512])
    title('EOG & Component 2');
    
    pop_topoplot(EEGset);
    
    % 위의 plotting을 보고 유저가 manually하게 지운다.
    % 0(data delete), 1(remove EOG_1), 2(remove EOG_2), 
    % 3(Save data)
    command = input('Command(0 - delete data, 1 - remove 1, 2 - remove 2, 3 - remove no need to remove) : ');

    if command == 1
        index = index(1);
    elseif command == 3
        index = [];
    elseif command == 0
        index = [];
    end

    if sf == 1 
        if command == 1
            tmpdata = eeg_getdatact(EEGset_1, 'component', [1:size(EEGset_1.icaweights, 1)]);
            EEGset_1.compoactivity = tmpdata;
            pop_saveset(EEGset_1, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
        elseif command == 2
            tmpdata = eeg_getdatact(EEGset_2, 'component', [1:size(EEGset_2.icaweights, 1)]);
            EEGset_2.compoactivity = tmpdata;
            pop_saveset(EEGset_2, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
        elseif command == 3
            pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
        elseif command == 0
        end
    end
end
