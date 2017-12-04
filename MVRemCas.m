
% REJRATE = 0.7; % the ratio of inliers to overall MVs for GD based approach

function iMap = MVRemCas(npx, npy, rOUTLIERS, BlkSiz)

% the parameters for the cascade
if BlkSiz == 16
    THM = 0.40;          % the threshold on magnitude -- 40 percent
    THO = (19/360)*2*pi; % the threshold on orientation -- 18 degree
elseif BlkSiz == 8
    THM = 0.20;          % the threshold on magnitude -- 40 percent
    THO = (9/360)*2*pi; % the threshold on orientation -- 18 degree
end
    
THNUM = (1-rOUTLIERS)/3;
iMap = ones(size(npx));

iMap = cascadeAlgo_2(npx, npy, THM, THO, THNUM, iMap);

% this is the optimizied implementation
function iMap = cascadeAlgo_2(px, py, THM, THO, THNUM, iMap)

N=length(iMap(:));
magMV = px.^2+py.^2;  % calculate the magnitude of MV
nZeroMV = find(magMV==0);
lenZMV = length(nZeroMV);
nOUTLIERs = round(THNUM*3*N)-lenZMV;
if nOUTLIERs > 0
    iMap(nZeroMV)=0;
end
% get the data set -- 8-adjacency in 3x3 neighborhood
[MVx1nei, MVy1nei] = gen1Nei(px,py);
rM = find(iMap>0);
W=ones(size(rM));

%% filtering -- 1- adjacent MV
% get the inliers from previous round
IN_THSUM = (1-THNUM)*N;
if  IN_THSUM < length(rM)
    magNeiMV = MVx1nei(rM).^2+MVy1nei(rM).^2;
    [xDiff1, yDiff1, xDot1, yDot1] = genDiffDot(px(rM), py(rM), MVx1nei(rM), MVy1nei(rM));
    [rM,W] = fltcore(magMV(rM), magNeiMV, xDiff1, yDiff1, xDot1, yDot1, ...
        THM, THO, IN_THSUM, rM, W);
end

%% filtering -- 2- adjacent MVs
% get the data set -- 8-adjacency in 3x3 neighborhood
IN_THSUM = (1-THNUM*2)*N;
if  IN_THSUM < length(rM)
    [MVx2nei, MVy2nei] = gen2Nei(MVx1nei(rM,:), MVy1nei(rM,:));
    [xDiff2, yDiff2, xDot2, yDot2] = genDiffDot(px(rM), py(rM), MVx2nei, MVy2nei);
    magNeiMV = MVx2nei.^2+MVy2nei.^2;
    [rM,W] = fltcore(magMV(rM), magNeiMV, xDiff2, yDiff2, xDot2, yDot2, ...
        THM/2, THO/2, IN_THSUM, rM,W);
end

%% filtering -- 3- adjacent MVs
% get the data set -- 8-adjacency in 3x3 neighborhood
IN_THSUM = (1-THNUM*3)*N;
if  IN_THSUM < length(rM)
    [MVx3nei, MVy3nei] = gen3Nei(MVx1nei(rM,:), MVy1nei(rM,:));
    [xDiff3, yDiff3, xDot3, yDot3] = genDiffDot(px(rM), py(rM), MVx3nei, MVy3nei);
    magNeiMV = MVx3nei.^2+MVy3nei.^2;
    [rM,W] = fltcore(magMV(rM), magNeiMV, xDiff3, yDiff3, xDot3, yDot3, ...
        THM/4, THO/4, IN_THSUM, rM,W);
end
iMap(:)=0;
iMap(rM) = 1;

function [xDiff, yDiff, xDot, yDot] = genDiffDot(MVx, MVy, MVxNE, MVyNE)
sizNei = size(MVxNE,2);

for ii = 1:sizNei
    xDiff(:,ii)=MVx-MVxNE(:,ii);
    yDiff(:,ii)=MVy-MVyNE(:,ii);
    xDot(:,ii)=MVx.*MVxNE(:,ii);
    yDot(:,ii)=MVy.*MVyNE(:,ii);
end

function [MVx8adj, MVy8adj] = gen1Nei(px,py)

% symmetric extension
expx = wextend('2D','sym',px,1);
expy = wextend('2D','sym',py,1);

