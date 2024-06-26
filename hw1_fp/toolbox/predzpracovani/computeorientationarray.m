function orientationArray = computeorientationarray(imOriginal, contour, blkSize)

% orientationArray = computeorientationarray(imOriginal, contour,
%   blkSize)
%
% Funkce pocita orientacni pole pro kazdy pixel obrazku, krome okrajovych
% oblasti a zaroven uprostred segmentovane oblasti. Vypocet probiha po
% blocich.
%
%   imOriginal - vstupni obraz otisku
%   contour - segementace (vystup imSegmented funkce segmentiamge)
%   blkSize - nastaveni velikosti bloku pro vypocet

if nargin < 3
    blkSize = 10;
end

im = imOriginal;

[fx, fy] = gradient(double(im));
orientationArray = zeros(size(im) - 2 * blkSize);

for x = 1 : size(im,1) - 2 * blkSize
    for y = 1 : size(im,2) - 2 * blkSize
        if contour(x + blkSize, y + blkSize)~=0
            orientationAngle = computelocalorientation(x + blkSize, y + blkSize, fx, fy, blkSize);
            orientationArray(x, y) = orientationAngle;
        end  
    end
end

orientationArray = padarray(orientationArray, [blkSize blkSize], 'replicate', 'both');
