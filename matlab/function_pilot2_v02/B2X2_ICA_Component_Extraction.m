% B2X2_ICA_Component_Extraction

function EEGset = B2X2_ICA_Component_Extraction(se_list, sf)
    % pop_runica를 이용하여 ICA component를 계산한다
    % 구한 ICA component를 기존 EEGset에 추가한다
    
    % input
    %    1. se_list : EEGset 폴더의 session_dividing이 완료된 파일을 읽고, 그 중 하나의 파일에
    %    대한 dir을 입력 ex) se_list(se_num)
    
    fprintf("%s_%s run ICA ", se_list.name(1:5), se_list.name(end-7: end-4));
    
    EEGset = pop_loadset([se_list.folder, '\', se_list.name]);
    EEGset = pop_runica(EEGset, 'icatype', 'runica'); fprintf("\b\b\b");
    if sf == 1
        fprintf("saving: %s_ICA.set... ", se_list.name(1:end-4));
        pop_saveset(EEGset, [se_list.folder, '\', se_list.name(1:end-4), '_ICA.set']);
        fprintf('done!\n')
    end
    
    % 명령창이 지저분 해져서, pop_runica.m, runica.m, eeg_checkset.m에 주석처리 진행
    % pop_runica : 423 458 472
    % runica : line 623 624 627 629 632 642 643 644 645 649 650 653 655 657
    % ...    665 678 684 764 767 772 835 1016 1017 1140 1142 1509 1510 1511
    % 1518 1526
    % eeg_checkset : 974, 962
end