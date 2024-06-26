function show_orientation(im1, imContour, imSegmented, orientationArray, f)
% Show papilary lines orientation both with red lines and in a grey scale.
%
% show_orientation(im1, imContour, imSegmented, orientationArray, f)
% Input: im1 - original fingerprint image
%        imContour - contour
%        imSegmented - segmented fingerprint (binary image)
%        orientationArray - array of papilary orientation
%        f - figure handle (optional, default new figure)

if nargin < 5
    figure;
else
    figure(f);
end

h = subplot(121);
showorientationfield(im1, imContour, imSegmented, orientationArray, h); title('orientacni pole');
subplot(122); imshow(orientationArray / pi + .5); title('orientace pixelu v sede skale');