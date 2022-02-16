% B2X2_ManualInspection

function EEGset = B2X2_ManualInspection(se_list, sf, raw, varargin)
    % manual inspection을 통해 확인한 artifact 구간을 제거
    % 모든 epoch에 대해서, 모든 arti_s와 arti_e를 비교하여, artifact가 epoch에 조금이라도 포함되면,
    % 해당 epoch의 EEGset.event.type이 'S'인 row에 EEGset.event.arti에 1을 기입
    
    % input
    % 1. se_list : EEGset 폴더의 session_dividing이 완료된 파일을 읽고, 그 중 하나의 파일에
    %    대한 dir을 입력 ex) se_list(se_num)
    % 2. sf: saveflag
    % 3. raw: mannual inspection 결과가 저장되어 있는 cell array
    % ex)   stim_min	session	start(s)	end(s)	situation 
    %       5	        'base'	258	        268  	'눈을부릅뜸,침삼킴'

    EEGset = pop_loadset([se_list.folder, '\', se_list.name]);
    fs = EEGset.srate;

    % Extract the correct inspection (stim_min, session)
    file_name = EEGset.filename;
    artifacts = GetExcel(file_name, raw); % 모든 artifact 구간의 start, end time [sec]
    arti_s = fs.*artifacts(:,1); % 모든 artifact 구간의 start time [idx]
    arti_e = fs.*artifacts(:,2); % 모든 artifact 구간의 end time [idx]
    
    event = EEGset.event; % epoch 정보가 담겨 있는 구조체 필드

    % event 구조체에 artifact 필드를 추가
    for i = 1 : length(event)
        event(i).artifact = 0;
    end
%     event(1).artifact = 0; % event 구조체에 artifact 필드를 추가

    len_event = length(event);
    latency = [event.latency];
    start_latency = latency(1:2:len_event); % start indices
    end_latency =latency(2:2:len_event); % end indices

    for event_num = 1 : length(start_latency)
        % event 구조체는 start와 end로 구성되어 있기 때문에 반복문을 전체 길이의 절반만큼 적용한다
        for arti_num = 1 : length(arti_s)
            % artifact를 포함하는 4가지 case
            condition1 = start_latency(event_num) > arti_e(arti_num);
            condition2 = end_latency(event_num) < arti_s(arti_num);
            condition = condition1 || condition2;
%             condition1 = start_latency(event_num)>arti_s(arti_num) && end_latency(event_num) > arti_e(arti_num);
%             condition2 = start_latency(event_num)<arti_s(arti_num) && end_latency(event_num) > arti_e(arti_num);
%             condition3 = start_latency(event_num)<arti_s(arti_num) && end_latency(event_num) < arti_e(arti_num);
%             condition4 = start_latency(event_num)>arti_s(arti_num) && end_latency(event_num) < arti_e(arti_num);
%             condition = condition1 || condition2 || condition3 || condition4;

            if ~condition
                event(2*event_num-1).artifact = 1;
                event(2*event_num).artifact = 1;
            end
        end
    end

    EEGset.event = event;
    if sf == 1
        pop_saveset(EEGset, [se_list.folder, '\', se_list.name(1:end-4), '_rmARTI.set']);
    end
end

function artifacts = GetExcel(file_name, raw)
% set_name에 따라서, raw 정보 추출
% artifact의 start와 end를 artifact에 저장
    raw = raw(2:end,1:4);
    
    excel_info = [];
    % NaN이 포함된 정보는 제거
    for i = 1 : length(raw)
        temp = raw(i,:);
        if ~isnan(temp{1})
            excel_info = [excel_info; temp];
        end    
    end

    % 현재 EEGset의 stim_min과 session 추출
    if contains(file_name, '05')
        stim_min = 5;
    else
        stim_min = 10;
    end

    if contains(file_name, 'base')
        session = 'base';
    elseif contains(file_name, 'stim')
        session = 'stim';
    else
        session = 'reco';
    end

    % stim_min과 session에 맞는 artifact만 선택
    artifacts = []; % artifact 정보를 저장할 배열
    for i = 1 : length(excel_info)
        if excel_info{i,1}==stim_min && strcmp(excel_info{i,2}, session)
            artifacts = [artifacts; excel_info(i,3:4)];
        end
    end
    artifacts = cell2mat(artifacts);
    disp('done')
end