clear all; 
M= 5;
Esett = [-1 0 0 1 -1 0 0 0 1;
    0 0 0 -1 -1 1 1 0 0;
    0 1 -1 0 0 0 0 0 0;];
pair = getNodesPairIndexs(Esett',M);

function pairIdx = getNodesPairIndexs(Eset,M)  % from down to up
K = size(Eset,2);
pairIdx = zeros(1,2);
j = 1;
for k = 1: K
    E = Eset(:,k); % {k}; reverse ?
    idx1 = find(E == 1);
    idx_1 = find(E == -1);
    assert(length(idx1)==length(idx_1),"wrong number of -1 and 1 in the error vector")
    idx0 = find(E == 0);
    m = length(idx1);
    idx_pair1 = nchoosek(idx0,M-2*m);
    n = size(idx_pair1, 1);
    a = sum(2.^(idx_pair1-1),2);
    pairIdx(j : j+n-1,1) =  sum(2.^(idx1-1)) + a;
    pairIdx(j : j+n-1,2) =  sum(2.^(idx_1-1)) + a;
    j = j + n;
end
end