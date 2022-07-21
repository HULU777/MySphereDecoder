% clear all;
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
% run = 2e6;
Nt = 5; B = Nt;
Nr = 4; n = Nr;
% moduTypes = {'3psk','3psk','3psk'}; %

% moduTypes = {'bpsk','bpsk','bpsk','bpsk'};
% Ks = ones(1,4);
% offsets = [0,1,2,3];
% Ms = [2,2,2,2];
% constls = genConstls(moduTypes);
qam16 = 0;
% bits per symbol for each antenna


tic
for i = 1:length(SNR)
    %generate msg bits
%     tic
    j = 0;
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

        % coding matrix: 
        A = randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));     % complex

        rxSymbs = zeros(Nr,1); % H*txSymbs;
        [mindproperty,~,~] = calculateED(A,0,1);
        MPPM = MPPMset(B,1,M) * sqrt(1/M);
        C = A * MPPM;
        dmatrix = calculateDmatrix(C,0) ;

        [nodelist, nVistedNodes] = SD_searchpair(A,rxSymbs,moduTypes,M,mindproperty(1,1));
        
        % write nodelist  to a txt file
         % add node indices and weight
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
         filename = "B"+B+"M"+M+".dat";
         writematrix(tobewritten,filename,'Delimiter',' ')
end
toc

function set = getNodeset(B,M)
    idx_pair1 = nchoosek(1: B,M);
    idx_pair1 = B + 1 - idx_pair1;
    set = sum(2.^(idx_pair1-1),2);
%     set = sort(set);
end
