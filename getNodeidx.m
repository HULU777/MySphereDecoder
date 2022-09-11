% getNodesets(B,M)
function nodeset_new = getNodeidx(B,M,nodespair)
    idx_pair1 = nchoosek(1: B,M);
    nodelistpair = [nodespair(:,1:M);nodespair(:,M+1:2*M)];
    nodeset_new = zeros(size(nodelistpair,1),1);
     for vv = 1:size(nodelistpair,1)
         [~, ia, ~] =  intersect(idx_pair1,nodelistpair(vv,:),'rows');
         nodeset_new(vv) = ia;
     end
     nodeset_new = reshape(nodeset_new,[],2);
%     primelist = primes(800);
%     prime_pair1 = primelist(idx_pair1);
%     set = sum(1./(prime_pair1),2);  
end