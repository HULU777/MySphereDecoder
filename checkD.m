% check mind after vertex cover algorithm
% filenamecheck = "B"+B+"M"+M+'.txt';
filenamecheck = "okk.txt";
data = importdata(filenamecheck) ;  
nonzeroidx = data(:,1) ;
L = 1;
remainedMPPM = MPPMset(B,L,M,nonzeroidx);
codebook = A*remainedMPPM * sqrt(1/M);
[mindproperty,~,~] = calculateED(codebook,0,1) ;
mindproperty(1,1)