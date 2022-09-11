% read me:
% the newest version 20220911
% 1. run main_getNodelist.m
% 2. set d1 in main_iterateD.m: it will write pairs with distance less than d1
% to the file
% 3. open spyder, run writemwvcfile.py, get the .mwvc file
% 4. open vs2017, 
% compile: g++ mwvc.cpp -O3 --std=c++11 -o mwvc
% run: ./mwvc CWC_B9M4.mwvc 0 10 0