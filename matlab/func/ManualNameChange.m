function [] = ManualNameChange(set_list)
    EEGset = pop_loadset([set_list.folder, '\', set_list.name]);

    % pop_importdata를 별도로 실행하지 않기 때문에, 아래값들을 직접 변경

    EEGset.setname = EEGset.setname(1:end-4);
    % EEGset.setname = [EEGset.setname, '_ICA'];
    
    sf = 1;
    if sf == 1
        fprintf("saving: %s... ", set_list.name);
        pop_saveset(EEGset, [set_list.folder, '\', set_list.name]);
        fprintf('done!\n')
    end
end