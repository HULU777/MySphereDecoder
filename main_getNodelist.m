% clear all;
% save nodespairs with their distance
% then run main_iterateD.m: can choose those pairs with different distance
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = 5; B = Nt;
Nr = 4; n = Nr;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix: 
    A = randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));     % complex
    rxSymbs = zeros(Nr,1); % H*txSymbs;
    
    % Threshold D
    [mindproperty,~,~] = calculateED(A,0,1);

    % write nodelist and nodeweight to a txt file
    [nodelist, nVistedNodes] = SD_searchpair(A,rxSymbs,moduTypes,M,mindproperty(1,1));
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
     
% if count(py.sys.path,' ') == 0
%         insert(py.sys.path,int32(0),' ');
% end
% py.writemwvcfile.getmwvc(filename,v,p)  these 4 lines cannot work
end
toc
