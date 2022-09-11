% check mind after vertex cover algorithm
% for MPPM, power normalization is not solved, so directly observe remainedMPPM
filenamecheck = "okk.txt";
% filenamecheck = "B"+B+"M"+M+'.txt';
data = importdata(filenamecheck); 
% data = zeros(nchoosek(16,2),1);
nonzeroidx = data(:,1) ;
L = 1;
[ppmD,~] = calculateED(A,1,1);
remainedMPPM = MPPMset(B,L,M,nonzeroidx);
codebook = A*remainedMPPM * sqrt(1/M);
[mindproperty,~,~] = calculateED(codebook,1,1) ;
mindproperty(1,1)