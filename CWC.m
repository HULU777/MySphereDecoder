% CWC generate
% Change the coding matrix to ZC-based matrix
% how to normalize snr?
% clear all;
addpath('Functions'); 
parameter = [3^5, 9, 6, 4];
B=parameter(2);
M=parameter(3);
d1=parameter(4);  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = B;
n = B;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    A = eye(B);   
    D = sqrt(d1) - 1e-6;
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
     filename = "CWC_B"+B+"M"+M+".dat";
     writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
