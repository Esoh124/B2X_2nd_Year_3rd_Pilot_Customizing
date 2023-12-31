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
exception_path = "./exception.txt";
% Choose the subjects who are goning to be analyzed
% choose_sub = [1:20];
choose_sub = [1:20];

fid = fopen(exception_path, 'r');
data = textscan(fid, '%f');
fclose(fid);
number_array = data{1};
choose_sub(number_array) = [];

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
%       CalPSD     Change
flag = [0           0           0                   0                         0                 0                  0 ...
        0           1];
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
    disp('--------------------SESSIO N DIVIDING--------------------')
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
    result1 = [];
    for sub_i = 1 : length(f)
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corrEOG.set']);
        
        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            remove = [];
            [tmp1, index] = EOG_remove(set_list(set_num), 'save', 0, 'remove', 2);
            [tmp, index2] = EOG_remove(set_list(set_num), 'save', 0, 'remove', 2, 'try', 1);
            result1 = [result1 tmp1];%각 파일 command 저장
            result = [result tmp];
            remove = [index index2];
            remove = unique(remove);
            disp('Final remove components');
            disp(remove);
            EEGset= pop_loadset([set_list(set_num).folder, '\', set_list(set_num).name]);
            EEGset_1 = pop_subcomp(EEGset, remove, 1);% 위 결과에 따라 전체 remove
            figure;
            subplot(2, 1, 1);
            plot(EEGset.data(26, :));
            subtitle('raw');
            xlim([1,10*512]);
            subplot(2, 1, 2);
            plot(EEGset_1.data(26, :));
            subtitle('remove result');
            xlim([1,10*512]);

            %결과 저장
            tmpdata = eeg_getdatact(EEGset_1, 'component', [1:size(EEGset_1.icaweights, 1)]);
            EEGset_1.compoactivity = tmpdata;
            pop_saveset(EEGset_1, [set_list(set_num).folder, '\', set_list(set_num).name(1:end-4), '_rmEOG.set']);
        end
    end
    writematrix(result1, 'Data_check_result1.txt', 'Delimiter', ' ');
    writematrix(result, 'Data_check_result2.txt', 'Delimiter', ' ');
    

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

%% Epoching
if flag(7) == 1
    disp('--------------------------EPOCHING------------------------')
    h1 = waitbar(0,'Epoching --> Whole subject processing...');
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);

        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEGset\*_rmECG.set']);
        h2 = waitbar(0, [f(sub_num).name(1:2) '\_' f(sub_num).name(4:end) ' ...']);
               
        for set_num = 1 : length(set_list)
            EEGset = Epoching(set_list(set_num), 'save', 1);
            waitbar(set_num / length(set_list), h2);
        end
        close(h2);
        waitbar(round(sub_num / length(f)), h1, sprintf('%s %d %%', 'Epoching --> Whole subject processing...', sub_num / length(f)*100));
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


%% Change rate

if flag(9) == 1
    disp('-------------------------- CHANGE ------------------------');
    Change = struct();
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEGset\*_PSD.set']);
        n020_list = [];
        s0_list = [];
   
        for set_num = 1 : length(set_list)
            if(contains(set_list(set_num).name, 'N020'))
                n020_list = [n020_list, set_list(set_num)];
            elseif(contains(set_list(set_num).name, 'S0'))
                s0_list = [s0_list, set_list(set_num)];
            else
                break;
            end
        end
        Change = setfield(Change, genvarname(f(sub_num).name), 'S0', change(s0_list, 'save', 1));
        Change = setfield(Change, genvarname((f(sub_num).name)), 'N020', change(n020_list, 'save', 1));

    end
    save('Change.mat', "Change");
end

%% K-means





