% qpsk_rx_matched.m
% QPSK demodulator using matched filter
% Assuming coherent reception
%
% Copyright (c) 2020 Fedor Chervyakov
function [data, I_fil, Q_fil] = qpsk_rx_matched(y, f_sample, f_carrier, T_sym)
    % y         - received samples
    % f_sample  - sampling frequency of ADC in Samples/s
    % f_carrier - carrier frequency in Hz
    % T_sym     - duration of a QPSK symbol in seconds
    
    % Constants
    N = length(y);               % Number of input samples
    N_sym = ceil(T_sym*f_sample);% Number of samples per symbol
    n = 0:N-1;                   % sample indices
    w = 2*pi*f_carrier/f_sample; % normalized frequency

    % Modulate the input data with carrier
    I_mod = y.*cos(w*n);
    Q_mod = y.*sin(-w*n);

    %% Matched filter
    % Matched to a rectangular pulse
    taps = ones(1, N_sym); 
    I_fil = filter(taps, 1, I_mod);
    Q_fil = filter(taps, 1, Q_mod);

    % Last value from matched filter for each symbol
    I_sym = I_fil(N_sym:N_sym:end);
    Q_sym = Q_fil(N_sym:N_sym:end);

    % Convert to binary
    data = [];
    for i=1:(length(I_sym))
        d_i=0;d_q=0;

        if I_sym(i)>0
            d_i = 1;
        end;
        if Q_sym(i)>0
            d_q = 1;
        end;

        data = [data d_i d_q];
    end
end
