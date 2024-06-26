function show_markants(im, db, input)
% Plot markants in a fingerprint image.
%
% show_markants(f, db, input)
% Input: f - handle of a figure where the fingerprint image is shown
%        db - array with image markants
%        input - optional, array with markants of other image from a pair
%
% show_markants(im,...)
% Input: im - the fingerprint image

if nargin < 3, input = []; end

if numel(im) == 1
    figure(im);
else
    figure; imshow(im);
end

hold on
[x1,y1]= find(db == 1); [x2,y2]= find(db == 2);
plot(y1,x1,'ob','markersize',8); plot(y2,x2,'sb','markersize',8);

if ~isempty(input)
    [x3,y3]= find(input == 1); [x4,y4]= find(input == 2);
    plot(y3,x3,'or','markersize',8); plot(y4,x4,'sr','markersize',8);
end