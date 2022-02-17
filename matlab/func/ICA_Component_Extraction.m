function EEGset = ICA_Component_Extraction(set_list, varargin)
    % pop_runica를 이용하여 ICA component를 계산
    % 구한 ICA component를 기존 EEGset에 추가
    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'), 1)};
    else
        sf = 0;
    end

    EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
    EEGset = pop_runica(EEGset, 'icatype', 'runica'); fprintf("\b\b\b");

    % pop_importdata를 별도로 실행하지 않기 때문에, 아래값을 직접 변경
    EEGset.setname = [EEGset.setname, '_ICA'];

    if sf == 1
        fprintf("saving: %s_ICA.set... ", set_list.name(1:end-4));
        pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_ICA.set']);
        fprintf('done!\n')
    end
end