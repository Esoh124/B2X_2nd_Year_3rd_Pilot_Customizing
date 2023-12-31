function [command] = remove_components(set_list,  varargin)
    % EOG&component correlation으로 구한 component 결과를 적용하여,
    % artifact-related component를 제거
    % ex) [EEGset, newEEGset] = remove_components(set_list);
    % options
    % 'save', 1 -> save the result as .set
    % 'remove', 5 -> remove 5 components
    % 'user', 1 -> remove manually
    
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

    if sum(strcmp(varargin, 'user')) ~= 0
        user = varargin{circshift(strcmp(varargin, 'user'), 1)};
    else 
        user = 0;
    end

    if sum(strcmp(varargin, 'ECG')) ~= 0
        is_ecg = varargin{circshift(strcmp(varargin, 'ECG'), 1)};
    else 
        is_ecg = 0;
    end
    
    EEGset= pop_loadset([set_list.folder, '\', set_list.name]);             %data load



    if is_ecg == 0 %EOG
        if user == 0 
        
            [~, index]= maxk(EEGset.correlations, rm, 'ComparisonMethod','abs');    %가장 높은 coh의 rm개의 index 뽑기
            [~, index_2] = maxk(EEGset.correlations2, rm, 'ComparisonMethod', 'abs');
        
            disp('EOG 1 remove component')
            disp(index);
            disp('EOG 2 remove component')
            disp(index_2);
         
            %Remove components
            index = [index index_2];
            index = unique(index);

            newEEGset = pop_subcomp(EEGset, index, 1);

            %compoactivity renew
            tmpdata = eeg_getdatact(newEEGset, 'component', [1:size(newEEGset,icaweights, 1)]);
            newEEGset.compoactivity = tmpdata;

            command = 5;
    
        elseif user ~= 0
            [~, index_1]= maxk(EEGset.correlations, rm, 'ComparisonMethod','abs');    %가장 높은 coh의 rm개의 index 뽑기
            [~, index_2] = maxk(EEGset.correlations2, rm, 'ComparisonMethod', 'abs');
            
            disp('EOG 1 remove component')
            disp(index_1);
            disp('EOG 2 remove component')
            disp(index_2);
    
            EEGset_1 = pop_subcomp(EEGset, index_1, 1);    % verti만 제거
            EEGset_2 = pop_subcomp(EEGset, index_2, 1);  % hori만 제거
            index = [index_1 index_2];
            index = unique(index);
            EEGset_3 = pop_subcomp(EEGset, index, 1);    % 둘다 제거
    
    
            %plotting
            close all;
            figure;
            subtitle(set_list.name);
            subplot(6, 1, 1);
            plot(EEGset.eog);
            xlim([1,10*512]);
            title('EOG_1');
            subplot(6, 1, 2);
            plot(EEGset.eog2);
            xlim([1,10*512]);
            title('EOG_2');
            subplot(6, 1, 3);
            plot(EEGset.data(26, :));
            xlim([1, 10*512]);
            title('raw EEG(FP1)');
            subplot(6, 1, 4);
            plot(EEGset_1.data(26,:));
            xlim([1, 10*512]);
            title('removed EOG_1');
            subplot(6, 1, 5);
            plot(EEGset_2.data(26, :));
            xlim([1, 10*512]);
            title('removed EOG_2');
            subplot(6, 1, 6);
            plot(EEGset_3.data(26, :));
            xlim([1, 10*512]);
            title('removed EOG 1&2');
    
            figure;
            subtitle('component coh 1');
            subplot(4, 1, 1);
            plot(EEGset.eog);
            xlim([1,10*512]);
            title('EOG_1');
            subplot(4, 1, 2);
            plot(EEGset.compoactivity(index_1, :))
            xlim([1,10*512]);
            title('EOG_1 & Component');
            subplot(4, 1, 3);
            plot(EEGset.eog2);
            xlim([1,10*512]);
            title('EOG_2');
            subplot(4, 1, 4);
            plot(EEGset.compoactivity(index_2, :))
            xlim([1,10*512]);
            title('EOG_2 & Component');
            
            pop_topoplot(EEGset);
    
            % 위의 plotting을 보고 유저가 manually하게 지운다.
            % 0(data delete), 1(remove EOG_1), 2(remove EOG_2), 
            % 3(remove EOG_1&2)
            command = input('Command(0 - delete data, 1 - remove EOG_1, 2 - remove EOG_2, 3 - remove EOG_1&2, 4 - no need to remove) : ');
        end
    
        if sf == 1 
            if command == 5
                %compoactivity renew
                tmpdata = eeg_getdatact(newEEGset, 'component', [1:size(newEEGset,icaweights, 1)]);
                newEEGset.compoactivity = tmpdata;
                pop_saveset(newEEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
            elseif command == 1
                tmpdata = eeg_getdatact(EEGset_1, 'component', [1:size(EEGset_1,icaweights, 1)]);
                EEGset_1.compoactivity = tmpdata;
                pop_saveset(EEGset_1, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
            elseif command == 2
                tmpdata = eeg_getdatact(EEGset_2, 'component', [1:size(EEGset_2,icaweights, 1)]);
                EEGset_2.compoactivity = tmpdata;
                pop_saveset(EEGset_2, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
            elseif command == 3
                tmpdata = eeg_getdatact(EEGset_3, 'component', [1:size(EEGset_3,icaweights, 1)]);
                EEGset_3.compoactivity = tmpdata;
                pop_saveset(EEGset_3, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
            elseif command == 4
                pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
            end
        end
    else %ECG
        if user == 0
        
            [~, index]= maxk(EEGset.correlations_ecg, rm, 'ComparisonMethod','abs');    %가장 높은 coh의 rm개의 index 뽑기
        
            disp('ECG remove component')
            disp(index);
        
            %Remove components
            
            newEEGset = pop_subcomp(EEGset, index, 1);
                              
            command = 1;
    
        elseif user ~= 0
            [~, index]= maxk(EEGset.correlations_ecg, rm, 'ComparisonMethod','abs');    %가장 높은 coh의 rm개의 index 뽑기
            
            disp('ECG remove component')
            disp(index);

            %Remove components
            newEEGset = pop_subcomp(EEGset, index, 1);
    
            %plotting
            close all;
            figure;
            subtitle(set_list.name);
            subplot(3, 1, 1);
            plot(EEGset.ecg);
            xlim([1,10*512]);
            title('ECG');
            subplot(3, 1, 2);
            plot(EEGset.data(26, :));
            xlim([1,10*512]);
            title('raw_EEG(FP1)');
            subplot(3, 1, 3);
            plot(newEEGset.data(26, :));
            xlim([1, 10*512]);
            title('remove 1');
            
            %plotting을 remove 개수에 맞게 plotting하면 좋음
            figure;
            subtitle('component coh 1');
            subplot(2, 1, 1);
            plot(EEGset.ecg);
            xlim([1,10*512]);
            title('ECG');
            subplot(2, 1, 2);
            plot(EEGset.compoactivity(index, :))
            xlim([1,10*512]);
            title('ECG & Component');


            % figure;
            % for i = 1:10
            %     subplot(10, 1, i);
            %     plot(EEGset.compoactivity(i,:));
            %     title(EEGset.correlations(i));
            %     xlim([1,10*512]);
            % 
            % end
            % 
            % figure;
            % for i = 11:20
            %     subplot(10, 1, i-10);
            %     plot(EEGset.compoactivity(i,:));
            %     title(EEGset.correlations(i));
            %     xlim([1,10*512]);
            % 
            % end
            % 
            % figure;
            % for i = 21:size(EEGset.compoactivity, 1);
            %     subplot(11, 1, i-20);
            %     plot(EEGset.compoactivity(i,:));
            %     title(EEGset.correlations(i));
            %     xlim([1,10*512]);
            % 
            % end

    
            % 위의 plotting을 보고 유저가 manually하게 지운다.
            % 0(data delete), 1(remove 1), 2(no need to remove), 
            command = input('Command(0 - delete data, 1 - remove 1, 2 - no need to remove) : ');
        end
    
        if sf == 1 
            if command == 1
                tmpdata = eeg_getdatact(newEEGset, 'component', [1:size(newEEGset.icaweights, 1)]);
                newEEGset.compoactivity = tmpdata;
                pop_saveset(newEEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmECG.set']);
            elseif command == 2
                pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmECG.set']);
            end
        end
    end
end