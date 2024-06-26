function [eer FP FN thresh] = get_eer_dtw(clss, score)
% [eer FP FN thresh] = get_eer(clss, score)
% funkce pocitajici equal error rate
% vstupy:
%   CLSS je pole boolean hodnot, urcuje spravnou klasifikaci dat
%   SCORE urcuje ohodnoceni prirazene jedotlivym datum

scSort = sort(score, 'descend');
scLen = length(score);
genuineLength = sum(clss == 0);
forgeryLength = sum(clss == 1);

genuineMean = mean(score(clss == 0));
forgeryMean = mean(score(clss == 1));

FP = zeros(1, length(score)); %false positive
FN = zeros(1, length(score)); %false negative
for m = 1 : scLen
    thresh(m) = scSort(m);
    if genuineMean < forgeryMean
        clssT = score >= thresh(m);
    else
        clssT = score >= thresh(m);
    end
   FP(m) = sum(clss == 0 & clssT' == 1)/genuineLength;
   FN(m) = sum(clss == 1 & clssT' == 0)/forgeryLength;
end

fn = FN(abs(FP-FN) == min(abs(FP - FN)));
fp = FP(abs(FP-FN) == min(abs(FP - FN)));

eer = (fn+fp)/2;