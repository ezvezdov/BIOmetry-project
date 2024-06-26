function [imSegmented imContour] = segmentimage(imOriginal, thresh, blkSize)

%[imSegmented imContour] = segmentimage(imOriginal, blkSize, enh, smooth)
%
% Funkce segmentuje obrazek na otisk a pozadi.
%
%   imOriginal - vstupni otiskS
%   thresh - prah pro segmentaci otisku
%
%
% vystupy: 
%   imSegmented - binarni obrazek stejne velikosti jako imOriginal, 1
%       oznacuje otisk a 0 znaci pozadi
%   imContour - kontura segmentace binarni obrazek obsahujici pouze
%   konturu, ne celou plochu segmentace

if nargin < 2
    thresh = 1e-3;
    blkSize = 16;
end

%%
% Doplnte
%%

% Variance method

[m, n] = size(imOriginal);
numRows = floor(m / blkSize);
numCols = floor(n / blkSize);

imSegmented = zeros(m, n);

for i = 1:numRows
    for j = 1:numCols
        block = imOriginal((i-1)*blkSize + 1:i*blkSize, (j-1)*blkSize + 1:j*blkSize);
        
        % variance of the block
        variance = var(double(block(:)));

        if variance >= thresh
            imSegmented((i-1)*blkSize + 1:i*blkSize, (j-1)*blkSize + 1:j*blkSize) = 1; % Fingerprint region
        else
            imSegmented((i-1)*blkSize + 1:i*blkSize, (j-1)*blkSize + 1:j*blkSize) = 0; % Background region
        end
    end
end

% make imSegmented logical to use as indeces
imSegmented = logical(imSegmented);


% Removing small connected blocks detected as foreground
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the size threshold for removing small blocks
blkSizeThreshold = blkSize * 5;

% Create a structuring element for morphological operations
se = strel('square', blkSizeThreshold);

% Perform morphological opening to remove small blocks of ones
imSegmented = imopen(imSegmented, se);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate contour
imContour = edge(imSegmented);
