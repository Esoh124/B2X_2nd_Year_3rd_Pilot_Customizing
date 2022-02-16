% B2X2_SessionDividing
function EEGset = B2X2_SessionDividing_v03(f, f_list, sf)
    % 하나의 EEGset을 로드하여, data를 추출한다
    % 추출한 데이터를 기반으로 base, stim, reco의 시간 index를 구한다
    % 각 session의 index를 적용하여, data를 3개의 session data로 나눈다
    % pop_importdata를 이용하여, 각 data를 기반으로 EEGset을 생성한다
    % 생성한 EEGset은, pop_saveset을 이용하여, 파일 이름 마지막에 session
    % 이름을 추가하여 저장한다
    
    % input
    %   1. f: dir(subject folder) --> f(sub_num)으로 입력 받음
    %   2. f_list: EEGset 폴더의 *_Filt.set 파일에 대한 dir 값 -->
    %   f_list(stim_num)으로 입력 받음
    %   3. sf : saveflag
    
    fprintf("%s Session dividing...", f_list.name(1:5));
    EEGset = pop_loadset([f_list.folder, '\', f_list.name]); % data load
    data = EEGset.data;
    stim_min = CalStimMin(EEGset.pnts, EEGset.srate);
    [base_i, stim_i, reco_i] = FindSessionIdx5S5(data, stim_min, EEGset.srate);
    
    params.subject = f.name;
    params.chanlocs = [f.folder, '\', 'chanlocs_addCz.loc'];
    params.nbchan = 11;
    params.srate = EEGset.srate;
    
    base_set = CreateSessionSet(f_list, data(:, base_i), 'base', params);
    fprintf("  base %2.1f min", length(base_i)/EEGset.srate/60); 
    stim_set = CreateSessionSet(f_list, data(:, stim_i), 'stim', params);
    fprintf("  stim %2.1f min", length(stim_i)/EEGset.srate/60); 
    reco_set = CreateSessionSet(f_list, data(:, reco_i), 'reco', params);
    fprintf("  reco %2.1f min\n", length(reco_i)/EEGset.srate/60);

    EEGset = reco_set; % 출력용

    if sf == 1
        fprintf("saving...\n");
        pop_saveset(base_set, [f_list.folder, '\', f_list.name(1:end-4), '_base.set']);
        pop_saveset(stim_set, [f_list.folder, '\', f_list.name(1:end-4), '_stim.set']);
        pop_saveset(reco_set, [f_list.folder, '\', f_list.name(1:end-4), '_reco.set']);
    end
end

function SESSION_SET = CreateSessionSet(f_list, session_data, session_str, params)
    setname = [f_list.name(1:5), '_', session_str];

    SESSION_SET = pop_importdata('setname', setname, 'data', session_data, ...
        'dataformat', 'array', 'subject', params.subject, ...
        'chanlocs', params.chanlocs, 'nbchan', params.nbchan, ...
        'srate', params.srate);
end

function [base_i, stim_i, reco_i] = FindSessionIdx5S5(eeg, stim_min, fs)
    % base : 6분, stim : stim_min+1 분, reco : 6분
    % reco : stim 구간이 포함될 수 있기 때문에, 처음 5초 미포함
    % 5S5 : 6분 + Stimulation + 5분 55초
    
    t = 0 : 1/fs : (length(eeg)-1)/fs;
    
    base1=0; base2=6*60;
    base_i(1)=1; [val, base_i(2)] = find(t==base2);
    base_i = base_i(1):base_i(2);
    
    stim_i(1)=base_i(end)+1;
    stim2=60*(6+stim_min+1);
    [val, stim_i(2)] = find(t==stim2);
    stim_i = stim_i(1):stim_i(2);
    
    reco_i(1)=stim_i(end)+fs*5;
    reco_i(2)=length(t);
    reco_i = reco_i(1):reco_i(2);
end

function stim_min = CalStimMin(pnts, fs)
    total_min = pnts/fs/60; % 전체 시간 [min]
    if round(total_min) == 18
        stim_min = 5;
    elseif round(total_min) == 23
        stim_min = 10;
    end
end