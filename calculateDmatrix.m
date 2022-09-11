function distance_eachpoint = calculateDmatrix(matrix,P)   % ,table  dmatrix  ,P
% calculate the Euclidean mind of a given codebook  
% when P = 1, averge symbol power  = 1,
% calculate the dmin of codebook of EsNo=1 (No=1,Es = EsNo)
% countdmin=1: only give dmin and Admin
    [n,N] = size(matrix);
    
    % normalize the average power of codeword to P=n
    % thus, total codebook power is nN. 
    if P > 0
        Cpower = sum(sum(real(matrix).^2))+ sum(sum(imag(matrix).^2));   
        nM = matrix./ sqrt(Cpower/(P*N));    % normMatrix  n*N
    else
        nM = matrix./sqrt(n);
    end
    Cpower1 = sum(sum(real(nM).^2))+ sum(sum(imag(nM).^2));  
    
%     nM=matrix;
    distance_eachpoint = zeros(N,N);
    for n = 1:N
%         points = [1:(n-1),(n+1):N];
        for j = 1: N
            d1 = nM(:,n)-nM(:,j);
            distance_eachpoint(n,j) = norm(d1);
        end
    end
end
        
