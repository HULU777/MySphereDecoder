% CWC generate
% Change the coding matrix to ZC-based matrix
% how to normalize snr?
clear all;
addpath('Functions'); 
parameter = [3^5, 9, 6, 4];  %  21,4,7
% parameter = [1,9,
B=parameter(2);
d1=parameter(3);  % #nonzeros  EB/N0 in dB
M=parameter(4);
SNR = 25;   % dB
Nt = B;
Nr = Nt;
n = B;
L=1;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    A = eye(B);   
    D = sqrt(d1/M- 1e-6);
%     D = d1;
    rxSymbs = zeros(Nr,1); % H*txSymbs;
    
    % Threshold D
%     [mindproperty,~,~] = calculateED(A,0,1);

    % write nodelist and nodeweight to a txt file
    [nodelist, nVistedNodes] = SD_searchpair(A,rxSymbs,moduTypes,M,D);
%      nodeset = getNodeset(B,M);
%      v = length(nodeset);
%      nodeset_new = zeros(size(nodelist{:,3}));
%      for vv = 1:v
%          idx = find(nodelist{:,3} == nodeset(vv));
%          nodeset_new(idx) = vv;
%      end
     nodelist = orderDistance(nodelist);
%     d = nodelist{1};
%     dnum = nodelist{2};
    pair = nodelist{3};
%     b = find( d > d1, 1 );
    nodeset_new = [];
    v = nchoosek(B,M);
    for bb = 1:size(pair,1)% b
        pair1 = pair{bb};
        nodeset_new = [nodeset_new; pair1{:}];
    end
    nodeset_w = [(1:v)', ones(v,1)];
    p = size(nodeset_new,1);
    tobewritten = [nodeset_w; nodeset_new];
    filename = "CWC_B"+B+"M"+M+"L"+L+"_debugC++.dat";
    writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
