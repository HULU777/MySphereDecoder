function nodelist = orderDistance(nodelist)
d = nodelist{1};
dnum = nodelist{2};
pair = nodelist{3};
[d,idx] = sort(d);
dnum = dnum(idx);
pair = pair(idx);

nodelist{1} = d;
nodelist{2} = dnum;
nodelist{3} = pair;
end