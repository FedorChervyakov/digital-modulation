% pll.m
% Basic all-digital PLL demo
%
% Copyright (c) 2020 Fedor Chervyakov
clear; close all;

pkg load signal;   % Required for the fir1
rand('state', 10); % Random gen's state for reproducibility

f_sample = 1e3; % Sampling frequency in Samples/s
f_carrier = 10; % Carrier frequency in Hz

w = f_carrier/f_sample; % "Normalized" frequency
phi_off = 2*pi*rand();  % Carrier phase offset

%% "Original" sinewave
N_periods = 25;                   % Number of periods
N = N_periods*f_sample/f_carrier; % Number of samples
n = 0:(N-1);                      % Indices aid
x_in = cos(2*pi*w*n + phi_off);

%% FIR loop filter
% Cutoff at f_carrier
N_taps = N/N_periods;
b_lf = fir1(N_taps, w);
zf = zeros(N_taps,1);
v = 0;

%% CORDIC VCO
% Initial conditions
c = 1;
c_delay = 0;
s = 0;
s_delay = 0;
alpha = f_carrier/(2.5*f_sample);


%% Vectors for the outputs
sine = [];
cosine = [];
v_out = [];


%% PLL
for i=1:N
    
    % VCO
    w0 = 2*pi*(w + alpha*v);
    c_delay = c;
    s_delay = s;
    c = c_delay * cos(w0) - s_delay * sin(w0);
    s = s_delay * cos(w0) + c_delay * sin(w0);

    % Phase detector
    pd = -s * x_in(i);

    % Loop filter
    [v, zf] = filter(b_lf, 1, pd, zf);

    % Save for plotting
    sine = [sine s];
    cosine = [cosine c];
    v_out = [v_out v];
end

%% Plot
figure(1)
subplot(2,1,1);
plot(x_in);
hold on;
plot(cosine);
title('PLL Input vs output');

subplot(2,1,2);
plot(v_out);
title('Loop filter output');
