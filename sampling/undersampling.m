% undersampling.m
% Bandpass sampling (undersampling) of AM modulated carrier
%
% Copyright (c) 2020 Fedor Chervyakov
close all; clc; clear;

pkg load signal;

binary_data = [1, 0, 0, 1, 1];
T_sym = 10e-3; % Symbol duration in seconds

f_sample = 64e3;  % Sampling rate Samples/s
f_carrier = 10e3; % Carrier frequency Hz

% Generate baseband
N_sym = T_sym*f_sample; % Number of samples per symbol

y_bb = [];
for i=1:length(binary_data)
    y_bb = [y_bb binary_data(i)*ones(1, N_sym)];
end

% Generate AMed carrier
n = 0:length(y_bb)-1;
y = y_bb .* cos(2*pi*f_carrier/f_sample*n);

% FFT of the baseband
X_bb = fft(y_bb);

% FFT of modulated carrier
X_rf = fft(y);
% % Generate "original" signal
% N = f_sample;
% n = 0:N-1;
% y = sum(A_sig.*cos(n'*w_sig), 2)';
% 
% 
% % Calculate FFT of the original signal
% X_k = fft(y);
% 
% 
% % Find valid undersampling rate
% % such that original rate is an integer multiple of it
% Fu = max(f_sig);              % Upper signal frequency		
% Fl = min(f_sig);              % Lower signal frequency
% bw = Fu - Fl                  % Original signal's bandwidth
% valid_k = 1:floor(Fu/bw)      % Valid values for k
% 
% % TODO: rewrite this properly
% %for k=flip(valid_k)
% %    f_bps_l = 2*Fu/k;
% %    f_bps_u = 2*Fl/(k-1);
% %end
% 
% k = valid_k(end);
% f_bps_l = 2*Fu/k;
% f_bps_u = 2*Fl/(k-1);
% 
% f_bp_sample = 0; % Bandpass sampling rate
% 
% for f=f_bps_l:f_bps_u
%     if (gcd(f, f_sample) > 1)
%     	f_bp_sample = f;
% 	break;
%     end
% end
% 
% 
% % bandpass sample the signal
% n_diff = f_sample/f_bp_sample;
% n_bp_ix = 1:n_diff:length(y);
% y_bp_sampled = y(n_bp_ix);
% 
% % Calculate FFT of the undersampled signal
% Xu_k = fft(y_bp_sampled);
% 
% 
% % Plots
% % original signal and undersampled signal in time-domain
% figure(1)
% plot(n+1, y);
% hold on;
% plot(n_bp_ix, y_bp_sampled);
% title('Signal in time domain');
% legend('Nyquist sampled', 'Bandpass sampled')
% 
% % FFT of original signal
% figure(2)
% subplot(2,1,1);
% plot(abs(X_k));
% title('Magnitude spectrum');
% 
% subplot(2,1,2);
% plot(angle(X_k));
% title('Phase spectrum');
% 
% % FFT of undersampled signal
% figure(3)
% subplot(2,1,1);
% plot(abs(Xu_k));
% title('Magnitude spectrum');
% 
% subplot(2,1,2);
% plot(angle(Xu_k));
% title('Phase spectrum');
