function EEGset = CalPSD(set_list, varargin)
    % input
    % 1. set_list : dir(one EEGset)
    % 2. sf : save flag

    str_cmp = strcmp(varargin, 'save');
    if sum(str_cmp) ~= 0
        sf = varargin{circshift(str_cmp, 1)};
    else
        sf = 0;
    end
    
    EEGset = pop_loadset([set_list.folder, '\', set_list.name]);
    
    fs = EEGset.srate;
    chs = {EEGset.chanlocs.labels};
    epochs = [EEGset.event.latency]; % 각 epoch의 start, end indice가 저장되어 있는 배열
%     arti_flag = [EEGset.event.artifact]; % 각 epoch이 artifact를 포함하면 1이 저장되어 있음
    
    EEGset = setfield(EEGset, 'SpectralAnalysis', []); % PSD 필드 추가 in EEGset
    
    for ch_num = 1 : length(chs)
        data = EEGset.data(ch_num, :);
    
        % EEGset.SpectralAnalysis.Ch 선언 (ch: F3, Fz, ..., O4)
        % EEGset.SpectralAnalysis.Ch.epoch_data : 모든 epoch에 대한 정보가 담기는 필드
        % EEGset.SpectralAnalysis.Ch.Mean_epoch : 모든 epoch의 평균값이 담기는 필드
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', []);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', []);
        
        PSD = []; % epoch별 PSD가 담기는 array
        log_PSD = []; 

        % 모든 epoch의 주파수 파워가 stack 되는 array
        gamma = []; beta = []; alpha = [];
        theta = []; delta = [];
        
        total_power = []; % 각 epoch마다 total power를 stack

        % 모든 epoch의 normalized 주파수 파워가 stack 되는 array
        n_gamma = []; n_beta = []; n_alpha = [];
        n_theta = []; n_delta = [];

%         log_gamma = []; log_beta = []; log_alpha = [];
%         log_theta = []; log_delta = [];
    
            
        % artifact가 포함되지 않은 epoch에 대해 PSD 추출
        for epoch_num = 1 : length(epochs)/2
%             if arti_flag(2*epoch_num-1)==1 || arti_flag(2*epoch_num)==1
%                 continue;
%             end
            epoch_idx = epochs(2*epoch_num-1):epochs(2*epoch_num);
            nfft = length(epoch_idx);
            [pxx, f] = periodogram(data(epoch_idx), hanning(length(epoch_idx)), nfft, fs);
            PSD = [PSD, pxx];  
            log_PSD = [log_PSD, 10*log10(pxx+1)]; % log10의 결과가 음수가 발생하지 않도록 1을 더해줌

            % epoch_num에 따른 해당 epoch에 대한 파워 계산
            [temp_gamma, temp_beta, temp_alpha, temp_theta, temp_delta] = CalPowers(pxx, f);
            % stacking
            gamma = [gamma, temp_gamma];
            beta = [beta, temp_beta];
            alpha = [alpha, temp_alpha];
            theta = [theta, temp_theta];
            delta = [delta, temp_delta];
    
            % norm power calculation
            temp_total_power = temp_gamma + temp_beta + temp_alpha + temp_theta + temp_delta;
            [temp_n_gamma, temp_n_beta, temp_n_alpha, temp_n_theta, temp_n_delta] = ...
                NormPower(temp_total_power, temp_gamma, temp_beta, temp_alpha, temp_theta, temp_delta);
            % norm power stacking
            total_power = [total_power, temp_total_power];
            n_gamma = [n_gamma, temp_n_gamma];
            n_beta = [n_beta, temp_n_beta];
            n_alpha = [n_alpha, temp_n_alpha];
            n_theta = [n_theta, temp_n_theta];
            n_delta = [n_delta, temp_n_delta];

%             [log_temp_gamma, log_temp_beta, log_temp_alpha, log_temp_theta, log_temp_delta] = CalPowers(10*log10(pxx), f);
%             log_gamma = [log_gamma, log_temp_gamma];
%             log_beta = [log_beta, log_temp_beta];
%             log_alpha = [log_alpha, log_temp_alpha];
%             log_theta = [log_theta, log_temp_theta];
%             log_delta = [log_delta, log_temp_delta];
        end
        % 모든 epoch에 대한 for문이 끝나고, stacking이 완료된 배열에 평균을 적용
        total_power_of_mean_PSD = mean(gamma) + mean(beta) + mean(alpha) + mean(theta) + mean(delta);
        n_gamma_of_mean_PSD = mean(gamma)/total_power_of_mean_PSD;
        n_beta_of_mean_PSD = mean(beta)/total_power_of_mean_PSD;
        n_alpha_of_mean_PSD = mean(alpha)/total_power_of_mean_PSD;
        n_theta_of_mean_PSD = mean(theta)/total_power_of_mean_PSD;
        n_delta_of_mean_PSD = mean(delta)/total_power_of_mean_PSD;
        
        % EEGset에 저장
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'PSD', PSD);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'f', f);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'gamma', gamma);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'beta', beta);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'alpha', alpha);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'theta', theta);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'delta', delta);

        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'f', f);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'PSD', log_PSD);

        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'total_power', total_power);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'gamma', n_gamma);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'beta', n_beta);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'alpha', n_alpha);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'theta', n_theta);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'norm', 'delta', n_delta);
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'gamma', log_gamma);
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'beta', log_beta);
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'alpha', log_alpha);
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'theta', log_theta);
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'epoch_data', 'log', 'delta', log_delta);
    
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'PSD', mean(PSD'));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'f', f);  
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'gamma', mean(gamma));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'beta', mean(beta));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'alpha', mean(alpha));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'theta', mean(theta));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'delta', mean(delta));

        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'norm', 'gamma', n_gamma_of_mean_PSD);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'norm', 'beta', n_beta_of_mean_PSD);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'norm', 'alpha', n_alpha_of_mean_PSD);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'norm', 'theta', n_theta_of_mean_PSD);
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'norm', 'delta', n_delta_of_mean_PSD);

        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'PSD', 10*log10(mean(PSD')+1));
        EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'f', f); 
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'gamma', mean(log_gamma));
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'beta', mean(log_beta));
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'alpha', mean(log_alpha));
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'theta', mean(log_theta));
%         EEGset = setfield(EEGset, 'SpectralAnalysis', chs{ch_num}, 'Mean_epoch', 'log', 'delta', mean(log_delta));
    end

    EEGset.setname = [EEGset.setname, '_PSD'];
    if sf == 1
        fprintf('Saving: %s...', [set_list.name(1:end-4), '_PSD.set']);
        pop_saveset(EEGset, [set_list.folder, '\', set_list.name(1:end-4), '_PSD.set']);
        fprintf('done !\n');
    end
end

function [gamma, beta, alpha, theta, delta] = CalPowers(PSD, f)
    gamma_f=[30 99]; % 100HZ 자극 신호 피하기 : 100 --> 95
    beta_f = [13 30]; alpha_f = [8 13]; 
    theta_f = [4 8]; delta_f = [1 4]; % 0.5Hz HPF를 적용했으므로, 1Hz부터
    
    gamma_idx = FindIdx(gamma_f, f);
    beta_idx = FindIdx(beta_f, f);
    alpha_idx = FindIdx(alpha_f, f);
    theta_idx = FindIdx(theta_f, f);
    delta_idx = FindIdx(delta_f, f);

    gamma = trapz(f(gamma_idx), PSD(gamma_idx));
    beta = trapz(f(beta_idx), PSD(beta_idx));
    alpha = trapz(f(alpha_idx), PSD(alpha_idx));
    theta = trapz(f(theta_idx), PSD(theta_idx));
    delta = trapz(f(delta_idx), PSD(delta_idx));
end

function idx = FindIdx(f_band, f)
    [value, idx1] = min(abs(f-f_band(1)));
    [value, idx2] = min(abs(f-f_band(2)));

    idx = idx1:idx2;
end

function [n_gamma, n_beta, n_alpha, n_theta, n_delta] = NormPower(total_power, gamma, beta, alpha, theta, delta)
    n_gamma = gamma / total_power;
    n_beta = beta / total_power;
    n_alpha = alpha / total_power;
    n_theta = theta / total_power;
    n_delta = delta / total_power;
end