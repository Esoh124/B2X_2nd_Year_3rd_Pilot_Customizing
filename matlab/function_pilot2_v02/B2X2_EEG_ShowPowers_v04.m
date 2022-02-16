% v02 --> v03 : stim 추가
% v03 --> v04 : stim 제거 (stim 구간은 epoch_wise_psd에서만 사용)

function [powers, powers_ratio] = B2X2_EEG_ShowPowers_v04(f, sf)
    sessions = {'base', 'stim', 'reco'};
    stim_mins = {'05min', '10min'};
    f_bands = {'gamma', 'beta', 'alpha', 'theta', 'delta'};
    chs = {'F3', 'Fz', 'F4', 'C3', 'Cz', 'C4', 'O1', 'Oz', 'O2'};


    % 1. Show powers
    powers = []; % 모든 subject의 power 값 저장
    
    for sub_num = 1 : length(f)

        % 빈 껍데기 선언: subject 한 명에 대한 base & reco column
        sub_pws = [];
    
        % subject마다 EEGset 6개를 laod
        % 각 EEGset의 정보를 추출하여 sub_base, sub_reco에 append
    
        % target EEGset_list dir()
        set_list = dir([f(sub_num).folder, '\', f(sub_num).name, '\EEG\EEGset\*_PSD.set']);
        
        % session과 stim_min에 따른 EEGset 선택
        for session_num = 1 : length(sessions)
            for stim_num = 1 : length(stim_mins)
                
                % 모든 set_list들을 비교하는 for문
                for set_num = 1 : length(set_list)
                    file_name = set_list(set_num).name;
                    % session과 stim_min이 for에 의한 순서를 만족하는 EEGset 선택
                    if contains(file_name, sessions{session_num}) && ...
                                contains(file_name, stim_mins{stim_num})
                        % EEGset 선택    
                        EEGset = pop_loadset([set_list(set_num).folder, '\', ...
                            set_list(set_num).name]);
                    end
                end
                
                % 선택한 EEGset으로부터 data 추출
                for ch_num = 1 : length(chs)
                    temp_pws = [];
                    for band_num = 1 : length(f_bands)
                        temp_pw = getfield(EEGset, 'SpectralAnalysis', ... 
                            chs{ch_num}, 'Mean_epoch', f_bands{band_num});
                        temp_pws = [temp_pws, temp_pw];
                    end
    
                    if session_num == 1 % base 인 경우
                        if stim_num == 1
                            sub_pws(1:5, 2*ch_num-1) = temp_pws;
                        else
                            sub_pws(6:10, 2*ch_num-1) = temp_pws;
                        end
                    elseif session_num == 2 % stim 인 경우
                        % v04: stim 구간 포함 x
%                         if stim_num == 1
%                             sub_pws(1:5, 3*ch_num-1) = temp_pws;
%                         else
%                             sub_pws(6:10, 3*ch_num-1) = temp_pws;
%                         end
                    else % reco 인 경우
                        if stim_num == 1
                            sub_pws(1:5, 2*ch_num) = temp_pws;
                        else
                            sub_pws(6:10, 2*ch_num) = temp_pws;
                        end
                    end
                end
            end
        end
        powers = [powers; sub_pws];
    end

    % step 2. show_diff_ratio (base-reco/base * 100)
    powers_ratio = [];
    for ch_iter = 1 : length(chs)
        temp_base = powers(:, 2*ch_iter-1);
%         temp_stim = powers(:, 3*ch_iter-1);
        temp_reco = powers(:, 2*ch_iter);
        temp_ratio = ((temp_reco - temp_base) ./ temp_base) * 100;
        powers_ratio = [powers_ratio, temp_ratio];
    end

    if sf == 1
        savepath = [f(1).folder];
        save([savepath, '\Powers.mat'], 'powers');
        save([savepath, '\Powers_ratio.mat'], 'powers_ratio');
        csvwrite([savepath, '\Powers.csv'], powers);
        csvwrite([savepath, '\Powers_ratio.csv'], powers_ratio);
    end
end
    






% --- NO USE FUNCTION----

% function INIT_powers(sessions, stim_mins, f_bands)
%     % Initiation of structure-type 'powers'
%     powers.five_min = [];
%     powers.ten_min = [];
%     
%     stim_min_fields = fieldnames(powers);
% 
%     for stim_min = 1 : length(stim_min_fields)
%         for se_num = 1 : length(sessions)
%             for band_num = 1 : length(f_bands)
%                 powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'frontal', f_bands{band_num}, []);
%                 powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'central', f_bands{band_num}, []);
%                 powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'occipital', f_bands{band_num}, []);
%             end
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'frontal', 'PSD', []);
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'frontal', 'f', []);
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'central', 'PSD', []);
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'central', 'f', []);
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'occipital', 'PSD', []);
%             powers = setfield(powers, stim_min_fields{stim_min}, ... 
%                     sessions{se_num}, 'occipital', 'f', []);
%         end
%     end
% end
        
