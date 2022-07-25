function signalset = MPPMset(B,L,M)
    pSize = 1;
    idx = nchoosek(1:B,M);
    mppm = zeros(B,size(idx,1));
    for i = 1: size(idx,1)
        mppm(idx(i,:),i) = 1;
    end
    if L > 1
        signalset = zeros(B*L,pSize*Z^L);
        for p = 1:pSize
            for ell = 1:L
                signalset(B*(ell-1)+1:B*ell, (p-1)*Z^L+1 : p*Z^L) = repmat(kron(mppm(:,(p-1)*Z+1:p*Z),ones(1,B^(L-ell))) , 1 , B^(ell-1) );
            end
        end
    else
    signalset = mppm;
    end
end