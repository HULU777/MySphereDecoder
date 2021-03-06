% clear all; 
% M= 5;
% Esett = [-1 0 0 1 -1 0 0 0 1];
% %     0 0 0 -1 -1 1 1 0 0;
% %     0 1 -1 0 0 0 0 0 0;];
% a = cell(1,2);
% [a{1}, a{2}] = getNodesPairIndexs(Esett',M);

function [pairnum, pairIdx] = getNodesPairIndex(E,M)  % from down to up
% K = size(Eset,2);
% [0 0 0 0 0 0 1 1 0 ] = 6
% j = 1;
% for k = 1: K
%     E = Eset(:,k); % {k}; reverse ?
%     E1 = E;
%     E = flip(E);
    idx1 = find(E == 1);
    idx_1 = find(E == -1);
    assert(length(idx1)==length(idx_1),"wrong number of -1 and 1 in the error vector")
    idx0 = find(E == 0);
    m = length(idx1);
    if M-m ==0
        idx_pair1 = 0;
        a = 0;
    else
        idx_pair1 = nchoosek(idx0,M-m);
        a = sum((1.1).^(idx_pair1-1),2);
    end
    pairnum = size(idx_pair1, 1);
    pairIdx = zeros(pairnum,2);
    pairIdx(1: pairnum, 1) =  sum((1.1).^(idx1-1)) + a;
    pairIdx(1: pairnum, 2) =  sum((1.1).^(idx_1-1)) + a;
end
% end