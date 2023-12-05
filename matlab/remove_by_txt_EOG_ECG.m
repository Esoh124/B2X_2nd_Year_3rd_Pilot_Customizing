function [] = remove_by_txt_EOG_ECG(EOG_txt, ECG_txt)
    
    EOG_txt = 'Data_check_result';
    ECG_txt = 'Data_check_result_ECG';

    fid = fopen(file_path, 'r');

    number_Array = [];

    data = textscan(fid, '%f');
    fclose(fid);

    number_Array = data{1};
 
    %% Load data

    addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
    addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
    addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
    eeglab;
    close all;
    
    data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
    eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';

    % Choose the subjects who are going to be analyzed

    choose_sub = [1:20];

    f = dir(data_path);
    f = f(3:sum([f.isdir]));

    if sum(choose_sub)>0
        f = f(choose_sub);
    end

    i=1;
    % EOG에서 0인 사람 exception.txt에 저장 나머지는 command에 맞게 저장
    % 0이 있다면 exception.txt에 subject 저장
    % 1이라면 EOG vertical의 top 1만 제거
    % 2라면 EOG horizontal의 top 1만 제거
    % 3이라면 verti, hori의 각 top 1 제거
    % 4라면 그냥 그대로 저장
    % 5라면 특별 케이스 vert 2개 hori 1개 제거
    
    

    
end