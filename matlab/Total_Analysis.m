% Total Analysis
% Use custom functions, which are contained in the func/

%% Defualt Setting

% --Add path
% \eeglab2021.1: to use EEGLAB functions
% \func: to use customized functions
% \locs: to use locs files
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;
% eeglab; close all; clear; clc;

% --Data preparation
data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';
% Choose the subjects who are goning to be analyzed
choose_sub = 2;
% choose_sub = 10; 
f = dir(data_path);
f = f(3:sum([f.isdir]))
eog_f = dir(eog_path);
eog_f = eog_f(3:sum([eog_f.isdir]))
if sum(choose_sub) > 0
    f = f(choose_sub);
    eog_f = eog_f(choose_sub);
end


fprintf('Selected Subjects: ');
for mat_i = 1 : length(f)
    fprintf('%s ', f(mat_i).name);
end
disp(' ');

%% set the flags for the functions below whether run or not
%       mat2set    Filtering    SessionDividing     ICA_component_calculation_EOG_coh       ICA_EOG_coh                       Epoching
%       CalPSD
flag = [0           0           0                   1                                       1                                 0 ...
        0];
%% mat2set
warning('off')
if flag(1) == 1
    disp('--------------------   MAT2SET   --------------------')
    for sub_i = 1 : length(f)
        % EEG 폴더 안의 모든 .mat 파일 list 얻기
        set_list = dir([f(sub_i).folder '\' f(sub_i).name '\*.mat']); 
        
        % optional parameters for mat2set
        fs = 512; % sampling rate 
        n_ch = 31; % number of channels
    
        disp([f(sub_i).name]);
        for mat_i = 1 : length(set_list)
            EEGset = mat2set(f(sub_i), set_list(mat_i), fs, n_ch, 'save', 1);
        end
    end
    warning('on')
end

%% Filtering
if flag(2) == 1
    disp('--------------------  FILTERING  --------------------')
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*0.set']);
    
        disp([f(sub_i).name]);
        for mat_i = 1 : length(set_list)
            EEGset = Filtering(set_list(mat_i),f(sub_i).name, 'plot', 0, 'save', 1);
        end
    end
end

%% Session Dividing
if flag(3) == 1
    disp('--------------------SESSION DIVIDING--------------------')
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_Filt.set']);
    
            disp([f(sub_i).name]);
            for set_num = 1 : length(set_list)
                EEGset = SessionDividing(set_list(set_num), 'save', 1);
            end
    end
end

%% ICA component calculation
% if flag(4) == 1
%     clear set_list;
%     disp('--------------------  ICA Calculation  --------------------')
%     for sub_i = 1 : length(f)
% %         set_list(1:2) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_base.set']);  
% %         set_list(3:4) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_stim.set']);
% %         set_list(5:6) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_reco.set']);
%         set_list(1:2) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_base1.set']);
%         set_list(3:4) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_reco1.set']);
% 
%         disp([f(sub_i).name]);
%         for set_num = 1 : length(set_list)
%             EEGset = ICA_Component_Extraction(set_list(set_num), 'save', 1);
%         end
%     end
% end



%% Component&EOG correlation
% if flag(4) ==1
%     disp('--------------------  ICA&EOG correlation  --------------------')
%     for sub_i = 1 : length(f)
%         set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_ICA.set']);
%         eog_list = dir([eog_f(sub_i).folder, '\', f(sub_i).name, '\*.mat']);
% 
%         % 적절한 eog파일만 저장
%         for j = 1:length(set_list)
%             for k = 1:length(eog_list)      % !수정할 방법 나중에 생각하기
%                 disp(set_list(j).name)
%                 disp(erase(eog_list(k).name, '.mat'))
%                 if(contains(set_list(j).name, erase(eog_list(k).name, '.mat')))
%                     set_list(j).eog_name = eog_list(k).name;
%                     set_list(j).eog_folder = eog_list(k).folder;
%                 end
%             end
%         end
% 
%         disp([f(sub_i).name]);
%         for set_num = 1 : length(set_list)
%             EEGset = ICA_EOG_Correlation(set_list(set_num), 'save', 1, 'plot', 0);
%         end
%     end
% end

%% Remove the highest corr comp
if flag(4) == 1
    disp('--------------------Remove component--------------------')
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corr.set']);
            disp([f(sub_i).name]);

            for set_num = 1 : length(set_list)
                [EEGset, newEEGset] = remove_components(set_list(set_num), 'save', 1);
                figure;
                subplot(3, 1, 1);
                plot(EEGset.eog);
                xlim([1,10*512]);
                title("EOG");
                subplot(3, 1, 2);
                plot(EEGset.data(26, :));
                % ylim([-60 60]);
                xlim([1,10*512]);
                title("raw EEG(1)");
                subplot(3, 1, 3);
                plot(newEEGset.data(26, :));
                % ylim([-60 60]);
                xlim([1,10*512]);
                title("removed EEG(1)");
                

                % num = 5;
                % [~, index]= maxk(EEGset.correlations, num, 'ComparisonMethod','abs');
                % 
                % figure;
                % for i = 1:num
                %     subplot(num, 1, i);
                %     plot(EEGset.compoactivity(index(i),:));
                %     title(EEGset.correlations(index(i)));
                %     xlim([1,10*512]);
                % end
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
                % for i = 21:31
                %     subplot(11, 1, i-20);
                %     plot(EEGset.compoactivity(i,:));
                %     title(EEGset.correlations(i));
                %     xlim([1,10*512]);
                % 
                % end


                % [M, I]=max(EEGset.correlations);ee
                % disp(I);
                % figure;
                % subplot(2, 1, 1);
                % plot(EEGset.compoactivity(I,:));
                % xlim tight;
                % title("corr top1 component");
                % subplot(2, 1, 2);
                % plot(EEGset.eog);
                % xlim tight;
                % title("EOG");
            end
    end
end


%% Component&ECG correlation
if flag(5) ==1
    disp('--------------------  ICA&ECG correlation  --------------------')
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_rmEOG.set']);
        eog_list = dir([eog_f(sub_i).folder, '\', f(sub_i).name, '\*.mat']);

        % 적절한 eog파일만 저장
        for j = 1:length(set_list)
            for k = 1:length(eog_list)      % !수정할 방법 나중에 생각하기
                disp(set_list(j).name)
                disp(erase(eog_list(k).name, '.mat'))
                if(contains(set_list(j).name, erase(eog_list(k).name, '.mat')))
                    set_list(j).eog_name = eog_list(k).name;
                    set_list(j).eog_folder = eog_list(k).folder;
                end
            end
        end

        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            EEGset = ICA_EOG_Correlation(set_list(set_num), 'save', 1, 'plot', 0);
        end
    end
end

%% Remove the highest corr comp
if flag(5) == 1
    disp('--------------------Remove component--------------------')
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corr.set']);
            disp([f(sub_i).name]);

            for set_num = 1 : length(set_list)
                [EEGset, newEEGset] = remove_components(set_list(set_num), 'save', 1);
                figure;
                subplot(3, 1, 1);
                plot(EEGset.eog);
                xlim([1,10*512]);
                title("EOG");
                subplot(3, 1, 2);
                plot(EEGset.data(26, :));
                % ylim([-60 60]);
                xlim([1,10*512]);
                title("raw EEG(1)");
                subplot(3, 1, 3);
                plot(newEEGset.data(26, :));
                % ylim([-60 60]);
                xlim([1,10*512]);
                title("removed EEG(1)");
                

                num = 5;
                [~, index]= maxk(EEGset.correlations, num, 'ComparisonMethod','abs');

                figure;
                for i = 1:num
                    subplot(num, 1, i);
                    plot(EEGset.compoactivity(index(i),:));
                    title(EEGset.correlations(index(i)));
                    xlim([1,10*512]);
                end
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
                % for i = 21:31
                %     subplot(11, 1, i-20);
                %     plot(EEGset.compoactivity(i,:));
                %     title(EEGset.correlations(i));
                %     xlim([1,10*512]);
                % 
                % end


                % [M, I]=max(EEGset.correlations);ee
                % disp(I);
                % figure;
                % subplot(2, 1, 1);
                % plot(EEGset.compoactivity(I,:));
                % xlim tight;
                % title("corr top1 component");
                % subplot(2, 1, 2);
                % plot(EEGset.eog);
                % xlim tight;
                % title("EOG");
            end
    end
end
%% Manually Name Change
% for sub_i = 1 : length(f)
%     set_list= dir([f(sub_i).folder, '\', f(sub_i).name, '\EEG\EEGset\*_ICA.set']);
%     
%     disp([f(sub_i).name]);
%     for set_num = 1 : length(set_list)
%         ManualNameChange(set_list(set_num));
%     end
% end

%% Epoching
if flag(5) == 1
    disp('--------------------------EPOCHING------------------------')
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);
    
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEGset\*_rmICA.set']);
               
        for set_num = 1 : length(set_list)
            EEGset = Epoching(set_list(set_num), 'save', 1);
        end
    end
end

%% Spectral Analysis
% artifact를 포함하는 epoch을 제외한 나머지 epoch들을 이용
% 각 epoch에 대한 PSD, band power(gamma, beta, alpha, theta, delta)를 구하여
% EEGset에 저장

if flag(6) == 1
    disp('--------------------------SPECTRAL ANALYSIS------------------------')
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEGset\*_epoch.set']);
        for set_num = 1 : length(set_list)
            EEGset = CalPSD(set_list(set_num), 'save', 1);
        end
    end
end

%% Show Powers

% disp('--------------------------SHOW POWERS------------------------')
% [powers, powers_ratio] = B2X2_EEG_ShowPowers_v04(f, 1);
% [norm_powers, norm_powers_ratio] = B2X2_EEG_ShowNormPowers_v03(f, 1);


