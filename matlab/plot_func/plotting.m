function [] = plotting(g_name, box_label, band_name, data1, data2, varargin)
  
    if sum(strcmp(varargin, 'norm')) == 1
        norm_flag = varargin{circshift(strcmp(varargin, 'norm'),1)};
    else
        norm_flag = 0;
    end
%     line([ones(length(data1), 1), 2*ones(length(data2),1)]', [data1', data2']'); hold on;
    % scatter([ones(length(data1), 1), 2*ones(length(data2),1)], [data1', data2']); hold on;
    h1 = boxplot([data1'; data2'], [ones(length(data1),1); 2*ones(length(data2),1)], 'Labels', box_label); hold on;
    
    % boxplot_modification(h1, data1, data2);
    yline(0, '--', 'Color', 'r', 'LineWidth', 2);
    set(gca, 'fontsize', 15);

    if norm_flag == 0
        title([g_name, '\_', band_name], 'FontSize', 15); 
    else
        title([g_name, '\_', band_name, '\_normalized'], 'FontSize', 15); 
    end
end