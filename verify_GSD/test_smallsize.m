clear all; close all;
addpath('Functions'); 
M=2;  % #nonzeros  EB/N0 in dB     % dB
run = 2e4;
randsize = 2+ ceil(rand(1,2)*16);
Nt = max(randsize); B = Nt;
Nr = min(randsize); n = Nr;
subset = 0;
wrong = 0;


tic
parfor i = 1:8
    for j = 1:run/8
    cellA={'3psk'};
    moduTypes = repmat(cellA,1,Nt);
    Ks = 2* ones(1,Nt);

    % coding matrix: 
    A = randn(Nr,Nt); % sqrt(1/2)*(randn(Nr,Nt) + 1j* randn(Nr,Nt));     % complex

    % H*txSymbs;
    rxSymbs = zeros(Nr,1); 

    % PPMd
    [mindproperty,~,~] = calculateED(A,0,1);
    D = mindproperty(1,1);

    % MPPMd
    MPPM = MPPMset(B,1,M) * sqrt(1/M);
    C = A * MPPM;
    dmatrix = calculateDmatrix(C,0);
    MPPMsetsize = size(dmatrix,1);

    % MPPM node pairs
    pairidx_linear = find(dmatrix< D);
    [pairidx_row,pairidx_col] = ind2sub(size(dmatrix),pairidx_linear);
    pairidx_no = find(pairidx_row ~= pairidx_col);
%     pairdebug = [pairidx_row(pairidx_half_idx),pairidx_col(pairidx_half_idx )];
    pair_idx_bf = sub2ind(size(dmatrix),pairidx_row(pairidx_no), pairidx_col(pairidx_no));

    % SD node pairs
    [nodelist, nVistedNodes] = SD_searchpair(A,rxSymbs,moduTypes,M,D);
     nodeset = getNodeset(B,M);
     v = length(nodeset);
     nodeset_new = zeros(size(nodelist{:,3}));
     for vv = 1:v
         idx = find(nodelist{:,3} == nodeset(vv));
         nodeset_new(idx) = vv;
     end
    
     pair_idx_SD = sub2ind(size(dmatrix),[nodeset_new(:,1); nodeset_new(:,2)],[nodeset_new(:,2);nodeset_new(:,1)]);
     
     % comparison
    set = ismember(pair_idx_bf,pair_idx_SD);
    set_diff = setdiff(pair_idx_bf,pair_idx_SD);
    if ~isempty(set_diff)
        if all(set)   % if not all 1
%             disp('SD > BF');
            subset = subset+1;
        else
            wrong = wrong +1;
        end
    end
    end
end
toc
subset
wrong

function set = getNodeset(B,M)
    idx_pair1 = nchoosek(1: B,M);
    set = sum((1.1).^(idx_pair1-1),2);  
end
