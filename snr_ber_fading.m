% MATLAB Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel and compred to AWGN Channel

% Clear all the previously used variables
clear all;
 
format long;

% Frame Length
bit_count = 10000;

%Range of SNR over which to simulate
SNR = 0: 1: 40;

% Start the main calculation loop
for aa = 1: 1: length(SNR)
    
    % Initiate variables
    T_Errors = 0;
    T_bits = 0;
    
    % Keep going until you get 100 errors
    while T_Errors < 100
    
        % Generate some random bits
        uncoded_bits  = round(rand(1,bit_count));

        % BPSK modulator
        tx = -2*(uncoded_bits-0.5);
    
        % Noise variance
        N0 = 1/10^(SNR(aa)/10);
        
        % Rayleigh channel fading
        h = 1/sqrt(2)*[randn(1,length(tx)) + j*randn(1,length(tx))]; 

        % Send over Gaussian Link to the receiver
        rx = h.*tx + sqrt(N0/2)*(randn(1,length(tx))+i*randn(1,length(tx)));
        
%---------------------------------------------------------------

        % Equalization to remove fading effects. Ideal Equalization
        % Considered
        rx = rx./h;
        
        % BPSK demodulator at the Receiver
        rx2 = rx < 0;
    
        % Calculate Bit Errors
        diff = uncoded_bits - rx2;
        T_Errors = T_Errors + sum(abs(diff));
        T_bits = T_bits + length(uncoded_bits);
        
    end
    % Calculate Bit Error Rate
    BER(aa) = T_Errors / T_bits;
    disp(sprintf('bit error probability = %f',BER(aa)));

end
  
%------------------------------------------------------------

% Finally plot the BER Vs. SNR(dB) Curve on logarithmic scale 
% Calculate BER through Simulation

% Rayleigh Theoretical BER
SNRLin = 10.^(SNR/10);
theoryBer = 0.5.*(1-sqrt(SNRLin./(SNRLin+1)));

% Start Plotting
% Rayleigh Theoretical BER
figure(1);
semilogy(SNR,theoryBer,'-','LineWidth',2);
hold on;

% Simulated BER
figure(1);
semilogy(SNR,BER,'or','LineWidth',2);
hold on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR Vs BER plot for BPSK Modualtion in Rayleigh Channel');


% Theoretical BER
figure(1);
theoryBerAWGN = 0.5*erfc(sqrt(10.^(SNR/10)));
semilogy(SNR,theoryBerAWGN,'blad-','LineWidth',2);
legend('Rayleigh Theoretical','Rayleigh Simulated', 'AWGN Theoretical');
axis([0 40 10^-5 0.5]);
grid on;
