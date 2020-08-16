% coherent_modem_basic.m
% Basic coherent BPSK modem demo
%
% Copyright (c) 2020 Fedor Chervyakov
clear; close all; clc;

addpath("tx:rx");

f_sample = 64e4; % Sampling frequency in Samples/s
f_carrier = 1e3; % Carrier frequency in Hz
T_sym = 3e-3;    % Symbol duration in seconds

% Binary data to transmit
tx_bin = [1 0 1 1 0 1];

%% Modulate
y = bpsk_tx(tx_bin, f_sample, f_carrier, T_sym);

%% Demodulate
[rx_bin, I, Q] = bpsk_rx(y, f_sample, f_carrier, T_sym);


%% Plots
figure(1)
stem(tx_bin, 'o', 'markersize', 13, 'linewidth', 1.3);
hold on;
stem(rx_bin, 'x', 'markersize', 13, 'linewidth', 1.3);
legend('Tx', 'Rx');
grid on;
title('Binary data');

figure(2)
plot(I);
hold on;
plot(Q);
grid on;
title('Receiver I and Q channels after LPF');

figure(3)
plot(y)
grid on;
title('Trasmitted BPSK waveform');
