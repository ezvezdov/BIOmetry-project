function [matchingScore, nbmatch, inputmatch, dbmatch] = match(mAi1, mAi2)

% Porovnani dvou otisku pomoci parovani markantu.
%
% [matchingScore, nbmatch, inputmatch, dbmatch] = match(mAi1, mAi2)
%
%   vstupy: mAi1 - pole s markanty z databazoveho obrazku, stejne velike
%               jako originalni obrazek otisku.
%           mAi2 - pole s markanty z porovnavaneho obrazku, otisky a tedy i polohy
%               markantu musi byt co nejlepe srovnany. stejne velike jako
%               originalni obrazek otisku.
%
%   vystupy: matchingScore - ohodnoceni pøiøazení otiskù
%            nbmatch - pocet paru markantu
%            inputmatch - pole (stejne velikosti jako vstupni obrazek) s
%               vyznacenymi markanty ve vstupnim obrazku (mAi2) sparovane s
%               markanty ze zrovnavaneho obrazku.
%            dbmatch - pole (stejne velikosti jako vstupni obrazek) s
%               vyznacenymi markanty ve vstupnim obrazku (mAi2) sparovane s
%               markanty ze zrovnavaneho obrazku.

warning off all

dbMinutiap = double(bwmorph(mAi1, 'Shrink', 'Inf'));
inputMinutiap = double(bwmorph(mAi2, 'Shrink', 'Inf'));

[x,y]=find(dbMinutiap);
for i=1:length(x)
    dbMinutiap(x(i),y(i))=mAi1(x(i),y(i));
end

[x,y]=find(inputMinutiap);
for i=1:length(x)
    inputMinutiap(x(i),y(i))=mAi2(x(i),y(i));
end


[matchingScore,~, ~,nbmatch, inputmatch, dbmatch]= score(dbMinutiap ,inputMinutiap);
 
%--------------------------------------------------------------------------
function [matchingScore, nbElementInput, nbElement, nbmatch, inputmatch, dbmatch] = score(db, input)
%Vstupy:
% db - pole, stejne velikosti jako vstupni obraz, s vyznacenymi markanty.
%   odpovida obrazu, ktery slouzi jako vzor.
% input - pole, stejne velikosti jako vstupni obraz, s vyznacenymi markanty.
%   odpovida obrazu, ktery slouzi jako porovnavany vstup.
%
%Vystupy:
% matchingScore - ohodnoceni prirazení otiskù
% nbElementInput - pocet markantu ve srovnavacim obraze
% nbelement - celkovy pocet markantu v obou vstupnich polich
% nbmatch - pocet paru markantu
% inputmatch - pole (stejne velikosti jako vstupni obrazek) s
%   vyznacenymi markanty ve vstupnim obrazku (mAi2) sparovane s
%   markanty ze zrovnavaneho obrazku.
% dbmatch - pole (stejne velikosti jako vstupni obrazek) s
%   vyznacenymi markanty ve vstupnim obrazku (mAi2) sparovane s
%   markanty ze zrovnavaneho obrazku.

threshold =  12;


% DOPLNIT

% Indices of minutiaes (markanty) in db
db_indices = find(db);
[db_row, db_col] = ind2sub(size(db), db_indices);
dbN = nnz(db);

% Indices of minutiaes (markanty) in input
input_indices = find(input);
[input_row, input_col] = ind2sub(size(input), input_indices);
inN = nnz(input);

% Setting output variables
nbElementInput = inN;
nbElementDb = dbN;
nbElement = dbN + inN;

% Data that will changes
nbmatch = 0;
matchDist = 0;
inputmatch = zeros(size(input));
dbmatch = zeros(size(db));

for db_i = 1:dbN
    for in_i = 1:inN
        % Get x,y of db(i) and in(j) minutiaes
        db_x = db_row(db_i);
        db_y = db_col(db_i);
        in_x = input_row(in_i);
        in_y = input_col(in_i);

        % Check if same type if minutiaes
        if db(db_x,db_y) == input(in_x,in_y)

            % Calculating distance
            sd = sqrt((db_x - in_x)^2 + (db_y - in_y)^2);
            
            if sd <= threshold
                nbmatch = nbmatch + 1;
                inputmatch(in_x,in_y) = 1;
                dbmatch(db_x,db_y) = 1;
                matchDist = matchDist + sd;
            end
        end
    end
end

matchingScore = (matchDist / nbmatch) / 10;


fprintf('number of matched minutiae : %d\ndistance total computed : %d\n',nbmatch, matchDist);
fprintf('number of minutiae in input image : %d\n', nbElementInput);
fprintf('number of minutiae in database image : %d\n', nbElementDb);
fprintf('Score for minutiae : %1.2g\n', matchingScore);



