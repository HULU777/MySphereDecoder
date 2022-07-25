function [mindproperty,distance,distance_eachpoint] = calculateED(matrix,P,countdmin)   % ,table  dmatrix  ,P
% calculate the Euclidean mind of a given codebook  
% when P = 1, averge symbol power  = 1,
% calculate the dmin of codebook of EsNo=1 (No=1,Es = EsNo)
% countdmin=1: only give dmin and Admin
    [~,N] = size(matrix);
    
    % normalize the average power of codeword to P=n
    % thus, total codebook power is nN. 
    if P > 0
        Cpower = sum(sum(real(matrix).^2))+ sum(sum(imag(matrix).^2));   
        nM = matrix./ sqrt(Cpower/(P*N));    % normMatrix  n*N
    else
        nM = matrix;
    end

    
%     nM=matrix;
    distance_eachpoint = zeros(N,N-1);
    for n = 1:N
        points = [1:(n-1),(n+1):N];
        for j = 1: N-1
            d1 = nM(:,n)-nM(:,points(j));
            distance_eachpoint(n,j) = norm(d1);
        end
    end
%     dmatrix = tril(distance_eachpoint,-1);
    distance = reshape(distance_eachpoint,1,[]);
    if countdmin ==1
        dmin = min(distance);
        mindproperty(1,1) = dmin;
        distancefindAdmin = round(distance*10000);
        dmin10000 = round(dmin*10000);
        mindproperty(1,2) = length(find(distancefindAdmin  == dmin10000)); 
    else 
        distance = round(100000*distance);
        distancetable = tabulate(distance);
        dmincountidx = find(distancetable(:,2));
        mindproperty =  distancetable(dmincountidx,[1,2]);
        mindproperty(:,1) = mindproperty(:,1)/100000;
    end
    distance = reshape(distance/100000,N,N-1);
%     disp('mind:'); disp(mindproperty(1,1));
end
        
