function show_segmentation(im1, imContour, f, type)
% Show segmentation of a fingerprint.
%
% show_segmentation(im1, imContour, f, type)
% Input: im1 - original fingerprint image
%        imContour - contour
%        f - figure handle (optional, default new figure)
%        type - 1 or 2, 1 is subplot with original and segmented image
%               2 is contour only (optional, default 1)

if nargin < 4
    type = 1;
end
if nargin < 3
    figure;
else
    try
        figure(f);
    catch er
        switch er.identifier
            case 'MATLAB:Figure:HandleInUse'
                axes(f);
        end
    end
end

if type == 1
    subplot(121); imshow(im1); title('otisk')
    subplot(122); imshow(im1); hold on
    [xc, yc]= find(imContour);
    plot(yc, xc, '.'); title('segmentace otisku od pozadi')
elseif type == 2
        imshow(im1); hold on
        [xc, yc]= find(imContour);
        plot(yc, xc, '.'); title('segmentace otisku od pozadi')
end