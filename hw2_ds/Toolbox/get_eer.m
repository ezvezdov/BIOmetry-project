function [eer FP FN thresh] = get_eer(clss, score)
% [eer FP FN thresh] = get_eer(clss, score)
% funkce pocitajici equal error rate
% vstupy:
%   CLSS je pole boolean hodnot, urcuje spravnou klasifikaci dat
%   SCORE urcuje ohodnoceni prirazene jedotlivym datum

scSort = sort(score, 'descend');
scLen = length(score);

FP = zeros(1, length(score)); %false positive
FN = zeros(1, length(score)); %false negative
for m = 1 : length(scSort)
   thresh(m) = scSort(m);
   clssT = score <= thresh(m);
   FP(m) = sum(clss == 0 & clssT' == 1)/scLen;
   FN(m) = sum(clss == 1 & clssT' == 0)/scLen;
end

fn = FN(abs(FP-FN) == min(abs(FP - FN)));
fp = FP(abs(FP-FN) == min(abs(FP - FN)));

eer = (fn+fp)/2;