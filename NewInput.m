
filepre='imgset5/img_';
filepre2='output_imgset5/img_';
s=num2str(1); % i is the image number.
impath=strcat(filepre,s,'.jpeg');
frame=imread(impath);
tempimg1 = frame;

x = 55;
y = 60;
winsize = 24;

a = 0;
b = 0;

blkSiz = 16;
outlier = 0.5;

MAXITER_CAS = 1; % Maximum iterations for GD-GME with the cascade
MAXITER_ORI = 6; % Maximum iterations for plain GD-GME 
MAXITER_LSS = 3; % Maximum iterations for LSS-ME 
pC = winsize;
pR = winsize;
bC=pC/blkSiz; % number of column in blocks
bR=pR/blkSiz; % number of row in blocks

% get the coordinates
[coorX,coorY]=ndgrid(1:winsize-3,1:winsize-3);
%coorX = coorBlkX.*blkSiz-blkSiz/2;
%coorY = coorBlkY.*blkSiz-blkSiz/2;

% the parameters for the cascade
GM_TRAN = 1;  % translational model
GM_ISOT = 2;  % isotripic model
GM_AFFI = 3;  % affine model
GM_PERS = 4;  % perspective model
HALFPIX=2; % Half pixel
iniMM=[];
frameno = 190;
xval = zeros(1,frameno);

yval = zeros(1,frameno);
tic;
for i = 1:449
    s=num2str(i); % i is the image number.
    impath=strcat(filepre,s,'.jpeg');
    frame=imread(impath);
    tempimg2=frame;
    [m n] = size(tempimg2);
    temp1 = extract(tempimg1,x,y,winsize/2,160,120);
    temp2 = extract(tempimg2,x,y,winsize/2,160,120);
    %[a b] = smlWindw(temp1,temp2);
    [px py] = lk2(temp1,temp2);
    iMap = MVRemCas(px, py, outlier, blkSiz);
%   mmPers = mvGME_NR_test(GM_TRAN, px, py, iMap,coorX, coorY, MAXITER_CAS, outlier, iniMM);
    m = mvGME_NR_test(GM_TRAN, px(:), py(:), iMap(:),coorX(:) ,coorY(:), 6, outlier, iniMM);
    %[a b] = inlierxy(iMap,px,py,outlier);
    %[a b] = highgrad(temp1,temp2);
    %fprintf('(( %d %d ',a,b);
     
    % a = ( m(1,1)*x  +  m(1,2)*y  +  m(1,3)*4 )  /  ( m(1,7)*x  +  m(1,8)*y + 1 );
     %b = (m(1,4)*x + m(1,5)*y + m(1,6)*4)/(m(1,7)*x + m(1,8)*y + 1);
     a = ( m(1,1)*x  +   m(1,3))  ;
     b = (m(1,5)*y + m(1,6));
%     %fprintf('floor( %d %d )))',a,b);
     
    %a = m(1,3);
    %b = m(1,6);
    %a = round(a);
    %b = round(b);
    x = round(a);
    y = round(b);
    % x = x + a*4;
     %y = y + b*4;
    %fprintf('(%d %d)',x,y);
    temp3 = bb(tempimg2,winsize/2,x,y);
    tempimg1 = tempimg2;
    imshow(temp3);
    drawnow;
%     xval(1,i) = x;
%     yval(1,i) = y;
     impath=strcat(filepre2,s,'.jpeg');
     imwrite(temp3,impath,'jpeg');
end;
% for i = 30:190
%     tempimg1(yval(1,i),xval(1,i)) = 255;
% end
% imshow(tempimg1);
toc;
