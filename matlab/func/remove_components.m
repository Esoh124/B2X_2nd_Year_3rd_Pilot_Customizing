function [EEGset, newEEGset] = remove_components(set_list, varargin)
    % EOG&component correlation으로 구한 component 결과를 적용하여,
    % artifact-related component를 제거
    
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end

    if sum(strcmp(varargin, 'remove')) ~= 0
        rm = varargin{circshift(strcmp(varargin, 'remove'), 1)};
    else
        rm = 0;
    end
    
    EEGset= pop_loadset([set_list.folder, '\', set_list.name]);             %data load
    
    [~, index]= maxk(EEGset.correlations, rm, 'ComparisonMethod','abs');    %가장 높은 coh의 rm개의 index 뽑기
    disp(index);
    
    newEEGset = pop_subcomp(EEGset, index, 1);                              % 제거
    

    if sf == 1
        newEEGset = pop_saveset(newEEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
    end

end