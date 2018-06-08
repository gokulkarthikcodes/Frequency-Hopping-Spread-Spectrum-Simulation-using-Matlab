clc
clear

% Generation of Sample bits
sequence=round(rand(1,20));    % Generating 20 bits
input_signal=[];                 % input signal declaration                
carrier_signal=[];               % carrier signal declaration  
time=[0:2*pi/119:2*pi];          % Number of samples - Creating a vector of 120 total values including end point [0:0.052:6.28]  


for k = 1 :20
    if sequence(1,k)==0
        sig=-ones(1,120);    % -1 value for binary input 0
    else
        sig=ones(1,120);     % +1 value for binary input 1
    end
    c=cos(time);             % Carrier frequency is calculated.  
    carrier_signal = [carrier_signal c];  %signal that is generated which will transmitted with input signal
    input_signal = [input_signal sig];    %Original signal to be transmitted
end



figure(1)
subplot(4,1,1);               
plot(input_signal);    % Plotting input signal
axis([-100 2400 -1.5 1.5]);   
title('\bf\it Original 20 bit Sequence');

% BPSK Modulation of the signal
bpsk_mod_signal=input_signal.*carrier_signal;   % Modulating the signal
subplot(4,1,2);   
plot(bpsk_mod_signal);  %Plotting BPSK Modulated signal
axis([-100 2400 -1.5 1.5]);
title('\bf\it BPSK Modulated Signal');

% Preparation of 6 new carrier frequencies
%6 frequencies are randomly selected by the PN sequence generator
time1=[0:2*pi/9:2*pi];  %[0:0.698:6.28]
time2=[0:2*pi/19:2*pi]; %[0:0.331:6.28]
time3=[0:2*pi/29:2*pi]; %[0:0.217:6.28]
time4=[0:2*pi/39:2*pi]; %[0:0.161:6.28]
time5=[0:2*pi/59:2*pi]; %[0:0.106:6.28]
time6=[0:2*pi/119:2*pi];%[0:0.052:6.28]
carrier1=cos(time1);
carrier1=[carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1 carrier1];
carrier2=cos(time2);
carrier2=[carrier2 carrier2 carrier2 carrier2 carrier2 carrier2];
carrier3=cos(time3);
carrier3=[carrier3 carrier3 carrier3 carrier3];
carrier4=cos(time4);
carrier4=[carrier4 carrier4 carrier4];
carrier5=cos(time5);
carrier5=[carrier5 carrier5];
carrier6=cos(time6);

% Random frequency hopps to form a spread signal
spread_signal=[];
for n=1:20
    c=randi([1 6],1,1);     %6 frequencies are randomly are selected by the PN generator
    switch(c)
        case(1)
            spread_signal=[spread_signal carrier1];
        case(2)
            spread_signal=[spread_signal carrier2];
        case(3)
            spread_signal=[spread_signal carrier3];
        case(4)
            spread_signal=[spread_signal carrier4];
        case(5)        
            spread_signal=[spread_signal carrier5];
        case(6)
            spread_signal=[spread_signal carrier6];
    end
end
subplot(4,1,3)
plot([1:2400],spread_signal);
axis([-100 2400 -1.5 1.5]);
title('\bf\it Spread Signal with 6 frequencies');

% Spreading BPSK Signal
freq_hopped_sig=bpsk_mod_signal.*spread_signal;    %This is the signal which is being finallay transmitted
subplot(4,1,4)
plot([1:2400],freq_hopped_sig);
axis([-100 2400 -1.5 1.5]);
title('\bf\it Frequency Hopped Spread Spectrum Signal');      

% Demodulation of BPSK Signal
bpsk_demodulated=freq_hopped_sig./spread_signal;        %The received signal is FFH demodualted
figure(2)
subplot(2,1,1)
plot([1:2400],bpsk_demodulated);
axis([-100 2400 -1.5 1.5]);
title('\bf Demodulated BPSK Signal from Wide Spread');

original_BPSK_signal=bpsk_demodulated./carrier_signal;     %FFH demodulated signal is data demodulated by means of BPSK Signal 
subplot(2,1,2)
plot([1:2400],original_BPSK_signal);
axis([-100 2400 -1.5 1.5]);
title('\bf Transmitted Original Bit Sequence');