function [temp] = extract(img,x,y,s,szx,szy)
% if(y-s)<1
%     a1 = 1;
% else
%     a1 = y-s;
% end;
% 
% if(y+s)>480
%     a2 = 480;
% else
%     a2 = y+s;
% end;
% 
% if(x-s)<1
%     b1 = 1;
% else
%     b1 = x-s;
% end;
% 
% if(x+s)>640
%     b2 = 640;
% else
%     b2 = x+s;
% end;

%second edit


if (y-s)<1
    a1 = 1;
    a2 = 1 + 2*s;
    %fprintf('1');
elseif (y+s)>szy
    a2 = szy;
    a1 = szy - 2*s;
    %fprintf('x');
else
    a1 = y-s;
    a2 = y+s;
    %fprintf('0');
end;

if (x-s)<1
    b1 = 1;
    b2 = 1 + 2*s;
elseif (x+s)>szx 
    b1 = szx - 2*s;
    b2 = szx;
else
    b1 = x-s;
    b2 = x+s;
end;




% a1 = y-s;
% a2 = y+s;
% b1 = x-s;
% b2 = x+s;


l = 1;
tempimg = uint8(zeros(2*s,2*s));
for i = a1:a2
    m = 1;
    for j = b1:b2
        tempimg(l,m) = img(i,j);
        m = m + 1;
    end;
    l = l + 1;
end;
temp = tempimg;
