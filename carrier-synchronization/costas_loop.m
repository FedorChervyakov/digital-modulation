% costas_loop.m
% Basic Costas loop phase recovery demo
%
% Copyright (c) 2020 Fedor Chervyakov
clear; close all;

pkg load signal;   % Required for the fir1
rand('state', 10); % Random gen's state for reproducibility

f_sample = 1e3; % Sampling frequency in Samples/s
f_carrier = 10; % Carrier frequency in Hz

w = f_carrier/f_sample; % "Normalized" frequency
%phi_off = 2*pi*rand();  % Carrier phase offset
phi_off = 3/4*pi;  % Carrier phase offset

%% "Original" sinewave
N_periods = 10;                   % Number of periods
N = N_periods*f_sample/f_carrier; % Number of samples
n = 0:(N-1);                      % Indices aid
carrier = cos(2*pi*w*n + phi_off);


%% FIR Low pass filter
% Cutoff at f_carrier
N_taps = N/N_periods;
b_lf = fir1(N_taps, w);
zf_I = zeros(N_taps,1);
zf_Q = zeros(N_taps,1);
v = 0;


%% CORDIC VCO
% Initial conditions
c = 1;
c_delay = 0;
s = 0;
s_delay = 0;
alpha = f_carrier/(pi*f_sample);


%% Vectors for the outputs
sine = [];
cosine = [];
v_out = [];


%% Costas loop 
for i=1:N
    
    % VCO
    w0 = 2*pi*(w+alpha*v);
    c_delay = c;
    s_delay = s;
    c = c_delay * cos(w0) - s_delay * sin(w0);
    s = s_delay * cos(w0) + c_delay * sin(w0);

    I = carrier(i) * c;
    Q = -carrier(i) * s;

	% Remove 2f component
	[I_lpf, zf_I] = filter(b_lf, 1, I, zf_I);
	[Q_lpf, zf_Q] = filter(b_lf, 1, Q, zf_Q);
 
    % Phase detector
    v = atan((Q_lpf/I_lpf));

    % Save for plotting
    sine = [sine s];
    cosine = [cosine c];
    v_out = [v_out v];
end

%% Plot
figure(1)
subplot(2,1,1);
plot(carrier);
hold on;
plot(-cosine);
legend('Original carrier', 'VCO cosine output');
title('Costas Loop Input vs output');

subplot(2,1,2);
plot(v_out);
title('Phase detector output');
