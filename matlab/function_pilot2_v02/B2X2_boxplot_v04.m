% boxplot of pilot2
% power band의 변화율 이용
% boxplot + scatter 
% channel groups

clear; close all; clc;

f_bands = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
chs = {'F3', 'Fz', 'F4', 'C3', 'Cz', 'C4', 'O1', 'Oz', 'O2'};
color = {'r', 'g', 'b', 'c', 'm', 'y', 'k', 'w'};

% powers_ratio.mat 파일 로드
MAT = load(['C:\Users\CYS\Desktop\2차 Pilot EEG\powers_norm_ratio.mat']);
data = MAT.norm_powers_ratio;

%% step 1. 5min stimulation

% plotting에 사용할 배열 선언
total=[]; frontal=[]; central=[]; occipital=[];

for band_iter = 1 : length(f_bands)
    % band_iter에 의거한 band data 추출
    band_data = data(band_iter:10:40, :);

    total = band_data;
    frontal = band_data(:, 1:3);
    central = band_data(:, 4:6);
    occipital = band_data(:, 7:9);

    % array2vector for plotting, using 'reshape'
    t = reshape(total', [NumberOfData(total), 1]);
    f = reshape(frontal', [NumberOfData(frontal), 1]);
    c = reshape(central', [NumberOfData(central), 1]);
    o = reshape(occipital', [NumberOfData(occipital), 1]);
    
    % plotting
    pos1 = [0.2 0.1 0.1 0.8];
    pos2 = [0.4 0.1 0.5 0.8];

    fh = figure;
    % a. scatter 
    for sub_iter = 1 : 4 % number of the subjects
        if sub_iter == 2
            % subject_2는 5min 데이터 사용 x
            continue; 
        end

        % total scatter
        subplot('Position', pos1);
        scatter(ones(1, length(t(9*sub_iter-8:9*sub_iter))), t(9*sub_iter-8:9*sub_iter), color{sub_iter}); hold on;
        
        % channel groups scatter
        subplot('Position', pos2);
        scatter([ones(length(f(3*sub_iter-2:3*sub_iter)),1), 2*ones(length(f(3*sub_iter-2:3*sub_iter)),1), 3*ones(length(f(3*sub_iter-2:3*sub_iter)),1)], ...
            [f(3*sub_iter-2:3*sub_iter), c(3*sub_iter-2:3*sub_iter), o(3*sub_iter-2:3*sub_iter)], color{sub_iter}); hold on;
    end

    % b. boxplot
    % total boxplot
    subplot('Position', pos1);
    boxplot(t, 'Labels', {'Total'}); hold on;
    yline(0, '--');

    % channel groups boxplot
    subplot('Position', pos2);
    boxplot([f, c, o], 'Labels', {'Frontal', 'Central', 'Occipital'}); hold on;
    yline(0, '--');

    sgtitle(['5min stim: ' f_bands{band_iter}], 'FontSize', 30);
    
    legend({'1','','','2','','','3','',''});
    fh.WindowState = 'maximized';
end


%% step 2. 10 min stimulation

% plotting에 사용할 배열 선언
total=[]; frontal=[]; central=[]; occipital=[];

for band_iter = 1 : length(f_bands)
    % band_iter에 의거한 band data 추출
    band_data = data(band_iter+5:10:40, :);

    total = band_data;
    frontal = band_data(:, 1:3);
    central = band_data(:, 4:6);
    occipital = band_data(:, 7:9);

    % array2vector for plotting, using 'reshape'
    t = reshape(total', [NumberOfData(total), 1]);
    f = reshape(frontal', [NumberOfData(frontal), 1]);
    c = reshape(central', [NumberOfData(central), 1]);
    o = reshape(occipital', [NumberOfData(occipital), 1]);
    
    % plotting
    pos1 = [0.2 0.1 0.1 0.8];
    pos2 = [0.4 0.1 0.5 0.8];

    fh = figure;
    % a. scatter 
    for sub_iter = 1 : 4 % number of the subjects
        % total scatter
        subplot('Position', pos1);
        scatter(ones(1, length(t(9*sub_iter-8:9*sub_iter))), t(9*sub_iter-8:9*sub_iter), color{sub_iter}); hold on;
        
        % channel groups scatter
        subplot('Position', pos2);
        scatter([ones(length(f(3*sub_iter-2:3*sub_iter)),1), 2*ones(length(f(3*sub_iter-2:3*sub_iter)),1), 3*ones(length(f(3*sub_iter-2:3*sub_iter)),1)], ...
            [f(3*sub_iter-2:3*sub_iter), c(3*sub_iter-2:3*sub_iter), o(3*sub_iter-2:3*sub_iter)], color{sub_iter}); hold on;
    end

    % b. boxplot
    % total boxplot
    subplot('Position', pos1);
    boxplot(t, 'Labels', {'Total'}); hold on;
    yline(0, '--');

    % channel groups boxplot
    subplot('Position', pos2);
    boxplot([f, c, o], 'Labels', {'Frontal', 'Central', 'Occipital'}); hold on;
    yline(0, '--');

    sgtitle(['10min stim: ' f_bands{band_iter}], 'FontSize', 30);
    
    legend({'1','','','2','','','3','','','4','',''});
    fh.WindowState = 'maximized';
end

function number_of_datas = NumberOfData(array)
    number_of_datas = size(array, 1) * size(array, 2);
end
