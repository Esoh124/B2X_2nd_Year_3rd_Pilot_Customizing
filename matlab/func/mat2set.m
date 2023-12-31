function EEGset = mat2set(f, mat_list, fs, n_ch, varargin)
    % B2X 2차년도(2021) --> 3차 pilot study 
    % mat 파일을 EEGLAB set 파일로 변환

    if sum(strcmp(varargin, 'save')) ~= 0
        sf = varargin{circshift(strcmp(varargin, 'save'),1)};
    else
        sf = 0;
    end
    
    % use pop_importdata() from EEGLAB
    % set input options for the pop_importdata()
    % read mat file and return set file
    setname = mat_list.name(1:end-4); % a name of block s0, s1_N010, s2_S100, s3_N100, s4_S020
    data = [mat_list.folder, '\', mat_list.name];
    dataformat = 'matlab';
    subject = f.name; % a name of subject ex). 01_KDH
    chanlocs = ['C:\Users\USER\Desktop\이소현\EEG\B2X_2nd_Year_3rd_Pilot_Customizing\matlab\locs', '\', 'pilot3_32ch.locs'];
    nbchan = n_ch;
    srate = fs;
    
    EEGset = pop_importdata('setname', setname, 'data', data, ...
        'dataformat', dataformat, 'subject', subject, ...
        'chanlocs', chanlocs, 'nbchan', nbchan, 'srate', srate);
    
    if sf == 1
        savepath = [mat_list.folder, '\EEGset\'];
        mkdir(savepath);
        pop_saveset(EEGset, [savepath, '\', setname]);
        fprintf(" mat2set: EEGset saving... %s\n", setname);
    end
end