addpath ./predzpracovani
addpath ./porovnani
clear all; clc

%% nacteni obrazku otisku
id = 7; num = 5;
[im1 name] = loadfprint(id, num, 'fvc02_4');
% [imSegmented imContour] = segmentimage(im1, 9); % pro overeni segmentace
% show_segmentation(im1, imContour);               %
imS1 = preprocess(im1, name, 9);

id = 7; num = 6;
[im2 name2] = loadfprint(id, num, 'fvc02_4');
% [imSegmented imContour] = segmentimage(im2, 9); % pro overeni segmentace
% show_segmentation(im2, imContour);               % 

%% ZAROVNANI

% a) automaticky
% imS2 = preprocess(im2, name2, 9);
% [mAi2Align im2Align im2SkAlign offset2 angle2 core2] = ...
%     align2(imS1.imageSkeleton, imS1.singularityPoints, imS2.imageSkeleton, imS2.singularityPoints, imS2.minutiaArray, imS2.im);

% b) manualne
[im2Align offset ang jadra] = ...
    align_manually(imS1.im, im2);
imS2 = preprocess(im2Align, name2, 9);

%% ZOBRAZENI ZAROVNANI
show_align(imS1.imageSkeleton, imS2.imageSkeleton);
show_minutia(imS1.im, imS1.imageSkeleton, imS1.minutiaArray);
show_minutia(imS2.im, imS2.imageSkeleton, imS2.minutiaArray);

%% POROVNANI
% a) pomoci markatnu
%[matchingScore1P, nbmatch1P, inputmatch1P, dbmatch1P] = matchP(imS1.minutiaArray, imS2.minutiaArray); %markantovy align
[matchingScore1, nbmatch1, inputmatch1, dbmatch1] = match(imS1.minutiaArray, imS2.minutiaArray); %markantovy align

% b) pomoci fingercodu
matchingScoreG1 = fingercode_score(imS1.im, imS1.singularityPoints, im2Align, imS2.singularityPoints); %fingercode align

%zobrazeni vystupu
disp(' ')
disp(['Skore markantoveho matchingu1: ' num2str(matchingScore1)]);
disp(['Skore fingercode matchingu1: ' num2str(matchingScoreG1)]);