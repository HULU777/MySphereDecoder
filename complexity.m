M = 2;
B = 64;
cexp = zeros(1,B);
cbin = zeros(1,B);
for b = 4:1:B
    cexp(b) = 3^b;
    cbin(b) = 0;
    for m = 1:M
        cbin = cbin + nchoosek(b,m);
    end
end
plot(cexp); hold on;
plot(cbin); hold on;