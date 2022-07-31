function [PPMdmin,PPMAdmin] = PPMdmin(Z,L,ridx,EbNo)
    ppm = eye(Z);  %BIBD7(); Z is the number of sparse signals
    B = Z;
    signalset = zeros(B*L,Z^L);
    for ell = 1:L
        signalset(B*(ell-1)+1:B*ell, :) = repmat(kron(ppm,ones(1,B^(L-ell))) , 1 , B^(ell-1) );
    end
    if size(ridx,1) ==1
        codebookfull = hadamards(signalset);
        codebook = codebookfull(ridx,:);
    else
        codebook = ridx*signalset;
    end
    [~,b] = size(codebook);
    if nargin > 3
        EbNo = 10^(EbNo/10);
        nNP = EbNo*log2(b); 
    else
        nNP = 0;
    end
    [mindproperty,~] = calculateED(codebook,nNP,1);
    PPMdmin = mindproperty(1,1);
    PPMAdmin = mindproperty(1,2);
end