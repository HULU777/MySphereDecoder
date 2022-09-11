% compare minimum distance with 2019 Quasi-Othogonal SPARC
% Change the coding matrix to ZC-based matrix
% how to normalize snr?
% clear all;
% Benchmark2019_B"+B+"M"+M+"L"+L+".dat :  n=42
addpath('Functions'); 
M=3;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = 16; B = Nt;
Nr = 11; n = Nr;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    lengthM = 17; samples = 2; L =1; 
    [A,D] = ZCmatrix(lengthM,B/L,L,B,n,samples);
    rxSymbs = zeros(Nr,1); % H*txSymbs;

    MPPM = MPPMset(B,1,M) * sqrt(1/M);
    C = A * MPPM;
    dmatrix = calculateDmatrix(C,0);  
    
    % write nodelist and nodeweight to a txt file
    [nodelist, nVistedNodes] = SD_searchpair(A/sqrt(n),rxSymbs,moduTypes,M,D*1.5);  % 
%      nodeset = getNodeset(B,M);
%      v = size(nodeset,1);
%      nodeset_new = zeros(2*size(nodelist{:,3},1),1);
%      nodelistpair = [nodelist{:,3}(:,1:M);nodelist{:,3}(:,M+1:2*M)];
%      for vv = 1:v
%          idx =find(ismember(nodelistpair,nodeset(vv,:),'rows')==1);
%          nodeset_new(idx) = vv;
%      end
%      nodeset_new = reshape(nodeset_new,[],2);
%      nodeset_w = [(1:v)', ones(v,1)];
%      p = size(nodelist{:,3},1);
%      tobewritten = [nodeset_w; nodeset_new];
%      filename = "Benchmark2019_B"+B+"M"+M+"L"+L+".dat";
%      writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
