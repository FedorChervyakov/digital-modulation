% modem_costas_rx.m
% Basic QPSK modem with Costas loop receiver demo
%
% Copyright (c) 2020 Fedor Chervyakov
clear; close all; clc;

addpath("tx:rx");

f_sample = 64e4; % Sampling frequency in Samples/s
f_carrier = 1e3; % Carrier frequency in Hz
T_sym = 10e-3;    % Symbol duration in seconds

% Binary data to transmit
tx_bin = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%% Introduce phase offset
phi = 0;

%% Modulate
y = qpsk_tx_offset(tx_bin, f_sample, f_carrier, T_sym, phi);

%% Demodulate
[rx_bin, I, Q, vco] = qpsk_rx_costas(y, f_sample, f_carrier, T_sym);


%% Plots
figure(1)
stem(tx_bin, 'o', 'markersize', 13, 'linewidth', 1.3);
hold on;
stem(tx_bin, 'x', 'markersize', 13, 'linewidth', 1.3);
legend('Tx', 'Rx');
grid on;
title('Binary data');

figure(2)
plot(I);
hold on;
plot(Q);
grid on;
title('Receiver I and Q channels after LPFs in Costas loop');

figure(3)
plot(y);
grid on;
title('Trasmitted QPSK waveform');

figure(4)
plot(vco);
grid on;
title('VCO input');
