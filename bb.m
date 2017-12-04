function [temp] = bb(image,winsize,x,y)
temp = image;
s = winsize;
if(y-s)<1
    a1 = 1;
else
    a1 = y-s;
end;

if(y+s)>480
    a2 = 480;
else
    a2 = y+s;
end;

if(x-s)<1
    b1 = 1;
else
    b1 = x-s;
end;

if(x+s)>640
    b2 = 640;
else
    b2 = x+s;
end;


%1st edit
% a1 = y-s;
% a2 = y+s;
% b1 = x-s;
% b2 = x+s;


% if (y-s)<1
%     a1 = 1;
%     a2 = 1 + 2*s;
%     %fprintf('1');
% elseif (y+s)>480
%     a2 = 480;
%     a1 = 480 - 2*s;
%     %fprintf('x');
% else
%     a1 = y-s;
%     a2 = y+s;
%     %fprintf('0');
% end;
% 
% if (x-s)<1
%     b1 = 1;
%     b2 = 1 + 2*s;
% elseif (x+s)>640 
%     b1 = 640 - 2*s;
%     b2 = 640;
% else
%     b1 = x-s;
%     b2 = x+s;
% end;



for i = a1:a2
    for j = b1:b2
        if (i == a1 || i == a2)
            temp(i,j) = 255;
        elseif (j==b1 || j == b2)
            temp(i,j) = 255;
        end;
    end;
end;