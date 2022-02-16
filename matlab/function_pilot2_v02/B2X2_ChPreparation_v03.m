function EEGset = B2X2_ChPreparation_v03(f, f_list, sf)
    % Preparation of Channel Set
    % Divied all channels of EEG into each channel set and Re-referecning with the
    % designated channel for each channel
    
    %   1. Channel Selection using pop_select
    %   2. Re-referencing using pop_reref
    %   3. 2로부터 얻은 EEGset에서 데이터만 추출 
    %      --> 모든 채널에 대해 진행: F3, Fz, F4, C3, (Cz), C4, O1, Oz, O2, M1, M2
    %   4. 모든 채널의 데이터를 하나의 배열로 통합 (10 column을 가지는 배열이 생성됨)
    %   5. 새로 만들어진 data를 원래 EEGset의 data로 대체한다.
    
    % input 
    % 1. f : subject_folder에서의 dir 값을 얻고, f(sub_num)을 한 결과
    % 2. f_list : EEGset folder에서의 dir 값을 얻고, f(stim_num)을 한 결과
    % 2. sf : saveflag (save EEGset when sf=1)

    % 수면 분석에 중요한 channel pairs
    % set1 : F4 M1, C4 M1, O2 M1 --> reref by 'M1'
    % set2 : F3 M2, C3 M2, O1 M2 --> reref by 'M2'
    % set3 : Fz, Oz --> reref by 'Cz' (already done so no need to reref)
    % set4 : Cz --> reref by 'Oz' (Oz가 Cz를 reference로 측정되었으므로, 
    %                              Oz의 부호를 반대로 하여 Cz를 얻는다)
    
    fprintf(" EEGset ChPreparation... %s\n", f_list.name(1:5));
    
    chs = {'F3', 'Fz', 'F4', 'C3', 'Cz', 'C4', 'O1', 'Oz', 'O2'};
    new_data = []; % re-referencing 된 각 채널의 데이터를 통합하는 배열
    EEGset = pop_loadset([f_list.folder, '\', f_list.name]);
    
    for ch_num = 1 : length(chs)
        re_refered_ch_set = SelectAndRerefer(EEGset, chs{ch_num});
        new_data = [new_data; re_refered_ch_set.data];
    end

    setname = f_list.name(1:5);
    data = new_data;
    dataformat = 'array';
    subject = f.name;
    chanlocs = [f.folder, '\', 're_chanlocs.loc'];
    nbchan = 9;
    srate = EEGset.srate;
    
    EEGset = pop_importdata('setname', setname, 'data', data, ...
        'dataformat', dataformat, 'subject', subject, ...
        'chanlocs', chanlocs, 'nbchan', nbchan, 'srate', srate);
    
    if sf == 1
        pop_saveset(EEGset, [f_list.folder, '\', f_list.name(1:end-4), '_Reref']);
        fprintf(" saving... %s\n", [f_list.name(1:end-4), '_Reref']);
    end
    
end

function re_refered_ch_set = SelectAndRerefer(EEGSET, ch)
    if sum(contains({'F4', 'C4', 'O2'}, ch))
        ref_ch = 'M1';
        temp_ch = pop_select(EEGSET, 'channel', {ch, ref_ch});
        temp_ch = pop_reref(temp_ch, ref_ch);
    elseif sum(contains({'F3', 'C3', 'O1'}, ch))
        ref_ch = 'M2';
        temp_ch = pop_select(EEGSET, 'channel', {ch, ref_ch});
        temp_ch = pop_reref(temp_ch, ref_ch);
    elseif sum(contains({'Fz', 'Oz'}, ch)) % Fz와 Oz는 측정할 때, Cz를 reference로 함
        temp_ch = pop_select(EEGSET, 'channel', {ch});
    else % Oz-Cz --> Cz-Oz
        temp_ch = pop_select(EEGSET, 'channel', {'Oz'});
        temp_ch.data = -temp_ch.data;
    end
    
    re_refered_ch_set = temp_ch;
end
