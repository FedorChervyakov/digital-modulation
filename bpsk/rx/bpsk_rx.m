% bpsk_rx.m
% BPSK demodulator
% Assuming coherent reception
%
% Copyright (c) 2020 Fedor Chervyakov
function [data, I_lpf, Q_lpf] = bpsk_rx(y, f_sample, f_carrier, T_sym)
    % y         - received samples
    % f_sample  - sampling frequency of ADC in Samples/s
    % f_carrier - carrier frequency in Hz
    % T_sym     - duration of a BPSK symbol in seconds
    pkg load signal;             % Required for the fir1
    
    % Constants
    N = length(y);               % Number of input samples
    N_sym = ceil(T_sym*f_sample);% Number of samples per symbol
    n = 0:N-1;                   % sample indices
    w = f_carrier/f_sample;      % normalized frequency

    % Modulate the input data with carrier
    I_mod = y.*cos(2*pi*w*n);
    Q_mod = y.*sin(-2*pi*w*n);

    % Low pass filter modulated signals
    N_taps = ceil(N_sym/2);
    taps = fir1(N_taps, w, 'low');
    %delay = ceil((N_taps-1)/2);

    I_lpf = filter(taps, 1, I_mod);
    Q_lpf = filter(taps, 1, Q_mod);

    % Normalize
    I_lpf = I_lpf./max(abs(I_lpf));
    Q_lpf = Q_lpf./max(abs(Q_lpf));

    % Splice into symbols
    spl_size = [N_sym ceil(N/N_sym)];
    l_lpf = length(I_lpf);
    I_pad = [I_lpf];
    Q_pad = [Q_lpf];
    
    I_spl = reshape(I_pad, spl_size);
    Q_spl = reshape(Q_pad, spl_size);

    % get average for each symbol
    I_avg = mean(I_spl, 1);
    Q_avg = mean(Q_spl, 1);
    
    % Convert to binary
    data = [];
    for i=1:(length(I_avg))
        d_i=0;

        if I_avg(i)>0
            d_i = 1;
        end;

        data = [data d_i];
    end
end
