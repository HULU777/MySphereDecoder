function [nodelists, nVistedNodes] = SD_searchpair(H,rxSymbs,moduTypes,M,D)
% [out,nVistedNodes] = nrSphereDecoder(H,rxSymbs,moduTypes,outType) uses sphere decoding algorithms
% (single tree seach)for seeking the maximum-likelihood solution 
%  for a set of symbols transmitted over the MIMO channel. 
% Input:
%   H - channel matrix Nr X Nt
%   rxSymbs - received symbols: Nr X 1
%   moduTypes - nodulation for each tx antenna in a cell array of 1 X Nt
%   outType - 'soft' or 'hard'
% Output:
%   out - soft bits or hard bits output, soft bits (not sacled by 1/N0)
%   nVistedNodes - number of leaf nodes traversed
% source paper: 
%   "Soft-Output Sphere Decoding: Performance and Implementation Aspects"
% Author: Dr J Mao
% Email: juquan.justin.mao@gmail.com
% 2021 Nov
%--------------------------------------------------------------------------

    [Nr,Nt] = size(H);
    assert(Nr == length(rxSymbs));
    
    % get constllation cell array, 
    % first row: number of bits per symbol 
    % 2nd row: constllation symbols
    % 3rd row: constllation bitLabels
    constls = genConstls(moduTypes,M);
    
    
    if Nr >= Nt
        % QR decomposition of H
        [Q, R] = qr(H,0);
        Qy = Q'*rxSymbs;   %Q^H*y
        lambda = 0;
    else
        % transform to full-rank
        lambda = 0.0001;
        n = max(size(H));
        ATA = H' * H + lambda * eye(n);
        R = chol(ATA);
