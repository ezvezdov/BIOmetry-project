function [fingercode, Fmasked] = fingercode_creation(imOriginal, Gfilt, core, maskSize, dia)

% Funkce pro vypocet FingerCode priznaku z otisku prstu.
%
% [fingercode Fmasked] = fingercode_creation(imOriginal, Gfilt, core, maskSize, dia)
%
%   vstupy: imOriginal - vstupni obrazek otisku
%           Gfilt - banka Gaborovych filtru
%           core - [x;y] souradnice jadra otisku
%           maskSize - velikost bloku pri blokovem zpracovani (deafult 16)
%           dia - velikost [vnejsi vnitrni] polomer masky
%
%   vystupy: fingercode - priznakovy vektor pro obrazek
%            Fmasked - ilustracni blokovy obrazek s vyrizlym mezikruzim

if ~exist('maskSize', 'var'), maskSize = []; end
if isempty(maskSize), maskSize = 16; end
if ~exist('dia', 'var'), dia = []; end
if isempty(dia), dia = [6 2]; end


% DOPLNIT
[m, n] = size(imOriginal);
Fmasked = imOriginal;

% Making Fmasked 
for i = 1:m
    for j = 1:n
        % Calculate distance
        d = sqrt((core(1) - i)^2 + (core(2) - j)^2);

        % Set zero outside big circle and inside small circle
        if d > dia(1) || d < dia(2)
            Fmasked(i,j) = 0;
        end
    end
end

[filtCount, tmp,tmp]= size(Gfilt);
fingercode = zeros(size(Gfilt));

% Filtering all images
for filtI=1:filtCount
    gab = filtCount(filtI);
    block = imOriginal(core(1)-maskSize:core(1)+maskSize, core(2)-maskSize:core(2)+maskSize);
    
    % Aplication of Gabor filter
    imfilt = imfilter(block, gab, 'replicate', 'same');
    imfilt = mat2gray(imfilt);
    
    % Variance calculating
    variance = var(double(imfilt(:)));
    fingercode(filtI) = variance;
end




