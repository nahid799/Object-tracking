function [x y] = inlierxy(iMap,px,py,outlier)
[r c] = size(iMap);
sz = (r*c)*outlier;
sz = round(sz);
PX = zeros(1,sz);
PY = zeros(1,sz);
l=1;
m=1;
for i = 1:r
    for j = 1:c
        if iMap(i,j)==1
            PX(1,l) = px(i,j);
            PY(1,m) = py(i,j);
            l = l+1;
            m = m+1;
        end;
    end;
end;
x = mean(PX);
y = mean(PY);