MVx8adj(:,1)= reshape(expx(1:end-2, 1:end-2),1,[]);
MVx8adj(:,2)= reshape(expx(1:end-2, 2:end-1),1,[]);
MVx8adj(:,3)= reshape(expx(1:end-2, 3:end),1,[]);
MVx8adj(:,4)= reshape(expx(2:end-1, 3:end),1,[]);
MVx8adj(:,5)= reshape(expx(3:end, 3:end),1,[]);
MVx8adj(:,6)= reshape(expx(3:end, 2:end-1),1,[]);
MVx8adj(:,7)= reshape(expx(3:end, 1:end-2),1,[]);
MVx8adj(:,8)= reshape(expx(2:end-1, 1:end-2),1,[]);

MVy8adj(:,1)= reshape(expy(1:end-2, 1:end-2),1,[]);
MVy8adj(:,2)= reshape(expy(1:end-2, 2:end-1),1,[]);
MVy8adj(:,3)= reshape(expy(1:end-2, 3:end),1,[]);
MVy8adj(:,4)= reshape(expy(2:end-1, 3:end),1,[]);
MVy8adj(:,5)= reshape(expy(3:end, 3:end),1,[]);
MVy8adj(:,6)= reshape(expy(3:end, 2:end-1),1,[]);
MVy8adj(:,7)= reshape(expy(3:end, 1:end-2),1,[]);
MVy8adj(:,8)= reshape(expy(2:end-1, 1:end-2),1,[]);

function [MVx2nei, MVy2nei] = gen2Nei(MVx1nei, MVy1nei)

for ii = 1:4
    MVx2nei(:,ii)= (MVx1nei(:,ii)+MVx1nei(:,4+ii))/2;
    MVy2nei(:,ii)= (MVy1nei(:,ii)+MVy1nei(:,4+ii))/2;
end

function [MVx3nei, MVy3nei] = gen3Nei(MVx1nei, MVy1nei)

MVx3nei(:,1)= (MVx1nei(:,1)+MVx1nei(:,3)+MVx1nei(:,6))/3;
MVx3nei(:,2)= (MVx1nei(:,2)+MVx1nei(:,5)+MVx1nei(:,7))/3;
MVx3nei(:,3)= (MVx1nei(:,3)+MVx1nei(:,5)+MVx1nei(:,8))/3;
MVx3nei(:,4)= (MVx1nei(:,1)+MVx1nei(:,4)+MVx1nei(:,7))/3;

MVy3nei(:,1)= (MVy1nei(:,1)+MVy1nei(:,3)+MVy1nei(:,6))/3;
MVy3nei(:,2)= (MVy1nei(:,2)+MVy1nei(:,5)+MVy1nei(:,7))/3;
MVy3nei(:,3)= (MVy1nei(:,3)+MVy1nei(:,5)+MVy1nei(:,8))/3;
MVy3nei(:,4)= (MVy1nei(:,1)+MVy1nei(:,4)+MVy1nei(:,7))/3;

function [rM, W] = fltcore(magMV, magNeiMV, xDiff, yDiff, xDot, yDot, THM, THO, THSUM, rM, W)

% get the threshold
THM2 = THM^2;
THOCOS2 = cos(THO)^2;

% magnitude/phase examination...
magRes = magExam(magMV.*THM2, xDiff, yDiff);
oriRes = oriExam(magMV.*THOCOS2, magNeiMV, xDot, yDot);

% the overall number
maxW=max(W(:));
omRes = magRes+oriRes;
omRes = (magRes+oriRes).*exp(-(maxW-W)); % W(1) is the maximum in W.

% omRes = magRes;
[B, IX] = sort(omRes(:), 'descend');
% get the inliers for current round
inId = IX(1:round(THSUM));
rM = rM(inId);
W=B(1:round(THSUM));

function numM = magExam(magMV, xDiff, yDiff)
sizNei = size(xDiff,2);
for ii = 1:sizNei
    ee = magMV - (xDiff(:,ii).^2+yDiff(:,ii).^2);
    numTmp = zeros(size(magMV));
    numTmp(ee>0) = 1;
    if ii==1
        numM = numTmp;
    else
        numM = numM + numTmp;
    end
end

function numM = oriExam(magMV, magNeiMV, xDot, yDot)
sizNei = size(xDot,2);

for ii = 1:sizNei
    ee = xDot(:,ii)+yDot(:,ii);
    ee(ee<0)=0;  % for those phase difference larger than 90 degree
    ee = ee.^2-magMV.*magNeiMV(:,ii);
    numTmp = zeros(size(magMV));
    numTmp(ee>0) = 1;
    if ii==1
        numM = numTmp;
    else
        numM = numM + numTmp;
    end
end


