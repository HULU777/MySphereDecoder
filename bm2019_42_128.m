% compare minimum distance with 2019 Quasi-Othogonal SPARC
% Change the coding matrix to ZC-based matrix
% how to normalize snr?
% clear all;
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = 128; B = Nt;
Nr = 42; n = Nr;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    lengthM = 43; samples = 2; L =2; 
    [A,D] = ZCmatrix(lengthM,B/L,L,B,n,samples);
    rxSymbs = zeros(Nr,1); % H*txSymbs;

    % write nodelist and nodeweight to a txt file
    [nodelist, nVistedNodes] = SD_searchpair(A,rxSymbs,moduTypes,M,D);
     nodeset = getNodeset(B,M);
     v = length(nodeset);
     nodeset_new = zeros(size(nodelist{:,3}));
     for vv = 1:v
         idx = find(nodelist{:,3} == nodeset(vv));
         nodeset_new(idx) = vv;
     end
     nodeset_w = [(1:v)', ones(v,1)];
     p = size(nodelist{:,3},1);
     tobewritten = [nodeset_w; nodeset_new];
     filename = "Benchmark_B"+B+"M"+M+".dat";
     writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
