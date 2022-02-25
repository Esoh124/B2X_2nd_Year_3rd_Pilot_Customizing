%% default setting
close all; clear; clc;
stim_param_sets = {'s0.mat', 'N020.mat', 'N100.mat', 'S020.mat', 'S100.mat'};
band_names = {'alpha', 'delta'};
group_names = {'frontal', 'central', 'parietal', 'occipital', 'temporal'};

%% 1. norm_X 
cd 'D:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_X'

alpha_ratio = [];
delta_ratio = [];
                                      
for stim_param_i = 1 : length(stim_param_sets) % stim_parameter 별로 반복
    load(stim_param_sets{stim_param_i});
    struct_name = stim_param_sets{stim_param_i}(1:end-4);
    com = sprintf('temp_set = %s;', struct_name);
    eval(com);
    
    temp_alpha_ratio = [];
    temp_delta_ratio = [];
    
    disp('-------------------------------------------------------------')
    for b_i = 1 : length(band_names) % alpha, delta 별로 반복    
        for g_i = 1 : length(group_names) % frontal, cetnral, parietal, occipital, temporal 데이터 합치기
            chs_base = []; 
            chs_reco = []; 
            chs_base = [getfield(temp_set, group_names{g_i}, 'base', band_names{b_i})];
            chs_reco = [getfield(temp_set, group_names{g_i}, 'reco', band_names{b_i})];

            if b_i == 1 % alpha 인 경우
                test = chs_base > chs_reco;
            else % delta 인 경우
                test = chs_base < chs_reco;
            end
            desired_num = sum(test);
            desired_ratio = desired_num / length(test) * 100;
            
            if b_i == 1
                temp_alpha_ratio = [temp_alpha_ratio, desired_ratio];
            else
                temp_delta_ratio = [temp_delta_ratio, desired_ratio];
            end

            fprintf([struct_name, ' ', group_names{g_i},'  ', band_names{b_i}, ': ', ...
                num2str(desired_num), ' of ', num2str(length(test)), ' --> ', num2str(desired_ratio),'%%\n']);
        end       
    end   
    alpha_ratio = [alpha_ratio; temp_alpha_ratio];
    delta_ratio = [delta_ratio; temp_delta_ratio];
end

% alpha
figure;
subplot(1,2,1); title('alpha reduction rate', 'FontSize', 20); hold on;
p1 = plot(alpha_ratio(1,:), '--', 'Color', 'r'); hold on;
p2 = plot(alpha_ratio(2,:)); hold on;
p3 = plot(alpha_ratio(3,:)); hold on;
p4 = plot(alpha_ratio(4,:)); hold on;
p5 = plot(alpha_ratio(5,:)); hold on;
xticks([1 2 3 4 5]);
xticklabels({'frontal', 'central', 'parietal', 'occipital', 'temporal'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',15,'FontWeight','bold')
% set(gca,'XTickLabelMode','auto')

legend([p1 p2 p3 p4 p5], {'S0', 'N020', 'N100', 'S020', 'S100'}, 'FontSize',20)
axis([0 6 30 80]);

% delta
subplot(1,2,2); title('delta increase rate', 'FontSize', 20); hold on;
p1 = plot(delta_ratio(1,:), '--', 'Color', 'r'); hold on;
p2 = plot(delta_ratio(2,:)); hold on;
p3 = plot(delta_ratio(3,:)); hold on;
p4 = plot(delta_ratio(4,:)); hold on;
p5 = plot(delta_ratio(5,:)); hold on;
xticks([1 2 3 4 5]);
xticklabels({'frontal', 'central', 'parietal', 'occipital', 'temporal'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',15,'FontWeight','bold')
% set(gca,'XTickLabelMode','auto')

legend([p1 p2 p3 p4 p5], {'S0', 'N020', 'N100', 'S020', 'S100'}, 'FontSize',20)
axis([0 6 50 90]);

%% 2. norm_O
cd 'D:\B2X\2차년도\03_pilot\CODE\matlab\extracted_data\base_stim_reco\norm_O'
alpha_ratio = [];
delta_ratio = [];

for stim_param_i = 1 : length(stim_param_sets) % stim_parameter 별로 반복
    load(stim_param_sets{stim_param_i});
    struct_name = stim_param_sets{stim_param_i}(1:end-4);
    com = sprintf('temp_set = %s;', struct_name);
    eval(com);
    
    temp_alpha_ratio = [];
    temp_delta_ratio = [];
    
    disp('-------------------------------------------------------------')
    for b_i = 1 : length(band_names) % alpha, delta 별로 반복    
        for g_i = 1 : length(group_names) % frontal, cetnral, parietal, occipital, temporal 데이터 합치기
            chs_base = []; 
            chs_reco = []; 
            chs_base = [getfield(temp_set, group_names{g_i}, 'base', band_names{b_i})];
            chs_reco = [getfield(temp_set, group_names{g_i}, 'reco', band_names{b_i})];

            if b_i == 1 % alpha 인 경우
                test = chs_base > chs_reco;
            else % delta 인 경우
                test = chs_base < chs_reco;
            end
            desired_num = sum(test);
            desired_ratio = desired_num / length(test) * 100;
            
            if b_i == 1
                temp_alpha_ratio = [temp_alpha_ratio, desired_ratio];
            else
                temp_delta_ratio = [temp_delta_ratio, desired_ratio];
            end

            fprintf([struct_name, ' ', group_names{g_i},'  ', band_names{b_i}, ': ', ...
                num2str(desired_num), ' of ', num2str(length(test)), ' --> ', num2str(desired_ratio),'%%\n']);
        end       
    end   
    alpha_ratio = [alpha_ratio; temp_alpha_ratio];
    delta_ratio = [delta_ratio; temp_delta_ratio];
end

% alpha
figure;
subplot(1,2,1); title('alpha reduction rate', 'FontSize', 20); hold on;
p1 = plot(alpha_ratio(1,:), '--', 'Color', 'r'); hold on;
p2 = plot(alpha_ratio(2,:)); hold on;
p3 = plot(alpha_ratio(3,:)); hold on;
p4 = plot(alpha_ratio(4,:)); hold on;
p5 = plot(alpha_ratio(5,:)); hold on;
xticks([1 2 3 4 5]);
xticklabels({'frontal', 'central', 'parietal', 'occipital', 'temporal'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',15,'FontWeight','bold')
% set(gca,'XTickLabelMode','auto')

legend([p1 p2 p3 p4 p5], {'S0', 'N020', 'N100', 'S020', 'S100'}, 'FontSize',15)
axis([0 6 60 90]);

% delta
subplot(1,2,2); title('delta increase rate', 'FontSize', 20); hold on;
p1 = plot(delta_ratio(1,:), '--', 'Color', 'r'); hold on;
p2 = plot(delta_ratio(2,:)); hold on;
p3 = plot(delta_ratio(3,:)); hold on;
p4 = plot(delta_ratio(4,:)); hold on;
p5 = plot(delta_ratio(5,:)); hold on;
xticks([1 2 3 4 5]);
xticklabels({'frontal', 'central', 'parietal', 'occipital', 'temporal'});
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',15,'FontWeight','bold')
% set(gca,'XTickLabelMode','auto')

legend([p1 p2 p3 p4 p5], {'S0', 'N020', 'N100', 'S020', 'S100'}, 'FontSize',15)
axis([0 6 50 90]);