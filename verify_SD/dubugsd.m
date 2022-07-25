clear all;
addpath('Functions');
load('debugSD.mat');


tic
% ==================================================================
outType = 'hard';
[out,nVistedNodes] = nrSphereDecoder(H,rxSymbs,moduTypes,outType);
nErrs = sum(out ~= msg) 
t = toc;






