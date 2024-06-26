function show_gabor(imReconstruct, imSkeleton, f)
% Show image enhanced by applying gabor filtration.
%
% show_gabor(imReconstruct, imSkeleton, f)
% Input: imReconstruct - image with fingerprint enhanced by the filtration
%        imSkeleton - skeleton image
%        f - figure handle (optional)

if nargin < 3
    figure;
else
    figure(f);
end

subplot(121);
imshow(imReconstruct); title('enhance using Gabor filters');
subplot(122); imshow(imSkeleton); title('kostra otisku pred cistenim');