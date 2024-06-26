function frequencyArray = computelocalfrequency(im, contour, orientationArray, usefft)

% frequencyArray = computelocalfrequency(im, imSegmented, orientationArray,
% usefft)
%
% Pocita lokalni frekvenci papilarnich linii v otisku. Maximalni vzorkovani
% obrazku je v 8 bodech, jak horizontalne, tak vertikalne.
% Jsou mozne 2 algoritmy vypoctu. Bud pomoci pocitani maxim v prumetu
% lokalniho vyrezu otisku kolmo na papilarni linie nebo pomoci FFT spektra
% kazdeho lokalniho vrezu. Prepina se pomoci prepinace usefft, viz dole.
%
%       im - vstupni otisk
%       imSegmented - segmentace otisku
%       orientationArray - orientacni pole
%       usefft - TRUE = pouzit pro vypocet algoritmus vyuzivajici FFT,
%           FALSE = pouzit algoritmus pocitani maxim v prumetu otisku.
%


if nargin < 4, usefft = false; end

border = 20; %prevents from calculating the frequencies too close from the border of the image
% step = max(round(size(im, 2)/8), 50);
step = 30;

f = fspecial('Average', 3);
imh = imfilter(im, f);
% imh = histeq(imh);
% contour = imSegmented;

ind1 = 2;
% ind2 = 2;
if size(im,1) - border < border
    disp('error in computlocalfrequency.m, size too small');
end


frequencyArrayIndex = 0;
for i = border : step : size(im,1) - border
    ind2 = 2;
    for j = border : step : size(im,2) - border
        if (i+step < size(im,1) - border) && (j+step < size(im,2) - border) && all(all(contour(i:i+step,j:j+step)))
            imc = imh(i:i+step,j:j+step);
            orient = orientationArray(i:i+step,j:j+step);
            frequencyArrayIndex = frequencyArrayIndex + 1;
            
            if ~usefft
                frequencyArray(1, frequencyArrayIndex) =  freqest(imc, orient, 5, 5, 15);
            else
                frequencyArray(1, frequencyArrayIndex) = freqestfft(imc);
            end
            frequencyArray(2, frequencyArrayIndex) =  i+step/2;
            frequencyArray(3, frequencyArrayIndex) =  j+step/2;
            
            %debug
                     %figure; subplot(121); imshow(imcd); subplot(122); imshow(abs(fi) / max(abs(fi(:))));
                     %title(num2str(dd))
                     %fi;
            
        end
        ind2 = ind2 + 1;
    end
    ind1 = ind1 + 1;
end
