function orientation = computelocalorientation(x, y, fx, fy, blkSize)

% orientation = computelocalorientation(x, y, fx, fy, blkSize)
%
% Vypocet orientace papilarnich linii v bloku obrazku.
% 
%       x,y - souradnice pocitaneho pixelu
%       fx,fy - gradienty podle x a y
%       blkSize - celikost bloku (oblasti), kde probiha vypocet
%

fxtemp = fx(x - blkSize : x + blkSize, y - blkSize : y + blkSize);
fytemp = fy(x - blkSize : x + blkSize, y - blkSize : y + blkSize);

Gxy = fxtemp .* fytemp;
Gxx = fxtemp.^2 + (rand/10000);
Gyy = fytemp.^2 + (rand/10000);

Gxy = sum(Gxy(:));
Gxx = sum(Gxx(:));
Gyy = sum(Gyy(:));

expr1 = (Gxx - Gyy);
expr2 = (2 * Gxy);


if expr1 >= 0
    theta =  0.5 * atan((2 * Gxy)/(Gxx-Gyy));
elseif expr1 < 0 && expr2 > 0
    theta =  0.5 * (atan((2 * Gxy)/(Gxx-Gyy)) + (pi));
else 
    theta =  0.5 * (atan((2 * Gxy)/(Gxx-Gyy)) - (pi));
end


if theta <=0
    orientation = theta + pi/2;
else 
    orientation = theta - pi/2;
end

