% B2X2_EEG_pilot_v02


% 1. Filtering --> Sessiong Dividing
% 2. Re-referencing by M2 (stim) 
%    --> ICA: reject stimulation-related components, manually
%    --> after reject, re-reference by Cz so that back to original channels
% 3. ICA: reject eye-blinking-related components, manually
%    - use Cz-referenced channels, including M1, M2
% 4. re-referencing by M1, M2
%    - F3-M2, Fz-Cz, F4-M1, C3-M2, Cz-Oz, C4-M1, O1-M2, Oz-Cz, O2-M1

clear; close all; clc;
%% Default Setting ==================================================================================================================
addpath 'G:\내 드라이브\2021\0_Lab\2. Task\3. B2X\MATLAB\EEG_pre_CYS\function_pilot2_v02'
addpath 'G:\내 드라이브\2021\0_Lab\2. Task\3. B2X\MATLAB\EEG_pre_CYS\eeglab2021.1'
% eeglab; close all; clear; clc

default_path = 'C:\Users\CYS\Desktop\2차 Pilot EEG';
% choose_sub = [1,2,4,5];
choose_sub = [5];
choose_sub = [1,2,4,5];

f = dir(default_path);
f = f(3:sum([f.isdir]));
if sum(choose_sub) > 0
    f = f(choose_sub);
end

fprintf('Selected Subjects: ');
for set_num = 1 : length(f)
    fprintf('%s ', f(set_num).name);
end
disp(' ');

%      Channel Shift      mat2set           Filtering         Session Dividing   
%      Re-ref&ICA(stim)   Reref             ICA               ICA removal
%      Epoching           Manual Inspection Spectral Analysis Show Powers
flag=[ 0                  0                 0                 0 ...
       0                  0                 0                 0 ...
       0                  0                 0                 0];
% flag(1:7) = 1;
% flag(8:10)=1;
% flag(10:12) = 1;
% flag(10) = 1;
% flag(8:11) = 1;
flag(12) = 1;

%% ChannelShift ======================================================================================================================
% shift channel array for one space to the right
% Before: M2 F3 F4 C3 Fz C4 O1 Oz O2 M1
% After: M1 M2 F3 F4 C3 Fz C4 O1 Oz O2

