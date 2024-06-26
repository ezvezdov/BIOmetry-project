function h = showorientationfield(imOriginal, imContour, imSegmented, orientationArray, h)

% Plot the orientation ridges
%
% h = showorientationfield(imOriginal, imContour, imSegmented,
% orientationArray, h)
%
% Input: imOriginal - original fingerprint image
%        imSegmented - binary image same size as imOriginal, 
%           true = fingerprint a false = background
%        imContour - binary image with only contour (fingerprint border) 
%           marked by true
%        orientationArray - array of papilary linies orientation
%        h - axes handle for visualisation
%
% Output: h - axes handle

displayInterval = 40;
radius = 25;
border = 10;
im = imOriginal;


% imSegmented : background in black
temp = imSegmented;
imSegmentedDist = bwdist(imcomplement(temp));


temp = imContour;
temp = Thin(imcomplement(temp), 'Inf');
temp = bwmorph(imcomplement(temp), 'dilate');
axes(h);
imshow(im);
colormap gray
title('Orientation field');
hold on
axis ij

i = 1;
for x = displayInterval : displayInterval : size(im, 1) - displayInterval
    for y = displayInterval : displayInterval : size(im, 2) - displayInterval
        
        if imSegmentedDist(x, y) > 15
            orientation = orientationArray(x, y);
            plot([y - radius/2 * cos(orientation)  y + radius/2 * cos(orientation)],...
                [x - radius/2 * sin(orientation)  x + radius/2 * sin(orientation)], 'red', 'linewidth', 1.5);
            i=i+1;
        end
    end
end
hold off