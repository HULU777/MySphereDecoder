% compare minimum distance with SVC-ST codes in 2022
% Change the coding matrix to ZC-based matrix
% When Hadamard matrix was aline 36pplied, normalizing codewords P=1 and sparse signal
% power=1 is the same.
clear all;
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB
SNR = 25;   % dB
Nt = 128; B = Nt;  % 512:9bit but maybe C_128^2 = 8128 is not enough for 9bits
Nr = 15; n = Nr;

tic
for i = 1:length(SNR)
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix:   randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));
    QAM = 4; B1 = 5; L =1; b0 = 3;
    [~, D] = SVC_ST(n, QAM, B1, M ,L , b0);   % using partial Hadamard matrix
%     D = 0.2;
    A = rand(n,B)>0.5;
    A = -1*A;
    A(A==0) = 1;
    rxSymbs = zeros(Nr,1); % H*txSymbs;
    
    % Threshold D
%     [mindproperty,~,~] = calculateED(A,0,1);


% MPPMd
    MPPM = MPPMset(B,1,M) * sqrt(1/M);
    C = A * MPPM;
    dmatrix = calculateDmatrix(C,0);  % 
%     MPPMsetsize = size(dmatrix,1);
% % 
% %     % MPPM node pairs
%     pairidx_linear = find(dmatrix< D);
%     [pairidx_row,pairidx_col] = ind2sub(size(dmatrix),pairidx_linear);
%     pairidx_no = find(pairidx_row ~= pairidx_col);
% %     pairdebug = [pairidx_row(pairidx_half_idx),pairidx_col(pairidx_half_idx )];
%     pair_idx_bf = sub2ind(size(dmatrix),pairidx_row(pairidx_no), pairidx_col(pairidx_no));


    % write nodelist and nodeweight to a txt file
    [nodelist, nVistedNodes] = SD_searchpair(A/sqrt(n),rxSymbs,moduTypes,M,sqrt(1.1)*D);
     nodeset = getNodeset(B,M);
     v = length(nodeset);
     nodeset_new = zeros(size(nodelist{:,3}));
     for vv = 1:v
         idx = find(nodelist{:,3} == nodeset(vv));
         nodeset_new(idx) = vv;
     end
     aaaa = find(nodeset_new(:,1) == nodeset_new(:,2));
     if ~isempty(aaaa)
         disp(aaaa);
         error("same nodes in a pair in main!");
     end
     nodeset_w = [(1:v)', ones(v,1)];
     
%      if ~isempty(nodeset_new)
%         pair_idx_SD = sub2ind(size(dmatrix),[nodeset_new(:,1); nodeset_new(:,2)],[nodeset_new(:,2);nodeset_new(:,1)]);
%      else
%          pair_idx_SD = [];
%      end
%      % comparison
%     set = ismember(pair_idx_bf,pair_idx_SD);
%     set_diff = setdiff(pair_idx_bf,pair_idx_SD);
%     if ~isempty(set_diff)
%         if all(set)   % if not all 1
% %             disp('SD > BF');
%             subset = subset+1;
%         else
%             wrong = wrong +1;
%         end
%     end
     p = size(nodelist{:,3},1);
     tobewritten = [nodeset_w; nodeset_new];
     filename = "bm2022_B"+B+"M"+M+".dat";
     writematrix(tobewritten,filename,'Delimiter',' ')
end
toc
