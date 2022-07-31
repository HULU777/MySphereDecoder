% compare minimum distance with SVC-ST codes in 2022
% Change the coding matrix to ZC-based matrix
% When Hadamard matrix was applied, normalizing codewords P=1 and sparse signal
% power=1 is the same.
% clear all;
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = 64; B = Nt;
Nr = 15; n = Nr;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    QAM = 4; B1 = 9; L =1; B0 = 5;
    [A, D] = SVC_ST(n, QAM, B1, M ,L , b0);
    rxSymbs = zeros(Nr,1); % H*txSymbs;
    
    % Threshold D
%     [mindproperty,~,~] = calculateED(A,0,1);

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
     filename = "bm2022_B"+B+"M"+M+".dat";
     writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
