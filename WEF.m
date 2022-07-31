function Pe = WEF(dmin,Admin,count)
% double pair
countadmin = count*(count-1);
if sum(Admin(:,1)) < count
    Admin = repmat(countadmin,1,length(dmin));
end
Pe = ones(1,size(dmin,2))*(-1);

for j = 1:size(dmin,2)
    Pe(j) = 0;
    for i = 1:size(dmin,1)
        Pe(j)  = Pe(j)+Admin(i,j) * qfunc(dmin(i,j)/sqrt(2));
    end
end
Pe = Pe./count;
end