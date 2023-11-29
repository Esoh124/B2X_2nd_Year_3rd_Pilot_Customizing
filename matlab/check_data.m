%% init

addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\eeglab2021.1'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\func'
addpath 'C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs'

eeglab;
close all;

data_path = 'C:\Users\USER\Desktop\converted_B2X2\txt';
eog_path = 'C:\Users\USER\Desktop\B2X_data\eog_ecg_mat';

choose_sub = [1:20];

%% save dir path

f = dir(data_path);
f = f(3:sum([f.isdir]));
eog_f = dir(eog_path);
eog_f = eog_f(3:sum([eog_f.isdir]));

if sum(choose_sub) > 0
    f = f(choose_sub);
    eog_f = eog_f(choose_sub);
end


%% Check data and remove
result = [];
for i =  1:length(f)
    fprintf('Selected subject :  %s\n', f(i).name);
    set_list = dir([f(i).folder, '\', f(i).name, '\EEGset\*_corr.set']);

    for j = 1:length(set_list)
        [~, newEEGset_1] = remove_components(set_list(j), 'remove', 1,'save', 0);       % Remove 1
        [EEGset, newEEGset_2] = remove_components(set_list(j), 'remove', 2,'save', 0);  % Remove 2

        close all;
        %plotting
        figure;
        subtitle(set_list(j).name);
        subplot(4, 1, 1);
        plot(EEGset.eog);
        xlim([1,10*512]);
        title("EOG");
        subplot(4, 1, 2);
        plot(EEGset.data(26, :));
        xlim([1,10*512]);
        title('raw EEG(FP1)');
        subplot(4, 1, 3);
        plot(newEEGset_1.data(26, :));
        xlim([1,10*512]);
        title("removed 1");
        subplot(4, 1, 4);
        plot(newEEGset_2.data(26, :));
        xlim([1,10*512]);
        title("removed 2");
        
        %pop_topoplot(map plotting)
        pop_topoplot(EEGset);       %need to comment EEGLAB pop_topoplot row 92, 93, 94 and change row 90 typeplot=0

        command = input('Command : 0(delete data), 1(remove 1), 2(remove 2), 3(no need to remove)');
        result = [result command];
        if(command == 1||command == 2)
            [~, ~] = remove_components(set_list(j), 'remove', command, 'save', 1);      % Save removed EEG
        elseif (command == 3)
            [~, ~] = remove_components(set_list(j), 'remove', 0, 'save', 1);
        end
    end
end

writematrix(result, 'Data_check_result.txt', 'Delimiter', ' ');