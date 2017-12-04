function [output1 output2] = lk2(img1,img2);
original1 = double(img1);
original2 = double(img2);
[fx1 fy1] = gradient(original1);
[fx2 fy2] = gradient(original2);

Ix = (fx1+fx2)/2;
Iy = (fy1+fy2)/2;
It = original2 - original1;

[height width] = size(img1);

output1=zeros(height-4,width-4);         
output2=zeros(height-4,width-4);
%  output1=zeros(5,5);         
%  output2=zeros(5,5);
%[m n] = size(Ix);
%A=zeros(2,2);
%B=zeros(2,1);
l = 0;
neighborhood_size = 5;
for i=(1+floor(neighborhood_size/2)):(height-floor(neighborhood_size/2))
    l = l +1;
    k = 0;
    for j=(1+floor(neighborhood_size/2)):(width-floor(neighborhood_size/2))
        k = k +1;
        A=zeros(2,2);
        B=zeros(2,1);
        for m=i-floor(neighborhood_size/2):i+floor(neighborhood_size/2)
            for n=j-floor(neighborhood_size/2):j+floor(neighborhood_size/2)
                A(1,1)=A(1,1) + Ix(m,n)*Ix(m,n);
                A(1,2)=A(1,2) + Ix(m,n)*Iy(m,n);
                A(2,1)=A(2,1) + Ix(m,n)*Iy(m,n);
                A(2,2)=A(2,2) + Iy(m,n)*Iy(m,n);
                B(1,1)=B(1,1) + Ix(m,n)*It(m,n);
                B(2,1)=B(2,1) + Iy(m,n)*It(m,n);
            end;
        end;
        Ainv=pinv(A); %%Pseudo inverse
        result=Ainv*(-B);
        output1(i-2,j-2)=round(result(1,1));
        output2(i-2,j-2)=round(result(2,1));
    end;
end;
% fprintf('(x:%d y:%d)',l,k);
% Ainv=pinv(A); %%Pseudo inverse
% result=Ainv*(-B);
% quiver(output1, output2);
% medx = mean(output1);
% medy = mean(output2);
% x = mean(medx);
% y = mean(medy);
% fprintf('%d %d',x,y);