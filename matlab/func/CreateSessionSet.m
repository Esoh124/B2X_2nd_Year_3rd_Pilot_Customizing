function SESSION_SET = CreateSessionSet(set_list, EEGset, session_idx, session_str)
   
    % setname: 기존 파일 이름 + _session_str
    % 나머지 option은 그대로 유지하여 pop_importdata 함수에 전달
    setname = [set_list.name(1:end-4), '_', session_str];
    data = EEGset.data(:, session_idx);
    subject = EEGset.subject;
    chanlocs = EEGset.chanlocs;
    nbchan = EEGset.nbchan;
    srate = EEGset.srate;

    SESSION_SET = pop_importdata('setname', setname, 'data', data, ...
        'dataformat', 'array', 'subject', subject, 'chanlocs', chanlocs, ...
        'nbchan', nbchan, 'srate', srate);
end