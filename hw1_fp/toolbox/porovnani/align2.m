function [minutiaArrayAlign im2Align imSkeletonAlign offsetout angle core] = align2(im1Sk, sPi1, im2Sk, sPi2, mAi2, im2)

% Funkce na zarovnani dvou otisku pomoci posunu a rotace. Nefunguje vzdy.
%
% [minAlign minutiaArrayAlign imSkeletonAlign offsetout angle core] =
%   align2(im1Sk, sPi1, im2Sk, mAi2, sPi2)
%
%   vstupy: im1Sk - skeleton databazoveho obrazku
%           sPi1 - singularni body databazoveho obrazku
%           im2Sk - skeleton vstupniho obrazku
%           mAi2 - pole markantu vstupniho obrazku
%           sPi2 - singulrani body vstupniho obrazku
%           im2 - obrazek vstupniho otisku
%
%   vystupy: minAlign - markanty zarovnane z obrazku 2 na obrazek 1
%            minutiaArrayAlign - pole zarovnanych markantu
%            im2Align - zarovnany vstupni obrazek s databazovym
%            imSkeletonAlign - zarovnany skeleton
%            offsetout - posun obrazku 2 vuci obrazku 1
%            angle - uhel natoceni
%            core - [x;y] souradnice jadra otisku (jak databazoveho, tak zarovnaneho)

% warning off all

% dbSkel= imcomplement(full(im1Sk));
angle = 0;
maxRef = 0;

[dbSkelp inputSkelp inputMinutia dwnSampleFactor] = ...
    prepareAlign(im1Sk, im2Sk, mAi2);
inputSkel = imcomplement(full(im2Sk));

if isempty(sPi1) || isempty(sPi2)
    error('fingerprintToolbox:noSingularityPointsError', 'Singularity points are empty, unable to align.');
end
[ydb ydbind]=sort(sPi1(:,2));
xdb=sPi1(ydbind,1);
[y yind]=sort(sPi2(:,2));
x=sPi2(yind,1);
offset = [ydb(1)-y(1), xdb(1)-x(1)]; %[y x]
offsetout = fliplr(offset)';

inputSkelpreconstruct = imshift(inputSkelp, [offset(2)/dwnSampleFactor; offset(1)/dwnSampleFactor]);
inputSkelreconstruct = imshift(inputSkel, [offset(2); offset(1)]);

core = [xdb(1); ydb(1)];

% ii=0;
% ccc = [];
for ang = -24:3:24
%     ii = ii+1;
    inputSkelr = imrotatearound(inputSkelpreconstruct, ang, core/dwnSampleFactor);
    cc = sum(sum(inputSkelr .* dbSkelp));
    if cc > maxRef
        maxRef = cc;
        angle = ang;
    end
end
% figure; plot(-24:3:24,ccc)

%reconstruction good fp skeleton
inputSkelreconstruct = imrotatearound(inputSkelreconstruct, angle, core);
inputSkelreconstruct = imcomplement(full(inputSkelreconstruct));
imSkeletonAlign=inputSkelreconstruct;

%reconstruct good minutiae
inputMinRec = imshift(inputMinutia, [offset(2); offset(1)]);
inputMinRec = imrotatearound(inputMinRec, angle, core);
minutiaArrayAlign=inputMinRec;

% [mA1y mA1x] = find(inputMinRec == 1);
% [mA2y mA2x] = find(inputMinRec == 2);
% minAlign = [mA1x mA1y ones(length(mA1x), 1); mA2x mA2y ones(length(mA2x), 1)*2];

% zarovnani vstupniho obrazku s databazovym
im2Align = imrotatearound(imshift(im2, offsetout), angle, core);