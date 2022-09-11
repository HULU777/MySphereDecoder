d1  = 1.25;     
nodelist = orderDistance(nodelist);
d = nodelist{1};
dnum = nodelist{2};
pair = nodelist{3};
b = find( d > d1, 1 );
nodeset_new = [];
for bb = 1:b
    pair1 = pair{bb};
    nodeset_new = [nodeset_new; pair1{:}];
end

nodeset_w = [(1:v)', ones(v,1)];
p = size(nodeset_new,1);
tobewritten = [nodeset_w; nodeset_new];
filename = "Benchmark2019_B"+B+"M"+M+"L"+L+".dat";
writematrix(tobewritten,filename,'Delimiter',' ')