%         D = chol(ATA);
%         [Q, R] = qr(D,0);
        Qy = R' \ H' * rxSymbs;   % inv(R' ) * H' * rxSymbs;
    end
    
    % hypothesis minimum distances for ML bits and its counterpart
    lambdaML = D^2+lambda*Nt/M;
    % intinitalize patial symbol vector of the visiting node & PD
    % start form the root
    psv = constls{2,Nt}(1);
    psvIdx = 1;
    psvBitLabels = constls{3,Nt}(1,:);
    ped = zeros(1,Nt);
    count1 = zeros(1,Nt+1);
    count1(Nt) = 1;
    count_1 = zeros(1,Nt+1);
    traverseDone = false;
    nVistedNodes = 0;
    nodelists = cell(1,3);
%     nodelistnum = 0;
    while (~traverseDone)
        curLevl = Nt - length(psv) +1;
%         if curLevl ==5
%             disp(curLevl);
%         end
        % compute distance increment  !!!
        di = abs(Qy(curLevl) -  sum(R(curLevl,curLevl:Nt).*psv)).^2;
%         di = norm(Qy(curLevl) -  sum(R(curLevl,curLevl:Nt).*psv));
    
        % compute partial Euclidean distance
        if curLevl == Nt
            ped(curLevl) = di;
        else
            ped(curLevl) = ped(curLevl +1) + di;
        end
    
        if curLevl == 1 % leaf node
            nVistedNodes = nVistedNodes + 1;
            if ped(curLevl) < lambdaML && count1(curLevl)==count_1(curLevl) && count1(curLevl) <= M%smaller euclidean 
                bitsML = psvBitLabels;   % ???
                if ~isempty(find(bitsML))
                    nodelist{1} = ped(curLevl);
                    [nodelist{2},nodelist{3}] = getNodesPairIndex(bitsML,M);
                    nodelists{1} = [nodelists{1}; nodelist{1}];
                    nodelists{2} = [nodelists{2}; nodelist{2}];
                    nodelists{3} = [nodelists{3}; nodelist{3}];
                end
            end 
            % go to next node (right or up)
            [psvIdx,psv,psvBitLabels,traverseDone,count1,count_1] = moveToNextNode(psvIdx,psv,psvBitLabels,constls,count1,count_1);

        else % none leaf node
            aa1 = max(count1(curLevl),count_1(curLevl)) > M;
            aa2 = abs(count1(curLevl)-count_1(curLevl)) >= curLevl;
            if ped(curLevl) >= lambdaML || aa1  || aa2%  ped > search radius, prune subtree
                % go to next node (right or up)
                [psvIdx,psv,psvBitLabels,traverseDone,count1,count_1] = moveToNextNode(psvIdx,psv,psvBitLabels,constls,count1,count_1);
            else % go down a level
                psvIdx = [1, psvIdx];
                psv = [constls{2,curLevl-1}(1),psv]; % add a symbol to left
                psvBitLabels = [constls{3,curLevl-1}(1,:),psvBitLabels]; % add the corresponding bit to the left
                count1(curLevl-1) = count1(curLevl) +1;
                count_1(curLevl-1) = count_1(curLevl);
            end
        end
    end
end

function [psvIdx,psv,psvBitLabels,traverseDone,count1,count_1] = moveToNextNode(psvIdx,psv,psvBitLabels,constls,count1,count_1)
    % Move to the right node of the same level if symbol idx < M. Else
    % go up.

    Nt = size(constls,2);
    curLevl = Nt - length(psvIdx) +1;
    while 1
        if psvIdx(1) < constls{1,curLevl} && ~(psvIdx(1) ==2 && count1(curLevl+1) ==0)
            psvIdx(1) = psvIdx(1) + 1;
            psv(1) = constls{2,curLevl}(psvIdx(1));
            psvBitLabels(1)= constls{3,curLevl}(psvIdx(1),:);
%             psvBitLabels(1:constls{1,curLevl}) = constls{3,curLevl}(psvIdx(1),:);
% %             assert(sum(psvBitLabels-psv) == 0,"psvBitLabels!=psv")
%             if curLevl==5
%                 count1(curLevl) = constls{4,curLevl}(psvIdx(1));
%                 count_1(curLevl)  =  constls{5,curLevl}(psvIdx(1));
%             else
                count1(curLevl) = count1(curLevl+1)  + constls{4,curLevl}(psvIdx(1));
                count_1(curLevl)  = count_1(curLevl+1)  + constls{5,curLevl}(psvIdx(1));
%             end
            traverseDone = false;
            return;
        else
            if curLevl == Nt
                traverseDone =  true;
                return;
            else % up a level
                psvIdx(1) = [];psv(1) = [];
                psvBitLabels(1)= [];
                curLevl = curLevl+1;
            end

        end
    end
end

function constls = genConstls(moduTypes,MM)
% constls = genConstls(moduTypes) output the constellation info of a cell
% list of moduTypes.
% example
%moduTypes = {'qpsk','qpsk','16QAM'};
% constls = genConstls(moduTypes)

    constls = cell(5,length(moduTypes));
    for i = 1: length(moduTypes)
        moduType = moduTypes{i};
        switch lower(moduType)
        case '3psk'
            M =3;
        case 'bpsk'
            M =2;
        case 'qpsk'
            M = 4;
        case '16qam'
            M = 16;
        case  '64qam'
            M = 64;
        case '256qam'
            M = 256;
        end
        
        if strcmp(moduType,'3psk')
            constls{1,i} = 3;
            bitLabels = [1;0;-1];
            constls{3,i} = bitLabels;

            symbBitsIn = bitLabels.';
            constSymbs = nrModuMapper(symbBitsIn(:),lower(moduType),MM);

            constls{2,i} = constSymbs;
            constls{4,i} = [1;0;0];   % count 1
            constls{5,i} = [0;0;1];   % count -1
        else
            K = log2(M);
            constls{1,i} = K;

            bitLabels = de2bi(0:M-1,'left-msb');
            constls{3,i} = bitLabels;

            symbBitsIn = bitLabels.';
            constSymbs = nrModuMapper(symbBitsIn(:),lower(moduType));

            constls{2,i} = constSymbs;
        end
    end
end
