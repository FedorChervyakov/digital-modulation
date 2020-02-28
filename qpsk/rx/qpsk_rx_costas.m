% qpsk_rx_costas.m
% QPSK demodulator using Costas loop
%
% Copyright (c) 2020 Fedor Chervyakov
function [data, I, Q, vco] = qpsk_rx_costas(y, f_sample, f_carrier, T_sym)
    % y         - received samples
    % f_sample  - sampling frequency of ADC in Samples/s
    % f_carrier - carrier frequency in Hz
    % T_sym     - duration of a QPSK symbol in seconds

    pkg load signal; % Required for the fir1 command
    
    % Constants
    N = length(y);               % Number of input samples
    N_sym = ceil(T_sym*f_sample);% Number of samples per symbol
    w = f_carrier/f_sample;      % normalized frequency
    alpha = w;               % VCO proportionality constant

    % CORDIC VCO Initial conditions
    s = 0;
    c = 1;
    s_delay = 0;
    c_delay = 0;

    % FIR low-pass filters
    b_lpf = fir1(N_sym, w);   % LPF taps
    b_loop = fir1(N_sym, w/2);% Loop filter taps
    zf_i = zeros(N_sym, 1);   % State vector for I filter
    zf_q = zeros(N_sym, 1);   % State vector for Q filter
    zf_vco = zeros(N_sym, 1); % State vector for loop filter


    I_lpf = Q_lpf = 0;
    I_lim = Q_lim = 0;
    I_mix = Q_mix = 0;
    v_sum = v = 0;

    I = [];
    Q = [];
    vco = [];

    for i=1:N

        % VCO
        w0 = 2*pi*(w + alpha*v);
        s_delay = s;
        c_delay = c;
        s = s * cos(w0) + c_delay * sin(w0);
        c = c * cos(w0) - s_delay * sin(w0);

        % Phase detector
        I_pd = y(i) * s;
        Q_pd = y(i) * c;

        % Low-pass filters
        [I_lpf, zf_i] = filter(b_lpf, 1, I_pd, zf_i);
        [Q_lpf, zf_q] = filter(b_lpf, 1, Q_pd, zf_q);

        % Limiters
        I_lim = sign(I_lpf);
        Q_lim = sign(Q_lpf);

        % Symbol removal
        I_mix = Q_lpf * I_lim;
        Q_mix = I_lpf * Q_lim;

        % Add I and Q paths
        v_sum = Q_mix - I_mix;

        % Loop filter
        [v, zf_vco] = filter(b_loop, 1, v_sum, zf_vco);

        % Output vectors
        I = [I I_lpf];
        Q = [Q Q_lpf];
        vco = [vco v];

    end

    % Convert to binary
    data = [];
    %for i=1:(length(I_sym))
    %    d_i=0;d_q=0;

    %    if I_sym(i)>0
    %        d_i = 1;
    %    end;
    %    if Q_sym(i)>0
    %        d_q = 1;
    %    end;

    %    data = [data d_i d_q];
    %end
end
