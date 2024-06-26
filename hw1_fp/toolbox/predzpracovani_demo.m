addpath ./predzpracovani
%% nacteni obrazku otisku
% id = round(rand*9+1), num = round(rand*7+1)
id = 10; num = 1;
im1 = loadfprint(id, num, 'fvc02_4');

% segmentace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[imSegmented imContour] = segmentimage(im1);
show_segmentation(im1, imContour);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% orientacni pole %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orientationArray = computeorientationarray(imOriginal, contour, blkSize)
%   blkSIze - velikost bloku
orientationArray = computeorientationarray(im1, imSegmented, 30);
show_orientation(im1, imContour, imSegmented, orientationArray); %vykresleni
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% frekvencni pole
% frequencyArray = computelocalfrequency(im, imSegmented, orientationArray)
%   im - vstupni obrazek
%   imSegmented - segmentovany obrazek (vystup segmentimage)
%   orientationArray - orientacni pole (vystup computeorientationarray)

frequencyArray = computelocalfrequency(im1, imSegmented, orientationArray, false);

%% vylepseni kresby pomoci Gaborovych filtru + tvorba skeletonu
% [imReconstruct imBinary imSkeleton] = enhance2ridgevalley(im, imSegmented, 
%   orientationArray, frequencyArray, filtoff)
%       im - vstupni obrazek
%       imSegmented - segmentovany obrazek
%       orientationArray - orientacni pole
%       frequencyArray - frekvencni pole
%       filtoff - vypnuti Gaborovy filtrace (1 - vypnuta, 0 - zapnuta)

[imReconstruct imBinary imSkeleton] = enhance2ridgevalley(im1, imSegmented, orientationArray, frequencyArray, 0);
show_gabor(imReconstruct, imSkeleton); % vykresleni
%%% je potreba doplnit kod, aby fungovala %%%
%[imReconstruct imBinary imSkeleton] = enhance2ridgevalley(im1, imSegmented, orientationArray, frequencyArray, 0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% vycisteni skeletonu + finalni minutia
[imSkeleton minutiaArray] = cleanskeleton(im1, imSegmented, imContour, imSkeleton, orientationArray);
[minArray minRot] = findminutia(imSkeleton, imContour, orientationArray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vykresleni konecnych nalezenych minutii
show_minutia(im1, imSkeleton, minArray);

