% bpsk_tx.m
% BPSK modulator
%
% Copyright (c) 2020 Fedor Chervyakov
function I = bpsk_tx(data, f_sample, f_carrier, T_sym)
    % data      - binary data to be transmitted
    % f_sample  - sampling frequency in Samples/s
    % f_carrier - carrier frequency in Hz
    % T_sym     - duration of a BPSK symbol in seconds

    % Constants
    N_sym = length(data)   % Number of symbols
    N = ceil(T_sym*f_sample) % Number of samples per symbol

    % Convert binary data to NRZ
    nrz_data = 2*data-1;

    % Modulate I carrier
    I = [];
    n = 0:(N-1); % indices for a single symbol
    for i=1:N_sym
        I = [I (nrz_data(i) * cos(2*pi*f_carrier/f_sample.*n))];
    end

end
