

EOG_txt = './Data_check_result.txt';
ECG_txt = 'Data_check_result_ECG';

fid = fopen(EOG_txt, 'r');

disp(fid)

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

choose_sub = [19:20];

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

i=73;
exception = [];
disp(number_array);
%% Remove EOG
for sub_i = 1 : length(f)
    set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*corrEOG.set']);
    
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
        elseif number_array(i) == 1             %EOG 1만 지움
            [~, index] = maxk(EEGset.correlations, 1, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset.icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmEOG.set']);
    
        elseif number_array(i) == 2             %EOG 2만 지움  
            [~, index_1] = maxk(EEGset.correlations2, 1, 'ComparisonMethod', 'abs');
            EEGset = pop_subcomp(EEGset, index_1, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset.icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmEOG.set']);
    
        elseif number_array(i) == 3             %EOG 1, 2 지움
            [~, index] = maxk(EEGset.correlations, 1, 'ComparisonMethod', 'abs');
            [~, index_1] = maxk(EEGset.correlations2, 1, 'ComparisonMethod', 'abs');
            index = [index index_1];
            index = unique(index);
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset.icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmEOG.set']);
        elseif number_array(i) == 4             %그대로 저장
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmEOG.set']);
        elseif number_array(i) == 5
            [~, index] = maxk(EEGset.correlations, 2, 'ComparisonMethod', 'abs');
            [~, index_1] = maxk(EEGset.correlations2, 1, 'ComparisonMethod', 'abs');
            index = [index' index_1];
            index = unique(index);
            EEGset = pop_subcomp(EEGset, index, 1); 
            tmpdata = eeg_getdatact(EEGset, 'component', [1:size(EEGset.icaweights, 1)]);
            EEGset.compoactivity = tmpdata;
            pop_saveset(EEGset, [set_list(mat_i).folder, '\', set_list(mat_i).name(1:end-4), '_rmEOG.set']);
        else
            disp('Error');
            return;
    
        end
        i = i+1;
    end
end


writematrix(exception, 'exception.txt', 'Delimiter', ' ');


% Remove ECG

