% cordic_osc.m
% Cordic oscillator demo
%
% This is a derivative of oscillator.m, which is a part of the Digital Communications
% by Bernd Porr licensed under Creative Commons Attribution 4.0 International License
% Original (C) 2015 Bernd Porr, mail@berndporr.me.uk, www.berndporr.me.uk
% https://www.berndporr.me.uk/teaching/digicomms/digi_comms_web.zip
% http://creativecommons.org/licenses/by/4.0/
clear; close all;

%% Constants
f_sample = 1e3;                   % Sampling frequency in Samples/s
f_carrier = 10;                   % Carrier frequency in Hz
w0 = 2*pi*f_carrier/f_sample;     % "Normalized" frequency
N_periods = 2;                    % Number of periods
N = N_periods*f_sample/f_carrier; % Number of samples

%% Initial conditions
c = 1;
c_delay = 0;
s = 0;
s_delay = 0;

sine = [];
cosine = [];

%% Oscillate
for i=1:N
    c_delay = c;
    s_delay = s;
    c = c_delay * cos(w0) - s_delay * sin(w0);
    s = s_delay * cos(w0) + c_delay * sin(w0);
    cosine = [cosine c];
    sine = [sine s];
end

%% Plot
figure(1)
subplot(2,1,1);
plot(sine);
title('Sine');

subplot(2,1,2);
plot(cosine);
title('Cosine');
