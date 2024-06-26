function [minArray minRot] = findminutia(imSkeleton, imContour, orientationArray)

% [minArray minRot] = findminutia(imSkeleton, imContour, frequencyArray,
%   orientationArray)
%
% Funkce pro hledani minutii ve skeletonizovanem obrazku otisku.
% 1 - konec linie
% 2 - rozdvojeni
%
%       imSkeleton - skeletonizovany otisk (funkce cleanskeleton)
%       imContour - segmentace otisku (funkce segmentimage)
%       orientationArray - orientacni pole (funkce computeorientationarray)
%
%   vystupy
%       minArray - pole stejneho rozmeru jako vstupni obrazek s pixely
%          oznacenymi cisly charakterizujici markanty (viz nahore)
%       minRot - pro kazdou polohu minutia je uvedena take rotace


% width = size(imSkeleton, 2);
% height = size(imSkeleton, 1);


% resize imskeleton
% imSkeleton = imSkeleton(26:height-25,26: width-25);

width = size(imSkeleton, 2);
height = size(imSkeleton, 1);
minutiaArray = zeros(height, width);

temp = imContour;
temp = imresize(temp, size(imSkeleton)); 
contourDist = bwdist(temp);



count = 1;

[X, Y] = find(imSkeleton == 0);

while count <= length(X)
    
    if ~(X(count) == 1 | X(count) == height | Y(count) == 1 | Y(count) == width )
       % if ( (X(count)~= min(find(imSkeleton(X(count),:))==0)) & (X(count)~= max(find(imSkeleton(X(count),:))==0)) )
                cnp = 0.5 * (abs(imSkeleton(X(count)-1,Y(count))-imSkeleton(X(count)-1,Y(count)-1))...
                + abs(imSkeleton(X(count)-1,Y(count)+1)-imSkeleton(X(count)-1,Y(count)))...
                + abs(imSkeleton(X(count),Y(count)+1)-imSkeleton(X(count)-1,Y(count)+1))...
                + abs(imSkeleton(X(count)+1,Y(count)+1)-imSkeleton(X(count),Y(count)+1))...
                + abs(imSkeleton(X(count)+1,Y(count))-imSkeleton(X(count)+1,Y(count)+1))...
                + abs(imSkeleton(X(count)+1,Y(count)-1)-imSkeleton(X(count)+1,Y(count)))...
                + abs(imSkeleton(X(count),Y(count)-1)-imSkeleton(X(count)+1,Y(count)-1))...
                + abs(imSkeleton(X(count)-1,Y(count)-1)-imSkeleton(X(count),Y(count)-1)));
        
            if (cnp == 1) & (contourDist(X(count), Y(count)) > 6)  
                minutiaArray(X(count), Y(count)) = 1;
            elseif (cnp >= 3) & (contourDist(X(count), Y(count)) > 6)      % bifurcation
                minutiaArray(X(count), Y(count)) = 2;
            end
        %end
    end
    count = count + 1;
end

% % remove minutiae
% [x,y]= find(frequencyArray);
% xmax=max(x);
% xmin=min(x);

[Xro, Yro] = find(minutiaArray == 1);
[Xrt, Yrt] = find(minutiaArray == 2);

%if distance with border less than 10 pixel
for i = 1:length(Xro)
    if (contourDist(Xro(i), Yro(i)) < 15)% || (Xro(i)>xmax-10) || (Xro(i)<xmin+10)
        minutiaArray(Xro(i), Yro(i)) = 0;
    end
end

for i = 1:length(Xrt)
    if (contourDist(Xrt(i), Yrt(i)) < 15)% || (Xrt(i)>xmax-10) || (Xrt(i)<xmin+10)
        minutiaArray(Xrt(i), Yrt(i)) = 0;
    end
end

[Xro, Yro] = find(minutiaArray == 1);
[Xrt, Yrt] = find(minutiaArray == 2);

nbend = length(Xro);
nbbif = length(Xrt);

% store coordinates of minutia and angle

[rdb, cdb] = find(minutiaArray ~= 0);
m = imresize(orientationArray, [size(minutiaArray)], 'bicubic');

for i = 1:length(rdb)
    minutia(i, 1) = rdb(i);
    minutia(i, 2) = cdb(i); 
    minutia(i, 3) = m(rdb(i), cdb(i));
end

minArray = minutiaArray; minRot = minutia;