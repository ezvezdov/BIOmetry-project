function [imReconstruct imBinary imSkeleton] = enhance2ridgevalley(imOriginal, imSegmented, orientationArray, frequencyArray, filtoff)

%[imReconstruct imBinary imSkeleton] = enhance2ridgevalley(imOriginal,
%   imSegmented, orientationArray, frequencyArray, filtoff)
%
% Funkce implementuje smerovou filtraci pomoci Gaborovych filtru.
% Maximalni pocet filtru : 48
% Smerovy rozsah : [- pi/2 : pi/8 : pi/2]
% Maximalne 3 frekvence
% Paramter Sigma {2, 4)
%
% Fuknce provani vylepseni kvality otisku prstu pomoci filtrace Gaborovymi
% filtra a zaroven provadi skeletonizaci vysledneho obrazku.
%
%   imOriginal - vstupni obrazek otisku
%   imSegmented - segmentace otisku
%   orientationArray - orientacni pole
%   frequencyArray - pole lokalni frekvence papilarnich linii
%   filtoff - true = vypnuti G. filtrace, false = zapnuti filtrace


if nargin < 5, filtoff = false; end

Filteredimages = cell(2,8,3);
%Reconstructedimages = cell(2,3);
% binaryBlkSize = 20;
binaryBlkSize = 32;

imoriginal = imOriginal;
width = size(imoriginal, 2);
height = size(imoriginal, 1);

im = mat2gray(double(imoriginal));

% if ~filtoff
% determines 3 freqences that will be used for directional filtering
frequencyVector = choosefrequency(frequencyArray(1, :));


% creation of set of gabor filters. Gebor parameters sigma are determined
% by variable indsi, frequency fiven by Fp.frequencyVector, orientation
% given by indan (8 orientations)
for indfr = 1 : length(frequencyVector)
    frequency = frequencyVector(indfr);
    indsi = 2;
    sigmax = 2 * indsi;
    sigmay = 2 * indsi;
    
    for indan = -4 : 3
        angle = indan * (pi/8);
        imFiltered = filtergabor(im, sigmax, sigmay, angle, frequency);
        Filteredimages{indsi, indan + 5, indfr} = imFiltered;   %cell array of resulting Gabor-filtered images
    end
end


% construct final image. For every pixel it takes the corresponding values from Fp.frequencyArray and Fp.orientationArray
% and rounds them to the closest frequency values of Gabor fiters (from
% Fp.frequencyVector) and finds the closest discrete angular value (orientations)
%
% contourDist = bwdist(imContour);
% contourDist = imresize(contourDist, .3);
% contour = imSegmented;


% [x y]=find(frequencyArray);
% xm=min(x);
% xM=max(x);
frLen = size(frequencyArray, 2);
for i = 1 : size(im,1)
    for j = 1 : size(im,2)
        if imSegmented(i,j)~=0
            %                 if (i<xm) || (i>xM)
            %                     imOutput(i,j)=1;
            %                 else
            % chose appropriate frequence
            distances = sqrt(sum((frequencyArray(2:3, :) - repmat([i;j], 1, frLen)).^2));
            minDist = distances == min(distances);
            frq = frequencyArray(1, minDist);
            temp(1 : length(frequencyVector)) = frq(1);
            temp = abs(frequencyVector - temp);
            freqIndice = find(temp == min(temp));
            
            ang = orientationArray(i,j);
            ang = - round(ang/(pi/8));   %finds the closest discrete angular value (orientations)
            if ang == 4; ang = -4; end
            
            if filtoff
                imOutput(i,j) = imOriginal(i,j);
            else
                imOutput(i,j) = Filteredimages{2, ang + 5,freqIndice(1)}(i,j);
            end
            %                 end
            
        else
            imOutput(i,j) = 0;
        end
        
    end
end
% else
%     imOutput = im;
% end

nanImg = nan(size(imSegmented)); nanImg(imSegmented) = 1;
imReconstruct = mat2gray(imOutput) .* nanImg;    %reconstructed image
imReconstruct = blkpad(imReconstruct, binaryBlkSize);
warning('off', 'Images:BLKPROC:DeprecatedFunction');
imReconstruct = blkproc(imReconstruct, [binaryBlkSize binaryBlkSize], @binarizeimage);
warning('on', 'Images:BLKPROC:DeprecatedFunction');
imReconstruct = imcrop(imReconstruct, [0 0 width height]);

imBinary = imReconstruct;            %binary version of imReconstruct
imOutput = bwmorph(imcomplement(imReconstruct),'thin', 'Inf'); %thins the reconstructed image
imSkeleton = imOutput;               %stores the thinned binary image in Fp.imSkeleton




%--------------------------------------------------------------------------
%Sub-Function filtergabor
%--------------------------------------------------------------------------
function  imfilt = filtergabor(im, sigmaX, sigmaY, angle, f)

x = -16:16;
y = -16:16;

%%%
%DOPLNTE
%%%

[tmp, xSize] = size(x);
[tmp, ySize] = size(y);


% Transformation matrix
T = [cos(angle) sin(angle); -sin(angle) cos(angle)];
    
gab = zeros(xSize, ySize);
   
for i = 1:xSize
    for j = 1:ySize
        xt_yt = T * [x(i); y(j)];
        xt = xt_yt(1);
        yt = xt_yt(2);
            
        gab(i, j) = exp(-0.5 * (xt^2 / sigmaX^2 + yt^2 / sigmaY^2)) * cos(2 * pi * f * xt);
    end
end

imfilt = imfilter(im, gab, 'replicate', 'same');

imfilt = mat2gray(imfilt);

%--------------------------------------------------------------------------
%Sub-Function binarizeimage
%--------------------------------------------------------------------------
function  Iout = binarizeimage(Iin)
level = graythresh(Iin(~isnan(Iin)));
Iout = im2bw(Iin, level);



