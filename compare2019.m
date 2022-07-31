close all; clear all;
countdmin = 0;
EbNoRangedB = -2:0.5:10;
BITS = 12;
% load('MPPMSPARC42_4096.mat');
% MScmatrix = cmatrix;
% MSmppm = xbestcl{9};
% 
% 
% [MSMPPM_dmin,MSMPPM_Admin,MSdminforUnitPower] = Dmin_for_EbNo(MScmatrix,MSmppm,L,EbNoRangedB,BITS,countdmin);
% disp('MSdminforUnitPower:'); disp(MSdminforUnitPower);
% MSPe = WEF(MSMPPM_dmin, MSMPPM_Admin,2^(BITS));
% semilogy(EbNoRangedB,MSPe); hold on;%  SNRrangedB


load('SVC(42,92,2,1,12)');
svcMPPM_dmin = MPPM_dmin; svcMPPM_Admin = MPPM_Admin; svcdminforUnitPower = dminforUnitPower;
disp('svcdminforUnitPower:'); disp(svcdminforUnitPower);
svcPe = WEF(svcMPPM_dmin, svcMPPM_Admin,2^(BITS));
semilogy(EbNoRangedB,svcPe); hold on;


load('ZCdmin9078.mat');
zcMPPM_dmin = MPPM_dmin;  zcMPPM_Admin = MPPM_Admin; zcdminforUnitPower = dminforUnitPower;
disp('zcdminforUnitPower:'); disp(zcdminforUnitPower);
zcPe = WEF(zcMPPM_dmin, zcMPPM_Admin,2^(BITS));
semilogy(EbNoRangedB,zcPe); hold on;
xlim([-2,10]); 
ylim([1e-5,1]);
legend('MPPM-SPARC(B=Z=4096,L=1,M=2)','SVC(B=9,Z=128,L=1,M=2)','ZCsequence-based(B=Z=64,L=2,M=1)');
title('Union bound on 2 different schemes at n=42,k=12.');