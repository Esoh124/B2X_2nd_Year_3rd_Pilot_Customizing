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
% eeglab; close all; clear; cl
% --Data preparation
data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';

% Choose the subjects who are goning to be analyzed
% choose_sub = [1:20];
choose_sub = [1:20];

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
%       mat2set    Filtering    SessionDividing     ICA_component_calculation EOG_coh_remove    ECG_coh_remove     Epoching
%       CalPSD
flag = [1           1           1                   1                         0                 0                  0 ...
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
if flag(4) == 1
    clear set_list;
    disp('--------------------  ICA Calculation  --------------------')
    for sub_i = 1 : length(f)
%         set_list(1:2) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_base.set']);  
%         set_list(3:4) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_stim.set']);
%         set_list(5:6) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_reco.set']);
        set_list(1:2) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_base1.set']);
        set_list(3:4) = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_reco1.set']);

        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            EEGset = ICA_Component_Extraction(set_list(set_num), 'save', 1);
        end
    end
end



%% Component&EOG correlation
if flag(5) ==1
    disp('--------------------  ICA&EOG correlation  --------------------')
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_ICA.set']);
        eog_list = dir([eog_f(sub_i).folder, '\', f(sub_i).name, '\*.mat']);

        % 적절한 eog파일만 저장
        for j = 1:length(set_list)
            for k = 1:length(eog_list)      % !수정할 방법 나중에 생각하기
                if(contains(set_list(j).name, erase(eog_list(k).name, '.mat')))
                    set_list(j).eog_name = eog_list(k).name;
                    set_list(j).eog_folder = eog_list(k).folder;
                end
            end
        end

        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            EEGset = ICA_Correlation(set_list(set_num), 'save', 1, 'plot', 0, 'EOG', 1);
        end
    end
end

%% Remove the highest corr comp
if flag(5) == 1
    disp('--------------------Remove component--------------------')
    result = [];
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corrEOG.set']);
            disp([f(sub_i).name]);
            for set_num = 1 : length(set_list)
                result = [result remove_components(set_list(set_num), 'save', 1, 'user', 1, 'remove', 2)];
            end
    end
    writematrix(result, 'Data_check_result.txt', 'Delimiter', ' ');
end
        

%% Component&ECG correlation
if flag(6) ==1
    disp('--------------------  ICA&ECG correlation  --------------------')
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_rmEOG.set']);
        ecg_list = dir([eog_f(sub_i).folder, '\', f(sub_i).name, '\*.mat']);

        % 적절한 ecg파일만 저장
        for j = 1:length(set_list)
            for k = 1:length(ecg_list)      % !수정할 방법 나중에 생각하기
                if(contains(set_list(j).name, erase(ecg_list(k).name, '.mat')))
                    set_list(j).ecg_name = ecg_list(k).name;
                    set_list(j).ecg_folder = ecg_list(k).folder;
                end
            end
        end

        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            EEGset = ICA_Correlation(set_list(set_num), 'save', 1, 'plot', 0);
        end
    end
end

%% Remove the highest corr comp
if flag(6) == 1
    result = [];
    disp('--------------------Remove component--------------------')
    for sub_i = 1 : length(f)
            set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corrECG.set']);
            disp([f(sub_i).name]);

            for set_num = 1 : length(set_list)
                result = [result remove_components(set_list(set_num),'remove', 1, 'save', 1, 'user', 1, 'ECG', 1)];
            end
            writematrix(result, 'Data_check_result_ECG.txt', 'Delimiter', ' ');
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
if flag(7) == 1
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

if flag(8) == 1
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