warning('off')
if flag(1) == 1
    disp('--------------------CHANNEL SHIFT--------------------')
    for sub_iter = 1 : length(f)
        % EEG 폴더 안의 모든 .mat 파일 list 반환
        mat_list = dir([f(sub_iter).folder '\' f(sub_iter).name '\EEG\*min.mat']); 
        disp([f(sub_iter).name]);
        for mat_iter = 1 : length(mat_list) % mat 파일의 개수 만큼 반복
           mat = load([mat_list(mat_iter).folder, '\', mat_list(mat_iter).name]).eeg;
           fprintf("%dth file... number of channels: %d \n", mat_iter, size(mat,2));
           eeg = circshift(mat, 1, 2); % column을 한 칸씩 오른쪽으로 이동

           mkdir([mat_list(mat_iter).folder, '\', 'original_mat']); % 기존 mat 파일을 저장할 폴더 생성
           com1 = sprintf("save([mat_list(mat_iter).folder, '\\', 'original_mat\\', '%s'], 'mat');", mat_list(mat_iter).name);
           eval(com1); % 기존 파일을 'original_mat' 폴더에 저장

           com2 = sprintf("save([mat_list(mat_iter).folder, '\\', '%s_ChShift'], 'eeg')", mat_list(mat_iter).name(1:end-4));
           eval(com2); % shift된 데이터를 기존 파일에 덮어씀
        end
    end
end
warning('on')


%% ma2set ============================================================================================================================
warning('off')
if flag(2) == 1
    disp('--------------------   MAT2SET   --------------------')
    for sub_iter = 1 : length(f)
        mat_list = dir([f(sub_iter).folder '\' f(sub_iter).name '\EEG\*_ChShift.mat']); % EEG 폴더 안의 모든 .mat 파일 list 반환
        srate = 512;

        disp([f(sub_iter).name]);
        for set_num = 1 : length(mat_list)
            EEGset = B2X2_mat2set_v02(f(sub_iter), mat_list(set_num), srate, 1);
        end
    end
end
warning('on')

%% Filtering ==========================================================================================================================
if flag(3) == 1
    disp('--------------------  FILTERING  --------------------')
    for sub_iter = 1 : length(f)
        set_list = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*min.set']);

        disp([f(sub_iter).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_Filtering_v02(set_list(set_num), 1);
        end
    end
end

%% SESSION DIVIDING ===================================================================================================================
if flag(4) == 1
    disp('--------------------SESSION DIVIDING--------------------')
    for sub_iter = 1 : length(f)
        set_list = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_Filt.set']);

        disp([f(sub_iter).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_SessionDividing_v03(f(sub_iter), set_list(set_num), 1);
        end
    end
end

%% Re-refer and ICA STIM ===================================================================================================================
% Before: Cz referenced
% After: M2 referenced (M1-M2, M2-Cz, F3-M2, Fz-M2, F4-M2, C3-M2, Cz-M2, C4-M2, O1-M2, Oz-M2, O2-M2)
flag(5) = 0;
if flag(5) == 1
    disp('--------------------STIM: Re-ref & ICA--------------------')
    for sub_iter = 1 : length(f)
        set_list = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_stim.set']);

        disp([f(sub_iter).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_stim_reref_M2_ICA(f(sub_iter), set_list(set_num), 1);
        end
    end
end

%% Re-ref (M1, M2)
% Before: Cz referenced
% After: M1, M2 referenced (F3-M2, Fz-Cz, F4-M1, C3-M2, Cz-Oz, C4-M1, O1-M2, Oz-Cz, O2-M1)
if flag(6) == 1
    disp('--------------------  Re-referencing  --------------------')
    for sub_iter = 1 : length(f)
        set_list(1:2) = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_base.set']);
        set_list(3:4) = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_stim.set']);
        set_list(5:6) = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_reco.set']);

        disp([f(sub_iter).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_ChPreparation_v03(f(sub_iter), set_list(set_num), 1);
        end
    end
end


%% ICA Calculation
if flag(7) == 1
    disp('--------------------  ICA Calculation  --------------------')
    for sub_iter = 1 : length(f)
        set_list = dir([f(sub_iter).folder, '\', f(sub_iter).name, '\EEG\EEGset\*_Reref.set']);

        disp([f(sub_iter).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_ICA_Component_Extraction(set_list(set_num), 1);
        end
    end
end

%% ICA removal
% pilot study2는 EOG를 측정하지 않음
% 채널 수가 적어서 ICA에 적합하지 않으며, EEG 만으로 eye blinking을 특정하기 어려움
% 따라서, pilot study2에서는 동잡음만 MI로 제거하고, ICA를 통한 잡음제거는 진행하지 않는다
if flag(8) == 1
   
    ICA_flag = input("Enter 1 if you complete the ICA removal or any key if not: ");
    if ICA_flag == 1
        fprintf("Eye blinking removal done, manually ...! \n")
    else
        fprintf("Go back and try after eye blinking removal \n")
        return
    end
end

%% Epoching
if flag(9) == 1
    disp('--------------------------EPOCHING------------------------')
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);

        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEG\EEGset\*_rmICA*.set']);
        
        % 이미 epoch이 있으면, 해당 파일을 덮어 씌움
        num_temp = 1;
        for i = 1 : length(set_list)
            if ~contains(set_list(i).name, 'epoch')
                temp_list(num_temp) = set_list(i);
                num_temp = num_temp + 1;
            end
        end
        set_list = temp_list;
           
        for set_num = 1 : length(set_list)
            EEGset = B2X2_Epoching(set_list(set_num), 1);
        end
    end
end

%% Manual Inspection
% 눈으로 직접 보고, 노이즈 구간 제거하기
% save: *_MI.set

if flag(10) == 1
    disp('--------------------------MANUAL INSPECTION------------------------')
    for sub_num = 1 : length(f)
        EXCEL_PATH = dir([f(sub_num).folder, '\', f(sub_num).name, '\', '*.xlsx', ]);
        [num, text, raw] = xlsread([EXCEL_PATH.folder, '\', EXCEL_PATH.name],4, 'A:E');
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEG\EEGset\*_epoch.set']);
        
        disp([f(sub_num).name]);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_ManualInspection(set_list(set_num), 1, raw);
        end
    end
end

%% Spectral Analysis
% artifact를 포함하는 epoch을 제외한 나머지 epoch들을 이용
% 각 epoch에 대한 PSD, band power(gamma, beta, alpha, theta, delta)를 구하여
% EEGset에 저장

if flag(11) == 1
    disp('--------------------------SPECTRAL ANALYSIS------------------------')
    for sub_num = 1 : length(f)
        disp([f(sub_num).name]);
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEG\EEGset\*_rmARTI.set']);
        for set_num = 1 : length(set_list)
            EEGset = B2X2_EEG_CalPSD_v02(set_list(set_num), 1);
        end
    end
end

%% Show Powers

if flag(12) == 1
    disp('--------------------------SHOW POWERS------------------------')
    [powers, powers_ratio] = B2X2_EEG_ShowPowers_v04(f, 1);
    [norm_powers, norm_powers_ratio] = B2X2_EEG_ShowNormPowers_v03(f, 1);
end