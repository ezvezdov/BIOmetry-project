function imS = preprocess(im1, name, segTreshold, orientationWinSize)

% Vraci strukturu zakldnich priznaku extrahovanou z obrazku.
%
%   imS = preprocess(im1, name, segWinSize, orientationWinSize)
%       
%       vstupy: im1 - vstupni obrazek
%               name - nazev
%               segTrehold - velikost okna pro segmentaci otisku (default 3)
%               orientationWinSize - velikost okna pro pocitani
%                  orientacniho pole (default 15)
%       
%       vystupy: imS - struktura obsahujici im, name, segmentation,
%           contour, orientedArray, singularityPoints, localFrequencies,
%           imageGaborReconstruct, imageSkeleton, minutiaArray, minutiaRotation


if ~exist('name', 'var'), name = []; end
if isempty(name), name = ''; end
if ~exist('segTreshold', 'var'), segTreshold = []; end
if isempty(segTreshold), segTreshold = 3; end
if ~exist('orientationWinSize', 'var'), orientationWinSize = []; end
if isempty(orientationWinSize), orientationWinSize = 10; end

[im1S im1C] = segmentimageP(im1, segTreshold);
oAi1 = computeorientationarray(im1, im1S, orientationWinSize);
sPi1 = findsingularitypoint2(im1, im1S);
fAi1 = computelocalfrequency(im1, im1S, oAi1);
[im1R, ~, im1Sk] = enhance2ridgevalleyP(im1, im1S, oAi1, fAi1);
im1Sk = cleanskeleton(im1, im1S, im1C, im1Sk, oAi1);
[mAi1 mRi1] = findminutia(im1Sk, im1C, oAi1);

imS.im = im1;
imS.name = name;
imS.segmentation = im1S;
imS.contour = im1C;
imS.orientedArray = oAi1;
imS.singularityPoints = sPi1;
imS.localFrequencies = fAi1;
imS.imageGaborReconstruct = im1R;
imS.imageSkeleton = im1Sk;
imS.minutiaArray = mAi1;
imS.minutiaRotation = mRi1;