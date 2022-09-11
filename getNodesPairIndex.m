% % clear all; 
% M= 2;
% Esett = [0 -1 0 0 0 1 0 0 0];
% %     0 0 0 -1 -1 1 1 0 0;
% %     0 1 -1 0 0 0 0 0 0;];
% a = cell(1,2);
% [a{1}, a{2}] = getNodesPairIndexs(Esett,M);

function [pairnum, nodeset_new] = getNodesPairIndex(E,M)  % from down to up
% E : row vector

    idx1 = find(E == 1);
    idx_1 = find(E == -1);
    assert(length(idx1)==length(idx_1),"wrong number of -1 and 1 in the error vector")
    idx0 = find(E == 0);
    m = length(idx1);
%     pairIdx = zeros(pairnum,2);
%     primelist = primes(2000);  %256-2000    128-800
    if M-m == 0
%         idx_pair1 = [];
        pairnum = 1;
        pairIdx(1,1:M) =  sort( idx1,2  );
        pairIdx(1,M+1:2*M) = sort(idx_1,2);
%         a = 0;
%         else M-m == 1
%         idx_pair1 = idx0;
%         a = (1.1).^(idx_pair1-1);
    elseif M-m == 1
        idx_pair1 = idx0';  % column vector
        pairnum = size(idx_pair1, 1);
        pairIdx(1: pairnum,1:M) =  sort(  [idx_pair1,repmat(idx1,pairnum,1)],2  );
        pairIdx(1: pairnum,M+1:2*M) = sort(  [idx_pair1,repmat(idx_1,pairnum,1)],2  );
%         prime_pair1 = primelist(idx_pair1); % row vector
%         a = 1./(prime_pair1'); % column vector
        % a = a';
    else
        idx_pair1 = nchoosek(idx0,M-m);  
        pairnum = size(idx_pair1, 1);
        pairIdx(1: pairnum,1:M) =  sort(  [idx_pair1,repmat(idx1,pairnum,1)],2  );
        pairIdx(1: pairnum,M+1:2*M) = sort(  [idx_pair1,repmat(idx_1,pairnum,1)],2  );
%         prime_pair1 = primelist(idx_pair1);
%         a = sum(1./(prime_pair1),2);   % sum row vector
    end
    if pairIdx(1,1) > pairIdx(1,2) || pairIdx(1,2) > pairIdx(1,3) || pairIdx(1,1) > pairIdx(1,3)
        disp(M);
    end
    
     nodeset_new = getNodeidx(length(E),M,pairIdx);
%     prime1 = primelist(idx1);
%     prime_1 = primelist(idx_1);
%     if pairnum ~= size(a,1)
%         disp(a);
%     end
    
    
     
%     pairIdx(1: pairnum,1) =  sum(1./(prime1)) + a;
%     pairIdx(1: pairnum,2) =  sum(1./(prime_1)) + a;
%     aaa = find(pairIdx(:,1) == pairIdx(:,2));
%     if ~isempty(aaa)
%         disp(aaa);
%         error("same nodes in a pair in getNodesPairIndex");
%     end
    
%     nodeset = getNodeset(length(E),M);
%      v = length(nodeset);
%      nodeset_new = zeros(size(pairIdx));
%      for vv = 1:v
%          idx = find(pairIdx == nodeset(vv));
%          nodeset_new(idx) = vv;
%      end
     
%      aa = find(nodeset_new==0);
%      if ~isempty(aa)
%         disp(aa);
%         error("nodes didn't exist in a pair in getNodesPairIndex");
%     end
    
end
% end