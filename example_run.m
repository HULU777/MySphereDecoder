clear all;
addpath('Functions');
% EBN0dB=-2:2:6;     
M=2;  % EB/N0 in dB
% SNR=EBN0dB+10*log10(2);   % QPSK
SNR = 5:5:35;   % dB
% targeterr = [0.3 0.2 0.1 0.03 0.003 0.0004 0.00003 ];
% run = ceil(50 ./ targeterr);
run = ones(1,length(SNR))*2e4;
nErrs = zeros(1,length(SNR));
nErrs1 = zeros(1,length(SNR));
nDiff = zeros(1,length(SNR));
% run = 2e6;
Nt = 5; B = Nt;
Nr = 2; n = Nr;
% moduTypes = {'3psk','3psk','3psk'}; %

% moduTypes = {'bpsk','bpsk','bpsk','bpsk'};
% Ks = ones(1,4);
% offsets = [0,1,2,3];
% Ms = [2,2,2,2];
% constls = genConstls(moduTypes);
qam16 = 0;
% bits per symbol for each antenna


tic
parfor i = 1:length(SNR)
    %generate msg bits
    tic
    j = 0;
    while j < run(i)
        if qam16
            moduTypes = {'16qam','16qam','16qam','16qam'};
            Ks = [4,4,4,4];
            offsets = [0,4,8,12];
            Ms = [16,16,16,16];
        end
    cellA={'qpsk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);
    offsets = 0:2:(Nt-1)*2;
    Ms = 4* ones(1,Nt);
%     len = 2*Nt;
    % number bits to transform
    totBits = sum(Ks);
    msg = randi([0,1],totBits,1);  % ones(B,1);
%     msg = [0,0,0,1,1,0,1,1]';
    % modulation
    txSymbs = zeros(Nt,1);   % msg; 
    for it = 1: Nt
        txSymbs(it) =  nrModuMapper(msg(offsets(it) + (1: Ks(it))),moduTypes{it});
    end
    
    snr = 10.^(SNR(i)/10);
    Es = (sum(real(txSymbs).^2)+sum(imag(txSymbs).^2))/Nt; % sum(real(txSymbs(1))^2+imag(txSymbs(1))^2);
%     Es=2;    
    N0 = Es/snr;

    %flat channel: 
    H = sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));     % complex
    % H = randn(Nr,Nt);  % real
    H = H/sqrt(Nt);  % ???
    
    rxSymbs = H*txSymbs;
%     (sum(real(rxSymbs).^2)+sum(imag(rxSymbs).^2))
    % noise
    noise =sqrt(N0/2)*(randn(Nr,1)+ 1j* randn(Nr,1));
%     (sum(real(noise).^2)+sum(imag(noise).^2))
    rxSymbs = rxSymbs + noise;
    
    if qam16
        msg = t16to4(msg);
        H = [sqrt(2)*H, sqrt(2)/2*H];
        moduTypes = {'qpsk','qpsk','qpsk','qpsk','qpsk','qpsk','qpsk','qpsk'};
    end
    
    % ==================================================================
    outType = 'hard';
    [out,nVistedNodes] = nrSphereDecoder(H,rxSymbs,moduTypes,outType);
%     dec_seq = fpSD(H,rxSymbs,N0);
    nErrs(i) = sum(out ~= msg) + nErrs(i);
%     nErrs1(i) = sum(dec_seq' ~= msg) + nErrs1(i);
%     nDiff(i) = sum(out ~= dec_seq') + nDiff(i);
    j = j + 1;
    end
    tt = toc
end
t = toc;
BER = nErrs ./(Nt*M*run)
% BER1 = nErrs1/(length(msg)*run)
disp('Sim Results')
disp('------------------')
% fprintf("Tx Antennas:%d,Rx Antennas: %d \n", Nt,Nr);
fprintf('Modulations:')
% disp(moduTypes)

% fprintf('(SD) Error bits: %d out of %d\n',nErrs,length(msg) );
% fprintf(' - (Hard SD) %d of %d leaf nodes are visited.', nVistedNodes,prod(Ms) );
semilogy(SNR, BER,'-^');
% semilogy(EBN0dB, BER,'-^');
xlim([5,35]); 
ylim([1e-5,1]);
grid on;

% ==================================================================
% outType = 'soft';
% [outSoft,nVistedNodes] = nrSphereDecoder(H,rxSymbs,moduTypes,outType);
% nErrs = sum((outSoft < 0) ~= msg);
% 
% %fprintf('(Soft SD)Error bits: %d out of %d\n',nErrs,length(msg) );
% fprintf(' - (Soft SD)%d of %d leaf nodes are visited\n',
% nVistedNodes,prod(Ms) );git
% 
% % ======================================================================
% % ZF
% eqSymbs = pinv(H)*rxSymbs;
% out(:) = 0.0;
% for i = 1 : Nt
%  out(offsets(i) + (1: Ks(i))) = nrSoftModuDemapper(eqSymbs(i),moduTypes{i},N0,'max-log-map');
% end
% nErrs = sum((out<0) ~= msg);
% fprintf('(ZF) Error bits: %d out of %d\n',nErrs,length(msg) );
% 
% % ======================================================================
% % MMSE
% eqSymbs = inv(H' * H + N0*eye(Nt))*H'*rxSymbs;
% for i = 1 : Nt
%  out(offsets(i) + (1: Ks(i))) = nrSoftModuDemapper(eqSymbs(i),moduTypes{i},N0,'max-log-map');
% end
% nErrs = sum((out<0) ~= msg);
% fprintf('(MMSE) Error bits: %d out of %d\n',nErrs,length(msg) );






