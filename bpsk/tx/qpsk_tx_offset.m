% qpsk_tx_offset.m
% QPSK modulator
%
% Copyright (c) 2020 Fedor Chervyakov
function Y = qpsk_tx_offset(data, f_sample, f_carrier, T_sym, phi)
    % data      - binary data to be transmitted
    % f_sample  - sampling frequency in Samples/s
    % f_carrier - carrier frequency in Hz
    % T_sym     - duration of a QPSK symbol in seconds
    % phi       - carrier offset in radians

    % Constants
    N_sym = length(data)/2   % Number of symbols
    N = ceil(T_sym*f_sample) % Number of samples per symbol

    % Convert binary data to NRZ
    nrz_data = 2*data-1;

    % 1:2 Demux
    I_nrz = nrz_data(1:2:end)
    Q_nrz = nrz_data(2:2:end)

    % Modulate I and Q carriers
    I = []; Q = [];
    n = 0:(N-1); % indices for a single symbol
    for i=1:N_sym
        I = [I (I_nrz(i) * cos(2*pi*f_carrier/f_sample.*n + phi))];
        Q = [Q (Q_nrz(i) * sin(-2*pi*f_carrier/f_sample.*n - phi))];
    end

    % Combine I and Q paths
    Y = (I + Q) ./ sqrt(2);
end
