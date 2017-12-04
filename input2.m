


% vid = videoinput('winvideo',1,'RGB24_320x240');
% triggerconfig(vid,'manual');
% set(vid,'FramesPerTrigger',1);
% set(vid,'TriggerRepeat', Inf);
% start(vid);
% preview(vid);
% %im = zeros(640,480,3);
% trigger(vid);
%im1= getdata(vid,1);
filepre='imgset2/img_';
s=num2str(1); % i is the image number.
impath=strcat(filepre,s,'.jpeg');
frame=imread(impath);
tempimg1 = frame;
x = 88;
y = 62;

a = 0;
b = 0;
winsize = 52;
blkSiz = 16;
outlier = 0.5;

MAXITER_CAS = 1; % Maximum iterations for GD-GME with the cascade
MAXITER_ORI = 6; % Maximum iterations for plain GD-GME 
MAXITER_LSS = 3; % Maximum iterations for LSS-ME 
pC = 52;
pR = 52;
bC=pC/blkSiz; % number of column in blocks
bR=pR/blkSiz; % number of row in blocks

% get the coordinates
[coorX,coorY]=ndgrid(1:49,1:49);
%coorX = coorBlkX.*blkSiz-blkSiz/2;
%coorY = coorBlkY.*blkSiz-blkSiz/2;

% the parameters for the cascade
GM_TRAN = 1;  % translational model
GM_ISOT = 2;  % isotripic model
GM_AFFI = 3;  % affine model
GM_PERS = 4;  % perspective model
HALFPIX=2; % Half pixel

iniMM=[];
pause on;
for i = 2:100
    %trigger(vid);
    
    %im2= getdata(vid,1);
    temp1 = extract(tempimg1,x,y,winsize/2,88,72);
    s=num2str(i); % i is the image number.
    impath=strcat(filepre,s,'.jpeg');
    frame=imread(impath);
    tempimg2=frame;
    %name=['Frame' num2str(i) '.jpg'];
    %imwrite(im2,name);

    %tempimg2 = rgb2gray(im2);
    [m n] = size(tempimg2);
    
    temp2 = extract(tempimg2,x,y,winsize/2,88,72);
    %[a b] = smlWindw(temp1,temp2);
    [px py] = lk2(temp1,temp2);
    iMap = MVRemCas(px, py, outlier, blkSiz);
%   mmPers = mvGME_NR_test(GM_TRAN, px, py, iMap,coorX, coorY, MAXITER_CAS, outlier, iniMM);
    m = mvGME_NR_test(GM_TRAN, px(:), py(:), iMap(:),coorX(:) ,coorY(:), 6, outlier, iniMM);
    %[a b] = inlierxy(iMap,px,py,outlier);
    %[a b] = highgrad(temp1,temp2);
    %fprintf('(( %d %d ',a,b);
     
     a = ( m(1,1)*x  +  m(1,2)*y  +  m(1,3) )  /  ( m(1,7)*x  +  m(1,8)*y + 1 );
     b = (m(1,4)*x + m(1,5)*y + m(1,6))/(m(1,7)*x + m(1,8)*y + 1);
    % a = ( m(1,1)*x  +   m(1,3)*4 )  ;
    % b = (m(1,5)*y + m(1,6)*4);
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
    imshow(temp3,'initialmagnification','fit');
    drawnow;
    %imagesc(temp3);
    
    
    
    
end;

