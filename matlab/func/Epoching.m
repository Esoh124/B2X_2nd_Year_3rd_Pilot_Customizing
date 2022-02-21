function EEGset = Epoching(se_list, varargin)
    
    % window 마다 overlap 비율로 중첩하여 epoching
    % EEGset.event에 각 epoch의 start와 end point 기록
    %   EEGset.event.type: 'S'(start point) or 'E'(end point) 
    %   EEGset.event.latency: start index, end index
    %   EEGset.event.urevent: latency의 index가 포함된 두 가지 epoch 중, 더 큰 index
    %   EEGset.event.epoch: epoch index
    %   ex) eeg_epoch_test\epoched_eeg.set

    % input
    %    1. se_list : EEGset 폴더의 session_dividing이 완료된 파일을 읽고, 그 중 하나의 파일에
    %    대한 dir을 입력 ex) se_list(se_num)
    %    2. sf: saveflag
    %    3. window: epoch size
    %    4. overlap: ratio of overlap (0-1)

    str_cmp = strcmp(varargin, 'window');
    if sum(str_cmp) ~= 1 % 입력 변수 중, 'window'와 일치하는 것이 없는 경우
        window = 10; % default window size : 10s
    else % 입력 변수 중, 'window'와 일치하는 것이 있는 경우
        window = varargin{circshift(str_cmp, 1)};
    end

    str_cmp = strcmp(varargin, 'overlap');
    if sum(str_cmp) ~= 1
        overlap = 0.1; % default overlap: 10%
    else 
        overlap = varargin{circshift(str_cmp, 1)};
    end

    str_cmp = strcmp(varargin, 'save');
    if sum(str_cmp) ~= 0
        sf = varargin{circshift(str_cmp, 1)};
    else
        sf = 0;
    end
    
    disp([se_list.folder, '\', se_list.name]);
    EEGset = pop_loadset([se_list.folder, '\', se_list.name]);
    
    total_length = EEGset.pnts; % 데이터 전체 길이
    fs = EEGset.srate; % sampling rate

    latency = window*fs; % 10초(window)에 해당하는 sample 개수
    overlap_latency = round(latency*overlap);
    
    % epoch 정보를 저장할 구조체 선언
    event = struct('type', [], 'latency', [], 'urevent', [], 'epoch', []); 
    event(1).type = 'S';
    event(1).latency = 1;
    event(1).urevent = 1;
    event(1).epoch = 1;

    event(2).type = 'E';
    event(2).latency = window*fs;
    event(2).urevent = 2;
    event(2).epoch = 1;

%     fprintf("\n\n%d%%", 0);
%     now_per = 0;
    iter = 1;
    while event(2*(iter-1)+2).latency + latency <= total_length
%         pause(0.00001);
%         now_per = round((2*iter+1)/total_length*100);
%         if now_per < 10
%             fprintf('\b\b');
%         elseif now_per>=10 && now_per<100
%             fprintf('\b\b\b');
%         else
%             fprintf('\b\b\b\b')
%         end
%         fprintf("%d%%", now_per);

        event(2*iter+1).type = 'S';
        event(2*iter+1).latency = event(2*iter+1 - 1).latency - overlap_latency;
        event(2*iter+1).urevent = event(2*iter+1 - 1).urevent;
        event(2*iter+1).epoch = event(2*iter+1 - 2).epoch + 1;

        event(2*iter+2).type = 'E';
        event(2*iter+2).latency = event(2*iter+2 - 1).latency + latency;
        event(2*iter+2).urevent = event(2*iter+1 - 1).urevent + 1;
        event(2*iter+2).epoch = event(2*iter+2 - 2).epoch + 1;
        iter = iter + 1;
    end

    EEGset.event = event;
    EEGset.setname = [EEGset.setname, '_epoch'];
    if sf == 1
        disp(['Saving: ', se_list.name(1:end-4), '_epoch.set ...']);
        save_path = [se_list.folder, '\', se_list.name(1:end-4), '_epoch.set'];
        pop_saveset(EEGset, save_path);
        disp("done !");
    end
end
