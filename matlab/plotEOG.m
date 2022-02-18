function [] = plotEOG(varargin)
% - based on subject, stimulation block, and session
%   - subject = {1_KDH, 2_HHB, ...} ==> {1, 2, ...}
%   - stimulation block = {s0, s1, s2, s3, s4} ==> {0, 1, 2, 3, 4}
%   - session = {base, reco} ==> {'base', 'reco'}
    if sum(strcmp(varargin, 'subject')) ~= 0
        subject = varargin{circshift(strcmp(varargin, 'subject'), 1)};
    else
        subject = nan;
        disp('Error: no subject selected')
    end

    if sum(strcmp(varargin, 'block')) ~= 0
        block = 1 + varargin{circshift(strcmp(varargin, 'block'), 1)};
    else
        block = nan;
        disp('Error: no block selected')
    end

    if sum(strcmp(varargin, 'session')) ~= 0
        session = varargin{circshift(strcmp(varargin, 'session'), 1)};
    else
        session = nan;
        disp('Error: no subject selected')
    end
    
    %% Default Setting
    path_biopac_mat = 'E:\B2X\2차년도\03_pilot\biopac_mat'; % 모든 subject 폴더가 포함되어 있는 경로
    addpath 'E:\B2X\2차년도\03_pilot\CODE\matlab\func';
    
    %% 1. Choose Subject
    f = dir(path_biopac_mat);
    f = f(3:sum([f.isdir]));

    choose_sub = subject;
    if sum(choose_sub) > 0
        f = f(choose_sub);
    end
    fprintf('Selected Subjects: ');
    for mat_i = 1 : length(f)
        fprintf('%s ', f(mat_i).name);
    end
    disp(' ');

    %% 2. load data
    subject_path = [f.folder, '\', f.name];
    mat_list = dir(subject_path);
    mat_list = mat_list(~[mat_list.isdir]);
    
    filename = mat_list(block).name;
    biopac_data = load([subject_path, '\', filename]);
    vertical_eog = biopac_data.eog100c_4.wave;
    horizontal_eog = biopac_data.eog100c_5.wave;
    Fs = biopac_data.eog100c_4.Fs;
    t = 0:1/Fs:(length(vertical_eog)-1)/Fs;

    %% 3. plot eog
    % based on the session
    % calculate the indices corresponding to the session
    
    len_eog = length(vertical_eog);
    [base_i, stim_i, reco_i] = FindSessionIdx(len_eog, Fs); % base, stim, reco: each 6min but reco exclude the first 5s

    if session == 'base'
        session_idx = base_i;
    elseif session == 'reco'
        session_idx = reco_i;
    end

    figure;
    ax1 = subplot(2,1,1); plot(t(session_idx), vertical_eog(session_idx)); xlim([0 15]); title('Vertical EOG', 'FontSize', 15);
    ax2 = subplot(2,1,2); plot(t(session_idx), horizontal_eog(session_idx)); xlim([0 15]); title('Horizontal EOG', 'FontSize', 15);
    linkaxes([ax1, ax2], 'x');

end
