% irisHammingDistance - calculate hamming distance between two iris codes
% with noise masks

% USAGE:
%   HD = irisHammingDistance(codeA,codeB, maskA, maskB) 
%   codeA, codeB - irisCodes
%   maskA, maskB - corresponding noise masks

function HD = irisHammingDistance(codeA,codeB, maskA, maskB) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shift_max = 16;
shift_step = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HD = inf;

for shift=-shift_max:shift_step:shift_max 
    % Code shifting
    codeA_shifted = circshift(codeA, shift,2);
    maskA_shifted = circshift(maskA, shift,2);

    HD_current = sum(xor(codeA_shifted, codeB) & maskA_shifted & maskB, "all") / sum(maskA_shifted & maskB,"all");

    HD = min(HD, HD_current);
end