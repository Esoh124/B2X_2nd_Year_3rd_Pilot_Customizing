% demo version
% epoch-wise plotting

% frontal: 12 --> subplot(3,4)
% central: 3 --> subplot(1,3)
% parietal: 9 --> subplot(3,3)
% occipital: 4 --> subplot(2,2)
% temporal: 2 --> subplot(1,2)
close all;

% gamma
band = 'gamma';
band_s0 = getfield(s0, 'KDH_01', 'frontal', 'Fp1', band);
band_S100 = getfield(S100, 'KDH_01', 'frontal', 'Fp1', band);
figure; sgtitle(band, 'FontSize', 30)
subplot(2,1,1); plot(band_s0); hold on; 
title('Sham', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 
subplot(2,1,2); plot(band_S100); hold on;
title('100Hz Symmetric', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 

% beta
band = 'beta';
band_s0 = getfield(s0, 'KDH_01', 'frontal', 'Fp1', band);
band_S100 = getfield(S100, 'KDH_01', 'frontal', 'Fp1', band);
figure; sgtitle(band, 'FontSize', 30)
subplot(2,1,1); plot(band_s0); hold on; 
title('Sham', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 
subplot(2,1,2); plot(band_S100); hold on;
title('100Hz Symmetric', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 

% alpha
band = 'alpha';
band_s0 = getfield(s0, 'KDH_01', 'frontal', 'Fp1', band);
band_S100 = getfield(S100, 'KDH_01', 'frontal', 'Fp1', band);
figure; sgtitle(band, 'FontSize', 30)
subplot(2,1,1); plot(band_s0); hold on; 
title('Sham', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 
subplot(2,1,2); plot(band_S100); hold on;
title('100Hz Symmetric', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 

% theta
band = 'theta';
band_s0 = getfield(s0, 'KDH_01', 'frontal', 'Fp1', band);
band_S100 = getfield(S100, 'KDH_01', 'frontal', 'Fp1', band);
figure; sgtitle(band, 'FontSize', 30)
subplot(2,1,1); plot(band_s0); hold on; 
title('Sham', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 
subplot(2,1,2); plot(band_S100); hold on;
title('100Hz Symmetric', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 

% delta
band = 'delta';
band_s0 = getfield(s0, 'KDH_01', 'frontal', 'Fp1', band);
band_S100 = getfield(S100, 'KDH_01', 'frontal', 'Fp1', band);
figure; sgtitle(band, 'FontSize', 30)
subplot(2,1,1); plot(band_s0); hold on; 
title('Sham', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 
subplot(2,1,2); plot(band_S100); hold on;
title('100Hz Symmetric', 'FontSize', 20); xlabel('epoch (base~stim~reco)', 'FontSize', 20); ylabel([band, ' power'], 'FontSize', 20); 