function [EEGset, newEEGset] = remove_components(set_list, varargin)
    % EOG&component correlation으로 구한 component 결과를 적용하여,
    % artifact-related component를 제거
    
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end
    
    EEGset= pop_loadset([set_list.folder, '\', set_list.name]);
    
    [~, rejcomp]=max(EEGset.correlations); % rejcomp - 삭제할 component의 index
    [~, index]= maxk(EEGset.correlations, 1, 'ComparisonMethod','abs');
    disp(index);
    newEEGset = pop_subcomp(EEGset, index, 1);% 제거
    

    if sf == 1
        newEEGset = pop_saveset(newEEGset, [set_list.folder, '\', set_list.name(1:end-4), '_rmEOG.set']);
    end

end