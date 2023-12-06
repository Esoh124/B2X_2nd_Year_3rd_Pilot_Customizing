ECG_txt = './Data_check_result_ECG.txt';

fid = fopen(ECG_txt, 'r');

disp(fid)
number_array = [];

data = textscan(fid, '%f');
fclose(fid);

number_array = data{1};

%% Load data

addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;

data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';

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
% 1이라면 ECG 의 top 1만 제거
% 2라면 그냥 그대로 저장

exception = [];
disp(number_array);
%% Remove EOG
for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*corrECG.set']);
    
    disp(f(sub_i).name);
    for mat_i = 1 : length(set_list)
        disp([set_list(mat_i).name]);
        disp(number_array(i));
        EEGset= pop_loadset([set_list(mat_i).folder, '\', set_list(mat_i).name]);
        if number_array(i) == 0                 %데이터 지움
            disp('Delete data');
            exception = [exception f(sub_i).name];
            i = i+ (4 - mat_i)+1;
            break;
        elseif number_array(i) == 1             %ECG 1만 지움
            [~, index] = maxk(EEGset.correlations_ecg, 1, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset.icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmECG.set']);
    
        elseif number_array(i) == 2             %그대로
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmECG.set']);

        else
            disp('Error');
            return;
    
        end
        i = i+1;
    end
end


writematrix(exception, 'exception2.txt', 'Delimiter', ' ');


% Remove ECG

