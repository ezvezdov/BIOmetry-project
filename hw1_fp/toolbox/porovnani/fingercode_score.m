function matchingScoreG = fingercode_score(im1, singularityPoints1, im2, singularityPoints2)
% Spocita matching skore pro dvojici obrazku.
%
% matchongScoreG = fingercode_score(im1, singularityPoints1, im2,
%   singularityPoints2)
%
%   Vstupy: im1 - obrazek 1
%           singularityPoints1 - pole se singularnimi body k otisku 1
%           im2 - obrazek 2
%           singularityPoints2 - pole se singularnimi body k otisku 2

Gfilt = GaborFilter_creation;

[fingercode1,Fmasked1]= fingercode_creation(im1, Gfilt, singularityPoints1);
[fingercode2,Fmasked2] = fingercode_creation(im2, Gfilt, singularityPoints2);

D = abs(fingercode1 - fingercode2);
matchingScoreG = mean(D);

% fingercode1P = fingercode_creationP(im1, Gfilt, singularityPoints1);
% fingercode2P = fingercode_creationP(im2, Gfilt, singularityPoints2);
% DP = abs(fingercode1P - fingercode2P);
% matchingScoreGP = mean(D);
% disp(['Skore fingercode matchingu1P: ' num2str(matchingScoreGP)]);

