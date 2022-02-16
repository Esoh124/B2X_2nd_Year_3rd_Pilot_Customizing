% B2X_mat2set_v02
% session dividing을 하지 않고, 통째로 eegset 생성
% session dividing이 필요하면, eegset을 로드한 이후, 
% eegset을 input으로 하는 함수를 따로 만들어서 각 session에 대한 신호처리 진행

function EEGset = B2X_mat2set_v02(f, f_list, fs, sf)
    % input 
    %   1. f
    %   2. f_list
    %   3. srate
    %   4. sf : saveflag, 0 or 1
    
    % pop_importdata
    % .mat 형식을 데이터를 읽어오기 위해서, eeglab의 pop_importdata 사용
    
    % optional input 설정
    setname = f_list.name(1:5);
    data = [f_list.folder, '\', f_list.name];
    dataformat = 'matlab';
    subject = f.name;
    chanlocs = [f.folder, '\', 'chanlocs.loc'];
    nbchan = 10;
    srate = fs;
    
    EEGset = pop_importdata('setname', setname, 'data', data, ...
        'dataformat', dataformat, 'subject', subject, ...
        'chanlocs', chanlocs, 'nbchan', nbchan, 'srate', srate);

    Oz_set = pop_select(EEGset, 'channel', {'Oz'});
    Cz_data = -Oz_set.data;

    temp_data =[];
    chs = {EEGset.chanlocs.labels};

    for ch_num = 1:length(chs)
        if chs{ch_num} == 'C4'
            temp_data = [temp_data; Cz_data]; % put Cz data into the desired location
        end
        ch_set = pop_select(EEGset, 'channel', chs(ch_num));
        temp_data = [temp_data; ch_set.data]; % stack the datas from the other chs
    end

    setname = EEGset.setname;
    data = temp_data;
    dataformat = 'array';
    subject = f.name;
    chanlocs = [f.folder, '\chanlocs_addCz.loc'];
    nbchan = 11;
    srate = EEGset.srate;

    EEGset = pop_importdata('setname', setname, 'data', data, 'dataformat', dataformat, 'subject', subject, ...
        'chanlocs', chanlocs, 'nbchan', nbchan, 'srate', srate);
    
    if sf == 1
        savepath = [f_list.folder, '\EEGset\'];
        mkdir(savepath);
        pop_saveset(EEGset, [savepath, '\', f_list.name(1:5)]);
        fprintf(" mat2set: EEGset saving... %s\n", f_list.name(1:5));
    end
end

% Optional inputs:
    %   'setname'    - Name of the EEG dataset
    %   'data'       - ['varname'|'filename'|array] Import data from a Matlab variable 
    %                  or file into an EEG data structure.
    %   'dataformat' - ['array|matlab|ascii|float32le|float32be'] Input data format.
    %                  'array' is a Matlab array in the global workspace.
    %                  'matlab' is a Matlab file (which must contain a single variable).
    %                  'ascii' is an ascii file. 'float32le' and 'float32be' are 32-bit
    %                  float data files with little-endian and big-endian byte order.
    %                  Data must be organised as (channels, timepoints) i.e. 
    %                  channels = rows, timepoints = columns; else, as 3-D (channels, 
    %                  timepoints, epochs). For convenience, the data file is transposed 
    %                  if the number of rows is larger than the number of columns as the
    %                  program assumes that there is more channel than data points. 
    %   'subject'    - [string] subject code. For example, 'S01'.
    %                   {default: none -> each dataset from a different subject}
    %   'condition'  - [string] task condition. For example, 'Targets'
    %                   {default: none -> all datasets from one condition}
    %   'group'      - [string] subject group. For example 'Patients' or 'Control'.
    %                   {default: none -> all subjects in one group}
    %   'session'    - [integer] session number (from the same subject). All datasets
    %                   from the same subject and session will be assumed to use the
    %                   same ICA decomposition {default: none -> each dataset from
    %                   a different session}
    %   'chanlocs'   - ['varname'|'filename'] Import a channel location file.
    %                   For file formats, see >> help readlocs
    %   'nbchan'     - [int] Number of data channels. 
    %   'xmin'       - [real] Data epoch start time (in seconds).
    %                   {default: 0}
    %   'pnts'       - [int] Number of data points per data epoch. The number of trial
    %                  is automatically calculated.
    %                   {default: length of the data -> continuous data assumed}
    %   'srate'      - [real] Data sampling rate in Hz {default: 1Hz}
    %   'ref'        - [string or integer] reference channel indices. 'averef' indicates
    %                  average reference. Note that this does not perform referencing
    %                  but only sets the initial reference when the data is imported.
    %   'icaweight'  - [matrix] ICA weight matrix. 
    %   'icasphere'  - [matrix] ICA sphere matrix. By default, the sphere matrix 
    %                  is initialized to the identity matrix if it is left empty.
    %   'comments'   - [string] Comments on the dataset, accessible through the EEGLAB
    %                  main menu using (Edit > About This Dataset). Use this to attach 
    %                  background information about the experiment or data to the dataset.
    % Outputs:
    %   EEGOUT      - modified EEG dataset structure