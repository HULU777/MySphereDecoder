function set = getNodeset(B,M)
    idx_pair1 = nchoosek(1: B,M);
    set = sum((1.1).^(idx_pair1-1),2);  
end