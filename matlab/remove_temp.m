% Remove the specific subject's session noise
%% Defualt Setting

addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'
eeglab;
close all;

data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';

choose_sub = [2];

f = dir(data_path);
f = f(3:sum([f.isdir]))

if sum(choose_sub) > 0
    f = f(choose_sub);

end


fprintf('Selected Subjects: ');
for mat_i = 1 : length(f)
    fprintf('%s ', f(mat_i).name);
end
disp(' ');

disp('--------------------Remove component--------------------')
result1 = [];
result=  [];
for sub_i = 1 : length(f)
        remove = [];
        set_list = dir([f(sub_i).folder, '\', f(sub_i).name, '\EEGset\*_corr.set']);
        
        disp([f(sub_i).name]);
        for set_num = 1 : length(set_list)
            % if set_list(set_num).name == ""
            [tmp1, index] = temp_remove(set_list(set_num), 'save', 1, 'remove', 2);
            [tmp, index2] = temp_remove(set_list(set_num), 'save', 1, 'remove', 2, 'try', 1);
            result1 = [result1 tmp1];
            result = [result tmp];
            remove = [index index2];
            remove = unique(remove);
            EEGset= pop_loadset([set_list(set_num).folder, '\', set_list(set_num).name]);
            EEGset1 = pop_subcomp(EEGset, remove, 1);
            figure;
            subplot(2, 1, 1);
            plot(EEGset.data(26, :));
            subtitle('raw');
            xlim([1,10*512]);
            subplot(2, 1, 2);
            plot(EEGset1.data(26, :));
            subtitle('remove result');
            xlim([1,10*512]);
            % end
        end
end
writematrix(result1, 'Data_check_result1.txt', 'Delimiter', ' ');
writematrix(result, 'Data_check_result2.txt', 'Delimiter', ' ');



